using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace EduLab_Domain.Entities
{
    /// <summary>
    /// Represents a promotional discount coupon code
    /// </summary>
    public class Coupon
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        public string Code { get; set; } = string.Empty;

        [Required]
        public DiscountType DiscountType { get; set; } = DiscountType.Percentage;

        [Required]
        [Column(TypeName = "decimal(18,2)")]
        public decimal DiscountValue { get; set; }

        [Column(TypeName = "decimal(18,2)")]
        public decimal? MinimumSpend { get; set; }

        [Column(TypeName = "decimal(18,2)")]
        public decimal? MaxDiscountAmount { get; set; }

        public DateTime? StartDate { get; set; }

        public DateTime? ExpiryDate { get; set; }

        public int? UsageLimit { get; set; }

        public int? UsageLimitPerUser { get; set; } = 1;

        public int TimesUsed { get; set; } = 0;

        public bool IsActive { get; set; } = true;

        [MaxLength(250)]
        public string? Description { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public DateTime? UpdatedAt { get; set; }

        public virtual ICollection<CouponUsage> Usages { get; set; } = new List<CouponUsage>();

        public virtual ICollection<Cart> Carts { get; set; } = new List<Cart>();

        /// <summary>
        /// Checks if the coupon is currently valid in terms of dates, active status, and usage limit
        /// </summary>
        public bool IsValidNow()
        {
            if (!IsActive) return false;

            var now = DateTime.UtcNow;
            if (StartDate.HasValue && now < StartDate.Value) return false;
            if (ExpiryDate.HasValue && now > ExpiryDate.Value) return false;

            if (UsageLimit.HasValue && TimesUsed >= UsageLimit.Value) return false;

            return true;
        }

        /// <summary>
        /// Calculates the discount amount for a given subtotal
        /// </summary>
        public decimal CalculateDiscount(decimal subtotal)
        {
            if (subtotal <= 0) return 0;
            if (MinimumSpend.HasValue && subtotal < MinimumSpend.Value) return 0;

            decimal discount = 0;
            if (DiscountType == DiscountType.Percentage)
            {
                discount = subtotal * (DiscountValue / 100m);
                if (MaxDiscountAmount.HasValue && discount > MaxDiscountAmount.Value)
                {
                    discount = MaxDiscountAmount.Value;
                }
            }
            else
            {
                discount = DiscountValue;
            }

            // Discount cannot exceed subtotal
            return Math.Min(subtotal, Math.Max(0, discount));
        }
    }
}
