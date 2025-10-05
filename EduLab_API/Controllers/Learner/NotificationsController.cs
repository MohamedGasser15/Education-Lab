using EduLab.Shared.DTOs.Notification;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EduLab_API.Controllers.Learner
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class NotificationsController : ControllerBase
    {
        private readonly INotificationService _notificationService;
        private readonly ILogger<NotificationsController> _logger;

        public NotificationsController(
            INotificationService notificationService,
            ILogger<NotificationsController> logger)
        {
            _notificationService = notificationService;
            _logger = logger;
        }

        private string GetUserId()
        {
            return User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        }

        [HttpGet]
        public async Task<ActionResult<List<NotificationDto>>> GetNotifications(
            [FromQuery] NotificationFilterDto filter)
        {
            try
            {
                var userId = GetUserId();
                var notifications = await _notificationService.GetUserNotificationsAsync(userId, filter);
                return Ok(notifications);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting notifications for user");
                return StatusCode(500, "An error occurred while retrieving notifications");
            }
        }

        [HttpGet("summary")]
        public async Task<ActionResult<NotificationSummaryDto>> GetNotificationSummary()
        {
            try
            {
                var userId = GetUserId();
                var summary = await _notificationService.GetUserNotificationSummaryAsync(userId);
                return Ok(summary);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting notification summary for user");
                return StatusCode(500, "An error occurred while retrieving notification summary");
            }
        }

        [HttpGet("unread-count")]
        public async Task<ActionResult<int>> GetUnreadCount()
        {
            try
            {
                var userId = GetUserId();
                var count = await _notificationService.GetUnreadCountAsync(userId);
                return Ok(count);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting unread count for user");
                return StatusCode(500, "An error occurred while retrieving unread count");
            }
        }

        [HttpPost("mark-all-read")]
        public async Task<IActionResult> MarkAllAsRead()
        {
            try
            {
                var userId = GetUserId();
                await _notificationService.MarkAllNotificationsAsReadAsync(userId);
                return Ok(new { message = "All notifications marked as read" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking all notifications as read for user");
                return StatusCode(500, "An error occurred while marking notifications as read");
            }
        }

        [HttpPut("{id}/read")]
        public async Task<IActionResult> MarkAsRead(int id)
        {
            try
            {
                var userId = GetUserId();
                await _notificationService.MarkNotificationAsReadAsync(id, userId);
                return Ok(new { message = "Notification marked as read" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking notification {NotificationId} as read for user", id);
                return StatusCode(500, "An error occurred while marking notification as read");
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteNotification(int id)
        {
            try
            {
                var userId = GetUserId();
                await _notificationService.DeleteNotificationAsync(id, userId);
                return Ok(new { message = "Notification deleted successfully" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting notification {NotificationId} for user", id);
                return StatusCode(500, "An error occurred while deleting notification");
            }
        }

        [HttpDelete("delete-all")]
        public async Task<IActionResult> DeleteAllNotifications()
        {
            try
            {
                var userId = GetUserId();
                await _notificationService.DeleteAllNotificationsAsync(userId);
                return Ok(new { message = "All notifications deleted successfully" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting all notifications for user");
                return StatusCode(500, "An error occurred while deleting all notifications");
            }
        }
    }
}
