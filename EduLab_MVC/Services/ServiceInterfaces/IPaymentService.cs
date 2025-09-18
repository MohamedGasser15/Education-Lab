using EduLab_MVC.Models.DTOs.Payment;
using EduLab_MVC.Models.DTOs.Profile;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    public interface IPaymentService
    {
        Task<PaymentResponse> CreatePaymentIntentAsync(PaymentRequest request, CancellationToken cancellationToken = default);
        Task<ProfileDTO> GetUserDataAsync(CancellationToken cancellationToken = default);
        Task<PaymentResponse> ConfirmPaymentAsync(string paymentIntentId, CancellationToken cancellationToken = default);
        Task<PaymentResponse> CreateCheckoutSessionAsync(CheckoutRequest request, CancellationToken cancellationToken = default);
        Task<bool> ProcessPaymentSuccessAsync(string sessionId, CancellationToken cancellationToken = default);
        string GetBaseUrl();
    }
}