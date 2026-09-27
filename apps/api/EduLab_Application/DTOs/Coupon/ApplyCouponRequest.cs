using System.ComponentModel.DataAnnotations;

namespace EduLab_Application.DTOs.Coupon
{
    /// <summary>
    /// Request to apply a promo coupon to the current cart
    /// </summary>
    public class ApplyCouponRequest
    {
        [Required(ErrorMessage = "Coupon code is required")]
        public string Code { get; set; } = string.Empty;
    }
}
