using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Threading.Tasks;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    [Area("Learner")]
    [Authorize]
    /// <summary>
    /// Handles support conversations for learners.
    /// </summary>
    public class SupportController : Controller
    {
        private readonly ISupportService _supportService;
        private readonly ILogger<SupportController> _logger;

        public SupportController(
            ISupportService supportService,
            ILogger<SupportController> logger)
        {
            _supportService = supportService;
            _logger = logger;
        }

        [HttpGet]
        public IActionResult Index()
        {
            // Support is now a floating chatbox available on every page (in the layout)
            return RedirectToAction("Index", "Home");
        }

        [HttpGet]
        public async Task<IActionResult> GetConversations()
        {
            var conversations = await _supportService.GetUserConversationsAsync();
            return Json(conversations);
        }

        [HttpPost]
        public async Task<IActionResult> CreateConversation([FromForm] string subject, [FromForm] string message)
        {
            if (string.IsNullOrWhiteSpace(message))
                return Json(new { success = false, message = "Message is required" });

            var conversation = await _supportService.CreateConversationAsync(subject ?? "General support", message);
            return Json(new { success = conversation != null, conversation });
        }

        [HttpGet]
        public async Task<IActionResult> GetMessages(int id)
        {
            var messages = await _supportService.GetConversationMessagesAsync(id);
            return Json(messages);
        }

        [HttpPost]
        public async Task<IActionResult> SendMessage(int id, [FromBody] string content)
        {
            if (string.IsNullOrWhiteSpace(content))
                return Json(new { success = false, message = "Message is required" });

            var message = await _supportService.SendUserMessageAsync(id, content);
            return Json(new { success = message != null, message });
        }

        [HttpPost]
        public async Task<IActionResult> CloseConversation(int id)
        {
            var closed = await _supportService.CloseConversationAsync(id);
            return Json(new { success = closed });
        }

        [HttpPost]
        public async Task<IActionResult> ReopenConversation(int id)
        {
            var reopened = await _supportService.ReopenConversationAsync(id);
            return Json(new { success = reopened });
        }

        [HttpGet]
        public async Task<IActionResult> UnreadCount()
        {
            var count = await _supportService.GetUserUnreadCountAsync();
            return Json(count);
        }
    }
}
