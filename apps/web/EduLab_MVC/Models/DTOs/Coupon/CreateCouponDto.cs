using System;
using System.ComponentModel.DataAnnotations;

namespace EduLab_MVC.Models.DTOs.Coupon
{
    public class CreateCouponDto
    {
        [Required(ErrorMessage = "CouponCodeRequired")]
        [StringLength(50, MinimumLength = 3, ErrorMessage = "CouponCodeLengthError")]
        public string Code { get; set; } = string.Empty;

        [Required]
        public DiscountType DiscountType { get; set; } = DiscountType.Percentage;

        [Required(ErrorMessage = "DiscountValueRequired")]
        [Range(0.01, 100000, ErrorMessage = "DiscountValueRangeError")]
        public decimal DiscountValue { get; set; }

        [Range(0, 100000, ErrorMessage = "MinimumSpendRangeError")]
        public decimal? MinimumSpend { get; set; }

        [Range(0, 100000, ErrorMessage = "MaxDiscountRangeError")]
        public decimal? MaxDiscountAmount { get; set; }

        public DateTime? StartDate { get; set; }

        public DateTime? ExpiryDate { get; set; }

        [Range(1, 1000000, ErrorMessage = "UsageLimitRangeError")]
        public int? UsageLimit { get; set; }

        [Range(1, 100, ErrorMessage = "UsageLimitPerUserRangeError")]
        public int? UsageLimitPerUser { get; set; } = 1;

        public bool IsActive { get; set; } = true;

        [StringLength(250)]
        public string? Description { get; set; }
    }
}
