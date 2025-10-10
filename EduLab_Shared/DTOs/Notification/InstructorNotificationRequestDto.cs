using System.ComponentModel.DataAnnotations;

namespace EduLab_Shared.DTOs.Notification
{
    public class InstructorNotificationRequestDto
    {
        [Required(ErrorMessage = "عنوان الإشعار مطلوب")]
        [StringLength(200, ErrorMessage = "العنوان يجب ألا يتجاوز 200 حرف")]
        public string Title { get; set; } = string.Empty;

        [Required(ErrorMessage = "محتوى الإشعار مطلوب")]
        [StringLength(2000, ErrorMessage = "المحتوى يجب ألا يتجاوز 2000 حرف")]
        public string Message { get; set; } = string.Empty;

        public List<string> StudentIds { get; set; } = new List<string>();
        public bool SendEmail { get; set; } = true;
        public bool SendNotification { get; set; } = true;
        public NotificationTypeDto Type { get; set; } = NotificationTypeDto.System;
    }
}