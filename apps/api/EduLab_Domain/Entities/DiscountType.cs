namespace EduLab_Domain.Entities
{
    /// <summary>
    /// Type of discount for a promotional coupon
    /// </summary>
    public enum DiscountType
    {
        /// <summary>
        /// Percentage discount (e.g., 20% off)
        /// </summary>
        Percentage = 1,

        /// <summary>
        /// Fixed amount discount (e.g., 50 EGP off)
        /// </summary>
        FixedAmount = 2
    }
}
