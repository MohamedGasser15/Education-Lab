using EduLab_MVC.Models.DTOs.LectureComment;
using EduLab_MVC.Resources;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.Extensions.Localization;
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
        private readonly IStringLocalizer<SharedResources> _localizer;

        public CommentsController(ICommentsService commentsService, ILogger<CommentsController> logger, IStringLocalizer<SharedResources> localizer)
        {
            _commentsService = commentsService;
            _logger = logger;
            _localizer = localizer;
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
                    return Json(new { success = false, message = _localizer["InvalidData"].Value });

                var comment = await _commentsService.AddCommentAsync(dto);
                if (comment != null)
                    return Json(new { success = true, comment });
                return Json(new { success = false, message = _localizer["CommentAddFailed"].Value });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding comment");
                return Json(new { success = false, message = _localizer["ErrorOccurred"].Value });
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
                return Json(new { success = false, message = _localizer["ReplySendFailed"].Value });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error replying to comment {Id}", id);
                return Json(new { success = false, message = _localizer["ErrorOccurred"].Value });
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
