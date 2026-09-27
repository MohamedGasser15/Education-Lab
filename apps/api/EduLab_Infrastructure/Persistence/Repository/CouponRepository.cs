using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab_Infrastructure.DB;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    /// <summary>
    /// Repository implementation for Coupon entity
    /// </summary>
    public class CouponRepository : Repository<Coupon>, ICouponRepository
    {
        private readonly ApplicationDbContext _db;
        private readonly ILogger<CouponRepository> _logger;

        public CouponRepository(ApplicationDbContext db, ILogger<CouponRepository> logger)
            : base(db, logger)
        {
            _db = db;
            _logger = logger;
        }

        /// <summary>
        /// Retrieves a coupon by its code (case-insensitive)
        /// </summary>
        public async Task<Coupon?> GetByCodeAsync(string code, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(code)) return null;

            var normalizedCode = code.Trim().ToUpper();
            return await _db.Coupons
                .Include(c => c.Usages)
                .FirstOrDefaultAsync(c => c.Code.ToUpper() == normalizedCode, cancellationToken);
        }

        /// <summary>
        /// Updates an existing coupon
        /// </summary>
        public async Task<Coupon> UpdateAsync(Coupon entity, CancellationToken cancellationToken = default)
        {
            try
            {
                entity.UpdatedAt = DateTime.UtcNow;
                _db.Coupons.Update(entity);
                await _db.SaveChangesAsync(cancellationToken);
                return entity;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating coupon ID {CouponId}", entity.Id);
                throw;
            }
        }

        /// <summary>
        /// Gets the count of times a user has used a specific coupon
        /// </summary>
        public async Task<int> GetUserUsageCountAsync(int couponId, string userId, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrEmpty(userId)) return 0;

            return await _db.CouponUsages
                .CountAsync(u => u.CouponId == couponId && u.UserId == userId, cancellationToken);
        }

        /// <summary>
        /// Records a coupon redemption
        /// </summary>
        public async Task AddUsageAsync(CouponUsage usage, CancellationToken cancellationToken = default)
        {
            try
            {
                await _db.CouponUsages.AddAsync(usage, cancellationToken);
                await _db.SaveChangesAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error recording coupon usage for coupon ID {CouponId}", usage.CouponId);
                throw;
            }
        }

        /// <summary>
        /// Checks if a coupon code exists (excluding optional coupon ID)
        /// </summary>
        public async Task<bool> CodeExistsAsync(string code, int? excludeId = null, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(code)) return false;

            var normalizedCode = code.Trim().ToUpper();
            var query = _db.Coupons.Where(c => c.Code.ToUpper() == normalizedCode);

            if (excludeId.HasValue)
            {
                query = query.Where(c => c.Id != excludeId.Value);
            }

            return await query.AnyAsync(cancellationToken);
        }
    }
}
