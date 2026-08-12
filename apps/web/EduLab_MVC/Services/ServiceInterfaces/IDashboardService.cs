using EduLab_MVC.Models.DTOs.Dashboard;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for dashboard-related operations in the MVC application
    /// </summary>
    public interface IDashboardService
    {
        /// <summary>
        /// Retrieves the admin dashboard data from the API
        /// </summary>
        Task<AdminDashboardDto> GetAdminDashboardAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the instructor dashboard data from the API
        /// </summary>
        Task<InstructorDashboardDto> GetInstructorDashboardAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the instructor revenue data from the API for a given period
        /// </summary>
        Task<InstructorRevenueDto> GetInstructorRevenueAsync(string period, CancellationToken cancellationToken = default);
    }
}
