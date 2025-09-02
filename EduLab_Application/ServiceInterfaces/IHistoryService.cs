using EduLab_Shared.DTOs.History;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for history-related operations
    /// </summary>
    public interface IHistoryService
    {
        #region History Operations

        /// <summary>
        /// Logs a user operation to the history
        /// </summary>
        /// <param name="userId">The ID of the user performing the operation</param>
        /// <param name="operation">Description of the operation performed</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>Task representing the asynchronous operation</returns>
        Task LogOperationAsync(string userId, string operation, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves all history logs from the system
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of all history DTOs</returns>
        Task<List<HistoryDTO>> GetAllHistoryAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves history logs for the current user
        /// </summary>
        /// <param name="currentUserId">The ID of the current user</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of history DTOs for the current user</returns>
        Task<List<HistoryDTO>> GetMyHistoryAsync(string currentUserId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves history logs for a specific user
        /// </summary>
        /// <param name="userId">The ID of the user</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of history DTOs for the specified user</returns>
        Task<List<HistoryDTO>> GetHistoryByUserAsync(string userId, CancellationToken cancellationToken = default);

        #endregion
    }
}