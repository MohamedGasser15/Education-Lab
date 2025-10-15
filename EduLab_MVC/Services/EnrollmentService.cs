using AutoMapper;
using EduLab_MVC.Models.DTOs.Enrollment;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System;
using System.Buffers.Text;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services
{
    public class EnrollmentService : IEnrollmentService
    {
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly ILogger<EnrollmentService> _logger;
        private readonly IWebHostEnvironment _env;
        private readonly string BaseUrl;

        public EnrollmentService(
            IAuthorizedHttpClientService httpClientService,
            ILogger<EnrollmentService> logger,
            IWebHostEnvironment env)
        {
            _httpClientService = httpClientService ?? throw new ArgumentNullException(nameof(httpClientService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _env = env;
            BaseUrl = _env.IsDevelopment()
                    ? "https://localhost:7292"
                    : "https://edulabapi.runasp.net";
        }

        public async Task<IEnumerable<EnrollmentDto>> GetUserEnrollmentsAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting user enrollments");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("enrollment", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    var enrollments = JsonConvert.DeserializeObject<IEnumerable<EnrollmentDto>>(content);

                    if (enrollments != null)
                    {
                        foreach (var enrollment in enrollments)
                        {
                            // Instructor image
                            if (!string.IsNullOrEmpty(enrollment.ProfileImageUrl) &&
                                !enrollment.ProfileImageUrl.StartsWith("http", StringComparison.OrdinalIgnoreCase))
                            {
                                var fixedProfileUrl = enrollment.ProfileImageUrl.StartsWith("/")
                                    ? enrollment.ProfileImageUrl
                                    : "/" + enrollment.ProfileImageUrl;

                                enrollment.ProfileImageUrl = $"{BaseUrl}{fixedProfileUrl}";
                            }

                            // Course thumbnail
                            if (!string.IsNullOrEmpty(enrollment.ThumbnailUrl) &&
                                !enrollment.ThumbnailUrl.StartsWith("http", StringComparison.OrdinalIgnoreCase))
                            {
                                var fixedThumbUrl = enrollment.ThumbnailUrl.StartsWith("/")
                                    ? enrollment.ThumbnailUrl
                                    : "/" + enrollment.ThumbnailUrl;

                                enrollment.ThumbnailUrl = $"{BaseUrl}{fixedThumbUrl}";
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


        public async Task<EnrollmentDto> GetEnrollmentByIdAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting enrollment by ID: {EnrollmentId}", enrollmentId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"enrollment/{enrollmentId}", cancellationToken);

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

        public async Task<EnrollmentDto> GetUserCourseEnrollmentAsync(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting course enrollment for course ID: {CourseId}", courseId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"enrollment/course/{courseId}", cancellationToken);

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

        public async Task<bool> IsUserEnrolledInCourseAsync(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Checking enrollment for course ID: {CourseId}", courseId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"enrollment/check/{courseId}", cancellationToken);

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

        public async Task<EnrollmentDto> EnrollInCourseAsync(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Enrolling in course ID: {CourseId}", courseId);

                var client = _httpClientService.CreateClient();
                var response = await client.PostAsync($"enrollment/course/{courseId}", null, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
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

        public async Task<bool> UnenrollAsync(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Unenrolling from enrollment ID: {EnrollmentId}", enrollmentId);

                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync($"enrollment/{enrollmentId}", cancellationToken);

                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error unenrolling from enrollment ID: {EnrollmentId}", enrollmentId);
                return false;
            }
        }

        public async Task<int> GetEnrollmentsCountAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting enrollments count");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("enrollment/count", cancellationToken);

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

        public async Task<bool> CheckEnrollmentAsync(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Checking enrollment for course ID: {CourseId}", courseId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"enrollment/check/{courseId}", cancellationToken);

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
    }
}