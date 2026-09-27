using AutoMapper;
using EduLab_Application.DTOs.Coupon;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for promotional coupons and cart discount management
    /// </summary>
    public class CouponService : ICouponService
    {
        private readonly ICouponRepository _couponRepository;
        private readonly ICartRepository _cartRepository;
        private readonly IMapper _mapper;
        private readonly ILogger<CouponService> _logger;

        public CouponService(
            ICouponRepository couponRepository,
            ICartRepository cartRepository,
            IMapper mapper,
            ILogger<CouponService> logger)
        {
            _couponRepository = couponRepository ?? throw new ArgumentNullException(nameof(couponRepository));
            _cartRepository = cartRepository ?? throw new ArgumentNullException(nameof(cartRepository));
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region Admin Operations

        public async Task<List<CouponDto>> GetAllAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                var coupons = await _couponRepository.GetAllAsync(
                    orderBy: q => q.OrderByDescending(c => c.CreatedAt),
                    cancellationToken: cancellationToken);

                return coupons.Select(MapToDto).ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting all coupons");
                throw;
            }
        }

        public async Task<CouponDto?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                var coupon = await _couponRepository.GetAsync(
                    c => c.Id == id,
                    cancellationToken: cancellationToken);

                return coupon != null ? MapToDto(coupon) : null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting coupon by ID {CouponId}", id);
                throw;
            }
        }

        public async Task<CouponDto> CreateAsync(CreateCouponDto dto, CancellationToken cancellationToken = default)
        {
            if (dto == null) throw new ArgumentNullException(nameof(dto));

            var normalizedCode = dto.Code.Trim().ToUpper();

            if (await _couponRepository.CodeExistsAsync(normalizedCode, null, cancellationToken))
            {
                throw new InvalidOperationException($"Coupon code '{normalizedCode}' already exists.");
            }

            if (dto.ExpiryDate.HasValue && dto.ExpiryDate.Value <= DateTime.UtcNow)
            {
                throw new InvalidOperationException("تاريخ الانتهاء لا يمكن أن يكون في الماضي");
            }

            if (dto.StartDate.HasValue && dto.ExpiryDate.HasValue && dto.ExpiryDate.Value <= dto.StartDate.Value)
            {
                throw new InvalidOperationException("تاريخ الانتهاء يجب أن يكون بعد تاريخ البدء");
            }

            var coupon = new Coupon
            {
                Code = normalizedCode,
                DiscountType = dto.DiscountType,
                DiscountValue = dto.DiscountValue,
                MinimumSpend = dto.MinimumSpend,
                MaxDiscountAmount = dto.MaxDiscountAmount,
                StartDate = dto.StartDate,
                ExpiryDate = dto.ExpiryDate,
                UsageLimit = dto.UsageLimit,
                UsageLimitPerUser = dto.UsageLimitPerUser,
                IsActive = dto.IsActive,
                Description = dto.Description,
                CreatedAt = DateTime.UtcNow
            };

            await _couponRepository.CreateAsync(coupon, cancellationToken);
            _logger.LogInformation("Successfully created coupon '{Code}' with ID {Id}", coupon.Code, coupon.Id);

            return MapToDto(coupon);
        }

        public async Task<CouponDto> UpdateAsync(int id, UpdateCouponDto dto, CancellationToken cancellationToken = default)
        {
            if (dto == null) throw new ArgumentNullException(nameof(dto));

            var coupon = await _couponRepository.GetAsync(c => c.Id == id, isTracking: true, cancellationToken: cancellationToken);
            if (coupon == null)
            {
                throw new KeyNotFoundException($"Coupon with ID {id} not found.");
            }

            var normalizedCode = dto.Code.Trim().ToUpper();
            if (await _couponRepository.CodeExistsAsync(normalizedCode, id, cancellationToken))
            {
                throw new InvalidOperationException($"Coupon code '{normalizedCode}' is already used by another coupon.");
            }

            if (dto.ExpiryDate.HasValue && dto.ExpiryDate.Value <= DateTime.UtcNow)
            {
                throw new InvalidOperationException("تاريخ الانتهاء لا يمكن أن يكون في الماضي");
            }

            if (dto.StartDate.HasValue && dto.ExpiryDate.HasValue && dto.ExpiryDate.Value <= dto.StartDate.Value)
            {
                throw new InvalidOperationException("تاريخ الانتهاء يجب أن يكون بعد تاريخ البدء");
            }

            coupon.Code = normalizedCode;
            coupon.DiscountType = dto.DiscountType;
            coupon.DiscountValue = dto.DiscountValue;
            coupon.MinimumSpend = dto.MinimumSpend;
            coupon.MaxDiscountAmount = dto.MaxDiscountAmount;
            coupon.StartDate = dto.StartDate;
            coupon.ExpiryDate = dto.ExpiryDate;
            coupon.UsageLimit = dto.UsageLimit;
            coupon.UsageLimitPerUser = dto.UsageLimitPerUser;
            coupon.IsActive = dto.IsActive;
            coupon.Description = dto.Description;
            coupon.UpdatedAt = DateTime.UtcNow;

            await _couponRepository.UpdateAsync(coupon, cancellationToken);
            _logger.LogInformation("Successfully updated coupon ID {Id}", id);

            return MapToDto(coupon);
        }

        public async Task<bool> DeleteAsync(int id, CancellationToken cancellationToken = default)
        {
            var coupon = await _couponRepository.GetAsync(c => c.Id == id, cancellationToken: cancellationToken);
            if (coupon == null) return false;

            await _couponRepository.DeleteAsync(coupon, cancellationToken);
            _logger.LogInformation("Successfully deleted coupon ID {Id}", id);
            return true;
        }

        public async Task<bool> ToggleStatusAsync(int id, CancellationToken cancellationToken = default)
        {
            var coupon = await _couponRepository.GetAsync(c => c.Id == id, isTracking: true, cancellationToken: cancellationToken);
            if (coupon == null) return false;

            coupon.IsActive = !coupon.IsActive;
            coupon.UpdatedAt = DateTime.UtcNow;
            await _couponRepository.UpdateAsync(coupon, cancellationToken);
            _logger.LogInformation("Toggled active status for coupon ID {Id} to {Status}", id, coupon.IsActive);
            return true;
        }

        #endregion

        #region Cart & Redemption Operations

        public async Task<ApplyCouponResultDto> ApplyCouponToCartAsync(
            string? userId,
            string? guestId,
            string code,
            CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(code))
            {
                return new ApplyCouponResultDto
                {
                    Success = false,
                    Message = "يرجى إدخال رمز الخصم"
                };
            }

            // 1. Retrieve the cart
            Cart? cart = null;
            if (!string.IsNullOrEmpty(userId))
            {
                cart = await _cartRepository.GetCartByUserIdAsync(userId, cancellationToken);
            }
            else if (!string.IsNullOrEmpty(guestId))
            {
                cart = await _cartRepository.GetCartByGuestIdAsync(guestId, cancellationToken);
            }

            if (cart == null || cart.CartItems == null || !cart.CartItems.Any())
            {
                return new ApplyCouponResultDto
                {
                    Success = false,
                    Message = "السلة فارغة، أضف دورات أولاً لتطبيق الخصم"
                };
            }

            var subtotal = cart.Subtotal;
            if (subtotal <= 0)
            {
                return new ApplyCouponResultDto
                {
                    Success = false,
                    Message = "الدورات الموجودة في السلة مجانية بالفعل"
                };
            }

            // 2. Retrieve the coupon
            var coupon = await _couponRepository.GetByCodeAsync(code, cancellationToken);
            if (coupon == null)
            {
                return new ApplyCouponResultDto
                {
                    Success = false,
                    Message = "رمز القسيمة غير صحيح أو غير موجود"
                };
            }

            // 3. Check active state
            if (!coupon.IsActive)
            {
                return new ApplyCouponResultDto
                {
                    Success = false,
                    Message = "رمز القسيمة غير مفعل حالياً"
                };
            }

            var now = DateTime.UtcNow;

            // 4. Check start date
            if (coupon.StartDate.HasValue && now < coupon.StartDate.Value)
            {
                return new ApplyCouponResultDto
                {
                    Success = false,
                    Message = "لم يبدأ موعد سريان هذا الرمز الترويجي بعد"
                };
            }

            // 5. Check expiry date
            if (coupon.ExpiryDate.HasValue && now > coupon.ExpiryDate.Value)
            {
                return new ApplyCouponResultDto
                {
                    Success = false,
                    Message = "عذراً، هذا الرمز الترويجي منتهي الصلاحية"
                };
            }

            // 6. Check total usage limit
            if (coupon.UsageLimit.HasValue && coupon.TimesUsed >= coupon.UsageLimit.Value)
            {
                return new ApplyCouponResultDto
                {
                    Success = false,
                    Message = "تم الوصول إلى الحد الأقصى لاستخدام هذا الرمز الترويجي"
                };
            }

            // 7. Check per-user usage limit if user is authenticated
            if (!string.IsNullOrEmpty(userId) && coupon.UsageLimitPerUser.HasValue)
            {
                var userUsageCount = await _couponRepository.GetUserUsageCountAsync(coupon.Id, userId, cancellationToken);
                if (userUsageCount >= coupon.UsageLimitPerUser.Value)
                {
                    return new ApplyCouponResultDto
                    {
                        Success = false,
                        Message = "لقد استخدمت هذا الرمز الترويجي من قبل بالحد الأقصى المسموح لك"
                    };
                }
            }

            // 8. Check minimum spend
            if (coupon.MinimumSpend.HasValue && subtotal < coupon.MinimumSpend.Value)
            {
                return new ApplyCouponResultDto
                {
                    Success = false,
                    Message = $"الحد الأدنى لقيمة السلة لاستخدام هذا الرمز هو {coupon.MinimumSpend.Value:N0} ج.م"
                };
            }

            // 9. Calculate discount
            var discount = coupon.CalculateDiscount(subtotal);
            var newTotal = Math.Max(0, subtotal - discount);

            // 10. Persist applied coupon to cart
            await _cartRepository.SetAppliedCouponAsync(cart.Id, coupon.Id, cancellationToken);

            string discountDescription = coupon.DiscountType == DiscountType.Percentage
                ? $"خصم {coupon.DiscountValue:0.#}%"
                : $"خصم {coupon.DiscountValue:N0} ج.م";

            return new ApplyCouponResultDto
            {
                Success = true,
                Message = $"تم تطبيق الرمز الترويجي بنجاح! ({discountDescription})",
                Code = coupon.Code,
                Subtotal = subtotal,
                DiscountAmount = discount,
                NewTotal = newTotal,
                DiscountDescription = discountDescription
            };
        }

        public async Task<bool> RemoveCouponFromCartAsync(
            string? userId,
            string? guestId,
            CancellationToken cancellationToken = default)
        {
            Cart? cart = null;
            if (!string.IsNullOrEmpty(userId))
            {
                cart = await _cartRepository.GetCartByUserIdAsync(userId, cancellationToken);
            }
            else if (!string.IsNullOrEmpty(guestId))
            {
                cart = await _cartRepository.GetCartByGuestIdAsync(guestId, cancellationToken);
            }

            if (cart == null) return false;

            return await _cartRepository.SetAppliedCouponAsync(cart.Id, null, cancellationToken);
        }

        public async Task RecordCouponUsageAsync(
            int couponId,
            string userId,
            decimal discountAmount,
            string? paymentIntentId = null,
            CancellationToken cancellationToken = default)
        {
            try
            {
                var coupon = await _couponRepository.GetAsync(c => c.Id == couponId, isTracking: true, cancellationToken: cancellationToken);
                if (coupon == null) return;

                coupon.TimesUsed++;
                await _couponRepository.UpdateAsync(coupon, cancellationToken);

                await _couponRepository.AddUsageAsync(new CouponUsage
                {
                    CouponId = couponId,
                    UserId = userId,
                    DiscountAmount = discountAmount,
                    PaymentIntentId = paymentIntentId,
                    UsedAt = DateTime.UtcNow
                }, cancellationToken);

                _logger.LogInformation("Recorded coupon usage for coupon ID {CouponId}, User {UserId}, Discount {Discount}",
                    couponId, userId, discountAmount);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error recording coupon usage for coupon ID {CouponId}", couponId);
                // Do not throw so payment/checkout flow isn't interrupted
            }
        }

        #endregion

        #region Helper Mapping

        private static CouponDto MapToDto(Coupon entity)
        {
            return new CouponDto
            {
                Id = entity.Id,
                Code = entity.Code,
                DiscountType = entity.DiscountType,
                DiscountValue = entity.DiscountValue,
                MinimumSpend = entity.MinimumSpend,
                MaxDiscountAmount = entity.MaxDiscountAmount,
                StartDate = entity.StartDate,
                ExpiryDate = entity.ExpiryDate,
                UsageLimit = entity.UsageLimit,
                UsageLimitPerUser = entity.UsageLimitPerUser,
                TimesUsed = entity.TimesUsed,
                IsActive = entity.IsActive,
                Description = entity.Description,
                CreatedAt = entity.CreatedAt,
                UpdatedAt = entity.UpdatedAt
            };
        }

        #endregion
    }
}
