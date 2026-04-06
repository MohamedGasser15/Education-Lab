using EduLab_MVC.Models.DTOs.Notifications;
using EduLab_MVC.Models.DTOs.Student;
using EduLab_MVC.Models.Response;
using EduLab_MVC.Services.ServiceInterfaces;
using Newtonsoft.Json;
using System.Text;

namespace EduLab_MVC.Services
{
    #region Student Service Class
    /// <summary>
    /// Service implementation for student-related operations in the MVC application
    /// Handles communication with the API and data transformation for student management
    /// Uses the unified ApiResponse{T} model.
    /// </summary>
    public class StudentService : IStudentService
    {
        #region Private Fields
        /// <summary>
        /// HTTP client service for making authorized API requests
        /// </summary>
        private readonly IAuthorizedHttpClientService _httpClientService;

        /// <summary>
        /// Logger instance for logging service operations and errors
        /// </summary>
        private readonly ILogger<StudentService> _logger;

        private readonly string _imageBaseUrl;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the StudentService class
        /// </summary>
        /// <param name="httpClientService">The HTTP client service for API communication</param>
        /// <param name="logger">The logger instance for logging operations</param>
        /// <exception cref="ArgumentNullException">Thrown when httpClientService or logger is null</exception>
        public StudentService(
            IAuthorizedHttpClientService httpClientService,
            ILogger<StudentService> logger, IConfiguration configuration)
        {
            _httpClientService = httpClientService ?? throw new ArgumentNullException(nameof(httpClientService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            var apiBaseUrl = configuration["ApiBaseUrl"];
            _imageBaseUrl = apiBaseUrl.Replace("/api/", "/");
        }
        #endregion

        #region Student Retrieval Methods
        /// <summary>
        /// Retrieves students associated with a specific instructor from the API
        /// </summary>
        /// <param name="instructorId">The unique identifier of the instructor</param>
        /// <returns>
        /// List of StudentDto objects if successful; 
        /// otherwise returns an empty list
        /// </returns>
        public async Task<List<StudentDto>> GetStudentsByInstructorAsync(string instructorId)
        {
            const string operationName = nameof(GetStudentsByInstructorAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName} for instructor: {InstructorId}",
                    operationName, instructorId);

                if (string.IsNullOrWhiteSpace(instructorId))
                {
                    _logger.LogWarning("Invalid instructor ID provided in {OperationName}", operationName);
                    return new List<StudentDto>();
                }

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"students/by-instructor/{instructorId}");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var apiResponse = JsonConvert.DeserializeObject<ApiResponse<List<StudentDto>>>(content);

                    var students = apiResponse?.Data ?? new List<StudentDto>();

                    foreach (var student in students)
                        UpdateStudentImageUrl(student);

                    _logger.LogInformation("Successfully retrieved {Count} students for instructor: {InstructorId} in {OperationName}",
                        students.Count, instructorId, operationName);

                    return students;
                }

                _logger.LogWarning("Failed to get students for instructor. Status code: {StatusCode} in {OperationName}",
                    response.StatusCode, operationName);
                return new List<StudentDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for instructor: {InstructorId}",
                    operationName, instructorId);
                return new List<StudentDto>();
            }
        }

        /// <summary>
        /// Retrieves students for the currently authenticated instructor
        /// </summary>
        public async Task<List<StudentDto>> GetMyStudentsAsync()
        {
            const string operationName = nameof(GetMyStudentsAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName} for current instructor", operationName);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("students/my-students");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var apiResponse = JsonConvert.DeserializeObject<ApiResponse<List<StudentDto>>>(content);

                    var students = apiResponse?.Data ?? new List<StudentDto>();

                    foreach (var student in students)
                        UpdateStudentImageUrl(student);

                    _logger.LogInformation("Successfully retrieved {Count} students for current instructor in {OperationName}",
                        students.Count, operationName);

                    return students;
                }

                _logger.LogWarning("Failed to get students for current instructor. Status code: {StatusCode} in {OperationName}",
                    response.StatusCode, operationName);
                return new List<StudentDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return new List<StudentDto>();
            }
        }

        /// <summary>
        /// Retrieves students with filtering and pagination support
        /// </summary>
        public async Task<List<StudentDto>> GetStudentsAsync(StudentFilterDto filter)
        {
            const string operationName = nameof(GetStudentsAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName} with filter: {@Filter}",
                    operationName, filter);

                var client = _httpClientService.CreateClient();

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

                    foreach (var student in students)
                        UpdateStudentImageUrl(student);

                    _logger.LogInformation("Successfully retrieved {Count} students with filter in {OperationName}",
                        students.Count, operationName);

                    return students;
                }

                _logger.LogWarning("Failed to get students with filter. Status code: {StatusCode} in {OperationName}",
                    response.StatusCode, operationName);
                return new List<StudentDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} with filter: {@Filter}",
                    operationName, filter);
                return new List<StudentDto>();
            }
        }

        /// <summary>
        /// Retrieves detailed information for a specific student
        /// </summary>
        public async Task<StudentDetailsDto> GetStudentDetailsAsync(string studentId)
        {
            const string operationName = nameof(GetStudentDetailsAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName} for student: {StudentId}",
                    operationName, studentId);

                if (string.IsNullOrWhiteSpace(studentId))
                {
                    _logger.LogWarning("Invalid student ID provided in {OperationName}", operationName);
                    return null;
                }

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
                            UpdateStudentImageUrl(studentDetails.Student);

                        if (studentDetails.Enrollments != null && studentDetails.Enrollments.Any())
                        {
                            foreach (var enrollment in studentDetails.Enrollments)
                            {
                                UpdateEnrollmentImageUrl(enrollment);
                            }
                        }

                        _logger.LogInformation("Successfully retrieved student details for: {StudentId} in {OperationName}",
                            studentId, operationName);
                    }

                    return studentDetails;
                }

                _logger.LogWarning("Failed to get student details. Status code: {StatusCode} in {OperationName}",
                    response.StatusCode, operationName);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for student: {StudentId}",
                    operationName, studentId);
                return null;
            }
        }
        #endregion

        #region Summary and Statistics Methods
        /// <summary>
        /// Retrieves summary statistics for students
        /// </summary>
        public async Task<StudentsSummaryDto> GetStudentsSummaryAsync()
        {
            const string operationName = nameof(GetStudentsSummaryAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName}", operationName);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("students/summary");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var apiResponse = JsonConvert.DeserializeObject<ApiResponse<StudentsSummaryDto>>(content);

                    _logger.LogInformation("Successfully retrieved students summary in {OperationName}", operationName);

                    return apiResponse?.Data ?? new StudentsSummaryDto();
                }

                _logger.LogWarning("Failed to get students summary. Status code: {StatusCode} in {OperationName}",
                    response.StatusCode, operationName);
                return new StudentsSummaryDto();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return new StudentsSummaryDto();
            }
        }
        #endregion

        #region Notification Methods
        /// <summary>
        /// Sends notifications to students based on the provided request
        /// </summary>
        public async Task<BulkNotificationResultDto> SendNotificationAsync(InstructorNotificationRequestDto request)
        {
            const string operationName = nameof(SendNotificationAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName}", operationName);

                if (request == null)
                {
                    _logger.LogWarning("Null request received in {OperationName}", operationName);
                    return new BulkNotificationResultDto
                    {
                        Errors = new List<string> { "Request cannot be null" }
                    };
                }

                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(request);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync("students/send-notification", content);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync();
                    var apiResponse = JsonConvert.DeserializeObject<ApiResponse<BulkNotificationResultDto>>(responseContent);

                    _logger.LogInformation("Successfully sent notification in {OperationName}", operationName);

                    return apiResponse?.Data ?? new BulkNotificationResultDto();
                }

                _logger.LogWarning("Failed to send notification. Status code: {StatusCode} in {OperationName}",
                    response.StatusCode, operationName);

                return new BulkNotificationResultDto
                {
                    Errors = new List<string> { "Failed to send notification" }
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return new BulkNotificationResultDto
                {
                    Errors = new List<string> { $"Error: {ex.Message}" }
                };
            }
        }

        /// <summary>
        /// Retrieves students for notification purposes with selection status
        /// </summary>
        public async Task<List<StudentNotificationDto>> GetStudentsForNotificationAsync(List<string> selectedStudentIds = null)
        {
            const string operationName = nameof(GetStudentsForNotificationAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName}", operationName);

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

                    foreach (var student in students)
                    {
                        UpdateNotificationStudentImageUrl(student);
                    }

                    _logger.LogInformation("Successfully retrieved {Count} students for notification in {OperationName}",
                        students.Count, operationName);

                    return students;
                }

                _logger.LogWarning("Failed to get students for notification. Status code: {StatusCode} in {OperationName}",
                    response.StatusCode, operationName);
                return new List<StudentNotificationDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return new List<StudentNotificationDto>();
            }
        }

        /// <summary>
        /// Retrieves summary information for notification operations
        /// </summary>
        public async Task<InstructorNotificationSummaryDto> GetNotificationSummaryAsync(List<string> selectedStudentIds = null)
        {
            const string operationName = nameof(GetNotificationSummaryAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName}", operationName);

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

                    _logger.LogInformation("Successfully retrieved notification summary in {OperationName}", operationName);

                    return apiResponse?.Data ?? new InstructorNotificationSummaryDto();
                }

                _logger.LogWarning("Failed to get notification summary. Status code: {StatusCode} in {OperationName}",
                    response.StatusCode, operationName);
                return new InstructorNotificationSummaryDto();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return new InstructorNotificationSummaryDto();
            }
        }
        #endregion

        #region Private Helper Methods
        /// <summary>
        /// Updates the profile image URL for a student to include the full base URL
        /// </summary>
        private void UpdateStudentImageUrl(StudentDto student)
        {
            if (student == null) return;

            if (!string.IsNullOrEmpty(student.ProfileImageUrl) && !student.ProfileImageUrl.StartsWith("https"))
            {
                student.ProfileImageUrl = _imageBaseUrl + student.ProfileImageUrl;
            }
        }

        /// <summary>
        /// Updates the course thumbnail URL for an enrollment to include the full base URL
        /// </summary>
        private void UpdateEnrollmentImageUrl(StudentEnrollmentDto enrollment)
        {
            if (enrollment == null) return;

            if (!string.IsNullOrEmpty(enrollment.CourseThumbnailUrl) &&
                !enrollment.CourseThumbnailUrl.StartsWith("https"))
            {
                enrollment.CourseThumbnailUrl = _imageBaseUrl + enrollment.CourseThumbnailUrl;
            }
        }

        /// <summary>
        /// Updates the profile image URL for a notification student to include the full base URL
        /// </summary>
        private void UpdateNotificationStudentImageUrl(StudentNotificationDto student)
        {
            if (student == null) return;

            if (!string.IsNullOrEmpty(student.ProfileImageUrl) && !student.ProfileImageUrl.StartsWith("https"))
            {
                student.ProfileImageUrl = _imageBaseUrl + student.ProfileImageUrl;
            }
        }
        #endregion
    }
    #endregion
}