// EduLab_MVC/Controllers/PaymentController.cs
using EduLab_MVC.Models.DTOs.Cart;
using EduLab_MVC.Models.DTOs.Payment;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Controllers
{
    [Area("Learner")]
    [Authorize]
    public class PaymentController : Controller
    {
        private readonly IPaymentService _paymentService;
        private readonly ICartService _cartService;
        private readonly ILogger<PaymentController> _logger;

        public PaymentController(
            IPaymentService paymentService,
            ICartService cartService,
            ILogger<PaymentController> logger)
        {
            _paymentService = paymentService ?? throw new ArgumentNullException(nameof(paymentService));
            _cartService = cartService ?? throw new ArgumentNullException(nameof(cartService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        [HttpGet]
        public async Task<IActionResult> Checkout(CancellationToken cancellationToken = default)
        {
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
                return RedirectToAction("Index", "Cart");
            }
        }

        [HttpPost]
        public async Task<IActionResult> CreatePaymentIntent([FromBody] PaymentRequest request, CancellationToken cancellationToken = default)
        {
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

        [HttpPost]
        public async Task<IActionResult> ConfirmPayment([FromBody] string paymentIntentId, CancellationToken cancellationToken = default)
        {
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

        [HttpPost]
        public async Task<IActionResult> CreateCheckoutSession([FromBody] CheckoutRequest request, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Creating checkout session via AJAX");

                // تعيين returnUrl إذا لم يتم توفيره
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

        [HttpGet]
        [AllowAnonymous]
        public async Task<IActionResult> PaymentResult(string session_id, bool success, CancellationToken cancellationToken = default)
        {
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

        [HttpGet]
        public IActionResult Success()
        {
            _logger.LogInformation("Loading payment success page");
            return View();
        }

        [HttpGet]
        public IActionResult Cancel()
        {
            _logger.LogInformation("Loading payment cancel page");
            return View();
        }
        [HttpGet]
        public async Task<JsonResult> GetUserData(CancellationToken cancellationToken = default)
        {
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
        [HttpGet]
        public async Task<JsonResult> GetPaymentData(CancellationToken cancellationToken = default)
        {
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
                    // إزالة customerEmail - لن يُرسل إلى الـ API
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
    }
}