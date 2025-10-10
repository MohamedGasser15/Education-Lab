using EduLab_MVC.Models.DTOs.Notifications;
using EduLab_MVC.Models.DTOs.Student;
using EduLab_MVC.Services.ServiceInterfaces;
using EduLab_Shared.Utitlites;
using Newtonsoft.Json;
using System.Text;

namespace EduLab_MVC.Services
{
    public class StudentService : IStudentService
    {
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly ILogger<StudentService> _logger;

        public StudentService(
            IAuthorizedHttpClientService httpClientService,
            ILogger<StudentService> logger)
        {
            _httpClientService = httpClientService;
            _logger = logger;
        }

        public async Task<List<StudentDto>> GetStudentsByInstructorAsync(string instructorId)
        {
            try
            {
                _logger.LogInformation("Getting students for instructor: {InstructorId}", instructorId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"students/by-instructor/{instructorId}");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var apiResponse = JsonConvert.DeserializeObject<ApiResponse<List<StudentDto>>>(content);

                    var students = apiResponse?.Data ?? new List<StudentDto>();

                    // 🟢 استخدم الدالة هنا لتعديل روابط الصور
                    foreach (var student in students)
                        ImageUrl(student);

                    return students;
                }

                _logger.LogWarning("Failed to get students for instructor. Status code: {StatusCode}", response.StatusCode);
                return new List<StudentDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting students for instructor: {InstructorId}", instructorId);
                return new List<StudentDto>();
            }
        }

        public async Task<List<StudentDto>> GetMyStudentsAsync()
        {
            try
            {
                _logger.LogInformation("Getting students for current instructor");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("students/my-students");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var apiResponse = JsonConvert.DeserializeObject<ApiResponse<List<StudentDto>>>(content);

                    var students = apiResponse?.Data ?? new List<StudentDto>();

                    // 🟢 برضه هنا
                    foreach (var student in students)
                        ImageUrl(student);

                    return students;
                }

                _logger.LogWarning("Failed to get students for current instructor. Status code: {StatusCode}", response.StatusCode);
                return new List<StudentDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting students for current instructor");
                return new List<StudentDto>();
            }
        }

        public async Task<List<StudentDto>> GetStudentsAsync(StudentFilterDto filter)
        {
            try
            {
                _logger.LogInformation("Getting students with filter");

                var client = _httpClientService.CreateClient();

                // Build query string
                var queryParams = new List<string>();
                if (!string.IsNullOrEmpty(filter.Search))
                    queryParams.Add($"search={Uri.EscapeDataString(filter.Search)}");
                if (filter.CourseId.HasValue)
                    queryParams.Add($"courseId={filter.CourseId.Value}");
                if (!string.IsNullOrEmpty(filter.Status))
                    queryParams.Add($"status={filter.Status}");
                queryParams.Add($"pageNumber={filter.PageNumber}");
                queryParams.Add($"pageSize={filter.PageSize}");

                var queryString = queryParams.Any() ? "?" + string.Join("&", queryParams) : "";
                var response = await client.GetAsync($"students{queryString}");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var apiResponse = JsonConvert.DeserializeObject<ApiResponse<List<StudentDto>>>(content);

                    var students = apiResponse?.Data ?? new List<StudentDto>();

                    // 🟢 وهنا كمان
                    foreach (var student in students)
                        ImageUrl(student);

                    return students;
                }

                _logger.LogWarning("Failed to get students. Status code: {StatusCode}", response.StatusCode);
                return new List<StudentDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting students");
                return new List<StudentDto>();
            }
        }


        public async Task<StudentsSummaryDto> GetStudentsSummaryAsync()
        {
            try
            {
                _logger.LogInformation("Getting students summary");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("students/summary");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var apiResponse = JsonConvert.DeserializeObject<ApiResponse<StudentsSummaryDto>>(content);
                    return apiResponse?.Data ?? new StudentsSummaryDto();
                }

                _logger.LogWarning("Failed to get students summary. Status code: {StatusCode}", response.StatusCode);
                return new StudentsSummaryDto();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting students summary");
                return new StudentsSummaryDto();
            }
        }

        public async Task<StudentDetailsDto> GetStudentDetailsAsync(string studentId)
        {
            try
            {
                _logger.LogInformation("Getting student details for: {StudentId}", studentId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"students/{studentId}");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var apiResponse = JsonConvert.DeserializeObject<ApiResponse<StudentDetailsDto>>(content);
                    var studentDetails = apiResponse?.Data;

                    if (studentDetails != null)
                    {
                        if (studentDetails.Student != null)
                            ImageUrl(studentDetails.Student);

                        if (studentDetails.Enrollments != null && studentDetails.Enrollments.Any())
                        {
                            foreach (var enrollment in studentDetails.Enrollments)
                            {
                                if (!string.IsNullOrEmpty(enrollment.CourseThumbnailUrl) &&
                                    !enrollment.CourseThumbnailUrl.StartsWith("https"))
                                {
                                    enrollment.CourseThumbnailUrl = "https://localhost:7292" + enrollment.CourseThumbnailUrl;
                                }
                            }
                        }
                    }

                    return studentDetails;
                }

                _logger.LogWarning("Failed to get student details. Status code: {StatusCode}", response.StatusCode);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting student details for: {StudentId}", studentId);
                return null;
            }
        }



        public async Task<BulkNotificationResultDto> SendNotificationAsync(InstructorNotificationRequestDto request)
        {
            try
            {
                _logger.LogInformation("Sending notification to students");

                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(request);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync("students/send-notification", content);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync();
                    var apiResponse = JsonConvert.DeserializeObject<ApiResponse<BulkNotificationResultDto>>(responseContent);
                    return apiResponse?.Data ?? new BulkNotificationResultDto();
                }

                _logger.LogWarning("Failed to send notification. Status code: {StatusCode}", response.StatusCode);
                return new BulkNotificationResultDto
                {
                    Errors = new List<string> { "Failed to send notification" }
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending notification");
                return new BulkNotificationResultDto
                {
                    Errors = new List<string> { $"Error: {ex.Message}" }
                };
            }
        }

        public async Task<List<StudentNotificationDto>> GetStudentsForNotificationAsync(List<string> selectedStudentIds = null)
        {
            try
            {
                _logger.LogInformation("Getting students for notification");

                var client = _httpClientService.CreateClient();

                var queryString = "";
                if (selectedStudentIds != null && selectedStudentIds.Any())
                {
                    var studentIdsParam = string.Join("&", selectedStudentIds.Select(id => $"selectedStudentIds={id}"));
                    queryString = $"?{studentIdsParam}";
                }

                var response = await client.GetAsync($"students/notification-students{queryString}");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var apiResponse = JsonConvert.DeserializeObject<ApiResponse<List<StudentNotificationDto>>>(content);
                    var students = apiResponse?.Data ?? new List<StudentNotificationDto>();

                    // تحديث روابط الصور
                    foreach (var student in students)
                    {
                        if (!string.IsNullOrEmpty(student.ProfileImageUrl) && !student.ProfileImageUrl.StartsWith("https"))
                        {
                            student.ProfileImageUrl = "https://localhost:7292" + student.ProfileImageUrl;
                        }
                    }

                    return students;
                }

                _logger.LogWarning("Failed to get students for notification. Status code: {StatusCode}", response.StatusCode);
                return new List<StudentNotificationDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting students for notification");
                return new List<StudentNotificationDto>();
            }
        }

        public async Task<InstructorNotificationSummaryDto> GetNotificationSummaryAsync(List<string> selectedStudentIds = null)
        {
            try
            {
                _logger.LogInformation("Getting notification summary");

                var client = _httpClientService.CreateClient();

                var queryString = "";
                if (selectedStudentIds != null && selectedStudentIds.Any())
                {
                    var studentIdsParam = string.Join("&", selectedStudentIds.Select(id => $"selectedStudentIds={id}"));
                    queryString = $"?{studentIdsParam}";
                }

                var response = await client.GetAsync($"students/notification-summary{queryString}");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var apiResponse = JsonConvert.DeserializeObject<ApiResponse<InstructorNotificationSummaryDto>>(content);
                    return apiResponse?.Data ?? new InstructorNotificationSummaryDto();
                }

                _logger.LogWarning("Failed to get notification summary. Status code: {StatusCode}", response.StatusCode);
                return new InstructorNotificationSummaryDto();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting notification summary");
                return new InstructorNotificationSummaryDto();
            }
        }
        #region Private Helper Methods
        /// <summary>
        /// Updates the image URL for a wishlist item to include the full base URL
        /// </summary>
        /// <param name="course">The wishlist item to update</param>
        private void ImageUrl(StudentDto student)
        {
            if (student == null) return;

            if (!string.IsNullOrEmpty(student.ProfileImageUrl) && !student.ProfileImageUrl.StartsWith("https"))
            {
                student.ProfileImageUrl = "https://localhost:7292" + student.ProfileImageUrl;
            }
        }
        #endregion
    }
}