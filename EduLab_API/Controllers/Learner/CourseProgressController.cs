// EduLab_API/Controllers/Learner/CourseProgressController.cs
using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.CourseProgress;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel;
using System.Threading;

namespace EduLab_API.Controllers.Learner
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    [Produces("application/json")]
    [DisplayName("Course Progress Management")]
    [Description("APIs for managing course progress and tracking learning activities")]
    public class CourseProgressController : ControllerBase
    {
        private readonly ICourseProgressService _courseProgressService;
        private readonly IEnrollmentService _enrollmentService;
        private readonly ICurrentUserService _currentUserService;
        private readonly ILogger<CourseProgressController> _logger;

        public CourseProgressController(
            ICourseProgressService courseProgressService,
            IEnrollmentService enrollmentService,
            ICurrentUserService currentUserService,
            ILogger<CourseProgressController> logger)
        {
            _courseProgressService = courseProgressService;
            _enrollmentService = enrollmentService;
            _currentUserService = currentUserService;
            _logger = logger;
        }

        // في CourseProgressController في API
        [HttpPost("mark-completed")]
        [ProducesResponseType(typeof(ApiResponse<CourseProgressDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> MarkLectureAsCompleted([FromBody] MarkLectureCompletedRequest request, CancellationToken cancellationToken = default)
        {
            try
            {
                if (request == null)
                {
                    _logger.LogWarning("Request body is null");
                    return BadRequest(new { success = false, message = "Request body is required" });
                }

                if (request.CourseId <= 0 || request.LectureId <= 0)
                {
                    _logger.LogWarning("Invalid course or lecture ID: CourseId={CourseId}, LectureId={LectureId}",
                        request.CourseId, request.LectureId);
                    return BadRequest(new { success = false, message = "Invalid course or lecture ID" });
                }

                _logger.LogInformation("Marking lecture as completed - CourseId: {CourseId}, LectureId: {LectureId}",
                    request.CourseId, request.LectureId);

                var userId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(userId))
                    return Unauthorized(new ApiResponse { Success = false, Message = "User not authenticated" });

                // التحقق من أن المستخدم مسجل في الكورس
                var enrollment = await _enrollmentService.GetUserCourseEnrollmentAsync(userId, request.CourseId, cancellationToken);
                if (enrollment == null)
                    return BadRequest(new ApiResponse { Success = false, Message = "User is not enrolled in this course" });

                var progress = await _courseProgressService.MarkLectureAsCompletedAsync(enrollment.Id, request.LectureId, cancellationToken);

                _logger.LogInformation("Lecture {LectureId} marked as completed for user {UserId}", request.LectureId, userId);

                return Ok(new ApiResponse<CourseProgressDto>
                {
                    Success = true,
                    Message = "Lecture marked as completed successfully",
                    Data = progress
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking lecture {LectureId} as completed", request.LectureId);
                return StatusCode(500, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while marking lecture as completed",
                    Error = ex.Message
                });
            }
        }

        // نموذج ApiResponse للمساعدة في التوحيد
        public class ApiResponse
        {
            public bool Success { get; set; }
            public string Message { get; set; }
            public string Error { get; set; }
        }

        public class ApiResponse<T> : ApiResponse
        {
            public T Data { get; set; }
        }
        [HttpPost("mark-incomplete")]
        [ProducesResponseType(typeof(CourseProgressDto), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> MarkLectureAsIncomplete([FromBody] MarkLectureCompletedRequest request, CancellationToken cancellationToken = default)
        {
            try
            {
                var userId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(userId))
                    return Unauthorized(new { success = false, message = "User not authenticated" });

                var enrollment = await _enrollmentService.GetUserCourseEnrollmentAsync(userId, request.CourseId, cancellationToken);
                if (enrollment == null)
                    return BadRequest(new { success = false, message = "User is not enrolled in this course" });

                var progress = await _courseProgressService.MarkLectureAsIncompleteAsync(enrollment.Id, request.LectureId, cancellationToken);

                _logger.LogInformation("Lecture {LectureId} marked as incomplete for user {UserId}", request.LectureId, userId);

                return Ok(new
                {
                    success = true,
                    message = "Lecture marked as incomplete",
                    data = progress
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking lecture {LectureId} as incomplete", request.LectureId);
                return StatusCode(500, new
                {
                    success = false,
                    message = "An error occurred while marking lecture as incomplete",
                    error = ex.Message
                });
            }
        }


        [HttpGet("enrollment/{enrollmentId}")]
        [ProducesResponseType(typeof(List<CourseProgressDto>), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetProgressByEnrollment(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                var progress = await _courseProgressService.GetProgressByEnrollmentAsync(enrollmentId, cancellationToken);
                return Ok(progress);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting progress for enrollment {EnrollmentId}", enrollmentId);
                return StatusCode(500, new { message = "An error occurred while retrieving progress", error = ex.Message });
            }
        }

        [HttpGet("course/{courseId}/progress")]
        [ProducesResponseType(typeof(CourseProgressSummaryDto), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetCourseProgress(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                var userId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(userId))
                    return Unauthorized(new { success = false, message = "User not authenticated" });

                var enrollment = await _enrollmentService.GetUserCourseEnrollmentAsync(userId, courseId, cancellationToken);
                if (enrollment == null)
                    return BadRequest(new { success = false, message = "User is not enrolled in this course" });

                var progressSummary = await _courseProgressService.GetCourseProgressSummaryAsync(enrollment.Id, cancellationToken);

                return Ok(new
                {
                    success = true,
                    message = "Progress retrieved successfully",
                    data = progressSummary
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting progress for course {CourseId}", courseId);
                return StatusCode(500, new
                {
                    success = false,
                    message = "An error occurred while retrieving course progress",
                    error = ex.Message
                });
            }
        }

        [HttpGet("enrollment/{enrollmentId}/summary")]
        [ProducesResponseType(typeof(CourseProgressSummaryDto), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetProgressSummary(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                var summary = await _courseProgressService.GetCourseProgressSummaryAsync(enrollmentId, cancellationToken);
                return Ok(summary);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting progress summary for enrollment {EnrollmentId}", enrollmentId);
                return StatusCode(500, new { message = "An error occurred while retrieving progress summary", error = ex.Message });
            }
        }

        [HttpGet("lecture/{lectureId}/status")]
        [ProducesResponseType(typeof(bool), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetLectureStatus(int lectureId, [FromQuery] int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                var userId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(userId))
                    return Unauthorized(new { message = "User not authenticated" });

                var enrollment = await _enrollmentService.GetUserCourseEnrollmentAsync(userId, courseId, cancellationToken);
                if (enrollment == null)
                    return BadRequest(new { message = "User is not enrolled in this course" });

                var isCompleted = await _courseProgressService.IsLectureCompletedAsync(enrollment.Id, lectureId, cancellationToken);
                return Ok(new { isCompleted });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting status for lecture {LectureId}", lectureId);
                return StatusCode(500, new { message = "An error occurred while checking lecture status", error = ex.Message });
            }
        }
    }
}