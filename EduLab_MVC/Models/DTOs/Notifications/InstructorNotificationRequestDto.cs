using System.ComponentModel.DataAnnotations;

namespace EduLab_MVC.Models.DTOs.Notifications
{
    public class InstructorNotificationRequestDto
    {
        [Required(ErrorMessage = "عنوان الإشعار مطلوب")]
        [StringLength(200, ErrorMessage = "العنوان يجب ألا يتجاوز 200 حرف")]
        public string Title { get; set; } = string.Empty;

        [Required(ErrorMessage = "محتوى الإشعار مطلوب")]
        [StringLength(2000, ErrorMessage = "المحتوى يجب ألا يتجاوز 2000 حرف")]
        public string Message { get; set; } = string.Empty;

        public int Type { get; set; } = 0; // System
        public List<string> StudentIds { get; set; } = new List<string>();
        public bool SendToAll { get; set; } = false;
        public bool SendEmail { get; set; } = false;
        public bool SendNotification { get; set; } = true;
    }

    public class InstructorNotificationResultDto
    {
        public int TotalStudents { get; set; }
        public int NotificationsSent { get; set; }
        public int EmailsSent { get; set; }
        public int FailedNotifications { get; set; }
        public int FailedEmails { get; set; }
        public List<string> Errors { get; set; } = new List<string>();
        public bool IsSuccess => !Errors.Any();
    }
}