using EduLab_MVC.Models.DTOs.Notifications;
using EduLab_MVC.Resources;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ModelBinding;
using Microsoft.Extensions.Localization;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]
    public class NotificationController : Controller
    {
        private readonly INotificationService _NotificationService;
        private readonly ILogger<NotificationController> _logger;
        private readonly IStringLocalizer<SharedResources> _localizer;

        public NotificationController(
            INotificationService NotificationService,
            ILogger<NotificationController> logger,
            IStringLocalizer<SharedResources> localizer)
        {
            _NotificationService = NotificationService;
            _logger = logger;
            _localizer = localizer;
        }

        public IActionResult Index()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SendNotification([FromBody] AdminNotificationRequestDto request)
        {
            try
            {
                _logger.LogInformation("Received notification request: {@Request}", request);

                if (request == null)
                {
                    return Json(new { success = false, message = _localizer["InvalidRequestData"] });
                }

                // التحقق من البيانات يدوياً
                var errors = new List<string>();
                if (string.IsNullOrWhiteSpace(request.Title))
                    errors.Add(_localizer["NotificationTitleRequired"]);

                if (string.IsNullOrWhiteSpace(request.Message))
                    errors.Add(_localizer["NotificationContentRequired"]);

                if (errors.Any())
                {
                    return Json(new
                    {
                        success = false,
                        message = _localizer["InvalidData"],
                        errors = errors
                    });
                }

                var result = await _NotificationService.SendBulkNotificationAsync(request);

                if (result.Errors != null && result.Errors.Any())
                {
                    return Json(new
                    {
                        success = false,
                        message = _localizer["SendErrorsOccurred"],
                        errors = result.Errors,
                        data = result
                    });
                }

                return Json(new
                {
                    success = true,
                    message = _localizer["NotificationsSentSuccess"],
                    data = result
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending notification");
                return Json(new
                {
                    success = false,
                    message = _localizer["SendError", ex.Message]
                });
            }
        }
    }
}