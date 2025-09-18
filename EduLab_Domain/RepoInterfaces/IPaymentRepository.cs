// EduLab_Domain/RepoInterfaces/IPaymentRepository.cs
using EduLab_Domain.Entities;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    /// <summary>
    /// Repository interface for payment data operations
    /// </summary>
    public interface IPaymentRepository
    {
        /// <summary>
        /// Creates a new payment record
        /// </summary>
        /// <param name="payment">Payment entity to create</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Created payment entity</returns>
        Task<Payment> CreatePaymentAsync(Payment payment, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a payment by its identifier
        /// </summary>
        /// <param name="paymentId">Payment identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Payment entity or null</returns>
        Task<Payment> GetPaymentByIdAsync(int paymentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates the status of a payment
        /// </summary>
        /// <param name="paymentId">Payment identifier</param>
        /// <param name="status">New status value</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if successful, false otherwise</returns>
        Task<bool> UpdatePaymentStatusAsync(int paymentId, string status, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves all payments for a specific user
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Collection of user payments</returns>
        Task<IEnumerable<Payment>> GetUserPaymentsAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Creates multiple payments in a single transaction
        /// </summary>
        /// <param name="payments">Collection of payments to create</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Number of created payments</returns>
        Task<int> CreateBulkPaymentsAsync(IEnumerable<Payment> payments, CancellationToken cancellationToken = default);
    }
}