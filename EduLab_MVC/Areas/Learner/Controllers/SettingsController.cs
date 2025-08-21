using EduLab_MVC.Models.DTOs.Settings;
using EduLab_MVC.Services;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    [Area("Learner")]
    public class SettingsController : Controller
    {
        private readonly UserSettingsService _userSettingsService;

        public SettingsController(UserSettingsService userSettingsService)
        {
            _userSettingsService = userSettingsService;
        }

        [HttpGet]
        public async Task<IActionResult> Index()
        {
            var settings = await _userSettingsService.GetGeneralSettingsAsync();
            ViewBag.ActiveSessions = await _userSettingsService.GetActiveSessionsAsync() ?? new List<ActiveSessionDTO>();
            ViewBag.IsTwoFactorEnabled = await _userSettingsService.IsTwoFactorEnabledAsync();
            return View(settings ?? new GeneralSettingsDTO());
        }

        [HttpPost]
        public async Task<IActionResult> UpdateGeneral(GeneralSettingsDTO model)
        {
            if (ModelState.IsValid)
            {
                var result = await _userSettingsService.UpdateGeneralSettingsAsync(model);
                if (result)
                {
                    TempData["SuccessMessage"] = "تم تحديث الإعدادات بنجاح";
                }
                else
                {
                    TempData["ErrorMessage"] = "فشل في تحديث الإعدادات";
                }
            }
            return RedirectToAction("Index");
        }

        [HttpPost]
        public async Task<IActionResult> ChangePassword(ChangePasswordDTO model)
        {
            if (ModelState.IsValid)
            {
                var result = await _userSettingsService.ChangePasswordAsync(model);
                if (result)
                {
                    TempData["SuccessMessage"] = "تم تغيير كلمة المرور بنجاح";
                }
                else
                {
                    TempData["ErrorMessage"] = "فشل في تغيير كلمة المرور";
                }
            }
            return RedirectToAction("Index");
        }

        [HttpPost]
        public async Task<IActionResult> RevokeSession(Guid sessionId)
        {
            var result = await _userSettingsService.RevokeSessionAsync(sessionId);
            if (result)
            {
                TempData["SuccessMessage"] = "تم إنهاء الجلسة بنجاح";
            }
            else
            {
                TempData["ErrorMessage"] = "فشل في إنهاء الجلسة";
            }
            return RedirectToAction("Index");
        }

        [HttpPost]
        public async Task<IActionResult> RevokeAllSessions()
        {
            var result = await _userSettingsService.RevokeAllSessionsAsync();
            if (result)
            {
                TempData["SuccessMessage"] = "تم إنهاء جميع الجلسات بنجاح";
            }
            else
            {
                TempData["ErrorMessage"] = "فشل في إنهاء الجلسات";
            }
            return RedirectToAction("Index");
        }

        [HttpPost]
        public async Task<IActionResult> EnableTwoFactor(TwoFactorDTO model)
        {
            if (ModelState.IsValid)
            {
                var result = await _userSettingsService.EnableTwoFactorAsync(model);
                if (result)
                {
                    TempData["SuccessMessage"] = "تم تفعيل المصادقة الثنائية بنجاح";
                }
                else
                {
                    TempData["ErrorMessage"] = "فشل في تفعيل المصادقة الثنائية";
                }
            }
            return RedirectToAction("Index");
        }
        [HttpGet]
        public async Task<IActionResult> GetTwoFactorSetup()
        {
            var setup = await _userSettingsService.GetTwoFactorSetupAsync();
            if (setup != null)
            {
                return Json(new
                {
                    qrCodeUrl = "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=" + Uri.EscapeDataString(setup.QrCodeUrl),
                    secret = setup.Secret,
                    recoveryCodes = setup.RecoveryCodes
                });
            }
            return StatusCode(500, "Failed to generate 2FA setup");
        }

        [HttpPost]
        public async Task<IActionResult> DisableTwoFactor()
        {
            var result = await _userSettingsService.DisableTwoFactorAsync();
            if (result)
            {
                TempData["SuccessMessage"] = "تم تعطيل المصادقة الثنائية بنجاح";
            }
            else
            {
                TempData["ErrorMessage"] = "فشل في تعطيل المصادقة الثنائية";
            }
            return RedirectToAction("Index");
        }
        [HttpGet]
        public async Task<IActionResult> GetTwoFactorStatus()
        {
            var isEnabled = await _userSettingsService.IsTwoFactorEnabledAsync();
            return Json(new { isEnabled });
        }
    }
}