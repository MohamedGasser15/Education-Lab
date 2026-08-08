using System;

namespace EduLab_MVC.Models.DTOs.Payment
{
    /// <summary>
    /// DTO for admin refund request review
    /// </summary>
    public class AdminRefundRequestDto
    {
        public int Id { get; set; }
        public int PaymentId { get; set; }
        public string UserId { get; set; } = string.Empty;
        public string UserName { get; set; } = string.Empty;
        public string UserEmail { get; set; } = string.Empty;
        public string CourseTitle { get; set; } = string.Empty;
        public string? CourseThumbnail { get; set; }
        public decimal Amount { get; set; }
        public string Reason { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
        public DateTime? ProcessedAt { get; set; }
        public string? ProcessedBy { get; set; }
        public string? RejectionReason { get; set; }
        public string? StripeRefundId { get; set; }
    }
}
