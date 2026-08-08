using System;

namespace EduLab_Application.DTOs.Payment
{
    /// <summary>
    /// DTO for admin refund request review
    /// </summary>
    public class AdminRefundRequestDto
    {
        public int Id { get; set; }
        public int PaymentId { get; set; }
        public string UserId { get; set; }
        public string UserName { get; set; }
        public string UserEmail { get; set; }
        public string CourseTitle { get; set; }
        public string CourseThumbnail { get; set; }
        public decimal Amount { get; set; }
        public string Reason { get; set; }
        public string Status { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? ProcessedAt { get; set; }
        public string? ProcessedBy { get; set; }
        public string? RejectionReason { get; set; }
        public string? StripeRefundId { get; set; }
    }
}
