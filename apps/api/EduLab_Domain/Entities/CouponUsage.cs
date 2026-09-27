using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace EduLab_Domain.Entities
{
    /// <summary>
    /// Tracks individual redemptions of coupons by users
    /// </summary>
    public class CouponUsage
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int CouponId { get; set; }

        [ForeignKey("CouponId")]
        public virtual Coupon Coupon { get; set; } = null!;

        [Required]
        public string UserId { get; set; } = string.Empty;

        [ForeignKey("UserId")]
        public virtual ApplicationUser User { get; set; } = null!;

        [Column(TypeName = "decimal(18,2)")]
        public decimal DiscountAmount { get; set; }

        public DateTime UsedAt { get; set; } = DateTime.UtcNow;

        [MaxLength(100)]
        public string? PaymentIntentId { get; set; }
    }
}
