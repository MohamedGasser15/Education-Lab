using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EduLab_API.Controllers.Instructor
{
    [Route("api/instructor/comments")]
    [ApiController]
    [Authorize(Roles = "Instructor")]
    public class InstructorCommentsController : ControllerBase
    {
        private readonly ILectureCommentService _commentService;
        private readonly ILogger<InstructorCommentsController> _logger;

        public InstructorCommentsController(ILectureCommentService commentService, ILogger<InstructorCommentsController> logger)
        {
            _commentService = commentService;
            _logger = logger;
        }

        [HttpGet]
        public async Task<IActionResult> GetInstructorComments(CancellationToken cancellationToken)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                if (string.IsNullOrEmpty(userId))
                    return Unauthorized();

                var result = await _commentService.GetInstructorCommentsAsync(userId, cancellationToken);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching instructor comments");
                return StatusCode(500, new { message = "حدث خطأ" });
            }
        }
    }
}
