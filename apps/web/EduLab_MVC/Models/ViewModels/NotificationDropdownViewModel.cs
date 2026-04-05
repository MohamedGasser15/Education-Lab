using EduLab_MVC.Models.DTOs.Notifications;

namespace EduLab_MVC.Models.ViewModels
{
    public class NotificationDropdownViewModel
    {
        public List<NotificationDto> Notifications { get; set; }
        public int UnreadCount { get; set; }
    }
}
