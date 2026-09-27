using EduLab_MVC.Models.DTOs.Coupon;
using EduLab_MVC.Resources;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Policy = "AdminArea")]
    public class CouponController : Controller
    {
        private readonly ICouponService _couponService;
        private readonly ILogger<CouponController> _logger;
        private readonly IStringLocalizer<SharedResources> _localizer;

        public CouponController(
            ICouponService couponService,
            ILogger<CouponController> logger,
            IStringLocalizer<SharedResources> localizer)
        {
            _couponService = couponService ?? throw new ArgumentNullException(nameof(couponService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _localizer = localizer ?? throw new ArgumentNullException(nameof(localizer));
        }

        #region Views

        [HttpGet]
        public async Task<IActionResult> Index(CancellationToken cancellationToken = default)
        {
            try
            {
                var coupons = await _couponService.GetAllAsync(cancellationToken);
                return View(coupons);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading coupons page");
                TempData["Error"] = "حدث خطأ أثناء تحميل الرموز الترويجية";
                return View(new List<CouponDto>());
            }
        }

        #endregion

        #region AJAX Actions

        [HttpGet]
        public async Task<IActionResult> GetCoupon(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                var coupon = await _couponService.GetByIdAsync(id, cancellationToken);
                if (coupon == null)
                {
                    return Json(new { success = false, message = "الرمز الترويجي غير موجود" });
                }

                return Json(new { success = true, data = coupon });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting coupon with ID {Id}", id);
                return Json(new { success = false, message = "حدث خطأ أثناء استرجاع بيانات الرمز الترويجي" });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([FromBody] CreateCouponDto model, CancellationToken cancellationToken = default)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return Json(new { success = false, message = "يرجى التحقق من صحة البيانات المدخلة" });
                }

                var (success, data, error) = await _couponService.CreateAsync(model, cancellationToken);
                if (success)
                {
                    return Json(new { success = true, message = "تم إنشاء الرمز الترويجي بنجاح" });
                }

                return Json(new { success = false, message = error ?? "فشل إنشاء الرمز الترويجي" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating coupon");
                return Json(new { success = false, message = "حدث خطأ أثناء إنشاء الرمز الترويجي" });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [FromBody] UpdateCouponDto model, CancellationToken cancellationToken = default)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return Json(new { success = false, message = "يرجى التحقق من صحة البيانات المدخلة" });
                }

                var (success, data, error) = await _couponService.UpdateAsync(id, model, cancellationToken);
                if (success)
                {
                    return Json(new { success = true, message = "تم تعديل الرمز الترويجي بنجاح" });
                }

                return Json(new { success = false, message = error ?? "فشل تعديل الرمز الترويجي" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating coupon ID {Id}", id);
                return Json(new { success = false, message = "حدث خطأ أثناء تعديل الرمز الترويجي" });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                var success = await _couponService.DeleteAsync(id, cancellationToken);
                if (success)
                {
                    return Json(new { success = true, message = "تم حذف الرمز الترويجي بنجاح" });
                }

                return Json(new { success = false, message = "تعذر حذف الرمز الترويجي" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting coupon ID {Id}", id);
                return Json(new { success = false, message = "حدث خطأ أثناء حذف الرمز الترويجي" });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ToggleStatus(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                var success = await _couponService.ToggleStatusAsync(id, cancellationToken);
                if (success)
                {
                    return Json(new { success = true, message = "تم تحديث حالة الرمز الترويجي بنجاح" });
                }

                return Json(new { success = false, message = "تعذر تحديث حالة الرمز الترويجي" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error toggling coupon ID {Id}", id);
                return Json(new { success = false, message = "حدث خطأ أثناء تحديث حالة الرمز الترويجي" });
            }
        }

        #endregion
    }
}
