using EduLab_Shared.DTOs.Payment;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IPaymentService
    {
        Task<PaymentResponse> CreatePaymentIntentAsync(string userId, PaymentRequest request, CancellationToken cancellationToken = default);
        Task<PaymentResponse> ConfirmPaymentAsync(string paymentIntentId, CancellationToken cancellationToken = default);
        Task<bool> ProcessPaymentSuccessAsync(string paymentIntentId, CancellationToken cancellationToken = default);
        Task<PaymentResponse> CreateCheckoutSessionAsync(string userId, CheckoutRequest request, CancellationToken cancellationToken = default);
    }
}