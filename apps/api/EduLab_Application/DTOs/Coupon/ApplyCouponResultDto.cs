namespace EduLab_Application.DTOs.Coupon
{
    /// <summary>
    /// Result returned after applying or validating a promo coupon
    /// </summary>
    public class ApplyCouponResultDto
    {
        public bool Success { get; set; }
        public string Message { get; set; } = string.Empty;
        public string? Code { get; set; }
        public decimal Subtotal { get; set; }
        public decimal DiscountAmount { get; set; }
        public decimal NewTotal { get; set; }
        public string? DiscountDescription { get; set; }
    }
}
