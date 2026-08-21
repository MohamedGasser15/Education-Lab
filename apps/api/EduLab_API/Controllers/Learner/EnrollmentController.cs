using EduLab_Application.ServiceInterfaces;
using EduLab_Application.DTOs.Enrollment;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Learner
{
    /// <summary>
    /// Controller for managing course enrollments for the current user
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    [Produces("application/json")]
    [Authorize]
    public class EnrollmentController : ControllerBase
    {
        private readonly IEnrollmentService _enrollmentService;
        private readonly ILogger<EnrollmentController> _logger;

        /// <summary>
        /// Initializes a new instance of the EnrollmentController class
        /// </summary>
        /// <param name="enrollmentService">The enrollment service</param>
        /// <param name="logger">The logger instance</param>
        public EnrollmentController(
            IEnrollmentService enrollmentService,
            ILogger<EnrollmentController> logger)
        {
            _enrollmentService = enrollmentService ?? throw new ArgumentNullException(nameof(enrollmentService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        /// <summary>
        /// Retrieves the user ID from the current claims principal
        /// </summary>
        /// <returns>The user ID or null if not authenticated</returns>
        private string GetUserId()
        {
            return User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        }

        /// <summary>
        /// Gets all enrollments for the current user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of enrollments</returns>
        /// <response code="200">Returns the list of enrollments</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet]
        [ProducesResponseType(typeof(IEnumerable<EnrollmentDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<IEnumerable<EnrollmentDto>>> GetUserEnrollments(CancellationToken cancellationToken = default)
        {
            try
            {
                var userId = GetUserId();
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized();
                }

                var enrollments = await _enrollmentService.GetUserEnrollmentsAsync(userId, cancellationToken);
                return Ok(enrollments);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting user enrollments");
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while retrieving enrollments");
            }
        }

        /// <summary>
        /// Gets a single enrollment by ID
        /// </summary>
        /// <param name="enrollmentId">Enrollment ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The enrollment</returns>
        /// <response code="200">Returns the enrollment</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="404">If the enrollment was not found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("{enrollmentId:int}")]
        [ProducesResponseType(typeof(EnrollmentDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<EnrollmentDto>> GetEnrollmentById(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                var userId = GetUserId();
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized();
                }

                var enrollment = await _enrollmentService.GetEnrollmentByIdAsync(enrollmentId, cancellationToken);
                if (enrollment == null)
                {
                    return NotFound();
                }

                return Ok(enrollment);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting enrollment by ID: {EnrollmentId}", enrollmentId);
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while retrieving the enrollment");
            }
        }

        /// <summary>
        /// Gets the current user's enrollment in a specific course
        /// </summary>
        /// <param name="courseId">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The enrollment</returns>
        /// <response code="200">Returns the enrollment</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="404">If the enrollment was not found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("course/{courseId:int}")]
        [ProducesResponseType(typeof(EnrollmentDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<EnrollmentDto>> GetCourseEnrollment(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                var userId = GetUserId();
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized();
                }

                var enrollment = await _enrollmentService.GetUserCourseEnrollmentAsync(userId, courseId, cancellationToken);
                if (enrollment == null)
                {
                    return NotFound();
                }

                return Ok(enrollment);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting course enrollment for course ID: {CourseId}", courseId);
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while retrieving the course enrollment");
            }
        }

        /// <summary>
        /// Enrolls the current user in a course
        /// </summary>
        /// <param name="courseId">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The created enrollment</returns>
        /// <response code="201">Returns the created enrollment</response>
        /// <response code="400">If the request is invalid</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="404">If the course was not found</response>
        /// <response code="409">If the user is already enrolled</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPost("course/{courseId:int}")]
        [ProducesResponseType(typeof(EnrollmentDto), StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status409Conflict)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<EnrollmentDto>> EnrollInCourse(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                var userId = GetUserId();
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized();
                }

                var enrollment = await _enrollmentService.CreateEnrollmentAsync(userId, courseId, cancellationToken);
                return CreatedAtAction(nameof(GetEnrollmentById), new { enrollmentId = enrollment.Id }, enrollment);
            }
            catch (InvalidOperationException ex)
            {
                _logger.LogWarning(ex, "User already enrolled in course: {CourseId}", courseId);
                return Conflict(new { message = ex.Message });
            }
            catch (KeyNotFoundException ex)
            {
                _logger.LogWarning(ex, "Course not found: {CourseId}", courseId);
                return NotFound(new { message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error enrolling in course: {CourseId}", courseId);
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while enrolling in the course");
            }
        }

        /// <summary>
        /// Unenrolls the current user from a course
        /// </summary>
        /// <param name="enrollmentId">Enrollment ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>No content if successful</returns>
        /// <response code="204">If the enrollment was removed successfully</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="404">If the enrollment was not found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpDelete("{enrollmentId:int}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> Unenroll(int enrollmentId, CancellationToken cancellationToken = default)
        {
            try
            {
                var userId = GetUserId();
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized();
                }

                var success = await _enrollmentService.DeleteEnrollmentAsync(enrollmentId, cancellationToken);
                if (!success)
                {
                    return NotFound();
                }

                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error unenrolling from enrollment: {EnrollmentId}", enrollmentId);
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while unenrolling from the course");
            }
        }

        /// <summary>
        /// Gets the total number of enrollments for the current user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The enrollment count</returns>
        /// <response code="200">Returns the enrollment count</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("count")]
        [ProducesResponseType(typeof(int), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<int>> GetEnrollmentsCount(CancellationToken cancellationToken = default)
        {
            try
            {
                var userId = GetUserId();
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized();
                }

                var count = await _enrollmentService.GetUserEnrollmentsCountAsync(userId, cancellationToken);
                return Ok(count);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting enrollments count");
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while retrieving enrollments count");
            }
        }

        /// <summary>
        /// Checks whether the current user is enrolled in a course
        /// </summary>
        /// <param name="courseId">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if the user is enrolled, otherwise false</returns>
        /// <response code="200">Returns the enrollment status</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("check/{courseId:int}")]
        [ProducesResponseType(typeof(bool), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<bool>> CheckEnrollment(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                var userId = GetUserId();
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized();
                }

                var isEnrolled = await _enrollmentService.IsUserEnrolledInCourseAsync(userId, courseId, cancellationToken);
                return Ok(isEnrolled);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error checking enrollment for course: {CourseId}", courseId);
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while checking enrollment");
            }
        }
    }
}