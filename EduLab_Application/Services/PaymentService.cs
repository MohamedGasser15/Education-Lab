// EduLab_Application/Services/PaymentService.cs
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
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for payment processing operations
    /// </summary>
    public class PaymentService : IPaymentService
    {
        #region Dependencies

        private readonly IPaymentRepository _paymentRepository;
        private readonly ICourseRepository _courseRepository;
        private readonly ICartRepository _cartRepository;
        private readonly IMapper _mapper;
        private readonly ILogger<PaymentService> _logger;
        private readonly string _stripeSecretKey;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IEmailTemplateService _emailTemplateService;
        private readonly IEmailSender _emailSender;
        private readonly IEnrollmentRepository _enrollmentRepository;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the PaymentService class
        /// </summary>
        /// <param name="paymentRepository">Payment repository</param>
        /// <param name="cartRepository">Cart repository</param>
        /// <param name="mapper">AutoMapper instance</param>
        /// <param name="configuration">Configuration instance</param>
        /// <param name="logger">Logger instance</param>
        /// <param name="userManager">User manager</param>
        /// <param name="emailTemplateService">Email template service</param>
        /// <param name="emailSender">Email sender service</param>
        /// <param name="courseRepository">Course repository</param>
        /// <exception cref="ArgumentNullException">Thrown when any dependency is null</exception>
        /// <exception cref="ArgumentException">Thrown when Stripe secret key is missing</exception>
        public PaymentService(
            IPaymentRepository paymentRepository,
            ICartRepository cartRepository,
            IMapper mapper,
            IConfiguration configuration,
            ILogger<PaymentService> logger,
            UserManager<ApplicationUser> userManager,
            IEmailTemplateService emailTemplateService,
            IEmailSender emailSender,
            ICourseRepository courseRepository,
            IEnrollmentRepository enrollmentRepository)
        {
            _paymentRepository = paymentRepository ?? throw new ArgumentNullException(nameof(paymentRepository));
            _cartRepository = cartRepository ?? throw new ArgumentNullException(nameof(cartRepository));
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
            _emailTemplateService = emailTemplateService ?? throw new ArgumentNullException(nameof(emailTemplateService));
            _emailSender = emailSender ?? throw new ArgumentNullException(nameof(emailSender));
            _courseRepository = courseRepository ?? throw new ArgumentNullException(nameof(courseRepository));

            _stripeSecretKey = configuration["Stripe:SecretKey"];

            if (string.IsNullOrEmpty(_stripeSecretKey))
            {
                _logger.LogError("Stripe Secret Key is missing or empty");
                throw new ArgumentException("Stripe Secret Key is required");
            }

            StripeConfiguration.ApiKey = _stripeSecretKey;
            _logger.LogInformation("Stripe initialized successfully");
            _enrollmentRepository = enrollmentRepository;
        }

        #endregion

        #region Payment Intent Operations

        /// <summary>
        /// Creates a Stripe payment intent for processing payments
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="request">Payment request details</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Payment response with intent details</returns>
        /// <exception cref="ApplicationException">Thrown when user not found or email is missing</exception>
        public async Task<PaymentResponse> CreatePaymentIntentAsync(string userId, PaymentRequest request, CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Creating payment intent for user {UserId}", userId);

            try
            {
                _logger.LogInformation("Creating payment intent for user ID: {UserId}", userId);

                var user = await _userManager.FindByIdAsync(userId);
                if (user == null || string.IsNullOrEmpty(user.Email))
                {
                    _logger.LogWarning("User not found or email is empty for user ID: {UserId}", userId);
                    throw new ApplicationException("User email is required for payment");
                }

                // Update user information if provided
                await UpdateUserInformationAsync(user, request, cancellationToken);

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
                _logger.LogError(ex, "Stripe error creating payment intent for user ID: {UserId}", userId);
                throw new ApplicationException($"Stripe error: {ex.Message}");
            }
            catch (ApplicationException)
            {
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error creating payment intent for user ID: {UserId}", userId);
                throw new ApplicationException("An unexpected error occurred while creating payment intent");
            }
        }

        /// <summary>
        /// Confirms a payment intent and processes the payment
        /// </summary>
        /// <param name="paymentIntentId">Payment intent identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Payment confirmation response</returns>
        public async Task<PaymentResponse> ConfirmPaymentAsync(string paymentIntentId, CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Confirming payment intent {PaymentIntentId}", paymentIntentId);

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

                _logger.LogWarning("Payment intent {PaymentIntentId} has status: {Status}", paymentIntentId, paymentIntent.Status);

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
                throw new ApplicationException("An error occurred while confirming payment");
            }
        }

        #endregion

        #region Payment Processing

        /// <summary>
        /// Processes a successful payment and creates payment records
        /// </summary>
        /// <param name="paymentIntentId">Payment intent identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if processing was successful, false otherwise</returns>
        public async Task<bool> ProcessPaymentSuccessAsync(string paymentIntentId, CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Processing successful payment {PaymentIntentId}", paymentIntentId);

            try
            {
                _logger.LogInformation("Processing successful payment: {PaymentIntentId}", paymentIntentId);

                var service = new PaymentIntentService();
                var paymentIntent = await service.GetAsync(paymentIntentId, cancellationToken: cancellationToken);

                if (paymentIntent.Metadata.TryGetValue("userId", out var userId) &&
                    paymentIntent.Metadata.TryGetValue("courseIds", out var courseIdsStr))
                {
                    var courseIds = courseIdsStr.Split(',').Select(int.Parse).ToList();

                    // Create payment records
                    await CreatePaymentRecordsAsync(userId, courseIds, paymentIntent, cancellationToken);

                    // Clear user's cart
                    await ClearUserCartAsync(userId, cancellationToken);

                    // Send confirmation email
                    await SendPaymentConfirmationEmailAsync(userId, courseIds, paymentIntent, cancellationToken);

                    _logger.LogInformation("Successfully processed payment: {PaymentIntentId}", paymentIntentId);
                    return true;
                }

                _logger.LogWarning("Missing metadata in payment intent: {PaymentIntentId}", paymentIntentId);
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing successful payment: {PaymentIntentId}", paymentIntentId);
                throw new ApplicationException("An error occurred while processing payment");
            }
        }

        #endregion

        #region Checkout Operations

        /// <summary>
        /// Creates a Stripe checkout session for cart items
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="request">Checkout request details</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Checkout session response</returns>
        /// <exception cref="ApplicationException">Thrown when cart is empty or user email is missing</exception>
        public async Task<PaymentResponse> CreateCheckoutSessionAsync(string userId, CheckoutRequest request, CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Creating checkout session for user {UserId}", userId);

            try
            {
                _logger.LogInformation("Creating checkout session for user ID: {UserId}", userId);

                var cart = await _cartRepository.GetCartByUserIdAsync(userId, cancellationToken);
                if (cart == null || !cart.CartItems.Any())
                {
                    throw new ApplicationException("Cart is empty");
                }

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
                        Quantity = 1
                    }).ToList(),
                    Mode = "payment",
                    SuccessUrl = request.ReturnUrl + "?success=true&session_id={CHECKOUT_SESSION_ID}",
                    CancelUrl = request.ReturnUrl + "?canceled=true",
                    CustomerEmail = user.Email,
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
            catch (ApplicationException)
            {
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating checkout session for user ID: {UserId}", userId);
                throw new ApplicationException("An error occurred while creating checkout session");
            }
        }

        #endregion

        #region Private Helper Methods

        private async Task UpdateUserInformationAsync(ApplicationUser user, PaymentRequest request, CancellationToken cancellationToken)
        {
            bool needsUpdate = false;

            if (!string.IsNullOrEmpty(request.FullName) && user.FullName != request.FullName)
            {
                user.FullName = request.FullName;
                needsUpdate = true;
            }

            if (!string.IsNullOrEmpty(request.PhoneNumber) && user.PhoneNumber != request.PhoneNumber)
            {
                user.PhoneNumber = request.PhoneNumber;
                needsUpdate = true;
            }

            if (!string.IsNullOrEmpty(request.PostalCode) && user.PostalCode != request.PostalCode)
            {
                user.PostalCode = request.PostalCode;
                needsUpdate = true;
            }

            if (needsUpdate)
            {
                await _userManager.UpdateAsync(user);
            }
        }

        // في دالة ProcessPaymentSuccessAsync، بعد إنشاء سجلات الدفع
        private async Task CreatePaymentRecordsAsync(string userId, List<int> courseIds, PaymentIntent paymentIntent, CancellationToken cancellationToken)
        {
            var payments = courseIds.Select(courseId => new Payment
            {
                UserId = userId,
                CourseId = courseId,
                Amount = paymentIntent.Amount / 100m,
                PaymentMethod = "stripe",
                Status = "completed",
                PaidAt = DateTime.UtcNow,
                StripeSessionId = paymentIntent.Id ?? "unknown_session_id"
            }).ToList();

            await _paymentRepository.CreateBulkPaymentsAsync(payments, cancellationToken);

            // إنشاء enrollments بعد الدفع الناجح
            var enrollments = courseIds.Select(courseId => new Enrollment
            {
                UserId = userId,
                CourseId = courseId,
                EnrolledAt = DateTime.UtcNow
            }).ToList();

            await _enrollmentRepository.CreateBulkEnrollmentsAsync(enrollments, cancellationToken);
        }

        private async Task ClearUserCartAsync(string userId, CancellationToken cancellationToken)
        {
            var cart = await _cartRepository.GetCartByUserIdAsync(userId, cancellationToken);
            if (cart != null)
            {
                await _cartRepository.ClearCartAsync(cart.Id, cancellationToken);
            }
        }

        private async Task SendPaymentConfirmationEmailAsync(string userId, List<int> courseIds, PaymentIntent paymentIntent, CancellationToken cancellationToken)
        {
            var user = await _userManager.FindByIdAsync(userId);
            if (user != null && !string.IsNullOrEmpty(user.Email))
            {
                var purchasedCourses = await GetPurchasedCourses(courseIds, cancellationToken);
                var paymentSuccessEmail = _emailTemplateService.GeneratePaymentSuccessEmail(
                    user,
                    purchasedCourses,
                    paymentIntent.Amount / 100m,
                    "بطاقة ائتمان",
                    DateTime.UtcNow,
                    paymentIntent.Id
                );

                await _emailSender.SendEmailAsync(
                    user.Email,
                    "تمت عملية الدفع بنجاح - EduLab",
                    paymentSuccessEmail
                );
            }
        }

        private async Task<List<Course>> GetPurchasedCourses(List<int> courseIds, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving purchased courses for IDs: {CourseIds}", string.Join(",", courseIds));

                var courses = new List<Course>();

                foreach (var courseId in courseIds)
                {
                    var course = await _courseRepository.GetCourseByIdAsync(courseId);
                    if (course != null)
                    {
                        courses.Add(course);
                    }
                    else
                    {
                        _logger.LogWarning("Course with ID {CourseId} not found", courseId);
                    }
                }

                _logger.LogInformation("Successfully retrieved {Count} purchased courses", courses.Count);
                return courses;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving purchased courses");
                throw;
            }
        }

        #endregion
    }
}