// EduLab_MVC/Services/PaymentService.cs
using EduLab_MVC.Models.DTOs.Payment;
using EduLab_MVC.Models.DTOs.Profile;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// MVC service for handling payment operations with the API
    /// </summary>
    public class PaymentService : IPaymentService
    {
        #region Dependencies

        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly ILogger<PaymentService> _logger;
        private readonly IHttpContextAccessor _httpContextAccessor;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the PaymentService class
        /// </summary>
        /// <param name="httpClientService">HTTP client service</param>
        /// <param name="logger">Logger instance</param>
        /// <param name="httpContextAccessor">HTTP context accessor</param>
        /// <exception cref="ArgumentNullException">Thrown when any dependency is null</exception>
        public PaymentService(
            IAuthorizedHttpClientService httpClientService,
            ILogger<PaymentService> logger,
            IHttpContextAccessor httpContextAccessor)
        {
            _httpClientService = httpClientService ?? throw new ArgumentNullException(nameof(httpClientService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
        }

        #endregion

        #region User Data Operations

        /// <summary>
        /// Retrieves user data for payment processing
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>User profile data or null if not found</returns>
        public async Task<ProfileDTO> GetUserDataAsync(CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Getting user data");

            try
            {
                _logger.LogInformation("Getting user data");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("payment/user-data", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync(cancellationToken);
                    var userData = JsonConvert.DeserializeObject<ProfileDTO>(responseContent);

                    _logger.LogInformation("Successfully retrieved user data");
                    return userData;
                }

                _logger.LogWarning("Failed to get user data. Status code: {StatusCode}", response.StatusCode);
                return null;
            }
            catch (HttpRequestException httpEx)
            {
                _logger.LogError(httpEx, "HTTP error getting user data");
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error getting user data");
                return null;
            }
        }

        #endregion

        #region Payment Operations

        /// <summary>
        /// Creates a payment intent via API
        /// </summary>
        /// <param name="request">Payment request details</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Payment response</returns>
        public async Task<PaymentResponse> CreatePaymentIntentAsync(PaymentRequest request, CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Creating payment intent for amount {Amount}", request.Amount);

            try
            {
                _logger.LogInformation("Creating payment intent for amount: {Amount}", request.Amount);

                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(request);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync("payment/create-payment-intent", content, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync(cancellationToken);
                    var paymentResponse = JsonConvert.DeserializeObject<PaymentResponse>(responseContent);

                    _logger.LogInformation("Successfully created payment intent: {PaymentIntentId}",
                        paymentResponse?.PaymentIntentId);
                    return paymentResponse;
                }

                var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);
                _logger.LogWarning("Failed to create payment intent. Status: {StatusCode}, Response: {Error}",
                    response.StatusCode, errorContent);

                return new PaymentResponse
                {
                    Success = false,
                    Message = $"Failed to create payment intent: {response.StatusCode}"
                };
            }
            catch (HttpRequestException httpEx)
            {
                _logger.LogError(httpEx, "HTTP error creating payment intent");
                return new PaymentResponse
                {
                    Success = false,
                    Message = "Network error occurred while creating payment intent"
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error creating payment intent");
                return new PaymentResponse
                {
                    Success = false,
                    Message = "An unexpected error occurred while creating payment intent"
                };
            }
        }

        /// <summary>
        /// Confirms a payment via API
        /// </summary>
        /// <param name="paymentIntentId">Payment intent identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Payment confirmation response</returns>
        public async Task<PaymentResponse> ConfirmPaymentAsync(string paymentIntentId, CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Confirming payment {PaymentIntentId}", paymentIntentId);

            try
            {
                _logger.LogInformation("Confirming payment intent: {PaymentIntentId}", paymentIntentId);

                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(paymentIntentId);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync("payment/confirm-payment", content, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync(cancellationToken);
                    var paymentResponse = JsonConvert.DeserializeObject<PaymentResponse>(responseContent);

                    _logger.LogInformation("Successfully confirmed payment: {PaymentIntentId}", paymentIntentId);
                    return paymentResponse;
                }

                _logger.LogWarning("Failed to confirm payment. Status code: {StatusCode}", response.StatusCode);
                return new PaymentResponse
                {
                    Success = false,
                    Message = "Failed to confirm payment"
                };
            }
            catch (HttpRequestException httpEx)
            {
                _logger.LogError(httpEx, "HTTP error confirming payment: {PaymentIntentId}", paymentIntentId);
                return new PaymentResponse
                {
                    Success = false,
                    Message = "Network error occurred while confirming payment"
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error confirming payment: {PaymentIntentId}", paymentIntentId);
                return new PaymentResponse
                {
                    Success = false,
                    Message = "An unexpected error occurred while confirming payment"
                };
            }
        }

        /// <summary>
        /// Creates a checkout session via API
        /// </summary>
        /// <param name="request">Checkout request details</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Checkout session response</returns>
        public async Task<PaymentResponse> CreateCheckoutSessionAsync(CheckoutRequest request, CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Creating checkout session");

            try
            {
                _logger.LogInformation("Creating checkout session");

                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(request);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync("payment/create-checkout-session", content, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync(cancellationToken);
                    var paymentResponse = JsonConvert.DeserializeObject<PaymentResponse>(responseContent);

                    _logger.LogInformation("Successfully created checkout session: {PaymentIntentId}",
                        paymentResponse.PaymentIntentId);
                    return paymentResponse;
                }

                _logger.LogWarning("Failed to create checkout session. Status code: {StatusCode}", response.StatusCode);
                return new PaymentResponse
                {
                    Success = false,
                    Message = "Failed to create checkout session"
                };
            }
            catch (HttpRequestException httpEx)
            {
                _logger.LogError(httpEx, "HTTP error creating checkout session");
                return new PaymentResponse
                {
                    Success = false,
                    Message = "Network error occurred while creating checkout session"
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error creating checkout session");
                return new PaymentResponse
                {
                    Success = false,
                    Message = "An unexpected error occurred while creating checkout session"
                };
            }
        }

        /// <summary>
        /// Processes payment success notification
        /// </summary>
        /// <param name="sessionId">Stripe session identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if processing was successful</returns>
        public async Task<bool> ProcessPaymentSuccessAsync(string sessionId, CancellationToken cancellationToken = default)
        {
            using var scope = _logger.BeginScope("Processing payment success for session {SessionId}", sessionId);

            try
            {
                _logger.LogInformation("Processing payment success for session: {SessionId}", sessionId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"payment/success?session_id={sessionId}", cancellationToken);

                var success = response.IsSuccessStatusCode;

                if (success)
                {
                    _logger.LogInformation("Successfully processed payment for session: {SessionId}", sessionId);
                }
                else
                {
                    _logger.LogWarning("Failed to process payment success. Status code: {StatusCode}", response.StatusCode);
                }

                return success;
            }
            catch (HttpRequestException httpEx)
            {
                _logger.LogError(httpEx, "HTTP error processing payment success for session: {SessionId}", sessionId);
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error processing payment success for session: {SessionId}", sessionId);
                return false;
            }
        }

        #endregion

        #region Utility Methods

        /// <summary>
        /// Gets the base URL for the current application
        /// </summary>
        /// <returns>Base URL string</returns>
        public string GetBaseUrl()
        {
            try
            {
                var request = _httpContextAccessor.HttpContext?.Request;
                if (request == null)
                {
                    _logger.LogWarning("HTTP context is not available");
                    return string.Empty;
                }

                return $"{request.Scheme}://{request.Host}{request.PathBase}";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting base URL");
                return string.Empty;
            }
        }

        #endregion
    }
}