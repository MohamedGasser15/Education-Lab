using EduLab_Domain.Entities;
using System;
using System.ComponentModel.DataAnnotations;

namespace EduLab_Application.DTOs.Coupon
{
    /// <summary>
    /// Request model for creating a new promotional coupon
    /// </summary>
    public class CreateCouponDto
    {
        [Required(ErrorMessage = "Coupon code is required")]
        [StringLength(50, MinimumLength = 3, ErrorMessage = "Code must be between 3 and 50 characters")]
        public string Code { get; set; } = string.Empty;

        [Required]
        public DiscountType DiscountType { get; set; } = DiscountType.Percentage;

        [Required]
        [Range(0.01, 100000, ErrorMessage = "Discount value must be greater than zero")]
        public decimal DiscountValue { get; set; }

        [Range(0, 100000, ErrorMessage = "Minimum spend must be zero or positive")]
        public decimal? MinimumSpend { get; set; }

        [Range(0, 100000, ErrorMessage = "Max discount amount must be zero or positive")]
        public decimal? MaxDiscountAmount { get; set; }

        public DateTime? StartDate { get; set; }

        public DateTime? ExpiryDate { get; set; }

        [Range(1, 1000000, ErrorMessage = "Usage limit must be at least 1")]
        public int? UsageLimit { get; set; }

        [Range(1, 100, ErrorMessage = "Usage limit per user must be at least 1")]
        public int? UsageLimitPerUser { get; set; } = 1;

        public bool IsActive { get; set; } = true;

        [StringLength(250, ErrorMessage = "Description cannot exceed 250 characters")]
        public string? Description { get; set; }
    }
}
