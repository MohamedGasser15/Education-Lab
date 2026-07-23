using EduLab_MVC.Models.DTOs.LectureComment;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    [Area("Learner")]
    [Authorize]
    public class CommentsController : Controller
    {
        private readonly ICommentsService _commentsService;
        private readonly ILogger<CommentsController> _logger;

        public CommentsController(ICommentsService commentsService, ILogger<CommentsController> logger)
        {
            _commentsService = commentsService;
            _logger = logger;
        }

        [HttpGet]
        public async Task<IActionResult> GetLectureComments(int lectureId)
        {
            try
            {
                var comments = await _commentsService.GetLectureCommentsAsync(lectureId);
                return Json(comments);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting comments for lecture {LectureId}", lectureId);
                return Json(new List<LectureCommentDTO>());
            }
        }

        [HttpPost]
        public async Task<IActionResult> AddComment([FromBody] CreateLectureCommentDTO dto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return Json(new { success = false, message = "البيانات غير صالحة" });

                var comment = await _commentsService.AddCommentAsync(dto);
                if (comment != null)
                    return Json(new { success = true, comment });
                return Json(new { success = false, message = "فشل إضافة التعليق" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding comment");
                return Json(new { success = false, message = "حدث خطأ" });
            }
        }

        [HttpPost]
        public async Task<IActionResult> ReplyToComment(int id, [FromBody] ReplyDto dto)
        {
            try
            {
                var comment = await _commentsService.ReplyToCommentAsync(id, dto.Content);
                if (comment != null)
                    return Json(new { success = true, comment });
                return Json(new { success = false, message = "فشل إرسال الرد" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error replying to comment {Id}", id);
                return Json(new { success = false, message = "حدث خطأ" });
            }
        }

        [HttpPost]
        public async Task<IActionResult> DeleteComment(int id)
        {
            try
            {
                var result = await _commentsService.DeleteCommentAsync(id);
                return Json(new { success = result });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting comment {Id}", id);
                return Json(new { success = false });
            }
        }
    }

    public class ReplyDto
    {
        public string Content { get; set; }
    }
}
