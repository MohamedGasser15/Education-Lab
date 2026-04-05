namespace EduLab_MVC.Models.DTOs.Notifications
{
    public class NotificationFilterDto
    {
        public NotificationTypeDto? Type { get; set; }
        public NotificationStatusDto? Status { get; set; }
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 10;
    }
}
