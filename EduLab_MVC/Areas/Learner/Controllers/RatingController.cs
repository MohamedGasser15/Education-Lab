// EduLab_MVC/Controllers/RatingController.cs
using EduLab_MVC.Models.DTOs.Rating;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Controllers
{
    [Area("Learner")]
    [Authorize]
    public class RatingController : Controller
    {
        private readonly IRatingService _ratingService;
        private readonly IEnrollmentService _enrollmentService;
        private readonly ILogger<RatingController> _logger;

        public RatingController(
            IRatingService ratingService,
            IEnrollmentService enrollmentService,
            ILogger<RatingController> logger)
        {
            _ratingService = ratingService;
            _enrollmentService = enrollmentService;
            _logger = logger;
        }

        // عرض التقييمات الخاصة بكورس معين
        [AllowAnonymous]
        public async Task<IActionResult> CourseRatings(int courseId, int page = 1, int pageSize = 10)
        {
            try
            {
                var ratings = await _ratingService.GetCourseRatingsAsync(courseId, page, pageSize);
                var summary = await _ratingService.GetCourseRatingSummaryAsync(courseId);

                ViewBag.CourseId = courseId;
                ViewBag.Summary = summary;
                ViewBag.CurrentPage = page;
                ViewBag.PageSize = pageSize;

                return View(ratings);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading course ratings for course {CourseId}", courseId);
                TempData["Error"] = "حدث خطأ أثناء تحميل التقييمات";
                return RedirectToAction("Index", "Home");
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AddRating([FromBody] CreateRatingDto createRatingDto)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    TempData["Error"] = "بيانات التقييم غير صالحة";
                    return RedirectToAction("Learn", "Course", new { id = createRatingDto.CourseId });
                }

                // التحقق من إمكانية التقييم
                var canRateDto = await _ratingService.CanUserRateCourseAsync(createRatingDto.CourseId);
                if (canRateDto == null || !canRateDto.CanRate)
                {
                    TempData["Error"] = canRateDto?.EligibleToRate == false
                        ? "لا يمكنك تقييم هذا الكورس. يجب أن تكمل 80% على الأقل من محتواه"
                        : "لقد قمت بتقييم هذا الكورس من قبل";

                    return RedirectToAction("Learn", "Course", new { id = createRatingDto.CourseId });
                }

                var result = await _ratingService.AddRatingAsync(createRatingDto);

                if (result != null)
                {
                    TempData["Success"] = "تم إضافة التقييم بنجاح";
                }
                else
                {
                    TempData["Error"] = "فشل في إضافة التقييم";
                }

                return RedirectToAction("Learn", "Course", new { id = createRatingDto.CourseId });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding rating for course {CourseId}", createRatingDto.CourseId);
                TempData["Error"] = "حدث خطأ أثناء إضافة التقييم";
                return RedirectToAction("Learn", "Course", new { id = createRatingDto.CourseId });
            }
        }

        // تحديث تقييم موجود
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UpdateRating(int ratingId, [FromBody] UpdateRatingDto updateRatingDto)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    TempData["Error"] = "بيانات التقييم غير صالحة";
                    return RedirectToAction("Learn", "Course", new { id = updateRatingDto.CourseId });
                }

                var result = await _ratingService.UpdateRatingAsync(ratingId, updateRatingDto);

                if (result != null)
                {
                    TempData["Success"] = "تم تحديث التقييم بنجاح";
                }
                else
                {
                    TempData["Error"] = "فشل في تحديث التقييم";
                }

                return RedirectToAction("Learn", "Course", new { id = result.CourseId });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating rating {RatingId}", ratingId);
                TempData["Error"] = "حدث خطأ أثناء تحديث التقييم";
                return RedirectToAction("Learn", "Course", new { id = updateRatingDto.CourseId });
            }
        }

        // حذف تقييم
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteRating(int ratingId, int courseId)
        {
            try
            {
                var result = await _ratingService.DeleteRatingAsync(ratingId);

                if (result)
                {
                    TempData["Success"] = "تم حذف التقييم بنجاح";
                }
                else
                {
                    TempData["Error"] = "فشل في حذف التقييم";
                }

                return RedirectToAction("Learn", "Course", new { id = courseId });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting rating {RatingId}", ratingId);
                TempData["Error"] = "حدث خطأ أثناء حذف التقييم";
                return RedirectToAction("Learn", "Course", new { id = courseId });
            }
        }
        // EduLab_MVC/Controllers/RatingController.cs
        [AllowAnonymous]
        public async Task<IActionResult> _RatingSummary(int courseId)
        {
            try
            {
                var summary = await _ratingService.GetCourseRatingSummaryAsync(courseId);
                return PartialView("_RatingSummary", summary);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading rating summary for course {CourseId}", courseId);
                return Content("");
            }
        }

        [Authorize]
        public async Task<JsonResult> GetRatingData(int courseId)
        {
            try
            {
                var canRateDto = await _ratingService.CanUserRateCourseAsync(courseId);
                var existingRating = await _ratingService.GetMyRatingForCourseAsync(courseId);
                var summary = await _ratingService.GetCourseRatingSummaryAsync(courseId);

                return Json(new
                {
                    success = true,
                    canRate = canRateDto,   // بيرجع object كامل فيه EligibleToRate + HasRated + CanRate
                    existingRating,
                    summary
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading rating data for course {CourseId}", courseId);
                return Json(new { success = false, message = "Error loading rating data" });
            }
        }
        [AllowAnonymous]
        [HttpGet]
        public async Task<JsonResult> GetCourseRatingsJson(int courseId, int page = 1, int pageSize = 10)
        {
            try
            {
                var ratings = await _ratingService.GetCourseRatingsAsync(courseId, page, pageSize);
                return Json(new { success = true, data = ratings });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading course ratings for course {CourseId}", courseId);
                return Json(new { success = false, message = "حدث خطأ أثناء تحميل التعليقات" });
            }
        }
        [Authorize]
        public async Task<IActionResult> _RatingForm(int courseId)
        {
            try
            {
                var canRateDto = await _ratingService.CanUserRateCourseAsync(courseId);
                if (canRateDto == null || !canRateDto.CanRate)
                {
                    return Content(""); // المستخدم مش مسموحله يقيّم (لسه ما خلصش أو قيم قبل كده)
                }

                var existingRating = await _ratingService.GetMyRatingForCourseAsync(courseId);

                var model = new RatingFormViewModel
                {
                    CourseId = courseId,
                    ExistingRating = existingRating
                };

                return PartialView("_RatingForm", model);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading rating form for course {CourseId}", courseId);
                return Content("");
            }
        }
    }
}