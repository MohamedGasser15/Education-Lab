// EduLab_MVC/ViewComponents/NotificationViewComponent.cs
using EduLab_MVC.Models.DTOs.Notifications;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.ViewComponents
{
    /// <summary>
    /// Renders the notification dropdown with unread notifications and their count.
    /// </summary>
    public class NotificationViewComponent : ViewComponent
    {
        private readonly INotificationService _notificationService;

        /// <summary>
        /// Initializes a new instance of the <see cref="NotificationViewComponent"/> class.
        /// </summary>
        /// <param name="notificationService">The notification service.</param>
        public NotificationViewComponent(INotificationService notificationService)
        {
            _notificationService = notificationService;
        }

        /// <summary>
        /// Loads the recent unread notifications for the dropdown view.
        /// </summary>
        public async Task<IViewComponentResult> InvokeAsync()
        {
            try
            {
                var filter = new NotificationFilterDto
                {
                    Status = NotificationStatusDto.Unread,
                    PageNumber = 1,
                    PageSize = 3 // Same number of items as the Cart
                };

                var notifications = await _notificationService.GetUserNotificationsAsync(filter);
                var unreadCount = await _notificationService.GetUnreadCountAsync();

                var model = new NotificationDropdownViewModel
                {
                    Notifications = notifications,
                    UnreadCount = unreadCount
                };

                return View(model);
            }
            catch (Exception)
            {
                return View(new NotificationDropdownViewModel
                {
                    Notifications = new List<NotificationDto>(),
                    UnreadCount = 0
                });
            }
        }
    }

    public class NotificationDropdownViewModel
    {
        public List<NotificationDto> Notifications { get; set; }
        public int UnreadCount { get; set; }
    }
}