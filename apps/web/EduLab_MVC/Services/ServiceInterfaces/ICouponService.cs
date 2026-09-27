using EduLab_MVC.Models.DTOs.Coupon;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Service interface for promo coupons and discount operations in MVC
    /// </summary>
    public interface ICouponService
    {
        Task<List<CouponDto>> GetAllAsync(CancellationToken cancellationToken = default);
        Task<CouponDto?> GetByIdAsync(int id, CancellationToken cancellationToken = default);
        Task<(bool Success, CouponDto? Data, string? ErrorMessage)> CreateAsync(CreateCouponDto dto, CancellationToken cancellationToken = default);
        Task<(bool Success, CouponDto? Data, string? ErrorMessage)> UpdateAsync(int id, UpdateCouponDto dto, CancellationToken cancellationToken = default);
        Task<bool> DeleteAsync(int id, CancellationToken cancellationToken = default);
        Task<bool> ToggleStatusAsync(int id, CancellationToken cancellationToken = default);
        Task<ApplyCouponResultDto> ApplyCouponAsync(string code, CancellationToken cancellationToken = default);
        Task<bool> RemoveCouponAsync(CancellationToken cancellationToken = default);
    }
}
