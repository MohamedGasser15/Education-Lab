using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Shared.DTOs.Student;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel;
using System.Security.Claims;

namespace EduLab_API.Controllers.Instructor
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize(Roles = SD.Instructor)]
    [Produces("application/json")]
    [DisplayName("Student Management")]
    [Description("APIs for managing students and their progress")]
    public class StudentsController : ControllerBase
    {
        private readonly IStudentService _studentService;
        private readonly ILogger<StudentsController> _logger;
        private readonly ICurrentUserService _currentUserService;

        public StudentsController(
            IStudentService studentService,
            ILogger<StudentsController> logger,
            ICurrentUserService currentUserService)
        {
            _studentService = studentService ?? throw new ArgumentNullException(nameof(studentService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _currentUserService = currentUserService;
        }

        [HttpGet]
        [ProducesResponseType(typeof(ApiResponse<List<StudentDto>>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetStudents(
            [FromQuery] StudentFilterDto filter,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting students with filter: {@Filter}", filter);

                var students = await _studentService.GetStudentsAsync(filter, cancellationToken);

                return Ok(new ApiResponse<List<StudentDto>>
                {
                    Success = true,
                    Message = "Students retrieved successfully",
                    Data = students
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting students with filter: {@Filter}", filter);
                return StatusCode(500, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while retrieving students",
                    Error = ex.Message
                });
            }
        }

        [HttpGet("summary")]
        [ProducesResponseType(typeof(ApiResponse<StudentsSummaryDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetStudentsSummary(CancellationToken cancellationToken = default)
        {
            try
            {
                // الحصول على الـ Instructor الحالي من السياق
                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                {
                    _logger.LogWarning("Unauthorized access attempt to get students summary");
                    return Unauthorized(new ApiResponse
                    {
                        Success = false,
                        Message = "Unauthorized access"
                    });
                }

                _logger.LogInformation("Getting students summary for instructor: {InstructorId}", instructorId);

                // استدعاء السيرفيس الجديد المخصص لكل مدرس
                var summary = await _studentService.GetStudentsSummaryByInstructorAsync(instructorId, cancellationToken);

                return Ok(new ApiResponse<StudentsSummaryDto>
                {
                    Success = true,
                    Message = "Students summary retrieved successfully",
                    Data = summary
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting students summary");
                return StatusCode(500, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while retrieving students summary",
                    Error = ex.Message
                });
            }
        }


        [HttpGet("{studentId}")]
        [ProducesResponseType(typeof(ApiResponse<StudentDetailsDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetStudentDetails(
            string studentId,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting details for student: {StudentId}", studentId);

                var studentDetails = await _studentService.GetStudentDetailsAsync(studentId, cancellationToken);

                if (studentDetails == null)
                {
                    return NotFound(new ApiResponse
                    {
                        Success = false,
                        Message = "Student not found"
                    });
                }

                return Ok(new ApiResponse<StudentDetailsDto>
                {
                    Success = true,
                    Message = "Student details retrieved successfully",
                    Data = studentDetails
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting details for student: {StudentId}", studentId);
                return StatusCode(500, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while retrieving student details",
                    Error = ex.Message
                });
            }
        }

        [HttpPost("bulk-message")]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> SendBulkMessage(
            [FromBody] BulkMessageDto messageDto,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Sending bulk message to {Count} students", messageDto.StudentIds.Count);

                if (messageDto.StudentIds == null || !messageDto.StudentIds.Any())
                {
                    return BadRequest(new ApiResponse
                    {
                        Success = false,
                        Message = "No students selected"
                    });
                }

                if (string.IsNullOrWhiteSpace(messageDto.Subject) || string.IsNullOrWhiteSpace(messageDto.Message))
                {
                    return BadRequest(new ApiResponse
                    {
                        Success = false,
                        Message = "Subject and message are required"
                    });
                }

                var result = await _studentService.SendBulkMessageAsync(messageDto, cancellationToken);

                if (result)
                {
                    return Ok(new ApiResponse
                    {
                        Success = true,
                        Message = "Bulk message sent successfully"
                    });
                }
                else
                {
                    return StatusCode(500, new ApiResponse
                    {
                        Success = false,
                        Message = "Failed to send bulk message"
                    });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending bulk message to students");
                return StatusCode(500, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while sending bulk message",
                    Error = ex.Message
                });
            }
        }
        [HttpGet("my-students")]
        [ProducesResponseType(typeof(ApiResponse<List<StudentDto>>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetMyStudents(CancellationToken cancellationToken = default)
        {
            try
            {
                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                {
                    _logger.LogWarning("Unauthorized access attempt to get instructor courses");
                    return Unauthorized();
                }

                _logger.LogInformation("Getting students for current instructor: {InstructorId}", instructorId);

                var students = await _studentService.GetStudentsByInstructorAsync(instructorId, cancellationToken);

                return Ok(new ApiResponse<List<StudentDto>>
                {
                    Success = true,
                    Message = "Students retrieved successfully",
                    Data = students
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting students for current instructor");
                return StatusCode(500, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while retrieving students",
                    Error = ex.Message
                });
            }
        }

        [HttpGet("progress")]
        [ProducesResponseType(typeof(ApiResponse<List<StudentProgressDto>>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetStudentsProgress(
            [FromQuery] List<string> studentIds,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting progress for {Count} students", studentIds.Count);

                if (studentIds == null || !studentIds.Any())
                {
                    return BadRequest(new ApiResponse
                    {
                        Success = false,
                        Message = "Student IDs are required"
                    });
                }

                var progress = await _studentService.GetStudentsProgressAsync(studentIds, cancellationToken);

                return Ok(new ApiResponse<List<StudentProgressDto>>
                {
                    Success = true,
                    Message = "Students progress retrieved successfully",
                    Data = progress
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting students progress");
                return StatusCode(500, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while retrieving students progress",
                    Error = ex.Message
                });
            }
        }
    }
}
