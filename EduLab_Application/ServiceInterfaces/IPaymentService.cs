// EduLab_Application/ServiceInterfaces/IPaymentService.cs
using EduLab_Shared.DTOs.Payment;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for payment processing operations
    /// </summary>
    public interface IPaymentService
    {
        /// <summary>
        /// Creates a Stripe payment intent
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="request">Payment request details</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Payment response with intent details</returns>
        Task<PaymentResponse> CreatePaymentIntentAsync(string userId, PaymentRequest request, CancellationToken cancellationToken = default);

        /// <summary>
        /// Confirms a payment intent
        /// </summary>
        /// <param name="paymentIntentId">Payment intent identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Payment confirmation response</returns>
        Task<PaymentResponse> ConfirmPaymentAsync(string paymentIntentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Processes a successful payment
        /// </summary>
        /// <param name="paymentIntentId">Payment intent identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if processing was successful</returns>
        Task<bool> ProcessPaymentSuccessAsync(string paymentIntentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Creates a Stripe checkout session
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="request">Checkout request details</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Checkout session response</returns>
        Task<PaymentResponse> CreateCheckoutSessionAsync(string userId, CheckoutRequest request, CancellationToken cancellationToken = default);
    }
}