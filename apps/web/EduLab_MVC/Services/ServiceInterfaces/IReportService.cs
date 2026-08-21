using EduLab_MVC.Models.DTOs.Report;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for report operations in the MVC application.
    /// </summary>
    public interface IReportService
    {
        /// <summary>
        /// Retrieves the admin reports, optionally filtered by status, type and search term.
        /// </summary>
        Task<ReportListResultDto?> GetAdminReportsAsync(string? status, string? type, string? search, int page, int pageSize, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the number of pending reports.
        /// </summary>
        Task<int> GetPendingCountAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates the status of a report.
        /// </summary>
        Task<string> UpdateStatusAsync(int id, string status, string? note, string? action = null, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes the reported content.
        /// </summary>
        Task<string> DeleteContentAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Creates a new report.
        /// </summary>
        Task<(bool Success, string? Message)> CreateAsync(string type, int targetId, string reason, string? details, CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks whether the current user has already reported the target.
        /// </summary>
        Task<bool> CheckReportedAsync(string type, int targetId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks which targets of a list have already been reported by the current user.
        /// </summary>
        Task<List<int>> CheckReportedManyAsync(string type, List<int> targetIds, CancellationToken cancellationToken = default);
    }
}
