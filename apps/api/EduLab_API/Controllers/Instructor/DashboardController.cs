using EduLab_Application.Common.Constants;
using EduLab_Application.DTOs.Dashboard;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Instructor
{
    /// <summary>
    /// API controller for instructor dashboard analytics
    /// </summary>
    [Route("api/instructor/dashboard")]
    [ApiController]
    [Authorize(Roles = SD.Instructor)]
    public class DashboardController : ControllerBase
    {
        private readonly IDashboardService _dashboardService;
        private readonly ICurrentUserService _currentUserService;
        private readonly ILogger<DashboardController> _logger;

        public DashboardController(
            IDashboardService dashboardService,
            ICurrentUserService currentUserService,
            ILogger<DashboardController> logger)
        {
            _dashboardService = dashboardService ?? throw new ArgumentNullException(nameof(dashboardService));
            _currentUserService = currentUserService ?? throw new ArgumentNullException(nameof(currentUserService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        /// <summary>
        /// Gets aggregated data for the instructor dashboard
        /// </summary>
        [HttpGet]
        [ProducesResponseType(typeof(InstructorDashboardDto), 200)]
        [ProducesResponseType(401)]
        [ProducesResponseType(500)]
        public async Task<ActionResult<InstructorDashboardDto>> GetInstructorDashboard(CancellationToken cancellationToken = default)
        {
            try
            {
                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                {
                    _logger.LogWarning("Unauthorized access attempt to instructor dashboard");
                    return Unauthorized(new { message = "Instructor not identified" });
                }

                _logger.LogInformation("Retrieving instructor dashboard data for {InstructorId}", instructorId);

                var dashboard = await _dashboardService.GetInstructorDashboardAsync(instructorId, cancellationToken);

                return Ok(dashboard);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Instructor dashboard operation was cancelled");
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new { message = "Operation was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving instructor dashboard data");
                return StatusCode(500, new
                {
                    message = "An error occurred while retrieving dashboard data",
                    error = ex.Message
                });
            }
        }

        /// <summary>
        /// Gets revenue analytics for the instructor within a period (week/month/year/all)
        /// </summary>
        [HttpGet("revenue")]
        [ProducesResponseType(typeof(InstructorRevenueDto), 200)]
        [ProducesResponseType(401)]
        [ProducesResponseType(500)]
        public async Task<ActionResult<InstructorRevenueDto>> GetInstructorRevenue(
            [FromQuery] string period,
            CancellationToken cancellationToken = default)
        {
            try
            {
                var instructorId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(instructorId))
                {
                    _logger.LogWarning("Unauthorized access attempt to instructor revenue");
                    return Unauthorized(new { message = "Instructor not identified" });
                }

                _logger.LogInformation("Retrieving instructor revenue data for {InstructorId}, period {Period}", instructorId, period);

                var revenue = await _dashboardService.GetInstructorRevenueAsync(instructorId, period, cancellationToken);

                return Ok(revenue);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Instructor revenue operation was cancelled");
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new { message = "Operation was cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving instructor revenue data");
                return StatusCode(500, new
                {
                    message = "An error occurred while retrieving revenue data",
                    error = ex.Message
                });
            }
        }
    }
}
