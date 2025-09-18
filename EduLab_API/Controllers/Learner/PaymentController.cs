// EduLab_API/Controllers/Learner/PaymentController.cs
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Payment;
using EduLab_Shared.DTOs.Profile;
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
    /// <summary>
    /// API controller for handling payment operations
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    [Produces("application/json")]
    [Authorize]
    public class PaymentController : ControllerBase
    {
        #region Dependencies

        private readonly IPaymentService _paymentService;
        private readonly ICartService _cartService;
        private readonly ILogger<PaymentController> _logger;
        private readonly UserManager<ApplicationUser> _userManager;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the PaymentController class
        /// </summary>
        /// <param name="paymentService">Payment service</param>
        /// <param name="cartService">Cart service</param>
        /// <param name="logger">Logger instance</param>
        /// <param name="userManager">User manager</param>
        /// <exception cref="ArgumentNullException">Thrown when any dependency is null</exception>
        public PaymentController(
            IPaymentService paymentService,
            ICartService cartService,
            ILogger<PaymentController> logger,
            UserManager<ApplicationUser> userManager)
        {
            _paymentService = paymentService ?? throw new ArgumentNullException(nameof(paymentService));
            _cartService = cartService ?? throw new ArgumentNullException(nameof(cartService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
        }

        #endregion

        #region Helper Methods

        /// <summary>
        /// Retrieves the current user's identifier from claims
        /// </summary>
        /// <returns>User identifier or null if not found</returns>
        private string GetUserId()
        {
            return User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        }

        #endregion

        #region Payment Operations

        /// <summary>
        /// Creates a payment intent for processing payments
        /// </summary>
        /// <param name="request">Payment request details</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Payment intent response</returns>
        [HttpPost("create-payment-intent")]
        [ProducesResponseType(typeof(PaymentResponse), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<PaymentResponse>> CreatePaymentIntent(
            [FromBody] PaymentRequest request,
            CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Creating payment intent");

            try
            {
                var userId = GetUserId();
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized(new { Message = "User not authenticated" });
                }

                // Populate user data if available
                var user = await _userManager.FindByIdAsync(userId);
                if (user != null)
                {
                    request.FullName ??= user.FullName;
                    request.PhoneNumber ??= user.PhoneNumber;
                    request.PostalCode ??= user.PostalCode;
                }

                request.PaymentMethodId ??= "temp_payment_method";

                var response = await _paymentService.CreatePaymentIntentAsync(userId, request, cancellationToken);
                return Ok(response);
            }
            catch (ApplicationException ex)
            {
                _logger.LogWarning(ex, "Application error creating payment intent");
                return BadRequest(new { Message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error creating payment intent");
                return StatusCode(500, new { Message = "An unexpected error occurred while creating payment intent" });
            }
        }

        /// <summary>
        /// Confirms a payment intent
        /// </summary>
        /// <param name="paymentIntentId">Payment intent identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Payment confirmation response</returns>
        [HttpPost("confirm-payment")]
        [ProducesResponseType(typeof(PaymentResponse), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<PaymentResponse>> ConfirmPayment(
            [FromBody] string paymentIntentId,
            CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Confirming payment {PaymentIntentId}", paymentIntentId);

            try
            {
                if (string.IsNullOrEmpty(paymentIntentId))
                {
                    return BadRequest(new { Message = "Payment intent ID is required" });
                }

                var response = await _paymentService.ConfirmPaymentAsync(paymentIntentId, cancellationToken);
                return Ok(response);
            }
            catch (ApplicationException ex)
            {
                _logger.LogWarning(ex, "Application error confirming payment: {PaymentIntentId}", paymentIntentId);
                return BadRequest(new { Message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error confirming payment: {PaymentIntentId}", paymentIntentId);
                return StatusCode(500, new { Message = "An unexpected error occurred while confirming payment" });
            }
        }

        /// <summary>
        /// Creates a checkout session for cart items
        /// </summary>
        /// <param name="request">Checkout request details</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Checkout session response</returns>
        [HttpPost("create-checkout-session")]
        [ProducesResponseType(typeof(PaymentResponse), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<PaymentResponse>> CreateCheckoutSession(
            [FromBody] CheckoutRequest request,
            CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Creating checkout session");

            try
            {
                var userId = GetUserId();
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized(new { Message = "User not authenticated" });
                }

                var response = await _paymentService.CreateCheckoutSessionAsync(userId, request, cancellationToken);
                return Ok(response);
            }
            catch (ApplicationException ex)
            {
                _logger.LogWarning(ex, "Application error creating checkout session");
                return BadRequest(new { Message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error creating checkout session");
                return StatusCode(500, new { Message = "An unexpected error occurred while creating checkout session" });
            }
        }

        #endregion

        #region User Data

        /// <summary>
        /// Retrieves user data for payment processing
        /// </summary>
        /// <returns>User profile data</returns>
        [HttpGet("user-data")]
        [ProducesResponseType(typeof(ProfileDTO), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<ProfileDTO>> GetUserData()
        {
            using var scope = _logger.BeginScope("Getting user data");

            try
            {
                var userId = GetUserId();
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized(new { Message = "User not authenticated" });
                }

                var user = await _userManager.FindByIdAsync(userId);
                if (user == null)
                {
                    return NotFound(new { Message = "User not found" });
                }

                var userData = new ProfileDTO
                {
                    Id = user.Id,
                    FullName = user.FullName,
                    Email = user.Email,
                    PhoneNumber = user.PhoneNumber,
                    PostalCode = user.PostalCode
                };

                return Ok(userData);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting user data");
                return StatusCode(500, new { Message = "An error occurred while getting user data" });
            }
        }

        #endregion

        #region Payment Results

        /// <summary>
        /// Handles successful payment redirects from Stripe
        /// </summary>
        /// <param name="session_id">Stripe session identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Payment success response</returns>
        [HttpGet("success")]
        [AllowAnonymous]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> PaymentSuccess(
            [FromQuery] string session_id,
            CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Processing payment success for session {SessionId}", session_id);

            try
            {
                if (!string.IsNullOrEmpty(session_id))
                {
                    await _paymentService.ProcessPaymentSuccessAsync(session_id, cancellationToken);
                }

                return Ok(new { message = "Payment successful", session_id });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error handling payment success for session: {SessionId}", session_id);
                return StatusCode(500, new { Message = "An error occurred while processing payment success" });
            }
        }

        /// <summary>
        /// Handles canceled payment redirects from Stripe
        /// </summary>
        /// <returns>Payment cancel response</returns>
        [HttpGet("cancel")]
        [AllowAnonymous]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public IActionResult PaymentCancel()
        {
            _logger.LogInformation("Payment was canceled by user");
            return Ok(new { message = "Payment canceled" });
        }

        #endregion
    }
}