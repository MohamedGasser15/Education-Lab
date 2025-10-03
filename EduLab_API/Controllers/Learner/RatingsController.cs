// EduLab_API/Controllers/RatingsController.cs
using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Rating;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EduLab_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RatingsController : ControllerBase
    {
        private readonly IRatingService _ratingService;
        private readonly ILogger<RatingsController> _logger;

        public RatingsController(IRatingService ratingService, ILogger<RatingsController> logger)
        {
            _ratingService = ratingService;
            _logger = logger;
        }

        [HttpGet("course/{courseId}")]
        public async Task<IActionResult> GetCourseRatings(int courseId, [FromQuery] int page = 1, [FromQuery] int pageSize = 10)
        {
            try
            {
                var ratings = await _ratingService.GetCourseRatingsAsync(courseId, page, pageSize);
                return Ok(ratings);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ في جلب تقييمات الكورس {CourseId}", courseId);
                return StatusCode(500, "حدث خطأ أثناء جلب التقييمات");
            }
        }

        [HttpGet("course/{courseId}/summary")]
        public async Task<IActionResult> GetCourseRatingSummary(int courseId)
        {
            try
            {
                var summary = await _ratingService.GetCourseRatingSummaryAsync(courseId);
                return Ok(summary);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ في جلب ملخص تقييمات الكورس {CourseId}", courseId);
                return StatusCode(500, "حدث خطأ أثناء جلب ملخص التقييمات");
            }
        }

        [Authorize]
        [HttpGet("course/{courseId}/my-rating")]
        public async Task<IActionResult> GetMyRating(int courseId)
        {
            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized();
                }

                var rating = await _ratingService.GetUserRatingForCourseAsync(userId, courseId);
                return Ok(rating);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ في جلب تقييم المستخدم للكورس {CourseId}", courseId);
                return StatusCode(500, "حدث خطأ أثناء جلب التقييم");
            }
        }

        [Authorize]
        [HttpPost]
        public async Task<IActionResult> AddRating([FromBody] CreateRatingDto createRatingDto)
        {
            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized();
                }



                var rating = await _ratingService.AddRatingAsync(userId, createRatingDto);
                return CreatedAtAction(nameof(GetMyRating), new { courseId = createRatingDto.CourseId }, rating);
            }
            catch (InvalidOperationException ex)
            {
                return BadRequest(ex.Message);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ في إضافة تقييم للكورس {CourseId}", createRatingDto.CourseId);
                return StatusCode(500, "حدث خطأ أثناء إضافة التقييم");
            }
        }
        [Authorize]
        [HttpGet("can-rate/{courseId}")]
        public async Task<IActionResult> CanUserRateCourse(int courseId)
        {
            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized();
                }

                var result = await _ratingService.CanUserRateCourseAsync(userId, courseId);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ في التحقق من إمكانية التقييم للكورس {CourseId}", courseId);
                return StatusCode(500, "حدث خطأ أثناء التحقق من إمكانية التقييم");
            }
        }

        [Authorize]
        [HttpPut("{ratingId}")]
        public async Task<IActionResult> UpdateRating(int ratingId, [FromBody] UpdateRatingDto updateRatingDto)
        {
            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized();
                }

                var rating = await _ratingService.UpdateRatingAsync(userId, ratingId, updateRatingDto);
                return Ok(rating);
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ex.Message);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(ex.Message);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ في تحديث التقييم {RatingId}", ratingId);
                return StatusCode(500, "حدث خطأ أثناء تحديث التقييم");
            }
        }

        [Authorize]
        [HttpDelete("{ratingId}")]
        public async Task<IActionResult> DeleteRating(int ratingId)
        {
            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized();
                }

                await _ratingService.DeleteRatingAsync(userId, ratingId);
                return NoContent();
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ex.Message);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ في حذف التقييم {RatingId}", ratingId);
                return StatusCode(500, "حدث خطأ أثناء حذف التقييم");
            }
        }
    }
}