using EduLab_MVC.Common;
using EduLab_MVC.Models.DTOs.Instructor;
using EduLab_MVC.Resources;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.Extensions.Localization;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Instructor.Controllers
{
    [Area("Instructor")]
    [Authorize(Roles = SD.Instructor)]
    public class QuestionsController : Controller
    {
        private readonly ICommentsService _commentsService;
        private readonly ILogger<QuestionsController> _logger;
        private readonly IStringLocalizer<SharedResources> _localizer;

        public QuestionsController(ICommentsService commentsService, ILogger<QuestionsController> logger, IStringLocalizer<SharedResources> localizer)
        {
            _commentsService = commentsService;
            _logger = logger;
            _localizer = localizer;
        }

        public async Task<IActionResult> Index()
        {
            try
            {
                var groups = await _commentsService.GetInstructorQuestionsAsync();
                return View(groups);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading questions page");
                return View(new List<QuestionGroupDTO>());
            }
        }

        [HttpPost]
        public async Task<IActionResult> Reply(int id, [FromBody] ReplyModel model)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(model?.Content))
                    return Json(new { success = false, message = _localizer["ReplyRequired"].Value });

                var comment = await _commentsService.ReplyToCommentAsync(id, model.Content);
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
    }

    public class ReplyModel
    {
        public string Content { get; set; }
    }
}
