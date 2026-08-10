using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EduLab_API.Controllers.Instructor
{
    [Route("api/instructor/ratings")]
    [ApiController]
    [Authorize(Roles = "Instructor")]
    public class InstructorRatingsController : ControllerBase
    {
        private readonly IRatingService _ratingService;
        private readonly ILogger<InstructorRatingsController> _logger;

        public InstructorRatingsController(IRatingService ratingService, ILogger<InstructorRatingsController> logger)
        {
            _ratingService = ratingService;
            _logger = logger;
        }

        [HttpGet]
        public async Task<IActionResult> GetInstructorRatings(CancellationToken cancellationToken)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                if (string.IsNullOrEmpty(userId))
                    return Unauthorized();

                var result = await _ratingService.GetInstructorRatingsAsync(userId, cancellationToken);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching instructor ratings");
                return StatusCode(500, new { message = "حدث خطأ أثناء جلب التقييمات" });
            }
        }

        /// <summary>
        /// Retrieves ratings for a specific instructor's courses (public, no auth required)
        /// </summary>
        [HttpGet("{instructorId}")]
        [AllowAnonymous]
        public async Task<IActionResult> GetPublicInstructorRatings(string instructorId, CancellationToken cancellationToken)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(instructorId))
                    return BadRequest(new { message = "معرف المدرب مطلوب" });

                var result = await _ratingService.GetInstructorRatingsAsync(instructorId, cancellationToken);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching public instructor ratings for {InstructorId}", instructorId);
                return StatusCode(500, new { message = "حدث خطأ أثناء جلب التقييمات" });
            }
        }
    }
}
