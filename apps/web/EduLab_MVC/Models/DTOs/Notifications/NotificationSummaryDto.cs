namespace EduLab_MVC.Models.DTOs.Notifications
{
    /// <summary>
    /// Represents a notification summary data transfer object.
    /// </summary>
    public class NotificationSummaryDto
    {
        public int TotalCount { get; set; }
        public int UnreadCount { get; set; }
        public int SystemCount { get; set; }
        public int PromotionalCount { get; set; }
    }
}
