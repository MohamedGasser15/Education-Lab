using System.Threading;
using System.Threading.Tasks;
using EduLab_Application.DTOs.Report;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for managing content reports
    /// </summary>
    public interface IReportService
    {
        /// <summary>
        /// Creates a new report for a content target
        /// </summary>
        /// <param name="userId">Unique identifier of the reporting user</param>
        /// <param name="dto">Report creation data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The created report DTO</returns>
        Task<AdminReportDto> CreateReportAsync(string userId, CreateReportDto dto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves reports for the admin panel with filtering and pagination
        /// </summary>
        /// <param name="status">Optional status filter</param>
        /// <param name="type">Optional report type filter</param>
        /// <param name="search">Optional search term</param>
        /// <param name="page">Page number</param>
        /// <param name="pageSize">Page size</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Paginated list of reports</returns>
        Task<ReportListResultDto> GetAdminReportsAsync(string? status, string? type, string? search, int page, int pageSize, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets the number of pending reports
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The pending reports count</returns>
        Task<int> GetPendingCountAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks whether a user has already reported a specific target
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="type">Type of the reported target</param>
        /// <param name="targetId">Unique identifier of the target</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the user has reported the target, otherwise false</returns>
        Task<bool> HasReportedAsync(string userId, string type, int targetId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Returns the IDs of targets already reported by a user from a given list
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="type">Type of the reported targets</param>
        /// <param name="targetIds">List of target identifiers to check</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of reported target IDs</returns>
        Task<List<int>> GetReportedTargetIdsAsync(string userId, string type, List<int> targetIds, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates the status of a report
        /// </summary>
        /// <param name="adminId">Unique identifier of the reviewing admin</param>
        /// <param name="reportId">Unique identifier of the report</param>
        /// <param name="dto">Status update data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        Task UpdateStatusAsync(string adminId, int reportId, UpdateReportStatusDto dto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes the content targeted by a report
        /// </summary>
        /// <param name="adminId">Unique identifier of the reviewing admin</param>
        /// <param name="reportId">Unique identifier of the report</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The report DTO after the action</returns>
        Task<AdminReportDto> DeleteReportedContentAsync(string adminId, int reportId, CancellationToken cancellationToken = default);
    }
}