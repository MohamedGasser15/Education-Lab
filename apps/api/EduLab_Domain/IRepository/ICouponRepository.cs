using EduLab_Domain.Entities;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.IRepository
{
    /// <summary>
    /// Repository interface for coupon operations
    /// </summary>
    public interface ICouponRepository : IRepository<Coupon>
    {
        /// <summary>
        /// Retrieves a coupon by its code (case-insensitive)
        /// </summary>
        Task<Coupon?> GetByCodeAsync(string code, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing coupon
        /// </summary>
        Task<Coupon> UpdateAsync(Coupon entity, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets the count of times a user has used a specific coupon
        /// </summary>
        Task<int> GetUserUsageCountAsync(int couponId, string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Records a coupon redemption
        /// </summary>
        Task AddUsageAsync(CouponUsage usage, CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks if a coupon code exists (excluding optional coupon ID)
        /// </summary>
        Task<bool> CodeExistsAsync(string code, int? excludeId = null, CancellationToken cancellationToken = default);
    }
}
