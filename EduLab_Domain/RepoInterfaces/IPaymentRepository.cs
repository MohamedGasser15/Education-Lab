using EduLab_Domain.Entities;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    public interface IPaymentRepository
    {
        Task<Payment> CreatePaymentAsync(Payment payment, CancellationToken cancellationToken = default);
        Task<Payment> GetPaymentByIdAsync(int paymentId, CancellationToken cancellationToken = default);
        Task<bool> UpdatePaymentStatusAsync(int paymentId, string status, CancellationToken cancellationToken = default);
        Task<IEnumerable<Payment>> GetUserPaymentsAsync(string userId, CancellationToken cancellationToken = default);
    }
}