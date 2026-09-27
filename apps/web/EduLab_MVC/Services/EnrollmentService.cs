using AutoMapper;
using EduLab_MVC.Common;
using EduLab_MVC.Models.DTOs.Enrollment;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// Service implementation for enrollment operations.
    /// </summary>
    public class EnrollmentService : IEnrollmentService
    {
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly ILogger<EnrollmentService> _logger;
        private readonly IHttpContextAccessor? _httpContextAccessor;
        private readonly string _imageBaseUrl;
        private HashSet<int>? _cachedEnrolledCourseIds;

        /// <summary>
        /// Initializes a new instance of the <see cref="EnrollmentService"/> class.
        /// </summary>
        /// <param name="httpClientService">The authorized HTTP client service.</param>
        /// <param name="logger">The logger instance.</param>
        /// <param name="configuration">The application configuration.</param>
        /// <param name="httpContextAccessor">The HTTP context accessor.</param>
        public EnrollmentService(
            IAuthorizedHttpClientService httpClientService,
            ILogger<EnrollmentService> logger,
            IConfiguration configuration,
            IHttpContextAccessor? httpContextAccessor = null)
        {
            _httpClientService = httpClientService ?? throw new ArgumentNullException(nameof(httpClientService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _httpContextAccessor = httpContextAccessor;
            var apiBaseUrl = configuration["ApiBaseUrl"];
            _imageBaseUrl = apiBaseUrl.Replace("/api/", "/");
        }

        /// <summary>
        /// Retrieves the current user's enrollments.
        /// </summary>
        public async Task<IEnumerable<EnrollmentDto>> GetUserEnrollmentsAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting user enrollments");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync(ApiEndpoints.Enrollment.Base, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    var enrollments = JsonConvert.DeserializeObject<IEnumerable<EnrollmentDto>>(content);

                    if (enrollments != null)
                    {
                        _cachedEnrolledCourseIds = enrollments.Select(e => e.CourseId).ToHashSet();
                        foreach (var enrollment in enrollments)
                        {
                            // Instructor image
                            if (!string.IsNullOrEmpty(enrollment.ProfileImageUrl) &&
                                !enrollment.ProfileImageUrl.StartsWith("http", StringComparison.OrdinalIgnoreCase))
                            {
                                enrollment.ProfileImageUrl = _imageBaseUrl.TrimEnd('/') + enrollment.ProfileImageUrl;
                            }

                            // Course thumbnail
                            if (!string.IsNullOrEmpty(enrollment.ThumbnailUrl) &&
                                !enrollment.ThumbnailUrl.StartsWith("http", StringComparison.OrdinalIgnoreCase))
                            {
                                enrollment.ThumbnailUrl = _imageBaseUrl.TrimEnd('/') + enrollment.ThumbnailUrl;
                            }
                        }
                    }

                    return enrollments ?? new List<EnrollmentDto>();
                }

                _logger.LogWarning("Failed to get enrollments. Status code: {StatusCode}", response.StatusCode);
                return new List<EnrollmentDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting user enrollments");
                return new List<EnrollmentDto>();
            }
        }


        /// <summary>
        /// Retrieves an enrollment by its ID.
        /// </summary>
        public async Task<EnrollmentDto> GetEnrollmentByIdAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting enrollment by ID: {EnrollmentId}", enrollmentId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"{ApiEndpoints.Enrollment.Base}/{enrollmentId}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    return JsonConvert.DeserializeObject<EnrollmentDto>(content);
                }

                _logger.LogWarning("Failed to get enrollment. Status code: {StatusCode}", response.StatusCode);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting enrollment by ID: {EnrollmentId}", enrollmentId);
                return null;
            }
        }

        /// <summary>
        /// Retrieves the current user's enrollment for a specific course.
        /// </summary>
        public async Task<EnrollmentDto> GetUserCourseEnrollmentAsync(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting course enrollment for course ID: {CourseId}", courseId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"{ApiEndpoints.Enrollment.Base}/course/{courseId}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    return JsonConvert.DeserializeObject<EnrollmentDto>(content);
                }

                _logger.LogWarning("Failed to get course enrollment. Status code: {StatusCode}", response.StatusCode);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting course enrollment for course ID: {CourseId}", courseId);
                return null;
            }
        }

        /// <summary>
        /// Checks whether the current user is enrolled in a course.
        /// </summary>
        public async Task<bool> IsUserEnrolledInCourseAsync(int courseId, CancellationToken cancellationToken = default)
        {
            if (_cachedEnrolledCourseIds != null)
            {
                return _cachedEnrolledCourseIds.Contains(courseId);
            }

            try
            {
                // Populate all user enrollments once for all course cards on the page
                var enrollments = await GetUserEnrollmentsAsync(cancellationToken);
                if (_cachedEnrolledCourseIds != null)
                {
                    return _cachedEnrolledCourseIds.Contains(courseId);
                }

                _logger.LogDebug("Checking enrollment for course ID: {CourseId}", courseId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"{ApiEndpoints.Enrollment.Check}/{courseId}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    return JsonConvert.DeserializeObject<bool>(content);
                }

                _logger.LogWarning("Failed to check enrollment. Status code: {StatusCode}", response.StatusCode);
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error checking enrollment for course ID: {CourseId}", courseId);
                return false;
            }
        }

        /// <summary>
        /// Enrolls the current user in a course.
        /// </summary>
        public async Task<EnrollmentDto> EnrollInCourseAsync(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Enrolling in course ID: {CourseId}", courseId);

                var client = _httpClientService.CreateClient();
                var response = await client.PostAsync($"{ApiEndpoints.Enrollment.Base}/course/{courseId}", null, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    _cachedEnrolledCourseIds = null;
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    return JsonConvert.DeserializeObject<EnrollmentDto>(content);
                }

                _logger.LogWarning("Failed to enroll in course. Status code: {StatusCode}", response.StatusCode);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error enrolling in course ID: {CourseId}", courseId);
                return null;
            }
        }

        /// <summary>
        /// Unenrolls the current user from a course.
        /// </summary>
        public async Task<bool> UnenrollAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Unenrolling from enrollment ID: {EnrollmentId}", enrollmentId);

                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync($"{ApiEndpoints.Enrollment.Base}/{enrollmentId}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    _cachedEnrolledCourseIds = null;
                    return true;
                }

                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error unenrolling from enrollment ID: {EnrollmentId}", enrollmentId);
                return false;
            }
        }

        /// <summary>
        /// Retrieves the total number of enrollments.
        /// </summary>
        public async Task<int> GetEnrollmentsCountAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting enrollments count");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync(ApiEndpoints.Enrollment.Count, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    return JsonConvert.DeserializeObject<int>(content);
                }

                _logger.LogWarning("Failed to get enrollments count. Status code: {StatusCode}", response.StatusCode);
                return 0;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting enrollments count");
                return 0;
            }
        }

        /// <summary>
        /// Checks the current user's enrollment status for a course.
        /// </summary>
        public async Task<bool> CheckEnrollmentAsync(int courseId, CancellationToken cancellationToken = default)
        {
            if (_cachedEnrolledCourseIds != null)
            {
                return _cachedEnrolledCourseIds.Contains(courseId);
            }

            try
            {
                var enrollments = await GetUserEnrollmentsAsync(cancellationToken);
                if (_cachedEnrolledCourseIds != null)
                {
                    return _cachedEnrolledCourseIds.Contains(courseId);
                }

                _logger.LogDebug("Checking enrollment for course ID: {CourseId}", courseId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"{ApiEndpoints.Enrollment.Check}/{courseId}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    return JsonConvert.DeserializeObject<bool>(content);
                }

                _logger.LogWarning("Failed to check enrollment. Status code: {StatusCode}", response.StatusCode);
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error checking enrollment for course ID: {CourseId}", courseId);
                return false;
            }
        }

        /// <summary>
        /// Retrieves the set of course IDs the current user is enrolled in (empty if guest or not enrolled).
        /// </summary>
        public async Task<HashSet<int>> GetEnrolledCourseIdsAsync(CancellationToken cancellationToken = default)
        {
            if (_cachedEnrolledCourseIds != null)
            {
                return _cachedEnrolledCourseIds;
            }

            var token = _httpContextAccessor?.HttpContext?.Request.Cookies["AuthToken"];
            if (_httpContextAccessor?.HttpContext != null && string.IsNullOrEmpty(token))
            {
                _cachedEnrolledCourseIds = new HashSet<int>();
                return _cachedEnrolledCourseIds;
            }

            try
            {
                var enrollments = await GetUserEnrollmentsAsync(cancellationToken);
                _cachedEnrolledCourseIds = enrollments?.Select(e => e.CourseId).ToHashSet() ?? new HashSet<int>();
                return _cachedEnrolledCourseIds;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting enrolled course IDs");
                _cachedEnrolledCourseIds = new HashSet<int>();
                return _cachedEnrolledCourseIds;
            }
        }
    }
}