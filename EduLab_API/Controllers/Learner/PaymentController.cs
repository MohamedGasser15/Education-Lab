using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Payment;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Learner
{
    [ApiController]
    [Route("api/[controller]")]
    [Produces("application/json")]
    [Authorize]
    public class PaymentController : ControllerBase
    {
        private readonly IPaymentService _paymentService;
        private readonly ICartService _cartService;
        private readonly ILogger<PaymentController> _logger;
        private readonly UserManager<ApplicationUser> _userManager;

        public PaymentController(
            IPaymentService paymentService,
            ICartService cartService,
            ILogger<PaymentController> logger,
            UserManager<ApplicationUser> userManager)
        {
            _paymentService = paymentService ?? throw new ArgumentNullException(nameof(paymentService));
            _cartService = cartService ?? throw new ArgumentNullException(nameof(cartService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _userManager = userManager;
        }

        private string GetUserId()
        {
            return User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        }

        [HttpPost("create-payment-intent")]
        [ProducesResponseType(typeof(PaymentResponse), 200)]
        public async Task<ActionResult<PaymentResponse>> CreatePaymentIntent(
            [FromBody] PaymentRequest request,
            CancellationToken cancellationToken = default)
        {
            try
            {
                var userId = GetUserId();
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized();
                }

                // إزالة تعيين البريد الإلكتروني - سيعالجها الـ Service
                request.PaymentMethodId ??= "temp_payment_method";

                var response = await _paymentService.CreatePaymentIntentAsync(userId, request, cancellationToken);
                return Ok(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating payment intent");
                return StatusCode(500, "An error occurred while creating payment intent");
            }
        }

        [HttpPost("confirm-payment")]
        [ProducesResponseType(typeof(PaymentResponse), 200)]
        [ProducesResponseType(400)]
        [ProducesResponseType(500)]
        public async Task<ActionResult<PaymentResponse>> ConfirmPayment(
            [FromBody] string paymentIntentId,
            CancellationToken cancellationToken = default)
        {
            try
            {
                var response = await _paymentService.ConfirmPaymentAsync(paymentIntentId, cancellationToken);
                return Ok(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error confirming payment: {PaymentIntentId}", paymentIntentId);
                return StatusCode(500, "An error occurred while confirming payment");
            }
        }

        [HttpPost("create-checkout-session")]
        [ProducesResponseType(typeof(PaymentResponse), 200)]
        [ProducesResponseType(400)]
        [ProducesResponseType(500)]
        public async Task<ActionResult<PaymentResponse>> CreateCheckoutSession(
            [FromBody] CheckoutRequest request,
            CancellationToken cancellationToken = default)
        {
            try
            {
                var userId = GetUserId();
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized();
                }

                var response = await _paymentService.CreateCheckoutSessionAsync(userId, request, cancellationToken);
                return Ok(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating checkout session");
                return StatusCode(500, "An error occurred while creating checkout session");
            }
        }

        [HttpGet("success")]
        [AllowAnonymous]
        public async Task<IActionResult> PaymentSuccess(
            [FromQuery] string session_id,
            CancellationToken cancellationToken = default)
        {
            try
            {
                // Handle successful payment
                return Ok(new { message = "Payment successful", session_id });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error handling payment success");
                return StatusCode(500, "An error occurred while processing payment success");
            }
        }

        [HttpGet("cancel")]
        [AllowAnonymous]
        public IActionResult PaymentCancel()
        {
            return Ok(new { message = "Payment canceled" });
        }
    }
}