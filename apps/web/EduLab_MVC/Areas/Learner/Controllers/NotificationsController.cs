using EduLab_MVC.Models.DTOs.Notifications;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using EduLab_MVC.Resources;
using Microsoft.Extensions.Localization;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    [Authorize]
    [Area("Learner")]
    public class NotificationsController : Controller
    {
        private readonly INotificationService _notificationService;
        private readonly ILogger<NotificationsController> _logger;
        private readonly IStringLocalizer<SharedResources> _localizer;

        public NotificationsController(
            INotificationService notificationService,
            ILogger<NotificationsController> logger,
            IStringLocalizer<SharedResources> localizer)
        {
            _notificationService = notificationService;
            _logger = logger;
            _localizer = localizer;
        }

        public async Task<IActionResult> Index()
        {
            try
            {
                var filter = new NotificationFilterDto();
                var notifications = await _notificationService.GetUserNotificationsAsync(filter);
                var summary = await _notificationService.GetUserNotificationSummaryAsync();

                ViewBag.NotificationSummary = summary;
                return View(notifications);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading notifications page");
                TempData["Error"] = _localizer["ErrorLoadingNotifications"].Value;
                return View(new List<NotificationDto>());
            }
        }

        [HttpPost]
        public async Task<IActionResult> GetFilteredNotifications(NotificationFilterDto filter)
        {
            try
            {
                var notifications = await _notificationService.GetUserNotificationsAsync(filter);
                return PartialView("_NotificationsList", notifications);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting filtered notifications");
                return PartialView("_NotificationsList", new List<NotificationDto>());
            }
        }

        [HttpPost]
        public async Task<IActionResult> MarkAllAsRead()
        {
            try
            {
                await _notificationService.MarkAllNotificationsAsReadAsync();
                TempData["Success"] = _localizer["NotificationsMarkedRead"].Value;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking all notifications as read");
                TempData["Error"] = _localizer["ErrorMarkingNotificationsRead"].Value;
            }

            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        public async Task<IActionResult> MarkAsRead(int id)
        {
            try
            {
                await _notificationService.MarkNotificationAsReadAsync(id);
                return Json(new { success = true, message = _localizer["NotificationMarkedRead"].Value });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking notification {NotificationId} as read", id);
                return Json(new { success = false, message = _localizer["ErrorMarkingNotificationRead"].Value });
            }
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            try
            {
                await _notificationService.DeleteNotificationAsync(id);
                TempData["Success"] = _localizer["NotificationDeleted"].Value;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting notification {NotificationId}", id);
                TempData["Error"] = _localizer["ErrorDeletingNotification"].Value;
            }

            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        public async Task<IActionResult> DeleteAll()
        {
            try
            {
                await _notificationService.DeleteAllNotificationsAsync();
                TempData["Success"] = _localizer["AllNotificationsDeleted"].Value;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting all notifications");
                TempData["Error"] = _localizer["ErrorDeletingAllNotifications"].Value;
            }

            return RedirectToAction(nameof(Index));
        }

        [HttpGet]
        public async Task<IActionResult> GetNotificationSummary()
        {
            try
            {
                var summary = await _notificationService.GetUserNotificationSummaryAsync();
                return Json(summary);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting notification summary");
                return Json(new NotificationSummaryDto());
            }
        }
    }
}
