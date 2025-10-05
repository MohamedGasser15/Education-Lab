using System.ComponentModel.DataAnnotations.Schema;

namespace EduLab_Domain.Entities
{
    public enum NotificationType
    {
        System,     // نظامية
        Promotional, // ترويجية
        Course,     // متعلقة بالدورات
        Enrollment, // متعلقة بالتسجيل
        Reminder    // تذكير
    }

    public enum NotificationStatus
    {
        Unread,
        Read
    }

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
        public string? RelatedEntityId { get; set; } // للربط مع كيان معين (دورة، مستخدم، etc)
        public string? RelatedEntityType { get; set; } // نوع الكيان المرتبط

        [ForeignKey("UserId")]
        public ApplicationUser User { get; set; }
    }
}