using System;

namespace EduLab_MVC.Models.DTOs.Payment
{
    /// <summary>
    /// Represents a payment data transfer object.
    /// </summary>
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
        public bool IsRefundable { get; set; }
        public string? RefundStatus { get; set; }
    }
}
