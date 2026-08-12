using EduLab_Application.DTOs.Dashboard;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Admin
{
    /// <summary>
    /// API controller for admin dashboard analytics
    /// </summary>
    [Route("api/admin/dashboard")]
    [ApiController]
    [Authorize(Policy = "AdminArea")]
    public class DashboardController : ControllerBase
    {
        private readonly IDashboardService _dashboardService;
        private readonly ILogger<DashboardController> _logger;

        public DashboardController(IDashboardService dashboardService, ILogger<DashboardController> logger)
        {
            _dashboardService = dashboardService ?? throw new ArgumentNullException(nameof(dashboardService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        /// <summary>
        /// Gets aggregated data for the admin dashboard
        /// </summary>
        [HttpGet]
        [ProducesResponseType(typeof(AdminDashboardDto), 200)]
        [ProducesResponseType(500)]
        public async Task<ActionResult<AdminDashboardDto>> GetAdminDashboard(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving admin dashboard data");

                var dashboard = await _dashboardService.GetAdminDashboardAsync(cancellationToken);

                _logger.LogInformation("Successfully retrieved admin dashboard data");
                return Ok(dashboard);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Admin dashboard operation was cancelled");
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new { message = "Operation was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving admin dashboard data");
                return StatusCode(500, new
                {
                    message = "An error occurred while retrieving dashboard data",
                    error = ex.Message
                });
            }
        }
    }
}
