namespace EduLab.Shared.DTOs.Notification
{
    public enum NotificationTypeDto
    {
        System = 0,
        Promotional = 1,
        Course = 2,
        Enrollment = 3,
        Reminder = 4
    }

    public enum NotificationStatusDto
    {
        Unread = 0,
        Read = 1
    }

    public class NotificationDto
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Message { get; set; }
        public NotificationTypeDto Type { get; set; }
        public NotificationStatusDto Status { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? ReadAt { get; set; }
        public string? RelatedEntityId { get; set; }
        public string? RelatedEntityType { get; set; }
        public string? IconClass { get; set; } // للاستخدام في الواجهة
        public string? ColorClass { get; set; } // للاستخدام في الواجهة
    }

    public class CreateNotificationDto
    {
        public string Title { get; set; }
        public string Message { get; set; }
        public NotificationTypeDto Type { get; set; }
        public string UserId { get; set; }
        public string? RelatedEntityId { get; set; }
        public string? RelatedEntityType { get; set; }
    }

    public class UpdateNotificationDto
    {
        public NotificationStatusDto Status { get; set; }
    }

    public class NotificationFilterDto
    {
        public NotificationTypeDto? Type { get; set; }
        public NotificationStatusDto? Status { get; set; }
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 10;
    }

    public class NotificationSummaryDto
    {
        public int TotalCount { get; set; }
        public int UnreadCount { get; set; }
        public int SystemCount { get; set; }
        public int PromotionalCount { get; set; }
    }
}