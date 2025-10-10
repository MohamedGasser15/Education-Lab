using EduLab_MVC.Models.DTOs.Notifications;
using EduLab_MVC.Models.DTOs.Student;
using EduLab_MVC.Services.ServiceInterfaces;
using EduLab_Shared.Utitlites;
using Newtonsoft.Json;
using System.Text;

namespace EduLab_MVC.Services
{
    #region Student Service Class
    /// <summary>
    /// Service implementation for student-related operations in the MVC application
    /// Handles communication with the API and data transformation for student management
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
            ILogger<StudentService> logger)
        {
            _httpClientService = httpClientService ?? throw new ArgumentNullException(nameof(httpClientService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
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
        /// <remarks>
        /// This method calls the API endpoint to get students by instructor ID
        /// and processes the image URLs for proper display in the MVC application
        /// </remarks>
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

                    // Process image URLs for all retrieved students
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
        /// <returns>
        /// List of StudentDto objects if successful; 
        /// otherwise returns an empty list
        /// </returns>
        /// <remarks>
        /// This method calls the API endpoint that automatically uses the current user's context
        /// to retrieve their associated students
        /// </remarks>
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

                    // Process image URLs for all retrieved students
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
        /// <param name="filter">The filter criteria for searching and paginating students</param>
        /// <returns>
        /// List of StudentDto objects matching the filter criteria if successful; 
        /// otherwise returns an empty list
        /// </returns>
        /// <remarks>
        /// This method builds a query string based on the filter parameters and calls the API
        /// to retrieve filtered student data
        /// </remarks>
        public async Task<List<StudentDto>> GetStudentsAsync(StudentFilterDto filter)
        {
            const string operationName = nameof(GetStudentsAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName} with filter: {@Filter}",
                    operationName, filter);

                var client = _httpClientService.CreateClient();

                // Build query string from filter parameters
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

                    // Process image URLs for all retrieved students
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
        /// <param name="studentId">The unique identifier of the student</param>
        /// <returns>
        /// StudentDetailsDto object containing comprehensive student information if successful;
        /// otherwise returns null
        /// </returns>
        /// <remarks>
        /// This method retrieves student details including enrollments, statistics, and activities,
        /// and processes image URLs for proper display
        /// </remarks>
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
                        // Process student profile image URL
                        if (studentDetails.Student != null)
                            UpdateStudentImageUrl(studentDetails.Student);

                        // Process course thumbnail URLs in enrollments
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
        /// <returns>
        /// StudentsSummaryDto object containing summary statistics if successful;
        /// otherwise returns an empty StudentsSummaryDto object
        /// </returns>
        /// <remarks>
        /// This method calls the API to get aggregated student statistics
        /// such as total students, active students, and completion rates
        /// </remarks>
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
        /// <param name="request">The notification request containing message details and target students</param>
        /// <returns>
        /// BulkNotificationResultDto object containing the operation result;
        /// includes success status and any errors that occurred
        /// </returns>
        /// <remarks>
        /// This method sends a POST request to the API to trigger notification sending
        /// to the specified students
        /// </remarks>
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
        /// <param name="selectedStudentIds">Optional list of pre-selected student IDs</param>
        /// <returns>
        /// List of StudentNotificationDto objects if successful;
        /// otherwise returns an empty list
        /// </returns>
        /// <remarks>
        /// This method retrieves students specifically for notification interfaces
        /// and indicates which students are currently selected
        /// </remarks>
        public async Task<List<StudentNotificationDto>> GetStudentsForNotificationAsync(List<string> selectedStudentIds = null)
        {
            const string operationName = nameof(GetStudentsForNotificationAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName}", operationName);

                var client = _httpClientService.CreateClient();

                // Build query string for selected student IDs
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

                    // Process profile image URLs for notification students
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
        /// <param name="selectedStudentIds">Optional list of selected student IDs</param>
        /// <returns>
        /// InstructorNotificationSummaryDto object containing notification summary if successful;
        /// otherwise returns an empty InstructorNotificationSummaryDto object
        /// </returns>
        /// <remarks>
        /// This method provides summary statistics for notification operations,
        /// including total students and selected student counts
        /// </remarks>
        public async Task<InstructorNotificationSummaryDto> GetNotificationSummaryAsync(List<string> selectedStudentIds = null)
        {
            const string operationName = nameof(GetNotificationSummaryAsync);

            try
            {
                _logger.LogInformation("Starting {OperationName}", operationName);

                var client = _httpClientService.CreateClient();

                // Build query string for selected student IDs
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
        /// <param name="student">The student DTO to update</param>
        /// <remarks>
        /// This method ensures that relative image URLs are converted to absolute URLs
        /// for proper display in the MVC application
        /// </remarks>
        private void UpdateStudentImageUrl(StudentDto student)
        {
            if (student == null) return;

            if (!string.IsNullOrEmpty(student.ProfileImageUrl) && !student.ProfileImageUrl.StartsWith("https"))
            {
                student.ProfileImageUrl = "https://localhost:7292" + student.ProfileImageUrl;
            }
        }

        /// <summary>
        /// Updates the course thumbnail URL for an enrollment to include the full base URL
        /// </summary>
        /// <param name="enrollment">The enrollment DTO to update</param>
        /// <remarks>
        /// This method ensures that relative course thumbnail URLs are converted to absolute URLs
        /// for proper display in the MVC application
        /// </remarks>
        private void UpdateEnrollmentImageUrl(StudentEnrollmentDto enrollment)
        {
            if (enrollment == null) return;

            if (!string.IsNullOrEmpty(enrollment.CourseThumbnailUrl) &&
                !enrollment.CourseThumbnailUrl.StartsWith("https"))
            {
                enrollment.CourseThumbnailUrl = "https://localhost:7292" + enrollment.CourseThumbnailUrl;
            }
        }

        /// <summary>
        /// Updates the profile image URL for a notification student to include the full base URL
        /// </summary>
        /// <param name="student">The notification student DTO to update</param>
        /// <remarks>
        /// This method ensures that relative profile image URLs are converted to absolute URLs
        /// for proper display in notification interfaces
        /// </remarks>
        private void UpdateNotificationStudentImageUrl(StudentNotificationDto student)
        {
            if (student == null) return;

            if (!string.IsNullOrEmpty(student.ProfileImageUrl) && !student.ProfileImageUrl.StartsWith("https"))
            {
                student.ProfileImageUrl = "https://localhost:7292" + student.ProfileImageUrl;
            }
        }
        #endregion
    }
    #endregion
}