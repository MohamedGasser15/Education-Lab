using EduLab_Application.DTOs.Dashboard;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Interface for dashboard analytics operations
    /// </summary>
    public interface IDashboardService
    {
        /// <summary>
        /// Retrieves the admin dashboard aggregated data
        /// </summary>
        Task<AdminDashboardDto> GetAdminDashboardAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the dashboard aggregated data for a specific instructor
        /// </summary>
        Task<InstructorDashboardDto> GetInstructorDashboardAsync(string instructorId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves revenue analytics for a specific instructor within a period (week/month/year/all)
        /// </summary>
        Task<InstructorRevenueDto> GetInstructorRevenueAsync(string instructorId, string period, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves public site statistics (students, courses, instructors, satisfaction)
        /// </summary>
        Task<SiteStatsDto> GetPublicStatsAsync(CancellationToken cancellationToken = default);
    }
}
