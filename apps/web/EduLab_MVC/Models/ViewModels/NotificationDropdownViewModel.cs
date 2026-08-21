using EduLab_MVC.Models.DTOs.Notifications;

namespace EduLab_MVC.Models.ViewModels
{
    /// <summary>
    /// View model that supplies data for the notification dropdown view.
    /// </summary>
    public class NotificationDropdownViewModel
    {
        public List<NotificationDto> Notifications { get; set; }
        public int UnreadCount { get; set; }
    }
}
