// EduLab_MVC/Controllers/PaymentController.cs
using EduLab_MVC.Models.DTOs.Cart;
using EduLab_MVC.Models.DTOs.Payment;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Controllers
{
    /// <summary>
    /// MVC Controller for handling payment operations in the Learner area
    /// </summary>
    [Area("Learner")]
    [Authorize]
    public class PaymentController : Controller
    {
        #region Dependencies

        private readonly IPaymentService _paymentService;
        private readonly ICartService _cartService;
        private readonly ILogger<PaymentController> _logger;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the PaymentController class
        /// </summary>
        /// <param name="paymentService">Payment service</param>
        /// <param name="cartService">Cart service</param>
        /// <param name="logger">Logger instance</param>
        /// <exception cref="ArgumentNullException">Thrown when any dependency is null</exception>
        public PaymentController(
            IPaymentService paymentService,
            ICartService cartService,
            ILogger<PaymentController> logger)
        {
            _paymentService = paymentService ?? throw new ArgumentNullException(nameof(paymentService));
            _cartService = cartService ?? throw new ArgumentNullException(nameof(cartService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #endregion

        #region Checkout Page

        /// <summary>
        /// Displays the checkout page
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Checkout view</returns>
        [HttpGet]
        public async Task<IActionResult> Checkout(CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Loading checkout page");

            try
            {
                _logger.LogInformation("Loading checkout page");

                var cart = await _cartService.GetUserCartAsync(cancellationToken);
                if (cart == null || cart.Items.Count == 0)
                {
                    _logger.LogWarning("Cart is empty, redirecting to cart page");
                    return RedirectToAction("Index", "Cart");
                }

                var userData = await _paymentService.GetUserDataAsync(cancellationToken);

                ViewBag.Cart = cart;
                ViewBag.StripePublishableKey = "pk_test_51S7GqdCqTufWux0JBFHAvznc9T07iHHyIUBOYl8FQoIkwp4WPj5jCP6uqt3ynHqqVGDjOt3NtDwFA1SpJ9iTcNYd00gSFPnDdc";
                ViewBag.UserData = userData;

                _logger.LogInformation("Successfully loaded checkout page");
                return View(cart);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading checkout page");
                TempData["Error"] = "حدث خطأ أثناء تحميل صفحة الدفع";
                return RedirectToAction("Index", "Cart");
            }
        }

        #endregion

        #region AJAX Endpoints

        /// <summary>
        /// Creates a payment intent via AJAX
        /// </summary>
        /// <param name="request">Payment request details</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>JSON response with payment intent details</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CreatePaymentIntent([FromBody] PaymentRequest request, CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Creating payment intent via AJAX");

            try
            {
                _logger.LogInformation("Creating payment intent via AJAX");

                var response = await _paymentService.CreatePaymentIntentAsync(request, cancellationToken);

                if (response.Success)
                {
                    _logger.LogInformation("Successfully created payment intent via AJAX: {PaymentIntentId}", response.PaymentIntentId);
                    return Json(new
                    {
                        success = true,
                        clientSecret = response.ClientSecret,
                        paymentIntentId = response.PaymentIntentId
                    });
                }

                _logger.LogWarning("Failed to create payment intent via AJAX: {Message}", response.Message);
                return Json(new { success = false, message = response.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating payment intent via AJAX");
                return Json(new { success = false, message = "حدث خطأ أثناء إنشاء عملية الدفع" });
            }
        }

        /// <summary>
        /// Confirms a payment via AJAX
        /// </summary>
        /// <param name="paymentIntentId">Payment intent identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>JSON response with confirmation result</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ConfirmPayment([FromBody] string paymentIntentId, CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Confirming payment via AJAX {PaymentIntentId}", paymentIntentId);

            try
            {
                _logger.LogInformation("Confirming payment via AJAX: {PaymentIntentId}", paymentIntentId);

                var response = await _paymentService.ConfirmPaymentAsync(paymentIntentId, cancellationToken);

                if (response.Success)
                {
                    _logger.LogInformation("Successfully confirmed payment via AJAX: {PaymentIntentId}", paymentIntentId);
                    return Json(new { success = true, message = response.Message });
                }

                _logger.LogWarning("Failed to confirm payment via AJAX: {Message}", response.Message);
                return Json(new { success = false, message = response.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error confirming payment via AJAX: {PaymentIntentId}", paymentIntentId);
                return Json(new { success = false, message = "حدث خطأ أثناء تأكيد الدفع" });
            }
        }

        /// <summary>
        /// Creates a checkout session via AJAX
        /// </summary>
        /// <param name="request">Checkout request details</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>JSON response with session details</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CreateCheckoutSession([FromBody] CheckoutRequest request, CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Creating checkout session via AJAX");

            try
            {
                _logger.LogInformation("Creating checkout session via AJAX");

                // Set default return URL if not provided
                if (string.IsNullOrEmpty(request.ReturnUrl))
                {
                    request.ReturnUrl = Url.Action("PaymentResult", "Payment", new { area = "Learner" }, protocol: Request.Scheme);
                }

                var response = await _paymentService.CreateCheckoutSessionAsync(request, cancellationToken);

                if (response.Success)
                {
                    _logger.LogInformation("Successfully created checkout session via AJAX: {PaymentIntentId}", response.PaymentIntentId);
                    return Json(new
                    {
                        success = true,
                        sessionId = response.PaymentIntentId,
                        clientSecret = response.ClientSecret
                    });
                }

                _logger.LogWarning("Failed to create checkout session via AJAX: {Message}", response.Message);
                return Json(new { success = false, message = response.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating checkout session via AJAX");
                return Json(new { success = false, message = "حدث خطأ أثناء إنشاء جلسة الدفع" });
            }
        }

        /// <summary>
        /// Retrieves user data via AJAX
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>JSON response with user data</returns>
        [HttpGet]
        public async Task<JsonResult> GetUserData(CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Getting user data via AJAX");

            try
            {
                _logger.LogInformation("Getting user data via AJAX");

                var userData = await _paymentService.GetUserDataAsync(cancellationToken);

                if (userData != null)
                {
                    _logger.LogInformation("Successfully retrieved user data via AJAX");
                    return Json(new { success = true, data = userData });
                }

                _logger.LogWarning("Failed to get user data via AJAX");
                return Json(new { success = false, message = "Failed to get user data" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting user data via AJAX");
                return Json(new { success = false, message = "حدث خطأ أثناء جلب بيانات المستخدم" });
            }
        }

        /// <summary>
        /// Retrieves payment data via AJAX
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>JSON response with payment data</returns>
        [HttpGet]
        public async Task<JsonResult> GetPaymentData(CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Getting payment data via AJAX");

            try
            {
                _logger.LogInformation("Getting payment data via AJAX");

                var cart = await _cartService.GetUserCartAsync(cancellationToken);
                var baseUrl = _paymentService.GetBaseUrl();

                var data = new
                {
                    totalAmount = cart.TotalPrice,
                    currency = "usd",
                    description = $"Payment for {cart.Items.Count} courses",
                    courseIds = cart.Items.Select(i => i.CourseId).ToList(),
                    returnUrl = $"{baseUrl}/Learner/Payment/PaymentResult"
                };

                _logger.LogInformation("Successfully retrieved payment data via AJAX");
                return Json(new { success = true, data });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting payment data via AJAX");
                return Json(new { success = false, message = "حدث خطأ أثناء تحضير بيانات الدفع" });
            }
        }

        #endregion

        #region Payment Results

        /// <summary>
        /// Displays payment result page
        /// </summary>
        /// <param name="session_id">Stripe session identifier</param>
        /// <param name="success">Whether payment was successful</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Payment result view</returns>
        [HttpGet]
        [AllowAnonymous]
        public async Task<IActionResult> PaymentResult(string session_id, bool success, CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Processing payment result for session {SessionId}", session_id);

            try
            {
                _logger.LogInformation("Processing payment result for session: {SessionId}, success: {Success}", session_id, success);

                if (success && !string.IsNullOrEmpty(session_id))
                {
                    await _paymentService.ProcessPaymentSuccessAsync(session_id, cancellationToken);
                }

                ViewBag.Success = success;
                ViewBag.SessionId = session_id;

                _logger.LogInformation("Successfully processed payment result for session: {SessionId}", session_id);
                return View();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing payment result for session: {SessionId}", session_id);
                ViewBag.Success = false;
                ViewBag.Message = "حدث خطأ أثناء معالجة نتيجة الدفع";
                return View();
            }
        }

        /// <summary>
        /// Displays payment success page
        /// </summary>
        /// <returns>Success view</returns>
        [HttpGet]
        public IActionResult Success()
        {
            _logger.LogInformation("Loading payment success page");
            return View();
        }

        /// <summary>
        /// Displays payment cancel page
        /// </summary>
        /// <returns>Cancel view</returns>
        [HttpGet]
        public IActionResult Cancel()
        {
            _logger.LogInformation("Loading payment cancel page");
            return View();
        }

        #endregion
    }
}