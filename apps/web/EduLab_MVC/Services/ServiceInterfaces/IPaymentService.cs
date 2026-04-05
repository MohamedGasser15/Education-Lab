// EduLab_MVC/Services/ServiceInterfaces/IPaymentService.cs
using EduLab_MVC.Models.DTOs.Payment;
using EduLab_MVC.Models.DTOs.Profile;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Service interface for MVC payment operations
    /// </summary>
    public interface IPaymentService
    {
        /// <summary>
        /// Creates a payment intent via API
        /// </summary>
        /// <param name="request">Payment request details</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Payment response</returns>
        Task<PaymentResponse> CreatePaymentIntentAsync(PaymentRequest request, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves user data for payment processing
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>User profile data</returns>
        Task<ProfileDTO> GetUserDataAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Confirms a payment via API
        /// </summary>
        /// <param name="paymentIntentId">Payment intent identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Payment confirmation response</returns>
        Task<PaymentResponse> ConfirmPaymentAsync(string paymentIntentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Creates a checkout session via API
        /// </summary>
        /// <param name="request">Checkout request details</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Checkout session response</returns>
        Task<PaymentResponse> CreateCheckoutSessionAsync(CheckoutRequest request, CancellationToken cancellationToken = default);

        /// <summary>
        /// Processes payment success notification
        /// </summary>
        /// <param name="sessionId">Stripe session identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if processing was successful</returns>
        Task<bool> ProcessPaymentSuccessAsync(string sessionId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets the base URL for the current application
        /// </summary>
        /// <returns>Base URL string</returns>
        string GetBaseUrl();
    }
}