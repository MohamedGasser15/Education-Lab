using EduLab_MVC.Models.DTOs.Payment;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for admin refund request management
    /// </summary>
    public interface IRefundRequestService
    {
        /// <summary>
        /// Gets all refund requests for admin review
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of refund requests or null if failed</returns>
        Task<List<AdminRefundRequestDto>?> GetRefundRequestsAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Approves a refund request
        /// </summary>
        /// <param name="id">Refund request identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Result message</returns>
        Task<string> ApproveRefundAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Rejects a refund request
        /// </summary>
        /// <param name="id">Refund request identifier</param>
        /// <param name="reason">Rejection reason</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Result message</returns>
        Task<string> RejectRefundAsync(int id, string? reason = null, CancellationToken cancellationToken = default);
    }
}
