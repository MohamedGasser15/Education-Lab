using EduLab_Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    /// <summary>
    /// Repository interface for managing History entity operations
    /// </summary>
    public interface IHistoryRepository : IRepository<History>
    {
        #region History Operations

        /// <summary>
        /// Adds a new history log entry asynchronously
        /// </summary>
        /// <param name="history">The history entity to add</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>Task representing the asynchronous operation</returns>
        Task AddAsync(History history, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves all history logs asynchronously
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of all history logs ordered by date and time descending</returns>
        Task<List<History>> GetAllAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves history logs for a specific user asynchronously
        /// </summary>
        /// <param name="userId">The user identifier</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of history logs for the specified user ordered by date and time descending</returns>
        Task<List<History>> GetByUserIdAsync(string userId, CancellationToken cancellationToken = default);

        #endregion
    }
}