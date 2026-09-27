using EduLab_Application.DTOs.Coupon;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for promotional coupons and cart discount management
    /// </summary>
    public interface ICouponService
    {
        #region Admin Operations

        /// <summary>
        /// Retrieves all promo coupons
        /// </summary>
        Task<List<CouponDto>> GetAllAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a coupon by its unique identifier
        /// </summary>
        Task<CouponDto?> GetByIdAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Creates a new promotional coupon
        /// </summary>
        Task<CouponDto> CreateAsync(CreateCouponDto dto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing promotional coupon
        /// </summary>
        Task<CouponDto> UpdateAsync(int id, UpdateCouponDto dto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a promotional coupon
        /// </summary>
        Task<bool> DeleteAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Toggles the active status of a coupon
        /// </summary>
        Task<bool> ToggleStatusAsync(int id, CancellationToken cancellationToken = default);

        #endregion

        #region Cart & Redemption Operations

        /// <summary>
        /// Validates a coupon code and applies it to the user's or guest's cart
        /// </summary>
        Task<ApplyCouponResultDto> ApplyCouponToCartAsync(string? userId, string? guestId, string code, CancellationToken cancellationToken = default);

        /// <summary>
        /// Removes any applied coupon from the user's or guest's cart
        /// </summary>
        Task<bool> RemoveCouponFromCartAsync(string? userId, string? guestId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Records a coupon redemption upon successful checkout
        /// </summary>
        Task RecordCouponUsageAsync(int couponId, string userId, decimal discountAmount, string? paymentIntentId = null, CancellationToken cancellationToken = default);

        #endregion
    }
}
