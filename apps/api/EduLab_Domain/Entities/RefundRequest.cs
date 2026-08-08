using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace EduLab_Domain.Entities
{
    public class RefundRequest
    {
        public int Id { get; set; }
        public int PaymentId { get; set; }
        public string UserId { get; set; }
        public string Reason { get; set; }
        public string Status { get; set; } = "pending";
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? ProcessedAt { get; set; }
        public string? ProcessedBy { get; set; }
        public string? RejectionReason { get; set; }
        public string? StripeRefundId { get; set; }

        [ForeignKey("PaymentId")]
        public Payment Payment { get; set; }

        [ForeignKey("UserId")]
        public ApplicationUser User { get; set; }
    }
}
