// EduLab_MVC/Controllers/RatingController.cs
using EduLab_MVC.Models.DTOs.Rating;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace EduLab_MVC.Controllers
{
    #region Rating MVC Controller
    /// <summary>
    /// MVC Controller for handling rating operations in the presentation layer
    /// Provides views and actions for rating management
    /// </summary>
    [Area("Learner")]
    [Authorize]
    public class RatingController : Controller
    {
        #region Fields
        private readonly IRatingService _ratingService;
        private readonly IEnrollmentService _enrollmentService;
        private readonly ILogger<RatingController> _logger;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the RatingController class
        /// </summary>
        /// <param name="ratingService">Rating service for business logic</param>
        /// <param name="enrollmentService">Enrollment service for validation</param>
        /// <param name="logger">Logger instance for logging operations</param>
        /// <exception cref="ArgumentNullException">Thrown when any dependency is null</exception>
        public RatingController(
            IRatingService ratingService,
            IEnrollmentService enrollmentService,
            ILogger<RatingController> logger)
        {
            _ratingService = ratingService ?? throw new ArgumentNullException(nameof(ratingService));
            _enrollmentService = enrollmentService ?? throw new ArgumentNullException(nameof(enrollmentService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }
        #endregion

        #region Public Actions
        /// <summary>
        /// Displays all ratings for a specific course
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="page">Page number for pagination (default: 1)</param>
        /// <param name="pageSize">Number of items per page (default: 10)</param>
        /// <returns>View displaying course ratings</returns>
        [AllowAnonymous]
        public async Task<IActionResult> CourseRatings(int courseId, int page = 1, int pageSize = 10)
        {
            const string operationName = "CourseRatings";

            try
            {
                _logger.LogInformation("Starting {OperationName} for Course ID: {CourseId}", operationName, courseId);

                var ratings = await _ratingService.GetCourseRatingsAsync(courseId, page, pageSize);
                var summary = await _ratingService.GetCourseRatingSummaryAsync(courseId);

                ViewBag.CourseId = courseId;
                ViewBag.Summary = summary;
                ViewBag.CurrentPage = page;
                ViewBag.PageSize = pageSize;

                _logger.LogInformation("Successfully loaded {Count} ratings for Course ID: {CourseId}",
                    ratings.Count, courseId);

                return View(ratings);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for Course ID: {CourseId}", operationName, courseId);
                TempData["Error"] = "حدث خطأ أثناء تحميل التقييمات";
                return RedirectToAction("Index", "Home");
            }
        }

        /// <summary>
        /// Adds a new rating for a course
        /// </summary>
        /// <param name="createRatingDto">Rating data to create</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Redirect to course learning page</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AddRating(
            [FromBody] CreateRatingDto createRatingDto,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "AddRating";

            try
            {
                _logger.LogInformation("Starting {OperationName} for Course ID: {CourseId}",
                    operationName, createRatingDto.CourseId);

                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid model state in {OperationName}", operationName);
                    TempData["Error"] = "بيانات التقييم غير صالحة";
                    return RedirectToAction("Learn", "Course", new { id = createRatingDto.CourseId });
                }

                // Check rating eligibility
                var canRateDto = await _ratingService.CanUserRateCourseAsync(createRatingDto.CourseId, cancellationToken);
                if (canRateDto == null || !canRateDto.CanRate)
                {
                    var errorMessage = canRateDto?.EligibleToRate == false
                        ? "لا يمكنك تقييم هذا الكورس. يجب أن تكمل 80% على الأقل من محتواه"
                        : "لقد قمت بتقييم هذا الكورس من قبل";

                    _logger.LogWarning("Rating not allowed in {OperationName}: {ErrorMessage}", operationName, errorMessage);
                    TempData["Error"] = errorMessage;
                    return RedirectToAction("Learn", "Course", new { id = createRatingDto.CourseId });
                }

                var result = await _ratingService.AddRatingAsync(createRatingDto, cancellationToken);

                if (result != null)
                {
                    _logger.LogInformation("Successfully added rating for Course ID: {CourseId}", createRatingDto.CourseId);
                    TempData["Success"] = "تم إضافة التقييم بنجاح";
                }
                else
                {
                    _logger.LogWarning("Failed to add rating for Course ID: {CourseId}", createRatingDto.CourseId);
                    TempData["Error"] = "فشل في إضافة التقييم";
                }

                return RedirectToAction("Learn", "Course", new { id = createRatingDto.CourseId });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for Course ID: {CourseId}",
                    operationName, createRatingDto.CourseId);
                TempData["Error"] = "حدث خطأ أثناء إضافة التقييم";
                return RedirectToAction("Learn", "Course", new { id = createRatingDto.CourseId });
            }
        }

        /// <summary>
        /// Updates an existing rating
        /// </summary>
        /// <param name="ratingId">Rating identifier to update</param>
        /// <param name="updateRatingDto">Updated rating data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Redirect to course learning page</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UpdateRating(
            int ratingId,
            [FromBody] UpdateRatingDto updateRatingDto,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "UpdateRating";

            try
            {
                _logger.LogInformation("Starting {OperationName} for Rating ID: {RatingId}", operationName, ratingId);

                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid model state in {OperationName}", operationName);
                    TempData["Error"] = "بيانات التقييم غير صالحة";
                    return RedirectToAction("Learn", "Course", new { id = updateRatingDto.CourseId });
                }

                var result = await _ratingService.UpdateRatingAsync(ratingId, updateRatingDto, cancellationToken);

                if (result != null)
                {
                    _logger.LogInformation("Successfully updated Rating ID: {RatingId}", ratingId);
                    TempData["Success"] = "تم تحديث التقييم بنجاح";
                }
                else
                {
                    _logger.LogWarning("Failed to update Rating ID: {RatingId}", ratingId);
                    TempData["Error"] = "فشل في تحديث التقييم";
                }

                return RedirectToAction("Learn", "Course", new { id = result?.CourseId ?? updateRatingDto.CourseId });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for Rating ID: {RatingId}", operationName, ratingId);
                TempData["Error"] = "حدث خطأ أثناء تحديث التقييم";
                return RedirectToAction("Learn", "Course", new { id = updateRatingDto.CourseId });
            }
        }

        /// <summary>
        /// Deletes a user's rating
        /// </summary>
        /// <param name="ratingId">Rating identifier to delete</param>
        /// <param name="courseId">Course identifier for redirect</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Redirect to course learning page</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteRating(
            int ratingId,
            int courseId,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "DeleteRating";

            try
            {
                _logger.LogInformation("Starting {OperationName} for Rating ID: {RatingId}", operationName, ratingId);

                var result = await _ratingService.DeleteRatingAsync(ratingId, cancellationToken);

                if (result)
                {
                    _logger.LogInformation("Successfully deleted Rating ID: {RatingId}", ratingId);
                    TempData["Success"] = "تم حذف التقييم بنجاح";
                }
                else
                {
                    _logger.LogWarning("Failed to delete Rating ID: {RatingId}", ratingId);
                    TempData["Error"] = "فشل في حذف التقييم";
                }

                return RedirectToAction("Learn", "Course", new { id = courseId });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for Rating ID: {RatingId}", operationName, ratingId);
                TempData["Error"] = "حدث خطأ أثناء حذف التقييم";
                return RedirectToAction("Learn", "Course", new { id = courseId });
            }
        }
        #endregion

        #region JSON Endpoints
        /// <summary>
        /// Returns comprehensive rating data for a course
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>JSON response with rating data</returns>
        [Authorize]
        public async Task<JsonResult> GetRatingData(int courseId, CancellationToken cancellationToken = default)
        {
            const string operationName = "GetRatingData";

            try
            {
                _logger.LogDebug("Starting {OperationName} for Course ID: {CourseId}", operationName, courseId);

                var canRateDto = await _ratingService.CanUserRateCourseAsync(courseId, cancellationToken);
                var existingRating = await _ratingService.GetMyRatingForCourseAsync(courseId, cancellationToken);
                var summary = await _ratingService.GetCourseRatingSummaryAsync(courseId, cancellationToken);

                _logger.LogDebug("Successfully loaded rating data for Course ID: {CourseId}", courseId);

                return Json(new
                {
                    success = true,
                    canRate = canRateDto,
                    existingRating,
                    summary
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for Course ID: {CourseId}", operationName, courseId);
                return Json(new { success = false, message = "Error loading rating data" });
            }
        }

        /// <summary>
        /// Returns course ratings in JSON format
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="page">Page number for pagination (default: 1)</param>
        /// <param name="pageSize">Number of items per page (default: 10)</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>JSON response with course ratings</returns>
        [AllowAnonymous]
        [HttpGet]
        public async Task<JsonResult> GetCourseRatingsJson(
            int courseId,
            int page = 1,
            int pageSize = 10,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "GetCourseRatingsJson";

            try
            {
                _logger.LogDebug("Starting {OperationName} for Course ID: {CourseId}", operationName, courseId);

                var ratings = await _ratingService.GetCourseRatingsAsync(courseId, page, pageSize, cancellationToken);

                _logger.LogDebug("Successfully loaded {Count} ratings for Course ID: {CourseId}",
                    ratings.Count, courseId);

                return Json(new { success = true, data = ratings });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for Course ID: {CourseId}", operationName, courseId);
                return Json(new { success = false, message = "حدث خطأ أثناء تحميل التعليقات" });
            }
        }
        #endregion
    }
    #endregion
}