using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Payment;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Stripe;
using Stripe.Checkout;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class PaymentService : IPaymentService
    {
        private readonly IPaymentRepository _paymentRepository;
        private readonly ICartRepository _cartRepository;
        private readonly IMapper _mapper;
        private readonly ILogger<PaymentService> _logger;
        private readonly string _stripeSecretKey;
        private readonly UserManager<ApplicationUser> _userManager;

        public PaymentService(
            IPaymentRepository paymentRepository,
            ICartRepository cartRepository,
            IMapper mapper,
            IConfiguration configuration,
            ILogger<PaymentService> logger,
            UserManager<ApplicationUser> userManager)
        {
            _paymentRepository = paymentRepository ?? throw new ArgumentNullException(nameof(paymentRepository));
            _cartRepository = cartRepository ?? throw new ArgumentNullException(nameof(cartRepository));
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));

            _stripeSecretKey = configuration["Stripe:SecretKey"];

            if (string.IsNullOrEmpty(_stripeSecretKey))
            {
                _logger.LogError("Stripe Secret Key is missing or empty");
                throw new ArgumentException("Stripe Secret Key is required");
            }

            StripeConfiguration.ApiKey = _stripeSecretKey;
            _logger.LogInformation("Stripe initialized with key: {Key}",
                _stripeSecretKey.Substring(0, Math.Min(10, _stripeSecretKey.Length)) + "...");
            _userManager = userManager;
        }

        public async Task<PaymentResponse> CreatePaymentIntentAsync(string userId, PaymentRequest request, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Creating payment intent for user ID: {UserId}", userId);

                var user = await _userManager.FindByIdAsync(userId);
                if (user == null || string.IsNullOrEmpty(user.Email))
                {
                    _logger.LogWarning("User not found or email is empty for user ID: {UserId}", userId);
                    throw new ApplicationException("User email is required for payment");
                }

                // تحديث بيانات المستخدم إذا تم تقديمها
                if (!string.IsNullOrEmpty(request.FullName))
                    user.FullName = request.FullName;

                if (!string.IsNullOrEmpty(request.PhoneNumber))
                    user.PhoneNumber = request.PhoneNumber;

                if (!string.IsNullOrEmpty(request.PostalCode))
                    user.PostalCode = request.PostalCode;

                await _userManager.UpdateAsync(user);

                var options = new PaymentIntentCreateOptions
                {
                    Amount = (long)(request.Amount * 100),
                    Currency = request.Currency,
                    PaymentMethodTypes = new List<string> { "card" },
                    Description = request.Description,
                    Metadata = new Dictionary<string, string>
            {
                { "userId", userId },
                { "courseIds", string.Join(",", request.CourseIds) },
                { "postalCode", request.PostalCode ?? "" }
            },
                    ReceiptEmail = user.Email
                };

                var service = new PaymentIntentService();
                var paymentIntent = await service.CreateAsync(options, cancellationToken: cancellationToken);

                _logger.LogInformation("Successfully created payment intent: {PaymentIntentId}", paymentIntent.Id);

                return new PaymentResponse
                {
                    Success = true,
                    PaymentIntentId = paymentIntent.Id,
                    ClientSecret = paymentIntent.ClientSecret,
                    Amount = request.Amount,
                    Currency = request.Currency,
                    CreatedAt = DateTime.UtcNow
                };
            }
            catch (StripeException ex)
            {
                _logger.LogError(ex, "Stripe error creating payment intent for user ID: {UserId}. Stripe error: {StripeError}",
                    userId, ex.StripeError?.Message);
                throw new ApplicationException($"Stripe error: {ex.Message}");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating payment intent for user ID: {UserId}", userId);
                throw;
            }
        }

        public async Task<PaymentResponse> ConfirmPaymentAsync(string paymentIntentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Confirming payment intent: {PaymentIntentId}", paymentIntentId);

                var service = new PaymentIntentService();
                var paymentIntent = await service.GetAsync(paymentIntentId, cancellationToken: cancellationToken);

                if (paymentIntent.Status == "succeeded")
                {
                    await ProcessPaymentSuccessAsync(paymentIntentId, cancellationToken);

                    return new PaymentResponse
                    {
                        Success = true,
                        Message = "Payment confirmed successfully",
                        PaymentIntentId = paymentIntent.Id,
                        Amount = paymentIntent.Amount / 100m,
                        Currency = paymentIntent.Currency,
                        CreatedAt = DateTime.UtcNow
                    };
                }

                return new PaymentResponse
                {
                    Success = false,
                    Message = $"Payment status: {paymentIntent.Status}",
                    PaymentIntentId = paymentIntent.Id
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error confirming payment intent: {PaymentIntentId}", paymentIntentId);
                throw;
            }
        }

        public async Task<bool> ProcessPaymentSuccessAsync(string paymentIntentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Processing successful payment: {PaymentIntentId}", paymentIntentId);

                var service = new PaymentIntentService();
                var paymentIntent = await service.GetAsync(paymentIntentId, cancellationToken: cancellationToken);

                if (paymentIntent.Metadata.TryGetValue("userId", out var userId) &&
                    paymentIntent.Metadata.TryGetValue("courseIds", out var courseIdsStr))
                {
                    var courseIds = courseIdsStr.Split(',').Select(int.Parse).ToList();

                    foreach (var courseId in courseIds)
                    {
                        var payment = new Payment
                        {
                            UserId = userId,
                            CourseId = courseId,
                            Amount = paymentIntent.Amount / 100m,
                            PaymentMethod = "stripe",
                            Status = "completed",
                            PaidAt = DateTime.UtcNow,
                            StripeSessionId = paymentIntentId ?? "unknown_session_id" // قيمة افتراضية
                        };

                        await _paymentRepository.CreatePaymentAsync(payment, cancellationToken);
                    }

                    // Clear the user's cart after successful payment
                    var cart = await _cartRepository.GetCartByUserIdAsync(userId, cancellationToken);
                    if (cart != null)
                    {
                        await _cartRepository.ClearCartAsync(cart.Id, cancellationToken);
                    }

                    _logger.LogInformation("Successfully processed payment: {PaymentIntentId}", paymentIntentId);
                    return true;
                }

                _logger.LogWarning("Missing metadata in payment intent: {PaymentIntentId}", paymentIntentId);
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing successful payment: {PaymentIntentId}", paymentIntentId);
                throw;
            }
        }

        public async Task<PaymentResponse> CreateCheckoutSessionAsync(string userId, CheckoutRequest request, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Creating checkout session for user ID: {UserId}", userId);

                var cart = await _cartRepository.GetCartByUserIdAsync(userId, cancellationToken);
                if (cart == null || !cart.CartItems.Any())
                {
                    throw new ApplicationException("Cart is empty");
                }

                // الحصول على البريد الإلكتروني من قاعدة البيانات
                var user = await _userManager.FindByIdAsync(userId);
                if (user == null || string.IsNullOrEmpty(user.Email))
                {
                    throw new ApplicationException("User email is required for checkout");
                }

                var options = new SessionCreateOptions
                {
                    PaymentMethodTypes = new List<string> { "card" },
                    LineItems = cart.CartItems.Select(item => new SessionLineItemOptions
                    {
                        PriceData = new SessionLineItemPriceDataOptions
                        {
                            Currency = "usd",
                            ProductData = new SessionLineItemPriceDataProductDataOptions
                            {
                                Name = item.Course.Title,
                                Description = $"Course by {item.Course.Instructor?.FullName}",
                                Images = !string.IsNullOrEmpty(item.Course.ThumbnailUrl) ?
                                    new List<string> { item.Course.ThumbnailUrl } : null
                            },
                            UnitAmount = (long)(item.Course.Price * 100)
                        },
                        Quantity = item.Quantity
                    }).ToList(),
                    Mode = "payment",
                    SuccessUrl = request.ReturnUrl + "?success=true&session_id={CHECKOUT_SESSION_ID}",
                    CancelUrl = request.ReturnUrl + "?canceled=true",
                    CustomerEmail = user.Email, // استخدام البريد من قاعدة البيانات
                    Metadata = new Dictionary<string, string>
            {
                { "userId", userId },
                { "cartId", cart.Id.ToString() }
            }
                };

                var sessionService = new SessionService();
                var session = await sessionService.CreateAsync(options, cancellationToken: cancellationToken);

                _logger.LogInformation("Successfully created checkout session: {SessionId}", session.Id);

                return new PaymentResponse
                {
                    Success = true,
                    PaymentIntentId = session.PaymentIntentId,
                    ClientSecret = session.ClientSecret,
                    Amount = cart.TotalPrice,
                    Currency = "usd",
                    CreatedAt = DateTime.UtcNow
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating checkout session for user ID: {UserId}", userId);
                throw;
            }
        }
    }
}