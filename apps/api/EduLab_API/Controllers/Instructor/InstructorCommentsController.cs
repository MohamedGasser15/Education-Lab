using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EduLab_API.Controllers.Instructor
{
    /// <summary>
    /// Controller for instructor lecture comments
    /// </summary>
    [Route("api/instructor/comments")]
    [ApiController]
    [Authorize(Roles = "Instructor")]
    public class InstructorCommentsController : ControllerBase
    {
        private readonly ILectureCommentService _commentService;
        private readonly ILogger<InstructorCommentsController> _logger;

        /// <summary>
        /// Initializes a new instance of the InstructorCommentsController class
        /// </summary>
        /// <param name="commentService">Lecture comment service</param>
        /// <param name="logger">Logger instance</param>
        public InstructorCommentsController(ILectureCommentService commentService, ILogger<InstructorCommentsController> logger)
        {
            _commentService = commentService;
            _logger = logger;
        }

        /// <summary>
        /// Gets all comments on the current instructor's lectures
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of comments on the instructor's lectures</returns>
        /// <response code="200">Returns the list of comments</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="500">If there was an internal server error</response>
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
