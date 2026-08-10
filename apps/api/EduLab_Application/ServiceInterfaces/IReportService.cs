using System.Threading;
using System.Threading.Tasks;
using EduLab_Application.DTOs.Report;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IReportService
    {
        Task<AdminReportDto> CreateReportAsync(string userId, CreateReportDto dto, CancellationToken cancellationToken = default);
        Task<ReportListResultDto> GetAdminReportsAsync(string? status, string? type, string? search, int page, int pageSize, CancellationToken cancellationToken = default);
        Task<int> GetPendingCountAsync(CancellationToken cancellationToken = default);
        Task<bool> HasReportedAsync(string userId, string type, int targetId, CancellationToken cancellationToken = default);
        Task<List<int>> GetReportedTargetIdsAsync(string userId, string type, List<int> targetIds, CancellationToken cancellationToken = default);
        Task UpdateStatusAsync(string adminId, int reportId, UpdateReportStatusDto dto, CancellationToken cancellationToken = default);
        Task<AdminReportDto> DeleteReportedContentAsync(string adminId, int reportId, CancellationToken cancellationToken = default);
    }
}
