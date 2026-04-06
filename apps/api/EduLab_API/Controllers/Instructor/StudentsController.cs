using EduLab_Application.Common;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.DTOs.Notification;
using EduLab_Application.DTOs.Student;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel;
using System.Threading;
using System.Threading.Tasks;
using EduLab_Application.Common.Constants;

namespace EduLab_API.Controllers.Instructor
{
    #region Students Controller
    /// <summary>
    /// API controller for managing students and their progress
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    [Authorize(Roles = SD.Instructor)]
    [Produces("application/json")]
    [DisplayName("Student Management")]
    [Description("APIs for managing students and their progress")]
    public class StudentsController : ControllerBase
    {
        #region Private Fields
        private readonly IStudentService _studentService;
        private readonly ILogger<StudentsController> _logger;
        private readonly ICurrentUserService _currentUserService;
        private readonly INotificationService _notificationService;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the StudentsController class
        /// </summary>
        /// <param name="studentService">Student service instance</param>
        /// <param name="logger">Logger instance</param>
        /// <param name="currentUserService">Current user service instance</param>
        /// <param name="notificationService">Notification service instance</param>
        public StudentsController(
            IStudentService studentService,
            ILogger<StudentsController> logger,
            ICurrentUserService currentUserService,
            INotificationService notificationService)
        {
            _studentService = studentService ?? throw new ArgumentNullException(nameof(studentService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _currentUserService = currentUserService ?? throw new ArgumentNullException(nameof(currentUserService));
            _notificationService = notificationService ?? throw new ArgumentNullException(nameof(notificationService));
        }
        #endregion

        #region Notification Endpoints
        /// <summary>
        /// Sends notification to students
        /// </summary>
        /// <param name="request">Notification request DTO</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Bulk notification result</returns>
        [HttpPost("send-notification")]
        [ProducesResponseType(typeof(ApiResponse<BulkNotificationResultDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> SendNotification(
            [FromBody] InstructorNotificationRequestDto request,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "SendNotification";

            try
            {
                _logger.LogInformation("Starting {OperationName}", operationName);

                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                {
                    _logger.LogWarning("Unauthorized access attempt in {OperationName}", operationName);
                    return Unauthorized(ApiResponse<object>.FailResponse("Unauthorized access"));
                }

                if (request == null)
                {
                    _logger.LogWarning("Null request received in {OperationName}", operationName);
                    return BadRequest(ApiResponse<object>.FailResponse("Request is null"));
                }

                var result = await _notificationService.SendInstructorNotificationAsync(request, instructorId);

                if (result.IsSuccess)
                {
                    _logger.LogInformation("Successfully completed {OperationName}", operationName);
                    return Ok(ApiResponse<BulkNotificationResultDto>.SuccessResponse(result, "Notification sent successfully"));
                }
                else
                {
                    _logger.LogWarning("Failed to send notification in {OperationName}", operationName);
                    return BadRequest(ApiResponse<BulkNotificationResultDto>.FailResponse("Failed to send notification"));
                }
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, ApiResponse<object>.FailResponse("Operation was cancelled"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, ApiResponse<object>.FailResponse(
                    "An error occurred while sending notification",
                    new List<string> { ex.Message }));
            }
        }

        /// <summary>
        /// Retrieves students for notification purposes
        /// </summary>
        /// <param name="selectedStudentIds">Optional list of selected student IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of students for notification</returns>
        [HttpGet("notification-students")]
        [ProducesResponseType(typeof(ApiResponse<List<StudentNotificationDto>>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetStudentsForNotification(
            [FromQuery] List<string> selectedStudentIds = null,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "GetStudentsForNotification";

            try
            {
                _logger.LogInformation("Starting {OperationName}", operationName);

                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                {
                    _logger.LogWarning("Unauthorized access attempt in {OperationName}", operationName);
                    return Unauthorized(ApiResponse<object>.FailResponse("Unauthorized access"));
                }

                var students = await _notificationService.GetInstructorStudentsForNotificationAsync(instructorId, selectedStudentIds);

                _logger.LogInformation("Successfully completed {OperationName}", operationName);
                return Ok(ApiResponse<List<StudentNotificationDto>>.SuccessResponse(students, "Students retrieved successfully"));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, ApiResponse<object>.FailResponse("Operation was cancelled"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, ApiResponse<object>.FailResponse(
                    "An error occurred while retrieving students",
                    new List<string> { ex.Message }));
            }
        }

        /// <summary>
        /// Retrieves notification summary
        /// </summary>
        /// <param name="selectedStudentIds">Optional list of selected student IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Notification summary</returns>
        [HttpGet("notification-summary")]
        [ProducesResponseType(typeof(ApiResponse<InstructorNotificationSummaryDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetNotificationSummary(
            [FromQuery] List<string> selectedStudentIds = null,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "GetNotificationSummary";

            try
            {
                _logger.LogInformation("Starting {OperationName}", operationName);

                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                {
                    _logger.LogWarning("Unauthorized access attempt in {OperationName}", operationName);
                    return Unauthorized(ApiResponse<object>.FailResponse("Unauthorized access"));
                }

                var summary = await _notificationService.GetInstructorNotificationSummaryAsync(instructorId, selectedStudentIds);

                _logger.LogInformation("Successfully completed {OperationName}", operationName);
                return Ok(ApiResponse<InstructorNotificationSummaryDto>.SuccessResponse(summary, "Notification summary retrieved successfully"));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, ApiResponse<object>.FailResponse("Operation was cancelled"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, ApiResponse<object>.FailResponse(
                    "An error occurred while retrieving notification summary",
                    new List<string> { ex.Message }));
            }
        }
        #endregion

        #region Student Management Endpoints
        /// <summary>
        /// Retrieves all students
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of students</returns>
        [HttpGet]
        [ProducesResponseType(typeof(ApiResponse<List<StudentDto>>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetStudents(CancellationToken cancellationToken = default)
        {
            const string operationName = "GetStudents";

            try
            {
                _logger.LogInformation("Starting {OperationName}", operationName);

                var students = await _studentService.GetStudentsAsync(cancellationToken);

                _logger.LogInformation("Successfully completed {OperationName}", operationName);
                return Ok(ApiResponse<List<StudentDto>>.SuccessResponse(students, "Students retrieved successfully"));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, ApiResponse<object>.FailResponse("Operation was cancelled"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, ApiResponse<object>.FailResponse(
                    "An error occurred while retrieving students",
                    new List<string> { ex.Message }));
            }
        }

        /// <summary>
        /// Retrieves students summary for the current instructor
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Students summary</returns>
        [HttpGet("summary")]
        [ProducesResponseType(typeof(ApiResponse<StudentsSummaryDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetStudentsSummary(CancellationToken cancellationToken = default)
        {
            const string operationName = "GetStudentsSummary";

            try
            {
                _logger.LogInformation("Starting {OperationName}", operationName);

                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                {
                    _logger.LogWarning("Unauthorized access attempt in {OperationName}", operationName);
                    return Unauthorized(ApiResponse<object>.FailResponse("Unauthorized access"));
                }

                var summary = await _studentService.GetStudentsSummaryByInstructorAsync(instructorId, cancellationToken);

                _logger.LogInformation("Successfully completed {OperationName}", operationName);
                return Ok(ApiResponse<StudentsSummaryDto>.SuccessResponse(summary, "Students summary retrieved successfully"));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, ApiResponse<object>.FailResponse("Operation was cancelled"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, ApiResponse<object>.FailResponse(
                    "An error occurred while retrieving students summary",
                    new List<string> { ex.Message }));
            }
        }

        /// <summary>
        /// Retrieves detailed information for a specific student
        /// </summary>
        /// <param name="studentId">Student ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Student details</returns>
        [HttpGet("{studentId}")]
        [ProducesResponseType(typeof(ApiResponse<StudentDetailsDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetStudentDetails(
            string studentId,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "GetStudentDetails";

            try
            {
                _logger.LogInformation("Starting {OperationName} for student: {StudentId}", operationName, studentId);

                if (string.IsNullOrWhiteSpace(studentId))
                {
                    _logger.LogWarning("Invalid student ID provided in {OperationName}", operationName);
                    return BadRequest(ApiResponse<object>.FailResponse("Student ID is required"));
                }

                var studentDetails = await _studentService.GetStudentDetailsAsync(studentId, cancellationToken);

                if (studentDetails == null)
                {
                    _logger.LogWarning("Student not found with ID: {StudentId} in {OperationName}", studentId, operationName);
                    return NotFound(ApiResponse<object>.FailResponse("Student not found"));
                }

                _logger.LogInformation("Successfully completed {OperationName} for student: {StudentId}", operationName, studentId);
                return Ok(ApiResponse<StudentDetailsDto>.SuccessResponse(studentDetails, "Student details retrieved successfully"));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for student: {StudentId}", operationName, studentId);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, ApiResponse<object>.FailResponse("Operation was cancelled"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for student: {StudentId}", operationName, studentId);
                return StatusCode(StatusCodes.Status500InternalServerError, ApiResponse<object>.FailResponse(
                    "An error occurred while retrieving student details",
                    new List<string> { ex.Message }));
            }
        }

        /// <summary>
        /// Sends bulk message to students
        /// </summary>
        /// <param name="messageDto">Bulk message DTO</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation result</returns>
        [HttpPost("bulk-message")]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> SendBulkMessage(
            [FromBody] BulkMessageDto messageDto,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "SendBulkMessage";

            try
            {
                _logger.LogInformation("Starting {OperationName} for {Count} students",
                    operationName, messageDto?.StudentIds?.Count ?? 0);

                if (messageDto == null)
                {
                    _logger.LogWarning("Null message DTO received in {OperationName}", operationName);
                    return BadRequest(ApiResponse<object>.FailResponse("Message data is required"));
                }

                if (messageDto.StudentIds == null || !messageDto.StudentIds.Any())
                {
                    _logger.LogWarning("No students selected in {OperationName}", operationName);
                    return BadRequest(ApiResponse<object>.FailResponse("No students selected"));
                }

                if (string.IsNullOrWhiteSpace(messageDto.Subject) || string.IsNullOrWhiteSpace(messageDto.Message))
                {
                    _logger.LogWarning("Invalid message content in {OperationName}", operationName);
                    return BadRequest(ApiResponse<object>.FailResponse("Subject and message are required"));
                }

                var result = await _studentService.SendBulkMessageAsync(messageDto, cancellationToken);

                if (result)
                {
                    _logger.LogInformation("Successfully completed {OperationName}", operationName);
                    return Ok(ApiResponse<object>.SuccessResponse(null, "Bulk message sent successfully"));
                }
                else
                {
                    _logger.LogWarning("Failed to send bulk message in {OperationName}", operationName);
                    return StatusCode(StatusCodes.Status500InternalServerError, ApiResponse<object>.FailResponse("Failed to send bulk message"));
                }
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, ApiResponse<object>.FailResponse("Operation was cancelled"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, ApiResponse<object>.FailResponse(
                    "An error occurred while sending bulk message",
                    new List<string> { ex.Message }));
            }
        }

        /// <summary>
        /// Retrieves students for the current instructor
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of students</returns>
        [HttpGet("my-students")]
        [ProducesResponseType(typeof(ApiResponse<List<StudentDto>>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetMyStudents(CancellationToken cancellationToken = default)
        {
            const string operationName = "GetMyStudents";

            try
            {
                _logger.LogInformation("Starting {OperationName}", operationName);

                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                {
                    _logger.LogWarning("Unauthorized access attempt in {OperationName}", operationName);
                    return Unauthorized(ApiResponse<object>.FailResponse("Unauthorized access"));
                }

                var students = await _studentService.GetStudentsByInstructorAsync(instructorId, cancellationToken);

                _logger.LogInformation("Successfully completed {OperationName}", operationName);
                return Ok(ApiResponse<List<StudentDto>>.SuccessResponse(students, "Students retrieved successfully"));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, ApiResponse<object>.FailResponse("Operation was cancelled"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, ApiResponse<object>.FailResponse(
                    "An error occurred while retrieving students",
                    new List<string> { ex.Message }));
            }
        }

        /// <summary>
        /// Retrieves progress information for multiple students
        /// </summary>
        /// <param name="studentIds">List of student IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of student progress</returns>
        [HttpGet("progress")]
        [ProducesResponseType(typeof(ApiResponse<List<StudentProgressDto>>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetStudentsProgress(
            [FromQuery] List<string> studentIds,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "GetStudentsProgress";

            try
            {
                _logger.LogInformation("Starting {OperationName} for {Count} students",
                    operationName, studentIds?.Count ?? 0);

                if (studentIds == null || !studentIds.Any())
                {
                    _logger.LogWarning("No student IDs provided in {OperationName}", operationName);
                    return BadRequest(ApiResponse<object>.FailResponse("Student IDs are required"));
                }

                var progress = await _studentService.GetStudentsProgressAsync(studentIds, cancellationToken);

                _logger.LogInformation("Successfully completed {OperationName}", operationName);
                return Ok(ApiResponse<List<StudentProgressDto>>.SuccessResponse(progress, "Students progress retrieved successfully"));
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, ApiResponse<object>.FailResponse("Operation was cancelled"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, ApiResponse<object>.FailResponse(
                    "An error occurred while retrieving students progress",
                    new List<string> { ex.Message }));
            }
        }
        #endregion
    }
    #endregion
}