using EduLab_Application.DTOs.LectureComment;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.IRepository;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EduLab_API.Controllers.Learner
{
    /// <summary>
    /// Controller for lecture comments (read, add, reply, delete)
    /// </summary>
    [Route("api/comments")]
    [ApiController]
    public class LectureCommentsController : ControllerBase
    {
        private readonly ILectureCommentService _commentService;
        private readonly IEnrollmentService _enrollmentService;
        private readonly ICourseRepository _courseRepository;
        private readonly ILogger<LectureCommentsController> _logger;

        /// <summary>
        /// Initializes a new instance of the LectureCommentsController class
        /// </summary>
        /// <param name="commentService">Lecture comment service</param>
        /// <param name="enrollmentService">Enrollment service</param>
        /// <param name="courseRepository">Course repository</param>
        /// <param name="logger">Logger instance</param>
        public LectureCommentsController(
            ILectureCommentService commentService,
            IEnrollmentService enrollmentService,
            ICourseRepository courseRepository,
            ILogger<LectureCommentsController> logger)
        {
            _commentService = commentService;
            _enrollmentService = enrollmentService;
            _courseRepository = courseRepository;
            _logger = logger;
        }

        /// <summary>
        /// Gets all comments for a lecture
        /// </summary>
        /// <param name="lectureId">Lecture ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of comments for the lecture</returns>
        /// <response code="200">Returns the list of comments</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("lecture/{lectureId}")]
        public async Task<IActionResult> GetComments(int lectureId, CancellationToken cancellationToken)
        {
            try
            {
                var comments = await _commentService.GetLectureCommentsAsync(lectureId, cancellationToken);
                return Ok(comments);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching comments for lecture {LectureId}", lectureId);
                return StatusCode(500, new { message = "حدث خطأ أثناء جلب التعليقات" });
            }
        }

        /// <summary>
        /// Adds a comment to a lecture (only for enrolled users or the course instructor)
        /// </summary>
        /// <param name="dto">Comment data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The created comment</returns>
        /// <response code="200">Returns the created comment</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="403">If the user is not enrolled in the course</response>
        /// <response code="404">If the lecture was not found</response>
        /// <response code="500">If there was an internal server error</response>
        [Authorize]
        [HttpPost]
        public async Task<IActionResult> AddComment([FromBody] CreateLectureCommentDTO dto, CancellationToken cancellationToken)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                if (string.IsNullOrEmpty(userId))
                    return Unauthorized(new { message = "المستخدم غير موثق" });

                var courseId = await _courseRepository.GetCourseIdByLectureAsync(dto.LectureId, cancellationToken);
                if (courseId == null)
                    return NotFound(new { message = "المحاضرة غير موجودة" });

                var course = await _courseRepository.GetCourseByIdAsync(courseId.Value, isTracking: true, cancellationToken: cancellationToken);
                bool isInstructor = course?.InstructorId == userId;
                bool isEnrolled = await _enrollmentService.IsUserEnrolledInCourseAsync(userId, courseId.Value, cancellationToken);

                if (!isEnrolled && !isInstructor)
                    return StatusCode(403, new { message = "يجب أن تكون مسجلاً في الدورة" });

                var comment = await _commentService.AddCommentAsync(userId, dto, cancellationToken);
                return Ok(comment);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding comment");
                return StatusCode(500, new { message = "حدث خطأ" });
            }
        }

        /// <summary>
        /// Replies to an existing comment
        /// </summary>
        /// <param name="commentId">Parent comment ID</param>
        /// <param name="request">Reply content</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The created reply</returns>
        /// <response code="200">Returns the created reply</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="404">If the parent comment was not found</response>
        /// <response code="500">If there was an internal server error</response>
        [Authorize]
        [HttpPost("{commentId}/reply")]
        public async Task<IActionResult> ReplyToComment(int commentId, [FromBody] ReplyRequest request, CancellationToken cancellationToken)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                if (string.IsNullOrEmpty(userId))
                    return Unauthorized(new { message = "المستخدم غير موثق" });

                var dto = new CreateLectureCommentDTO { Content = request.Content };
                var comment = await _commentService.ReplyToCommentAsync(userId, commentId, dto, cancellationToken);
                if (comment != null)
                    return Ok(comment);
                return NotFound(new { message = "التعليق غير موجود" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error replying to comment {CommentId}", commentId);
                return StatusCode(500, new { message = "حدث خطأ" });
            }
        }

        /// <summary>
        /// Deletes a comment (owner or authorized user)
        /// </summary>
        /// <param name="commentId">Comment ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Delete result</returns>
        /// <response code="200">If the comment was deleted successfully</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="404">If the comment was not found</response>
        /// <response code="500">If there was an internal server error</response>
        [Authorize]
        [HttpDelete("{commentId}")]
        public async Task<IActionResult> DeleteComment(int commentId, CancellationToken cancellationToken)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                if (string.IsNullOrEmpty(userId))
                    return Unauthorized(new { message = "المستخدم غير موثق" });

                var result = await _commentService.DeleteCommentAsync(commentId, userId, cancellationToken);
                if (!result)
                    return NotFound(new { message = "التعليق غير موجود" });

                return Ok(new { message = "تم الحذف" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting comment {CommentId}", commentId);
                return StatusCode(500, new { message = "حدث خطأ" });
            }
        }
    }

    /// <summary>
    /// Request body for replying to a comment
    /// </summary>
    public class ReplyRequest
    {
        public string Content { get; set; }
    }
}
