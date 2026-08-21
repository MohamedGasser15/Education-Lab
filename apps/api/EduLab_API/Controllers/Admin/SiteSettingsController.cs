using EduLab_Application.DTOs.Settings;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Common.Constants;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Admin
{
    /// <summary>
    /// Controller for managing site settings (Admin only)
    /// </summary>
    [Route("api/admin/settings")]
    [ApiController]
    [Authorize(Policy = "AdminArea")]
    public class SiteSettingsController : ControllerBase
    {
        private readonly ISiteSettingsService _siteSettingsService;
        private readonly ICurrentUserService _currentUserService;
        private readonly ILogger<SiteSettingsController> _logger;

        /// <summary>
        /// Initializes a new instance of the SiteSettingsController class
        /// </summary>
        /// <param name="siteSettingsService">Site settings service</param>
        /// <param name="currentUserService">Current user service</param>
        /// <param name="logger">Logger instance</param>
        public SiteSettingsController(
            ISiteSettingsService siteSettingsService,
            ICurrentUserService currentUserService,
            ILogger<SiteSettingsController> logger)
        {
            _siteSettingsService = siteSettingsService;
            _currentUserService = currentUserService;
            _logger = logger;
        }

        /// <summary>
        /// Gets the current site settings
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The current site settings</returns>
        /// <response code="200">Returns the site settings</response>
        /// <response code="500">If an error occurs while retrieving the settings</response>
        [AllowAnonymous]
        [HttpGet]
        public async Task<IActionResult> GetSettings(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting site settings");
                var settings = await _siteSettingsService.GetSettingsAsync(cancellationToken);
                return Ok(settings);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting site settings");
                return StatusCode(500, new { message = "An error occurred", error = ex.Message });
            }
        }

        /// <summary>
        /// Updates the site settings
        /// </summary>
        /// <param name="dto">Settings data to apply</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation result</returns>
        /// <response code="200">If the settings were saved successfully</response>
        /// <response code="400">If the settings data is invalid</response>
        /// <response code="500">If an error occurs while updating the settings</response>
        [HttpPut]
        public async Task<IActionResult> UpdateSettings([FromBody] SiteSettingsDTO dto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Updating site settings");

                if (dto == null)
                    return BadRequest(new { message = "Settings data is required" });

                var userId = await _currentUserService.GetUserIdAsync();
                var result = await _siteSettingsService.UpdateSettingsAsync(dto, userId, cancellationToken);

                if (!result)
                    return StatusCode(500, new { message = "Failed to update settings" });

                _logger.LogInformation("Site settings updated successfully");
                return Ok(new { message = "Settings saved successfully" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating site settings");
                return StatusCode(500, new { message = "An error occurred", error = ex.Message });
            }
        }
    }
}
