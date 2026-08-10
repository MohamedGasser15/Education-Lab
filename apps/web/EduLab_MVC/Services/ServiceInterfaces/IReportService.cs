using EduLab_MVC.Models.DTOs.Report;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    public interface IReportService
    {
        Task<ReportListResultDto?> GetAdminReportsAsync(string? status, string? type, string? search, int page, int pageSize, CancellationToken cancellationToken = default);
        Task<int> GetPendingCountAsync(CancellationToken cancellationToken = default);
        Task<string> UpdateStatusAsync(int id, string status, string? note, string? action = null, CancellationToken cancellationToken = default);
        Task<string> DeleteContentAsync(int id, CancellationToken cancellationToken = default);
        Task<(bool Success, string? Message)> CreateAsync(string type, int targetId, string reason, string? details, CancellationToken cancellationToken = default);
        Task<bool> CheckReportedAsync(string type, int targetId, CancellationToken cancellationToken = default);
        Task<List<int>> CheckReportedManyAsync(string type, List<int> targetIds, CancellationToken cancellationToken = default);
    }
}
