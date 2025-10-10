using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Notification;
using EduLab_Shared.DTOs.Student;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel;
using System.Threading;
using System.Threading.Tasks;

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
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
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
                    return Unauthorized(new ApiResponse
                    {
                        Success = false,
                        Message = "Unauthorized access"
                    });
                }

                if (request == null)
                {
                    _logger.LogWarning("Null request received in {OperationName}", operationName);
                    return BadRequest(new ApiResponse
                    {
                        Success = false,
                        Message = "Request is null"
                    });
                }

                var result = await _notificationService.SendInstructorNotificationAsync(request, instructorId);

                if (result.IsSuccess)
                {
                    _logger.LogInformation("Successfully completed {OperationName}", operationName);
                    return Ok(new ApiResponse<BulkNotificationResultDto>
                    {
                        Success = true,
                        Message = "Notification sent successfully",
                        Data = result
                    });
                }
                else
                {
                    _logger.LogWarning("Failed to send notification in {OperationName}", operationName);
                    return BadRequest(new ApiResponse<BulkNotificationResultDto>
                    {
                        Success = false,
                        Message = "Failed to send notification",
                        Data = result
                    });
                }
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new ApiResponse
                {
                    Success = false,
                    Message = "Operation was cancelled"
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while sending notification",
                    Error = ex.Message
                });
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
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
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
                    return Unauthorized(new ApiResponse
                    {
                        Success = false,
                        Message = "Unauthorized access"
                    });
                }

                var students = await _notificationService.GetInstructorStudentsForNotificationAsync(instructorId, selectedStudentIds);

                _logger.LogInformation("Successfully completed {OperationName}", operationName);
                return Ok(new ApiResponse<List<StudentNotificationDto>>
                {
                    Success = true,
                    Message = "Students retrieved successfully",
                    Data = students
                });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new ApiResponse
                {
                    Success = false,
                    Message = "Operation was cancelled"
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while retrieving students",
                    Error = ex.Message
                });
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
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
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
                    return Unauthorized(new ApiResponse
                    {
                        Success = false,
                        Message = "Unauthorized access"
                    });
                }

                var summary = await _notificationService.GetInstructorNotificationSummaryAsync(instructorId, selectedStudentIds);

                _logger.LogInformation("Successfully completed {OperationName}", operationName);
                return Ok(new ApiResponse<InstructorNotificationSummaryDto>
                {
                    Success = true,
                    Message = "Notification summary retrieved successfully",
                    Data = summary
                });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new ApiResponse
                {
                    Success = false,
                    Message = "Operation was cancelled"
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while retrieving notification summary",
                    Error = ex.Message
                });
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
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetStudents(CancellationToken cancellationToken = default)
        {
            const string operationName = "GetStudents";

            try
            {
                _logger.LogInformation("Starting {OperationName}", operationName);

                var students = await _studentService.GetStudentsAsync(cancellationToken);

                _logger.LogInformation("Successfully completed {OperationName}", operationName);
                return Ok(new ApiResponse<List<StudentDto>>
                {
                    Success = true,
                    Message = "Students retrieved successfully",
                    Data = students
                });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new ApiResponse
                {
                    Success = false,
                    Message = "Operation was cancelled"
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while retrieving students",
                    Error = ex.Message
                });
            }
        }

        /// <summary>
        /// Retrieves students summary for the current instructor
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Students summary</returns>
        [HttpGet("summary")]
        [ProducesResponseType(typeof(ApiResponse<StudentsSummaryDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
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
                    return Unauthorized(new ApiResponse
                    {
                        Success = false,
                        Message = "Unauthorized access"
                    });
                }

                var summary = await _studentService.GetStudentsSummaryByInstructorAsync(instructorId, cancellationToken);

                _logger.LogInformation("Successfully completed {OperationName}", operationName);
                return Ok(new ApiResponse<StudentsSummaryDto>
                {
                    Success = true,
                    Message = "Students summary retrieved successfully",
                    Data = summary
                });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new ApiResponse
                {
                    Success = false,
                    Message = "Operation was cancelled"
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while retrieving students summary",
                    Error = ex.Message
                });
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
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
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
                    return BadRequest(new ApiResponse
                    {
                        Success = false,
                        Message = "Student ID is required"
                    });
                }

                var studentDetails = await _studentService.GetStudentDetailsAsync(studentId, cancellationToken);

                if (studentDetails == null)
                {
                    _logger.LogWarning("Student not found with ID: {StudentId} in {OperationName}", studentId, operationName);
                    return NotFound(new ApiResponse
                    {
                        Success = false,
                        Message = "Student not found"
                    });
                }

                _logger.LogInformation("Successfully completed {OperationName} for student: {StudentId}", operationName, studentId);
                return Ok(new ApiResponse<StudentDetailsDto>
                {
                    Success = true,
                    Message = "Student details retrieved successfully",
                    Data = studentDetails
                });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for student: {StudentId}", operationName, studentId);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new ApiResponse
                {
                    Success = false,
                    Message = "Operation was cancelled"
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for student: {StudentId}", operationName, studentId);
                return StatusCode(StatusCodes.Status500InternalServerError, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while retrieving student details",
                    Error = ex.Message
                });
            }
        }

        /// <summary>
        /// Sends bulk message to students
        /// </summary>
        /// <param name="messageDto">Bulk message DTO</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation result</returns>
        [HttpPost("bulk-message")]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
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
                    return BadRequest(new ApiResponse
                    {
                        Success = false,
                        Message = "Message data is required"
                    });
                }

                if (messageDto.StudentIds == null || !messageDto.StudentIds.Any())
                {
                    _logger.LogWarning("No students selected in {OperationName}", operationName);
                    return BadRequest(new ApiResponse
                    {
                        Success = false,
                        Message = "No students selected"
                    });
                }

                if (string.IsNullOrWhiteSpace(messageDto.Subject) || string.IsNullOrWhiteSpace(messageDto.Message))
                {
                    _logger.LogWarning("Invalid message content in {OperationName}", operationName);
                    return BadRequest(new ApiResponse
                    {
                        Success = false,
                        Message = "Subject and message are required"
                    });
                }

                var result = await _studentService.SendBulkMessageAsync(messageDto, cancellationToken);

                if (result)
                {
                    _logger.LogInformation("Successfully completed {OperationName}", operationName);
                    return Ok(new ApiResponse
                    {
                        Success = true,
                        Message = "Bulk message sent successfully"
                    });
                }
                else
                {
                    _logger.LogWarning("Failed to send bulk message in {OperationName}", operationName);
                    return StatusCode(StatusCodes.Status500InternalServerError, new ApiResponse
                    {
                        Success = false,
                        Message = "Failed to send bulk message"
                    });
                }
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new ApiResponse
                {
                    Success = false,
                    Message = "Operation was cancelled"
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while sending bulk message",
                    Error = ex.Message
                });
            }
        }

        /// <summary>
        /// Retrieves students for the current instructor
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of students</returns>
        [HttpGet("my-students")]
        [ProducesResponseType(typeof(ApiResponse<List<StudentDto>>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
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
                    return Unauthorized(new ApiResponse
                    {
                        Success = false,
                        Message = "Unauthorized access"
                    });
                }

                var students = await _studentService.GetStudentsByInstructorAsync(instructorId, cancellationToken);

                _logger.LogInformation("Successfully completed {OperationName}", operationName);
                return Ok(new ApiResponse<List<StudentDto>>
                {
                    Success = true,
                    Message = "Students retrieved successfully",
                    Data = students
                });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new ApiResponse
                {
                    Success = false,
                    Message = "Operation was cancelled"
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while retrieving students",
                    Error = ex.Message
                });
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
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
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
                    return BadRequest(new ApiResponse
                    {
                        Success = false,
                        Message = "Student IDs are required"
                    });
                }

                var progress = await _studentService.GetStudentsProgressAsync(studentIds, cancellationToken);

                _logger.LogInformation("Successfully completed {OperationName}", operationName);
                return Ok(new ApiResponse<List<StudentProgressDto>>
                {
                    Success = true,
                    Message = "Students progress retrieved successfully",
                    Data = progress
                });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new ApiResponse
                {
                    Success = false,
                    Message = "Operation was cancelled"
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while retrieving students progress",
                    Error = ex.Message
                });
            }
        }
        #endregion
    }
    #endregion
}