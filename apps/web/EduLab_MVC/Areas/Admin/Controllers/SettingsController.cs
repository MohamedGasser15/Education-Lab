using EduLab_MVC.Common;
using EduLab_MVC.Models.DTOs.Settings;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;
using EduLab_MVC.Resources;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = SD.Admin)]
    public class SettingsController : Controller
    {
        private readonly ISiteSettingsService _siteSettingsService;
        private readonly ILogger<SettingsController> _logger;
        private readonly IStringLocalizer<SharedResources> _localizer;

        public SettingsController(
            ISiteSettingsService siteSettingsService, 
            ILogger<SettingsController> logger,
            IStringLocalizer<SharedResources> localizer)
        {
            _siteSettingsService = siteSettingsService;
            _logger = logger;
            _localizer = localizer;
        }

        public async Task<IActionResult> Index()
        {
            var settings = await _siteSettingsService.GetSettingsAsync();
            return View(settings ?? new SiteSettingsDTO());
        }

        [HttpPost]
        public async Task<IActionResult> Save([FromBody] SiteSettingsDTO dto)
        {
            try
            {
                var result = await _siteSettingsService.UpdateSettingsAsync(dto);
                if (result)
                    return Json(new { success = true, message = _localizer["SettingsSavedSuccessfully"].Value });

                return Json(new { success = false, message = _localizer["FailedToSaveSettings"].Value });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error saving settings");
                return Json(new { success = false, message = _localizer["ErrorSavingSettings"].Value });
            }
        }
    }
}
