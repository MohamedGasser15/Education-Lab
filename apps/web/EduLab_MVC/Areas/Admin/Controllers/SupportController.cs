using EduLab_MVC.Common;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Threading.Tasks;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Policy = "AdminArea")]
    public class SupportController : Controller
    {
        private readonly ISupportService _supportService;
        private readonly IConfiguration _configuration;
        private readonly ILogger<SupportController> _logger;

        public SupportController(
            ISupportService supportService,
            IConfiguration configuration,
            ILogger<SupportController> logger)
        {
            _supportService = supportService;
            _configuration = configuration;
            _logger = logger;
        }

        [HttpGet]
        public async Task<IActionResult> Index()
        {
            if (!User.HasClaim(c => c.Type == "ViewSupport"))
                return Forbid();

            try
            {
                ViewBag.UnreadCount = await _supportService.GetAgentUnreadCountAsync();
                var apiBase = _configuration["ApiBaseUrl"] ?? "";
                ViewBag.ApiBaseUrl = apiBase.Replace("/api/", "").TrimEnd('/');
                ViewBag.AuthToken = Request.Cookies["AuthToken"] ?? "";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading support inbox");
            }

            return View();
        }

        [HttpGet]
        public async Task<IActionResult> GetConversations()
        {
            if (!User.HasClaim(c => c.Type == "ViewSupport"))
                return Forbid();

            var conversations = await _supportService.GetAllConversationsAsync();
            return Json(conversations);
        }

        [HttpGet]
        public async Task<IActionResult> GetConversation(int id)
        {
            if (!User.HasClaim(c => c.Type == "ViewSupport"))
                return Forbid();

            var detail = await _supportService.GetConversationDetailAsync(id);
            return Json(detail);
        }

        [HttpPost]
        public async Task<IActionResult> SendMessage(int id, [FromBody] string content)
        {
            if (!User.HasClaim(c => c.Type == "HandleSupport"))
                return Forbid();

            if (string.IsNullOrWhiteSpace(content))
                return Json(new { success = false, message = "Message is required" });

            var message = await _supportService.SendAgentMessageAsync(id, content);
            return Json(new { success = message != null, message });
        }

        [HttpPost]
        public async Task<IActionResult> SetStatus(int id, [FromQuery] bool open)
        {
            if (!User.HasClaim(c => c.Type == "HandleSupport"))
                return Forbid();

            var success = await _supportService.SetConversationStatusAsync(id, open);
            return Json(new { success });
        }

        [HttpPost]
        public async Task<IActionResult> MarkAllRead()
        {
            if (!User.HasClaim(c => c.Type == "HandleSupport"))
                return Forbid();

            var marked = await _supportService.MarkAllReadAsync();
            return Json(new { success = true, marked });
        }

        [HttpGet]
        public async Task<IActionResult> UnreadCount()
        {
            if (!User.HasClaim(c => c.Type == "ViewSupport"))
                return Forbid();

            var count = await _supportService.GetAgentUnreadCountAsync();
            return Json(count);
        }
    }
}
