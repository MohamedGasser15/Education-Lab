using System.ComponentModel.DataAnnotations.Schema;

namespace EduLab_Domain.Entities
{
    /// <summary>
    /// Represents the category of a notification
    /// </summary>
    public enum NotificationType
    {
        System,
        Promotional,
        Course,
        Enrollment,
        Reminder
    }

    /// <summary>
    /// Represents the read state of a notification
    /// </summary>
    public enum NotificationStatus
    {
        Unread,
        Read
    }

    /// <summary>
    /// Represents a notification sent to a user
    /// </summary>
    public class Notification
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Message { get; set; }
        public NotificationType Type { get; set; }
        public NotificationStatus Status { get; set; } = NotificationStatus.Unread;
        public string UserId { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? ReadAt { get; set; }
        public string? RelatedEntityId { get; set; }
        public string? RelatedEntityType { get; set; }
        public string? TitleKey { get; set; }
        public string? MessageKey { get; set; }
        public string? Parameters { get; set; }

        [ForeignKey("UserId")]
        public ApplicationUser User { get; set; }
    }
}