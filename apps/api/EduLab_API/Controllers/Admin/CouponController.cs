using EduLab_Application.DTOs.Coupon;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Admin
{
    /// <summary>
    /// API controller for promotional coupons and cart discount management
    /// </summary>
    [Produces("application/json")]
    [Route("api/[controller]")]
    [ApiController]
    public class CouponController : ControllerBase
    {
        private readonly ICouponService _couponService;
        private readonly ILogger<CouponController> _logger;

        public CouponController(ICouponService couponService, ILogger<CouponController> logger)
        {
            _couponService = couponService ?? throw new ArgumentNullException(nameof(couponService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region Helper Methods

        private string? GetUserId()
        {
            return User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        }

        private string? GetGuestId()
        {
            if (Request.Cookies.TryGetValue("GuestId", out var guestId))
            {
                return guestId;
            }
            return null;
        }

        #endregion

        #region Admin Endpoints

        /// <summary>
        /// Retrieves all promotional coupons (Admin)
        /// </summary>
        [HttpGet]
        [Authorize(Policy = "AdminArea")]
        [ProducesResponseType(typeof(List<CouponDto>), StatusCodes.Status200OK)]
        public async Task<ActionResult<List<CouponDto>>> GetAll(CancellationToken cancellationToken = default)
        {
            try
            {
                var coupons = await _couponService.GetAllAsync(cancellationToken);
                return Ok(coupons);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving all coupons");
                return StatusCode(StatusCodes.Status500InternalServerError, "Error retrieving coupons");
            }
        }

        /// <summary>
        /// Retrieves a coupon by ID (Admin)
        /// </summary>
        [HttpGet("{id:int}")]
        [Authorize(Policy = "AdminArea")]
        [ProducesResponseType(typeof(CouponDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<CouponDto>> GetById(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                var coupon = await _couponService.GetByIdAsync(id, cancellationToken);
                if (coupon == null) return NotFound("Coupon not found");
                return Ok(coupon);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving coupon with ID {Id}", id);
                return StatusCode(StatusCodes.Status500InternalServerError, "Error retrieving coupon");
            }
        }

        /// <summary>
        /// Creates a new promotional coupon (Admin)
        /// </summary>
        [HttpPost]
        [Authorize(Policy = "AdminArea")]
        [ProducesResponseType(typeof(CouponDto), StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status409Conflict)]
        public async Task<ActionResult<CouponDto>> Create([FromBody] CreateCouponDto dto, CancellationToken cancellationToken = default)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                var created = await _couponService.CreateAsync(dto, cancellationToken);
                return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
            }
            catch (InvalidOperationException ex)
            {
                return Conflict(new { message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating coupon");
                return StatusCode(StatusCodes.Status500InternalServerError, "Error creating coupon");
            }
        }

        /// <summary>
        /// Updates an existing promotional coupon (Admin)
        /// </summary>
        [HttpPut("{id:int}")]
        [Authorize(Policy = "AdminArea")]
        [ProducesResponseType(typeof(CouponDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status409Conflict)]
        public async Task<ActionResult<CouponDto>> Update(int id, [FromBody] UpdateCouponDto dto, CancellationToken cancellationToken = default)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                var updated = await _couponService.UpdateAsync(id, dto, cancellationToken);
                return Ok(updated);
            }
            catch (KeyNotFoundException)
            {
                return NotFound("Coupon not found");
            }
            catch (InvalidOperationException ex)
            {
                return Conflict(new { message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating coupon ID {Id}", id);
                return StatusCode(StatusCodes.Status500InternalServerError, "Error updating coupon");
            }
        }

        /// <summary>
        /// Deletes a promotional coupon (Admin)
        /// </summary>
        [HttpDelete("{id:int}")]
        [Authorize(Policy = "AdminArea")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> Delete(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                var success = await _couponService.DeleteAsync(id, cancellationToken);
                if (!success) return NotFound("Coupon not found");
                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting coupon ID {Id}", id);
                return StatusCode(StatusCodes.Status500InternalServerError, "Error deleting coupon");
            }
        }

        /// <summary>
        /// Toggles active status of a coupon (Admin)
        /// </summary>
        [HttpPatch("{id:int}/toggle")]
        [Authorize(Policy = "AdminArea")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> ToggleStatus(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                var success = await _couponService.ToggleStatusAsync(id, cancellationToken);
                if (!success) return NotFound("Coupon not found");
                return Ok(new { success = true });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error toggling status for coupon ID {Id}", id);
                return StatusCode(StatusCodes.Status500InternalServerError, "Error toggling coupon status");
            }
        }

        #endregion

        #region Learner Cart Endpoints

        /// <summary>
        /// Applies a promotional coupon to the current cart
        /// </summary>
        [HttpPost("apply")]
        [AllowAnonymous]
        [ProducesResponseType(typeof(ApplyCouponResultDto), StatusCodes.Status200OK)]
        public async Task<ActionResult<ApplyCouponResultDto>> ApplyCoupon([FromBody] ApplyCouponRequest request, CancellationToken cancellationToken = default)
        {
            try
            {
                if (request == null || string.IsNullOrWhiteSpace(request.Code))
                {
                    return Ok(new ApplyCouponResultDto { Success = false, Message = "يرجى إدخال رمز الخصم" });
                }

                var userId = GetUserId();
                var guestId = GetGuestId();

                var result = await _couponService.ApplyCouponToCartAsync(userId, guestId, request.Code, cancellationToken);
                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error applying coupon {Code}", request?.Code);
                return Ok(new ApplyCouponResultDto { Success = false, Message = "حدث خطأ أثناء تطبيق الرمز الترويجي" });
            }
        }

        /// <summary>
        /// Removes the applied promotional coupon from the current cart
        /// </summary>
        [HttpPost("remove")]
        [AllowAnonymous]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> RemoveCoupon(CancellationToken cancellationToken = default)
        {
            try
            {
                var userId = GetUserId();
                var guestId = GetGuestId();

                var success = await _couponService.RemoveCouponFromCartAsync(userId, guestId, cancellationToken);
                return Ok(new { success });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error removing coupon from cart");
                return StatusCode(StatusCodes.Status500InternalServerError, "Error removing coupon");
            }
        }

        #endregion
    }
}
