// EduLab_MVC/ViewComponents/NotificationViewComponent.cs
using EduLab_MVC.Models.DTOs.Notifications;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.ViewComponents
{
    public class NotificationViewComponent : ViewComponent
    {
        private readonly INotificationService _notificationService;

        public NotificationViewComponent(INotificationService notificationService)
        {
            _notificationService = notificationService;
        }

        public async Task<IViewComponentResult> InvokeAsync()
        {
            try
            {
                var filter = new NotificationFilterDto
                {
                    Status = NotificationStatusDto.Unread,
                    PageNumber = 1,
                    PageSize = 3 // نفس عدد عناصر الـ Cart
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