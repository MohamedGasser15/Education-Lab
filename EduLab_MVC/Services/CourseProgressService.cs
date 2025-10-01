using EduLab_MVC.Models.DTOs.CourseProgress;
using EduLab_MVC.Models.DTOsCourseProgress;
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
    public class CourseProgressService : ICourseProgressService
    {
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly ILogger<CourseProgressService> _logger;

        public CourseProgressService(
            IAuthorizedHttpClientService httpClientService,
            ILogger<CourseProgressService> logger)
        {
            _httpClientService = httpClientService;
            _logger = logger;
        }

        // في CourseProgressService في MVC - تأكد من أن الدوال تعمل بشكل صحيح
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

                // تأكد من أن المسار صحيح - قد تحتاج إلى إضافة "api/" إذا كان الـ base URL لا يشملها
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

                // تأكد من أن المسار صحيح
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