using System.ComponentModel.DataAnnotations;

namespace EduLab_MVC.Models.DTOs.Notifications
{
    public enum NotificationTargetDto
    {
        AllUsers = 0,
        StudentsOnly = 1,
        InstructorsOnly = 2
    }

    public class AdminNotificationRequestDto
    {
        [StringLength(200, ErrorMessage = "العنوان يجب ألا يتجاوز 200 حرف")]
        public string Title { get; set; } = string.Empty;

        [StringLength(2000, ErrorMessage = "المحتوى يجب ألا يتجاوز 2000 حرف")]
        public string Message { get; set; } = string.Empty;

        public NotificationTypeDto Type { get; set; } = NotificationTypeDto.Promotional;

        public NotificationTargetDto Target { get; set; } = NotificationTargetDto.AllUsers;

        [Required(ErrorMessage = "يجب تحديد نوع الإرسال")]
        public bool SendEmail { get; set; } = true;

        [Required(ErrorMessage = "يجب تحديد نوع الإرسال")]
        public bool SendNotification { get; set; } = true;
    }
}