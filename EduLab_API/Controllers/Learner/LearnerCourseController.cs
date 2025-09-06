using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Course;
using EduLab_Shared.DTOs.Lecture;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel;

namespace EduLab_API.Controllers.Learner
{
    /// <summary>
    /// Controller for learner course operations
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Produces("application/json")]
    [DisplayName("Learner Course Management")]
    [Description("APIs for retrieving approved courses for learners")]
    [AllowAnonymous]
    public class LearnerCourseController : ControllerBase
    {
        private readonly ICourseService _courseService;
        private readonly ILogger<LearnerCourseController> _logger;

        /// <summary>
        /// Initializes a new instance of the LearnerCourseController class
        /// </summary>
        /// <param name="courseService">Course service</param>
        /// <param name="logger">Logger instance</param>
        public LearnerCourseController(
            ICourseService courseService,
            ILogger<LearnerCourseController> logger)
        {
            _courseService = courseService;
            _logger = logger;
        }

        /// <summary>
        /// Gets approved courses by categories
        /// </summary>
        /// <param name="categoryIds">List of category IDs</param>
        /// <param name="countPerCategory">Number of courses per category (default: 10)</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of approved courses by categories</returns>
        /// <response code="200">Returns the list of courses</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("approved/by-categories")]
        [ProducesResponseType(typeof(IEnumerable<CourseDTO>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetApprovedCoursesByCategories(
            [FromQuery] List<int> categoryIds,
            [FromQuery] int countPerCategory = 10,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting approved courses for categories: {CategoryIds} with count: {CountPerCategory}",
                    string.Join(",", categoryIds), countPerCategory);

                var courses = await _courseService.GetApprovedCoursesByCategoriesAsync(categoryIds, countPerCategory, cancellationToken);

                _logger.LogInformation("Retrieved {Count} approved courses for categories: {CategoryIds}",
                    courses?.Count() ?? 0, string.Join(",", categoryIds));

                return Ok(courses);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get approved courses by categories operation was cancelled");
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving approved courses by categories: {CategoryIds}",
                    string.Join(",", categoryIds));

                return StatusCode(500, new { message = "An error occurred", error = ex.Message });
            }
        }


        /// <summary>
        /// Gets approved courses by instructor
        /// </summary>
        /// <param name="instructorId">Instructor ID</param>
        /// <param name="count">Number of courses to retrieve (0 for all)</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of approved courses by instructor</returns>
        /// <response code="200">Returns the list of courses</response>
        /// <response code="404">If no courses are found for the instructor</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("approved/by-instructor/{instructorId}")]
        [ProducesResponseType(typeof(IEnumerable<CourseDTO>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetApprovedCoursesByInstructor(
            string instructorId,
            [FromQuery] int count = 0,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting approved courses for instructor ID: {InstructorId} with count: {Count}",
                    instructorId, count);

                var courses = await _courseService.GetApprovedCoursesByInstructorAsync(instructorId, count, cancellationToken);

                if (courses == null || !courses.Any())
                {
                    _logger.LogWarning("No approved courses found for instructor with ID: {InstructorId}", instructorId);
                    return NotFound(new { message = $"No approved courses found for instructor with ID {instructorId}" });
                }

                _logger.LogInformation("Retrieved {Count} approved courses for instructor ID: {InstructorId}",
                    courses.Count(), instructorId);

                return Ok(courses);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get approved courses by instructor operation was cancelled. Instructor ID: {InstructorId}", instructorId);
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving approved courses for instructor ID: {InstructorId}", instructorId);

                return StatusCode(500, new
                {
                    message = "An error occurred while retrieving approved courses by instructor",
                    error = ex.Message
                });
            }
        }


        /// <summary>
        /// Gets approved courses by category
        /// </summary>
        /// <param name="categoryId">Category ID</param>
        /// <param name="count">Number of courses to retrieve (default: 10)</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of approved courses by category</returns>
        /// <response code="200">Returns the list of courses</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("approved/by-category/{categoryId}")]
        [ProducesResponseType(typeof(IEnumerable<CourseDTO>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetApprovedCoursesByCategory(
            int categoryId,
            [FromQuery] int count = 10,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting approved courses for category ID: {CategoryId} with count: {Count}",
                    categoryId, count);

                var courses = await _courseService.GetApprovedCoursesByCategoryAsync(categoryId, count, cancellationToken);

                _logger.LogInformation("Retrieved {Count} approved courses for category ID: {CategoryId}",
                    courses?.Count() ?? 0, categoryId);

                return Ok(courses);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get approved courses by category operation was cancelled. Category ID: {CategoryId}", categoryId);
                return StatusCode(499, new { message = "Request was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving approved courses for category ID: {CategoryId}", categoryId);

                return StatusCode(500, new { message = "An error occurred", error = ex.Message });
            }
        }
    }
}