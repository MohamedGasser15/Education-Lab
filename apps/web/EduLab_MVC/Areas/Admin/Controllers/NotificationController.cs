using EduLab_MVC.Models.DTOs.Notifications;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ModelBinding;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]
    public class NotificationController : Controller
    {
        private readonly INotificationService _NotificationService;
        private readonly ILogger<NotificationController> _logger;

        public NotificationController(
            INotificationService NotificationService,
            ILogger<NotificationController> logger)
        {
            _NotificationService = NotificationService;
            _logger = logger;
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
                    return Json(new { success = false, message = "بيانات الطلب غير صالحة" });
                }

                // التحقق من البيانات يدوياً
                var errors = new List<string>();
                if (string.IsNullOrWhiteSpace(request.Title))
                    errors.Add("عنوان الإشعار مطلوب");

                if (string.IsNullOrWhiteSpace(request.Message))
                    errors.Add("محتوى الإشعار مطلوب");

                if (errors.Any())
                {
                    return Json(new
                    {
                        success = false,
                        message = "بيانات غير صالحة",
                        errors = errors
                    });
                }

                var result = await _NotificationService.SendBulkNotificationAsync(request);

                if (result.Errors != null && result.Errors.Any())
                {
                    return Json(new
                    {
                        success = false,
                        message = "حدثت بعض الأخطاء أثناء الإرسال",
                        errors = result.Errors,
                        data = result
                    });
                }

                return Json(new
                {
                    success = true,
                    message = "تم إرسال الإشعارات بنجاح",
                    data = result
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending notification");
                return Json(new
                {
                    success = false,
                    message = $"حدث خطأ: {ex.Message}"
                });
            }
        }
    }
}