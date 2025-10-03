// EduLab_API/Controllers/RatingsController.cs
using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Rating;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EduLab_API.Controllers
{
    #region Ratings API Controller
    /// <summary>
    /// API Controller for handling rating operations
    /// Provides endpoints for managing course ratings and reviews
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Produces("application/json")]
    public class RatingsController : ControllerBase
    {
        #region Fields
        private readonly IRatingService _ratingService;
        private readonly ILogger<RatingsController> _logger;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the RatingsController class
        /// </summary>
        /// <param name="ratingService">Rating service for business logic</param>
        /// <param name="logger">Logger instance for logging operations</param>
        /// <exception cref="ArgumentNullException">Thrown when ratingService or logger is null</exception>
        public RatingsController(IRatingService ratingService, ILogger<RatingsController> logger)
        {
            _ratingService = ratingService ?? throw new ArgumentNullException(nameof(ratingService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }
        #endregion

        #region GET Operations
        /// <summary>
        /// Retrieves all ratings for a specific course with pagination
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="page">Page number for pagination (default: 1)</param>
        /// <param name="pageSize">Number of items per page (default: 10)</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of ratings for the specified course</returns>
        [HttpGet("course/{courseId}")]
        [ProducesResponseType(typeof(List<RatingDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetCourseRatings(
            int courseId,
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 10,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "GetCourseRatings";

            try
            {
                _logger.LogInformation("Starting {OperationName} for Course: {CourseId}, Page: {Page}, PageSize: {PageSize}",
                    operationName, courseId, page, pageSize);

                var ratings = await _ratingService.GetCourseRatingsAsync(courseId, page, pageSize, cancellationToken);

                _logger.LogInformation("Successfully retrieved {Count} ratings for Course: {CourseId}",
                    ratings.Count, courseId);

                return Ok(ratings);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for Course: {CourseId}", operationName, courseId);
                return StatusCode(500, "حدث خطأ أثناء جلب التقييمات");
            }
        }

        /// <summary>
        /// Retrieves rating summary for a specific course
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Course rating summary with statistics</returns>
        [HttpGet("course/{courseId}/summary")]
        [ProducesResponseType(typeof(CourseRatingSummaryDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetCourseRatingSummary(int courseId, CancellationToken cancellationToken = default)
        {
            const string operationName = "GetCourseRatingSummary";

            try
            {
                _logger.LogInformation("Starting {OperationName} for Course: {CourseId}", operationName, courseId);

                var summary = await _ratingService.GetCourseRatingSummaryAsync(courseId, cancellationToken);

                _logger.LogInformation("Successfully retrieved rating summary for Course: {CourseId}", courseId);

                return Ok(summary);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for Course: {CourseId}", operationName, courseId);
                return StatusCode(500, "حدث خطأ أثناء جلب ملخص التقييمات");
            }
        }

        /// <summary>
        /// Retrieves the current user's rating for a specific course
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>User's rating for the course or null if not found</returns>
        [Authorize]
        [HttpGet("course/{courseId}/my-rating")]
        [ProducesResponseType(typeof(RatingDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetMyRating(int courseId, CancellationToken cancellationToken = default)
        {
            const string operationName = "GetMyRating";

            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("Unauthorized access attempt in {OperationName}", operationName);
                    return Unauthorized();
                }

                _logger.LogInformation("Starting {OperationName} for User: {UserId}, Course: {CourseId}",
                    operationName, userId, courseId);

                var rating = await _ratingService.GetUserRatingForCourseAsync(userId, courseId, cancellationToken);

                _logger.LogInformation("Successfully retrieved user rating for Course: {CourseId}", courseId);

                return Ok(rating);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for Course: {CourseId}", operationName, courseId);
                return StatusCode(500, "حدث خطأ أثناء جلب التقييم");
            }
        }

        /// <summary>
        /// Checks if the current user can rate a specific course
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Rating eligibility information</returns>
        [Authorize]
        [HttpGet("can-rate/{courseId}")]
        [ProducesResponseType(typeof(CanRateResponseDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> CanUserRateCourse(int courseId, CancellationToken cancellationToken = default)
        {
            const string operationName = "CanUserRateCourse";

            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("Unauthorized access attempt in {OperationName}", operationName);
                    return Unauthorized();
                }

                _logger.LogInformation("Starting {OperationName} for User: {UserId}, Course: {CourseId}",
                    operationName, userId, courseId);

                var result = await _ratingService.CanUserRateCourseAsync(userId, courseId, cancellationToken);

                _logger.LogInformation("Successfully checked rating eligibility for User: {UserId}, Course: {CourseId}",
                    userId, courseId);

                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for Course: {CourseId}", operationName, courseId);
                return StatusCode(500, "حدث خطأ أثناء التحقق من إمكانية التقييم");
            }
        }
        #endregion

        #region POST Operations
        /// <summary>
        /// Adds a new rating for a course
        /// </summary>
        /// <param name="createRatingDto">Rating data to create</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Created rating information</returns>
        [Authorize]
        [HttpPost]
        [ProducesResponseType(typeof(RatingDto), StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> AddRating(
            [FromBody] CreateRatingDto createRatingDto,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "AddRating";

            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("Unauthorized access attempt in {OperationName}", operationName);
                    return Unauthorized();
                }

                _logger.LogInformation("Starting {OperationName} for User: {UserId}, Course: {CourseId}",
                    operationName, userId, createRatingDto.CourseId);

                var rating = await _ratingService.AddRatingAsync(userId, createRatingDto, cancellationToken);

                _logger.LogInformation("Successfully added rating for Course: {CourseId} by User: {UserId}",
                    createRatingDto.CourseId, userId);

                return CreatedAtAction(nameof(GetMyRating), new { courseId = createRatingDto.CourseId }, rating);
            }
            catch (InvalidOperationException ex)
            {
                _logger.LogWarning("Business rule violation in {OperationName}: {ErrorMessage}", operationName, ex.Message);
                return BadRequest(ex.Message);
            }
            catch (ArgumentException ex)
            {
                _logger.LogWarning("Invalid argument in {OperationName}: {ErrorMessage}", operationName, ex.Message);
                return BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for Course: {CourseId}", operationName, createRatingDto.CourseId);
                return StatusCode(500, "حدث خطأ أثناء إضافة التقييم");
            }
        }
        #endregion

        #region PUT Operations
        /// <summary>
        /// Updates an existing rating
        /// </summary>
        /// <param name="ratingId">Rating identifier to update</param>
        /// <param name="updateRatingDto">Updated rating data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Updated rating information</returns>
        [Authorize]
        [HttpPut("{ratingId}")]
        [ProducesResponseType(typeof(RatingDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> UpdateRating(
            int ratingId,
            [FromBody] UpdateRatingDto updateRatingDto,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "UpdateRating";

            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("Unauthorized access attempt in {OperationName}", operationName);
                    return Unauthorized();
                }

                _logger.LogInformation("Starting {OperationName} for Rating ID: {RatingId} by User: {UserId}",
                    operationName, ratingId, userId);

                var rating = await _ratingService.UpdateRatingAsync(userId, ratingId, updateRatingDto, cancellationToken);

                _logger.LogInformation("Successfully updated Rating ID: {RatingId} by User: {UserId}", ratingId, userId);

                return Ok(rating);
            }
            catch (KeyNotFoundException ex)
            {
                _logger.LogWarning("Rating not found in {OperationName}: {ErrorMessage}", operationName, ex.Message);
                return NotFound(ex.Message);
            }
            catch (ArgumentException ex)
            {
                _logger.LogWarning("Invalid argument in {OperationName}: {ErrorMessage}", operationName, ex.Message);
                return BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for Rating ID: {RatingId}", operationName, ratingId);
                return StatusCode(500, "حدث خطأ أثناء تحديث التقييم");
            }
        }
        #endregion

        #region DELETE Operations
        /// <summary>
        /// Deletes a user's rating
        /// </summary>
        /// <param name="ratingId">Rating identifier to delete</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>No content if deletion was successful</returns>
        [Authorize]
        [HttpDelete("{ratingId}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> DeleteRating(int ratingId, CancellationToken cancellationToken = default)
        {
            const string operationName = "DeleteRating";

            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("Unauthorized access attempt in {OperationName}", operationName);
                    return Unauthorized();
                }

                _logger.LogInformation("Starting {OperationName} for Rating ID: {RatingId} by User: {UserId}",
                    operationName, ratingId, userId);

                await _ratingService.DeleteRatingAsync(userId, ratingId, cancellationToken);

                _logger.LogInformation("Successfully deleted Rating ID: {RatingId} by User: {UserId}", ratingId, userId);

                return NoContent();
            }
            catch (KeyNotFoundException ex)
            {
                _logger.LogWarning("Rating not found in {OperationName}: {ErrorMessage}", operationName, ex.Message);
                return NotFound(ex.Message);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for Rating ID: {RatingId}", operationName, ratingId);
                return StatusCode(500, "حدث خطأ أثناء حذف التقييم");
            }
        }
        #endregion
    }
    #endregion
}