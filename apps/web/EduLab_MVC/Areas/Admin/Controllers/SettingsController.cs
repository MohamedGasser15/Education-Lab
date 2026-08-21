using EduLab_MVC.Common;
using EduLab_MVC.Models.DTOs.Settings;
using EduLab_MVC.Resources;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Localization;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Policy = "AdminArea")]
    /// <summary>
    /// Manages global site settings from the admin panel.
    /// </summary>
    public class SettingsController : Controller
    {
        private readonly ISiteSettingsService _siteSettingsService;
        private readonly IWebHostEnvironment _env;
        private readonly ILogger<SettingsController> _logger;
        private readonly IStringLocalizer<SharedResources> _localizer;

        public SettingsController(ISiteSettingsService siteSettingsService, IWebHostEnvironment env, ILogger<SettingsController> logger, IStringLocalizer<SharedResources> localizer)
        {
            _siteSettingsService = siteSettingsService;
            _env = env;
            _logger = logger;
            _localizer = localizer;
        }

        public async Task<IActionResult> Index()
        {
            if (!User.HasClaim(c => c.Type == "ViewSiteSettings"))
                return Forbid();

            var settings = await _siteSettingsService.GetSettingsAsync();
            return View(settings ?? new SiteSettingsDTO());
        }

        [HttpPost]
        public async Task<IActionResult> Save([FromBody] SiteSettingsDTO dto)
        {
            if (!User.HasClaim(c => c.Type == "EditSiteSettings"))
                return Json(new { success = false, message = _localizer["NoPermissionEditSettings"].Value });

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

        [HttpPost]
        public async Task<IActionResult> UploadImage(IFormFile file)
        {
            try
            {
                if (file == null || file.Length == 0)
                    return Json(new { success = false, message = _localizer["NoFileProvided"].Value });

                var uploadsDir = Path.Combine(_env.WebRootPath, "uploads", "settings");
                Directory.CreateDirectory(uploadsDir);

                var ext = Path.GetExtension(file.FileName);
                var fileName = $"{Guid.NewGuid()}{ext}";
                var filePath = Path.Combine(uploadsDir, fileName);

                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await file.CopyToAsync(stream);
                }

                var url = $"/uploads/settings/{fileName}";
                _logger.LogInformation("Uploaded settings image: {Url}", url);

                return Json(new { success = true, url });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error uploading settings image");
                return Json(new { success = false, message = _localizer["ErrorUploadingImage"].Value });
            }
        }
    }
}
