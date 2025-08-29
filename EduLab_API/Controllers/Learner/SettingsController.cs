using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Settings;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EduLab_API.Controllers.Learner
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class SettingsController : ControllerBase
    {
        private readonly IUserSettingsService _userSettingsService;

        public SettingsController(IUserSettingsService userSettingsService)
        {
            _userSettingsService = userSettingsService;
        }

        private string GetUserId()
        {
            return User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        }

        [HttpGet("general")]
        public async Task<IActionResult> GetGeneralSettings()
        {
            var userId = GetUserId();
            var generalSettings = await _userSettingsService.GetGeneralSettingsAsync(userId);

            if (generalSettings == null)
                return NotFound();

            return Ok(generalSettings);
        }

        [HttpPut("general")]
        public async Task<IActionResult> UpdateGeneralSettings([FromBody] GeneralSettingsDTO generalSettings)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var userId = GetUserId();
            var result = await _userSettingsService.UpdateGeneralSettingsAsync(userId, generalSettings);

            if (!result)
                return BadRequest("فشل في تحديث الإعدادات");

            return Ok(new { message = "تم تحديث الإعدادات بنجاح" });
        }

        [HttpPost("change-password")]
        public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordDTO changePassword)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var userId = GetUserId();
            var result = await _userSettingsService.ChangePasswordAsync(userId, changePassword);

            if (!result)
                return BadRequest("فشل في تغيير كلمة المرور. يرجى التحقق من كلمة المرور الحالية");

            return Ok(new { message = "تم تغيير كلمة المرور بنجاح" });
        }

        [HttpPost("two-factor/enable")]
        public async Task<IActionResult> EnableTwoFactor([FromBody] TwoFactorDTO twoFactor)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var userId = GetUserId();
            var result = await _userSettingsService.EnableTwoFactorAsync(userId, twoFactor);

            if (!result)
                return BadRequest("فشل في تفعيل المصادقة الثنائية. يرجى التحقق من الرمز");

            return Ok(new { message = "تم تفعيل المصادقة الثنائية بنجاح" });
        }

        [HttpPost("two-factor/disable")]
        public async Task<IActionResult> DisableTwoFactor()
        {
            var userId = GetUserId();
            var result = await _userSettingsService.DisableTwoFactorAsync(userId);

            if (!result)
                return BadRequest("فشل في تعطيل المصادقة الثنائية");

            return Ok(new { message = "تم تعطيل المصادقة الثنائية بنجاح" });
        }

        [HttpPost("two-factor/verify")]
        public async Task<IActionResult> VerifyTwoFactorCode([FromBody] string code)
        {
            var userId = GetUserId();
            var result = await _userSettingsService.VerifyTwoFactorCodeAsync(userId, code);

            if (!result)
                return BadRequest("الرمز غير صحيح");

            return Ok(new { message = "الرمز صحيح" });
        }
        [HttpGet("active-sessions")]
        public async Task<IActionResult> GetActiveSessions()
        {
            var userId = GetUserId();
            var sessions = await _userSettingsService.GetActiveSessionsAsync(userId);

            return Ok(sessions);
        }

        [HttpPost("active-sessions/revoke/{sessionId}")]
        public async Task<IActionResult> RevokeSession(Guid sessionId)
        {
            var userId = GetUserId();
            var result = await _userSettingsService.RevokeSessionAsync(userId, sessionId);

            if (!result)
                return BadRequest("فشل في إنهاء الجلسة");

            return Ok(new { message = "تم إنهاء الجلسة بنجاح" });
        }

        [HttpPost("active-sessions/revoke-all")]
        public async Task<IActionResult> RevokeAllSessions()
        {
            var userId = GetUserId();
            var result = await _userSettingsService.RevokeAllSessionsAsync(userId);

            if (!result)
                return BadRequest("فشل في إنهاء جميع الجلسات");

            return Ok(new { message = "تم إنهاء جميع الجلسات بنجاح" });
        }
        [HttpGet("two-factor/setup")]
        public async Task<IActionResult> GetTwoFactorSetup()
        {
            var userId = GetUserId();
            var setupInfo = await _userSettingsService.GetTwoFactorSetupAsync(userId);

            if (setupInfo == null)
                return NotFound("المستخدم غير موجود");

            return Ok(setupInfo);
        }
        [HttpGet("two-factor/status")]
        public async Task<IActionResult> GetTwoFactorStatus()
        {
            var userId = GetUserId();
            var isEnabled = await _userSettingsService.IsTwoFactorEnabledAsync(userId);
            return Ok(isEnabled);
        }
    }
}
