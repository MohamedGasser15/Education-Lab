using EduLab_MVC.Models.DTOs.History;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    public interface IHistoryService
    {
        /// <summary>
        /// Logs an operation to the history API
        /// </summary>
        /// <param name="userId">The ID of the user performing the operation</param>
        /// <param name="operation">Description of the operation</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>Task representing the asynchronous operation</returns>
        Task LogOperationAsync(string userId, string operation, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets all history logs from the API
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of history DTOs</returns>
        Task<List<HistoryDTO>> GetAllHistoryAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets history logs for the current user from the API
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of history DTOs for the current user</returns>
        Task<List<HistoryDTO>> GetMyHistoryAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets history logs for a specific user from the API
        /// </summary>
        /// <param name="userId">The ID of the user</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of history DTOs for the specified user</returns>
        Task<List<HistoryDTO>> GetHistoryByUserAsync(string userId, CancellationToken cancellationToken = default);
    }
}
