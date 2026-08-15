using EduLab_Application.DTOs.Dashboard;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Learner
{
    /// <summary>
    /// Public site statistics (marketing pages)
    /// </summary>
    [Route("api/public")]
    [ApiController]
    [AllowAnonymous]
    public class PublicController : ControllerBase
    {
        private readonly IDashboardService _dashboardService;
        private readonly ILogger<PublicController> _logger;

        public PublicController(IDashboardService dashboardService, ILogger<PublicController> logger)
        {
            _dashboardService = dashboardService ?? throw new ArgumentNullException(nameof(dashboardService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        /// <summary>
        /// Gets public site statistics: students, courses, instructors, satisfaction
        /// </summary>
        [HttpGet("stats")]
        [ProducesResponseType(typeof(SiteStatsDto), 200)]
        [ProducesResponseType(500)]
        public async Task<ActionResult<SiteStatsDto>> GetStats(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving public site stats");

                var stats = await _dashboardService.GetPublicStatsAsync(cancellationToken);

                return Ok(stats);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving public site stats");
                return StatusCode(500, new { message = "An error occurred while retrieving site statistics" });
            }
        }
    }
}
