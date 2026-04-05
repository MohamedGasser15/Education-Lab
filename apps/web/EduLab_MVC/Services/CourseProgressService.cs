using EduLab_MVC.Models.DTOs.CourseProgress;
using EduLab_MVC.Services.ServiceInterfaces;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// Service for managing course progress and lecture completion status
    /// </summary>
    public class CourseProgressService : ICourseProgressService
    {
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly ILogger<CourseProgressService> _logger;

        /// <summary>
        /// Initializes a new instance of the CourseProgressService
        /// </summary>
        /// <param name="httpClientService">HTTP client service for API calls</param>
        /// <param name="logger">Logger instance</param>
        public CourseProgressService(
            IAuthorizedHttpClientService httpClientService,
            ILogger<CourseProgressService> logger)
        {
            _httpClientService = httpClientService;
            _logger = logger;
        }

        /// <summary>
        /// Marks a lecture as completed for the current user
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="lectureId">Lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if operation succeeded, false otherwise</returns>
        public async Task<bool> MarkLectureAsCompletedAsync(int courseId, int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var request = new
                {
                    CourseId = courseId,
                    LectureId = lectureId,
                    WatchedDuration = 0,
                    TotalDuration = 0
                };

                var json = JsonConvert.SerializeObject(request);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                _logger.LogInformation("Calling API to mark lecture as completed - Course: {CourseId}, Lecture: {LectureId}", courseId, lectureId);

                // Verify the path is correct - you may need to add "api/" if base URL doesn't include it
                var response = await client.PostAsync("courseprogress/mark-completed", content, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync(cancellationToken);
                    _logger.LogInformation("API response for mark-completed: {Response}", responseContent);
                    return true;
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);
                    _logger.LogWarning("API returned error for mark-completed: {StatusCode} - {Error}", response.StatusCode, errorContent);
                    return false;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking lecture {LectureId} as completed for course {CourseId}", lectureId, courseId);
                return false;
            }
        }

        /// <summary>
        /// Marks a lecture as incomplete for the current user
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="lectureId">Lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if operation succeeded, false otherwise</returns>
        public async Task<bool> MarkLectureAsIncompleteAsync(int courseId, int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var request = new
                {
                    CourseId = courseId,
                    LectureId = lectureId,
                    WatchedDuration = 0,
                    TotalDuration = 0
                };

                var json = JsonConvert.SerializeObject(request);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                _logger.LogInformation("Calling API to mark lecture as incomplete - Course: {CourseId}, Lecture: {LectureId}", courseId, lectureId);

                // Verify the path is correct
                var response = await client.PostAsync("courseprogress/mark-incomplete", content, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync(cancellationToken);
                    _logger.LogInformation("API response for mark-incomplete: {Response}", responseContent);
                    return true;
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);
                    _logger.LogWarning("API returned error for mark-incomplete: {StatusCode} - {Error}", response.StatusCode, errorContent);
                    return false;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking lecture {LectureId} as incomplete for course {CourseId}", lectureId, courseId);
                return false;
            }
        }

        /// <summary>
        /// Retrieves course progress summary for the current user
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Course progress summary DTO</returns>
        public async Task<CourseProgressSummaryDto> GetCourseProgressAsync(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"courseprogress/course/{courseId}/progress", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    var result = JsonConvert.DeserializeObject<CourseProgressSummaryResponse>(content);
                    return result?.Data;
                }

                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting progress for course {CourseId}", courseId);
                return null;
            }
        }

        /// <summary>
        /// Gets completion status for a specific lecture
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="lectureId">Lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if lecture is completed, false otherwise</returns>
        public async Task<bool> GetLectureStatusAsync(int courseId, int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"courseprogress/lecture/{lectureId}/status?courseId={courseId}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    var result = JsonConvert.DeserializeObject<LectureStatusResponse>(content);
                    return result?.IsCompleted ?? false;
                }

                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting status for lecture {LectureId} in course {CourseId}", lectureId, courseId);
                return false;
            }
        }

        /// <summary>
        /// Retrieves detailed progress information for a course
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of lecture progress DTOs</returns>
        public async Task<List<LectureProgressDto>> GetCourseProgressDetailsAsync(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var progressSummary = await GetCourseProgressAsync(courseId, cancellationToken);

                if (progressSummary != null)
                {
                    return new List<LectureProgressDto>();
                }

                return new List<LectureProgressDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting progress details for course {CourseId}", courseId);
                return new List<LectureProgressDto>();
            }
        }

        /// <summary>
        /// Gets completion status for multiple lectures in a course
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="lectureIds">List of lecture identifiers</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Dictionary with lecture ID as key and completion status as value</returns>
        public async Task<Dictionary<int, bool>> GetLecturesStatusAsync(int courseId, List<int> lectureIds, CancellationToken cancellationToken = default)
        {
            var statuses = new Dictionary<int, bool>();

            try
            {
                foreach (var lectureId in lectureIds)
                {
                    var isCompleted = await GetLectureStatusAsync(courseId, lectureId, cancellationToken);
                    statuses[lectureId] = isCompleted;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting lectures status for course {CourseId}", courseId);
            }

            return statuses;
        }
    }
}