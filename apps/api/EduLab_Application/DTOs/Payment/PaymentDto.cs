using System;

namespace EduLab_Application.DTOs.Payment
{
    public class PaymentDto
    {
        public int Id { get; set; }
        public decimal Amount { get; set; }
        public string Status { get; set; } = string.Empty;
        public DateTime PaidAt { get; set; }
        public string StripeSessionId { get; set; } = string.Empty;
        public int CourseId { get; set; }
        public string CourseTitle { get; set; } = string.Empty;
        public string? CourseThumbnail { get; set; }
        public bool IsRefundable { get; set; } // Will be calculated based on the rules
    }
}
