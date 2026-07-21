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
    [Route("api/admin/settings")]
    [ApiController]
    [Authorize(Roles = SD.Admin)]
    public class SiteSettingsController : ControllerBase
    {
        private readonly ISiteSettingsService _siteSettingsService;
        private readonly ICurrentUserService _currentUserService;
        private readonly ILogger<SiteSettingsController> _logger;

        public SiteSettingsController(
            ISiteSettingsService siteSettingsService,
            ICurrentUserService currentUserService,
            ILogger<SiteSettingsController> logger)
        {
            _siteSettingsService = siteSettingsService;
            _currentUserService = currentUserService;
            _logger = logger;
        }

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
