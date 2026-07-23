using EduLab_Application.DTOs.LectureComment;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.IRepository;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EduLab_API.Controllers.Learner
{
    [Route("api/comments")]
    [ApiController]
    public class LectureCommentsController : ControllerBase
    {
        private readonly ILectureCommentService _commentService;
        private readonly IEnrollmentService _enrollmentService;
        private readonly ICourseRepository _courseRepository;
        private readonly ILogger<LectureCommentsController> _logger;

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

    public class ReplyRequest
    {
        public string Content { get; set; }
    }
}
