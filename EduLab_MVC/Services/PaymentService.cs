// EduLab_MVC/Services/PaymentService.cs
using EduLab_MVC.Models.DTOs.Payment;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services
{
    public class PaymentService : IPaymentService
    {
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly ILogger<PaymentService> _logger;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public PaymentService(
            IAuthorizedHttpClientService httpClientService,
            ILogger<PaymentService> logger,
            IHttpContextAccessor httpContextAccessor)
        {
            _httpClientService = httpClientService ?? throw new ArgumentNullException(nameof(httpClientService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
        }

        public async Task<PaymentResponse> CreatePaymentIntentAsync(PaymentRequest request, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Creating payment intent for amount: {Amount}", request.Amount);

                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(request);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync("payment/create-payment-intent", content, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync();
                    var paymentResponse = JsonConvert.DeserializeObject<PaymentResponse>(responseContent);

                    _logger.LogInformation("Successfully created payment intent: {PaymentIntentId}",
                        paymentResponse?.PaymentIntentId);
                    return paymentResponse;
                }

                var errorContent = await response.Content.ReadAsStringAsync();
                _logger.LogWarning("Failed to create payment intent. Status: {StatusCode}, Response: {Error}",
                    response.StatusCode, errorContent);

                return new PaymentResponse
                {
                    Success = false,
                    Message = $"Failed to create payment intent: {response.StatusCode}"
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating payment intent");
                return new PaymentResponse
                {
                    Success = false,
                    Message = "An error occurred while creating payment intent"
                };
            }
        }

        public async Task<PaymentResponse> ConfirmPaymentAsync(string paymentIntentId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Confirming payment intent: {PaymentIntentId}", paymentIntentId);

                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(paymentIntentId);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync("payment/confirm-payment", content, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync();
                    var paymentResponse = JsonConvert.DeserializeObject<PaymentResponse>(responseContent);

                    _logger.LogInformation("Successfully confirmed payment: {PaymentIntentId}", paymentIntentId);
                    return paymentResponse;
                }

                _logger.LogWarning("Failed to confirm payment. Status code: {StatusCode}", response.StatusCode);
                return new PaymentResponse { Success = false, Message = "Failed to confirm payment" };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error confirming payment: {PaymentIntentId}", paymentIntentId);
                return new PaymentResponse { Success = false, Message = "An error occurred while confirming payment" };
            }
        }

        public async Task<PaymentResponse> CreateCheckoutSessionAsync(CheckoutRequest request, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Creating checkout session");

                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(request);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync("payment/create-checkout-session", content, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync();
                    var paymentResponse = JsonConvert.DeserializeObject<PaymentResponse>(responseContent);

                    _logger.LogInformation("Successfully created checkout session: {PaymentIntentId}", paymentResponse.PaymentIntentId);
                    return paymentResponse;
                }

                _logger.LogWarning("Failed to create checkout session. Status code: {StatusCode}", response.StatusCode);
                return new PaymentResponse { Success = false, Message = "Failed to create checkout session" };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating checkout session");
                return new PaymentResponse { Success = false, Message = "An error occurred while creating checkout session" };
            }
        }

        public async Task<bool> ProcessPaymentSuccessAsync(string sessionId, CancellationToken cancellationToken = default)
        {
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
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing payment success for session: {SessionId}", sessionId);
                return false;
            }
        }

        public string GetBaseUrl()
        {
            var request = _httpContextAccessor.HttpContext.Request;
            return $"{request.Scheme}://{request.Host}{request.PathBase}";
        }
    }
}