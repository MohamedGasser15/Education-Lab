using System.ComponentModel.DataAnnotations;

namespace EduLab_MVC.Models.DTOs.Coupon
{
    public class ApplyCouponRequest
    {
        [Required]
        public string Code { get; set; } = string.Empty;
    }
}
