using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.CourseProgress;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Learner
{
    /// <summary>
    /// API Controller for managing course progress and tracking learning activities
    /// Provides endpoints for tracking lecture completion and progress analytics
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    [Produces("application/json")]
    [DisplayName("Course Progress Management")]
    [Description("APIs for managing course progress and tracking learning activities")]
    public class CourseProgressController : ControllerBase
    {
        #region Private Fields

        private readonly ICourseProgressService _courseProgressService;
        private readonly IEnrollmentService _enrollmentService;
        private readonly ICurrentUserService _currentUserService;
        private readonly ILogger<CourseProgressController> _logger;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the <see cref="CourseProgressController"/> class
        /// </summary>
        /// <param name="courseProgressService">The course progress service</param>
        /// <param name="enrollmentService">The enrollment service</param>
        /// <param name="currentUserService">The current user service</param>
        /// <param name="logger">The logger instance</param>
        /// <exception cref="ArgumentNullException">Thrown when any dependency is null</exception>
        public CourseProgressController(
            ICourseProgressService courseProgressService,
            IEnrollmentService enrollmentService,
            ICurrentUserService currentUserService,
            ILogger<CourseProgressController> logger)
        {
            _courseProgressService = courseProgressService ?? throw new ArgumentNullException(nameof(courseProgressService));
            _enrollmentService = enrollmentService ?? throw new ArgumentNullException(nameof(enrollmentService));
            _currentUserService = currentUserService ?? throw new ArgumentNullException(nameof(currentUserService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #endregion



        #region Progress Tracking Operations

        /// <summary>
        /// Marks a lecture as completed for the current user
        /// </summary>
        /// <param name="request">The mark lecture completed request</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// The API response containing the course progress DTO
        /// </returns>
        /// <response code="200">Returns the updated course progress</response>
        /// <response code="400">If the request is invalid or user not enrolled</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="500">If an internal server error occurs</response>
        [HttpPost("mark-completed")]
        [ProducesResponseType(typeof(ApiResponse<CourseProgressDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> MarkLectureAsCompleted(
            [FromBody] MarkLectureCompletedRequest request,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Mark lecture as completed request received: {@Request}", request);

                #region Request Validation

                if (request == null)
                {
                    _logger.LogWarning("Mark lecture as completed request body is null");
                    return BadRequest(new ApiResponse
                    {
                        Success = false,
                        Message = "Request body is required"
                    });
                }

                if (request.CourseId <= 0 || request.LectureId <= 0)
                {
                    _logger.LogWarning("Invalid course or lecture ID: CourseId={CourseId}, LectureId={LectureId}",
                        request.CourseId, request.LectureId);
                    return BadRequest(new ApiResponse
                    {
                        Success = false,
                        Message = "Invalid course or lecture ID"
                    });
                }

                #endregion

                #region User Authentication

                var userId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("User not authenticated for mark lecture as completed request");
                    return Unauthorized(new ApiResponse
                    {
                        Success = false,
                        Message = "User not authenticated"
                    });
                }

                #endregion

                #region Enrollment Validation

                var enrollment = await _enrollmentService.GetUserCourseEnrollmentAsync(userId, request.CourseId, cancellationToken);
                if (enrollment == null)
                {
                    _logger.LogWarning("User {UserId} is not enrolled in course {CourseId}", userId, request.CourseId);
                    return BadRequest(new ApiResponse
                    {
                        Success = false,
                        Message = "User is not enrolled in this course"
                    });
                }

                #endregion

                #region Progress Update

                _logger.LogInformation("Marking lecture {LectureId} as completed for user {UserId} in course {CourseId}",
                    request.LectureId, userId, request.CourseId);

                var progress = await _courseProgressService.MarkLectureAsCompletedAsync(
                    enrollment.Id, request.LectureId, cancellationToken);

                _logger.LogInformation("Successfully marked lecture {LectureId} as completed for user {UserId}",
                    request.LectureId, userId);

                #endregion

                return Ok(new ApiResponse<CourseProgressDto>
                {
                    Success = true,
                    Message = "Lecture marked as completed successfully",
                    Data = progress
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking lecture {LectureId} as completed for request {@Request}",
                    request?.LectureId, request);
                return StatusCode(500, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while marking lecture as completed",
                    Error = ex.Message
                });
            }
        }

        /// <summary>
        /// Marks a lecture as incomplete for the current user
        /// </summary>
        /// <param name="request">The mark lecture completed request</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// The API response containing the course progress DTO
        /// </returns>
        /// <response code="200">Returns the updated course progress</response>
        /// <response code="400">If the request is invalid or user not enrolled</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="500">If an internal server error occurs</response>
        [HttpPost("mark-incomplete")]
        [ProducesResponseType(typeof(ApiResponse<CourseProgressDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> MarkLectureAsIncomplete(
            [FromBody] MarkLectureCompletedRequest request,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Mark lecture as incomplete request received: {@Request}", request);

                #region Request Validation

                if (request == null)
                {
                    _logger.LogWarning("Mark lecture as incomplete request body is null");
                    return BadRequest(new ApiResponse
                    {
                        Success = false,
                        Message = "Request body is required"
                    });
                }

                if (request.CourseId <= 0 || request.LectureId <= 0)
                {
                    _logger.LogWarning("Invalid course or lecture ID: CourseId={CourseId}, LectureId={LectureId}",
                        request.CourseId, request.LectureId);
                    return BadRequest(new ApiResponse
                    {
                        Success = false,
                        Message = "Invalid course or lecture ID"
                    });
                }

                #endregion

                #region User Authentication

                var userId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("User not authenticated for mark lecture as incomplete request");
                    return Unauthorized(new ApiResponse
                    {
                        Success = false,
                        Message = "User not authenticated"
                    });
                }

                #endregion

                #region Enrollment Validation

                var enrollment = await _enrollmentService.GetUserCourseEnrollmentAsync(userId, request.CourseId, cancellationToken);
                if (enrollment == null)
                {
                    _logger.LogWarning("User {UserId} is not enrolled in course {CourseId}", userId, request.CourseId);
                    return BadRequest(new ApiResponse
                    {
                        Success = false,
                        Message = "User is not enrolled in this course"
                    });
                }

                #endregion

                #region Progress Update

                _logger.LogInformation("Marking lecture {LectureId} as incomplete for user {UserId} in course {CourseId}",
                    request.LectureId, userId, request.CourseId);

                var progress = await _courseProgressService.MarkLectureAsIncompleteAsync(
                    enrollment.Id, request.LectureId, cancellationToken);

                if (progress == null)
                {
                    _logger.LogWarning("Progress record not found for lecture {LectureId} and enrollment {EnrollmentId}",
                        request.LectureId, enrollment.Id);
                    return BadRequest(new ApiResponse
                    {
                        Success = false,
                        Message = "Progress record not found"
                    });
                }

                _logger.LogInformation("Successfully marked lecture {LectureId} as incomplete for user {UserId}",
                    request.LectureId, userId);

                #endregion

                return Ok(new ApiResponse<CourseProgressDto>
                {
                    Success = true,
                    Message = "Lecture marked as incomplete successfully",
                    Data = progress
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking lecture {LectureId} as incomplete for request {@Request}",
                    request?.LectureId, request);
                return StatusCode(500, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while marking lecture as incomplete",
                    Error = ex.Message
                });
            }
        }

        #endregion

        #region Progress Retrieval Operations

        /// <summary>
        /// Gets all progress records for a specific enrollment
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// The API response containing list of course progress DTOs
        /// </returns>
        /// <response code="200">Returns the list of course progress records</response>
        /// <response code="500">If an internal server error occurs</response>
        [HttpGet("enrollment/{enrollmentId}")]
        [ProducesResponseType(typeof(ApiResponse<List<CourseProgressDto>>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetProgressByEnrollment(
            int enrollmentId,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving progress for enrollment {EnrollmentId}", enrollmentId);

                var progress = await _courseProgressService.GetProgressByEnrollmentAsync(enrollmentId, cancellationToken);

                _logger.LogInformation("Successfully retrieved {Count} progress records for enrollment {EnrollmentId}",
                    progress.Count, enrollmentId);

                return Ok(new ApiResponse<List<CourseProgressDto>>
                {
                    Success = true,
                    Message = "Progress records retrieved successfully",
                    Data = progress
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting progress for enrollment {EnrollmentId}", enrollmentId);
                return StatusCode(500, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while retrieving progress",
                    Error = ex.Message
                });
            }
        }

        /// <summary>
        /// Gets the course progress summary for the current user
        /// </summary>
        /// <param name="courseId">The course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// The API response containing the course progress summary
        /// </returns>
        /// <response code="200">Returns the course progress summary</response>
        /// <response code="400">If user is not enrolled in the course</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="500">If an internal server error occurs</response>
        [HttpGet("course/{courseId}/progress")]
        [ProducesResponseType(typeof(ApiResponse<CourseProgressSummaryDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetCourseProgress(
            int courseId,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving course progress for course {CourseId}", courseId);

                #region User Authentication

                var userId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("User not authenticated for get course progress request");
                    return Unauthorized(new ApiResponse
                    {
                        Success = false,
                        Message = "User not authenticated"
                    });
                }

                #endregion

                #region Enrollment Validation

                var enrollment = await _enrollmentService.GetUserCourseEnrollmentAsync(userId, courseId, cancellationToken);
                if (enrollment == null)
                {
                    _logger.LogWarning("User {UserId} is not enrolled in course {CourseId}", userId, courseId);
                    return BadRequest(new ApiResponse
                    {
                        Success = false,
                        Message = "User is not enrolled in this course"
                    });
                }

                #endregion

                #region Progress Retrieval

                var progressSummary = await _courseProgressService.GetCourseProgressSummaryAsync(enrollment.Id, cancellationToken);

                if (progressSummary == null)
                {
                    _logger.LogWarning("Progress summary not found for enrollment {EnrollmentId}", enrollment.Id);
                    return NotFound(new ApiResponse
                    {
                        Success = false,
                        Message = "Progress summary not found"
                    });
                }

                _logger.LogInformation("Successfully retrieved progress summary for course {CourseId} and user {UserId}",
                    courseId, userId);

                #endregion

                return Ok(new ApiResponse<CourseProgressSummaryDto>
                {
                    Success = true,
                    Message = "Progress retrieved successfully",
                    Data = progressSummary
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting progress for course {CourseId}", courseId);
                return StatusCode(500, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while retrieving course progress",
                    Error = ex.Message
                });
            }
        }

        /// <summary>
        /// Gets the progress summary for a specific enrollment
        /// </summary>
        /// <param name="enrollmentId">The enrollment identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// The API response containing the course progress summary
        /// </returns>
        /// <response code="200">Returns the course progress summary</response>
        /// <response code="404">If progress summary not found</response>
        /// <response code="500">If an internal server error occurs</response>
        [HttpGet("enrollment/{enrollmentId}/summary")]
        [ProducesResponseType(typeof(ApiResponse<CourseProgressSummaryDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetProgressSummary(
            int enrollmentId,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving progress summary for enrollment {EnrollmentId}", enrollmentId);

                var summary = await _courseProgressService.GetCourseProgressSummaryAsync(enrollmentId, cancellationToken);

                if (summary == null)
                {
                    _logger.LogWarning("Progress summary not found for enrollment {EnrollmentId}", enrollmentId);
                    return NotFound(new ApiResponse
                    {
                        Success = false,
                        Message = "Progress summary not found"
                    });
                }

                _logger.LogInformation("Successfully retrieved progress summary for enrollment {EnrollmentId}", enrollmentId);

                return Ok(new ApiResponse<CourseProgressSummaryDto>
                {
                    Success = true,
                    Message = "Progress summary retrieved successfully",
                    Data = summary
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting progress summary for enrollment {EnrollmentId}", enrollmentId);
                return StatusCode(500, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while retrieving progress summary",
                    Error = ex.Message
                });
            }
        }

        /// <summary>
        /// Gets the completion status of a specific lecture for the current user
        /// </summary>
        /// <param name="lectureId">The lecture identifier</param>
        /// <param name="courseId">The course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>
        /// The API response containing the lecture completion status
        /// </returns>
        /// <response code="200">Returns the lecture completion status</response>
        /// <response code="400">If user is not enrolled in the course</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="500">If an internal server error occurs</response>
        [HttpGet("lecture/{lectureId}/status")]
        [ProducesResponseType(typeof(ApiResponse<bool>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ApiResponse), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetLectureStatus(int lectureId, [FromQuery] int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving status for lecture {LectureId} in course {CourseId}", lectureId, courseId);

                #region User Authentication

                var userId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("User not authenticated for get lecture status request");
                    return Unauthorized(new ApiResponse
                    {
                        Success = false,
                        Message = "User not authenticated"
                    });
                }

                #endregion

                #region Enrollment Validation

                var enrollment = await _enrollmentService.GetUserCourseEnrollmentAsync(userId, courseId, cancellationToken);
                if (enrollment == null)
                {
                    _logger.LogWarning("User {UserId} is not enrolled in course {CourseId}", userId, courseId);
                    return BadRequest(new ApiResponse
                    {
                        Success = false,
                        Message = "User is not enrolled in this course"
                    });
                }

                #endregion

                #region Status Retrieval

                var isCompleted = await _courseProgressService.IsLectureCompletedAsync(enrollment.Id, lectureId, cancellationToken);

                _logger.LogInformation("Lecture {LectureId} completion status for user {UserId}: {IsCompleted}",
                    lectureId, userId, isCompleted);

                #endregion

                return Ok(new { isCompleted });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting status for lecture {LectureId} in course {CourseId}", lectureId, courseId);
                return StatusCode(500, new ApiResponse
                {
                    Success = false,
                    Message = "An error occurred while checking lecture status",
                    Error = ex.Message
                });
            }
        }

        #endregion
    }
}