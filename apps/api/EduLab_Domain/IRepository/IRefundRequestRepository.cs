// EduLab_Domain/IRepository/IRefundRequestRepository.cs
using EduLab_Domain.Entities;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.IRepository
{
    /// <summary>
    /// Repository interface for refund request data operations
    /// </summary>
    public interface IRefundRequestRepository
    {
        /// <summary>
        /// Creates a new refund request
        /// </summary>
        /// <param name="request">Refund request entity</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Created refund request entity</returns>
        Task<RefundRequest> CreateAsync(RefundRequest request, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a refund request by its identifier
        /// </summary>
        /// <param name="id">Refund request identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Refund request entity or null</returns>
        Task<RefundRequest> GetByIdAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves all refund requests with related data
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Collection of refund requests</returns>
        Task<IEnumerable<RefundRequest>> GetAllAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the latest pending refund request for a payment
        /// </summary>
        /// <param name="paymentId">Payment identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Refund request entity or null</returns>
        Task<RefundRequest> GetByPaymentIdAsync(int paymentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing refund request
        /// </summary>
        /// <param name="request">Refund request entity with updated values</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if successful, false otherwise</returns>
        Task<bool> UpdateAsync(RefundRequest request, CancellationToken cancellationToken = default);
    }
}
