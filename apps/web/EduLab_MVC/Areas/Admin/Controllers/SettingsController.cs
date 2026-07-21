using EduLab_MVC.Common;
using EduLab_MVC.Models.DTOs.Settings;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = SD.Admin)]
    public class SettingsController : Controller
    {
        private readonly ISiteSettingsService _siteSettingsService;
        private readonly IWebHostEnvironment _env;
        private readonly ILogger<SettingsController> _logger;

        public SettingsController(ISiteSettingsService siteSettingsService, IWebHostEnvironment env, ILogger<SettingsController> logger)
        {
            _siteSettingsService = siteSettingsService;
            _env = env;
            _logger = logger;
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
                    return Json(new { success = true, message = "Settings saved successfully" });

                return Json(new { success = false, message = "Failed to save settings" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error saving settings");
                return Json(new { success = false, message = ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> UploadImage(IFormFile file)
        {
            try
            {
                if (file == null || file.Length == 0)
                    return Json(new { success = false, message = "No file provided" });

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
                return Json(new { success = false, message = ex.Message });
            }
        }
    }
}
