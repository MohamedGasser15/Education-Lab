using EduLab_MVC.Models.DTOs.Settings;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    #region SettingsController Class
    /// <summary>
    /// MVC Controller for managing user settings in the Learner area
    /// </summary>
    [Area("Learner")]
    [Authorize]
    public class SettingsController : Controller
    {
        #region Fields
        private readonly IUserSettingsService _userSettingsService;
        private readonly ILogger<SettingsController> _logger;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the SettingsController class
        /// </summary>
        /// <param name="userSettingsService">User settings service</param>
        /// <param name="logger">Logger instance</param>
        public SettingsController(IUserSettingsService userSettingsService, ILogger<SettingsController> logger)
        {
            _userSettingsService = userSettingsService ?? throw new ArgumentNullException(nameof(userSettingsService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }
        #endregion

        #region General Settings Actions
        /// <summary>
        /// Displays the settings index page with user settings
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Settings view</returns>
        [HttpGet]
        public async Task<IActionResult> Index(CancellationToken cancellationToken = default)
        {
            const string operationName = "SettingsIndex";

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var settings = await _userSettingsService.GetGeneralSettingsAsync(cancellationToken);
                var activeSessions = await _userSettingsService.GetActiveSessionsAsync(cancellationToken);
                var isTwoFactorEnabled = await _userSettingsService.IsTwoFactorEnabledAsync(cancellationToken);

                ViewBag.ActiveSessions = activeSessions ?? new List<ActiveSessionDTO>();
                ViewBag.IsTwoFactorEnabled = isTwoFactorEnabled;

                _logger.LogInformation("Successfully loaded settings page in {OperationName}", operationName);

                return View(settings ?? new GeneralSettingsDTO());
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                TempData["ErrorMessage"] = "حدث خطأ أثناء تحميل الإعدادات";
                return View(new GeneralSettingsDTO());
            }
        }

        /// <summary>
        /// Updates general settings for the current user
        /// </summary>
        /// <param name="model">General settings model</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Redirect to index page</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UpdateGeneral(GeneralSettingsDTO model, CancellationToken cancellationToken = default)
        {
            const string operationName = "UpdateGeneral";

            if (!ModelState.IsValid)
            {
                _logger.LogWarning("Invalid model state in {OperationName}", operationName);
                TempData["ErrorMessage"] = "بيانات غير صحيحة";
                return RedirectToAction("Index");
            }

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var result = await _userSettingsService.UpdateGeneralSettingsAsync(model, cancellationToken);

                if (result)
                {
                    TempData["SuccessMessage"] = "تم تحديث الإعدادات بنجاح";
                    _logger.LogInformation("General settings updated successfully in {OperationName}", operationName);
                }
                else
                {
                    TempData["ErrorMessage"] = "فشل في تحديث الإعدادات";
                    _logger.LogWarning("Failed to update general settings in {OperationName}", operationName);
                }
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                TempData["WarningMessage"] = "تم إلغاء العملية";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                TempData["ErrorMessage"] = "حدث خطأ أثناء تحديث الإعدادات";
            }

            return RedirectToAction("Index");
        }
        #endregion

        #region Password Actions
        /// <summary>
        /// Changes the password for the current user
        /// </summary>
        /// <param name="model">Change password model</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Redirect to index page</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ChangePassword(ChangePasswordDTO model, CancellationToken cancellationToken = default)
        {
            const string operationName = "ChangePassword";

            if (!ModelState.IsValid)
            {
                _logger.LogWarning("Invalid model state in {OperationName}", operationName);
                TempData["ErrorMessage"] = "بيانات كلمة المرور غير صحيحة";
                return RedirectToAction("Index");
            }

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var result = await _userSettingsService.ChangePasswordAsync(model, cancellationToken);

                if (result)
                {
                    TempData["SuccessMessage"] = "تم تغيير كلمة المرور بنجاح";
                    _logger.LogInformation("Password changed successfully in {OperationName}", operationName);
                }
                else
                {
                    TempData["ErrorMessage"] = "فشل في تغيير كلمة المرور";
                    _logger.LogWarning("Failed to change password in {OperationName}", operationName);
                }
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                TempData["WarningMessage"] = "تم إلغاء العملية";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                TempData["ErrorMessage"] = "حدث خطأ أثناء تغيير كلمة المرور";
            }

            return RedirectToAction("Index");
        }
        #endregion

        #region Session Management Actions
        /// <summary>
        /// Revokes a specific session
        /// </summary>
        /// <param name="sessionId">Session ID to revoke</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Redirect to index page</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> RevokeSession(Guid sessionId, CancellationToken cancellationToken = default)
        {
            const string operationName = "RevokeSession";

            try
            {
                _logger.LogDebug("Starting {OperationName} for session ID: {SessionId}", operationName, sessionId);

                var result = await _userSettingsService.RevokeSessionAsync(sessionId, cancellationToken);

                if (result)
                {
                    TempData["SuccessMessage"] = "تم إنهاء الجلسة بنجاح";
                    _logger.LogInformation("Session revoked successfully in {OperationName} for session ID: {SessionId}",
                        operationName, sessionId);
                }
                else
                {
                    TempData["ErrorMessage"] = "فشل في إنهاء الجلسة";
                    _logger.LogWarning("Failed to revoke session in {OperationName} for session ID: {SessionId}",
                        operationName, sessionId);
                }
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for session ID: {SessionId}",
                    operationName, sessionId);
                TempData["WarningMessage"] = "تم إلغاء العملية";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for session ID: {SessionId}",
                    operationName, sessionId);
                TempData["ErrorMessage"] = "حدث خطأ أثناء إنهاء الجلسة";
            }

            return RedirectToAction("Index");
        }

        /// <summary>
        /// Revokes all sessions except the current one
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Redirect to index page</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> RevokeAllSessions(CancellationToken cancellationToken = default)
        {
            const string operationName = "RevokeAllSessions";

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var result = await _userSettingsService.RevokeAllSessionsAsync(cancellationToken);

                if (result)
                {
                    TempData["SuccessMessage"] = "تم إنهاء جميع الجلسات بنجاح";
                    _logger.LogInformation("All sessions revoked successfully in {OperationName}", operationName);
                }
                else
                {
                    TempData["ErrorMessage"] = "فشل في إنهاء الجلسات";
                    _logger.LogWarning("Failed to revoke all sessions in {OperationName}", operationName);
                }
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                TempData["WarningMessage"] = "تم إلغاء العملية";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                TempData["ErrorMessage"] = "حدث خطأ أثناء إنهاء الجلسات";
            }

            return RedirectToAction("Index");
        }
        #endregion

        #region Two-Factor Authentication Actions
        /// <summary>
        /// Enables two-factor authentication for the current user
        /// </summary>
        /// <param name="model">Two-factor authentication model</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Redirect to index page</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> EnableTwoFactor(TwoFactorDTO model, CancellationToken cancellationToken = default)
        {
            const string operationName = "EnableTwoFactor";

            if (!ModelState.IsValid)
            {
                _logger.LogWarning("Invalid model state in {OperationName}", operationName);
                TempData["ErrorMessage"] = "بيانات المصادقة الثنائية غير صحيحة";
                return RedirectToAction("Index");
            }

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var result = await _userSettingsService.EnableTwoFactorAsync(model, cancellationToken);

                if (result)
                {
                    TempData["SuccessMessage"] = "تم تفعيل المصادقة الثنائية بنجاح";
                    _logger.LogInformation("Two-factor authentication enabled successfully in {OperationName}", operationName);
                }
                else
                {
                    TempData["ErrorMessage"] = "فشل في تفعيل المصادقة الثنائية";
                    _logger.LogWarning("Failed to enable two-factor authentication in {OperationName}", operationName);
                }
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                TempData["WarningMessage"] = "تم إلغاء العملية";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                TempData["ErrorMessage"] = "حدث خطأ أثناء تفعيل المصادقة الثنائية";
            }

            return RedirectToAction("Index");
        }

        /// <summary>
        /// Retrieves two-factor authentication setup information
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>JSON response with setup information</returns>
        [HttpGet]
        public async Task<IActionResult> GetTwoFactorSetup(CancellationToken cancellationToken = default)
        {
            const string operationName = "GetTwoFactorSetup";

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var setup = await _userSettingsService.GetTwoFactorSetupAsync(cancellationToken);

                if (setup != null)
                {
                    _logger.LogInformation("Successfully retrieved two-factor setup in {OperationName}", operationName);

                    return Json(new
                    {
                        qrCodeUrl = "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=" +
                                   Uri.EscapeDataString(setup.QrCodeUrl),
                        secret = setup.Secret,
                        recoveryCodes = setup.RecoveryCodes
                    });
                }

                _logger.LogWarning("Failed to generate two-factor setup in {OperationName}", operationName);
                return StatusCode(500, new { message = "Failed to generate 2FA setup" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(499, new { message = "Operation cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return StatusCode(500, new { message = "An error occurred while generating 2FA setup" });
            }
        }

        /// <summary>
        /// Disables two-factor authentication for the current user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Redirect to index page</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DisableTwoFactor(CancellationToken cancellationToken = default)
        {
            const string operationName = "DisableTwoFactor";

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var result = await _userSettingsService.DisableTwoFactorAsync(cancellationToken);

                if (result)
                {
                    TempData["SuccessMessage"] = "تم تعطيل المصادقة الثنائية بنجاح";
                    _logger.LogInformation("Two-factor authentication disabled successfully in {OperationName}", operationName);
                }
                else
                {
                    TempData["ErrorMessage"] = "فشل في تعطيل المصادقة الثنائية";
                    _logger.LogWarning("Failed to disable two-factor authentication in {OperationName}", operationName);
                }
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                TempData["WarningMessage"] = "تم إلغاء العملية";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                TempData["ErrorMessage"] = "حدث خطأ أثناء تعطيل المصادقة الثنائية";
            }

            return RedirectToAction("Index");
        }

        /// <summary>
        /// Checks if two-factor authentication is enabled
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>JSON response with status</returns>
        [HttpGet]
        public async Task<IActionResult> GetTwoFactorStatus(CancellationToken cancellationToken = default)
        {
            const string operationName = "GetTwoFactorStatus";

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var isEnabled = await _userSettingsService.IsTwoFactorEnabledAsync(cancellationToken);

                _logger.LogInformation("Retrieved two-factor status: {Status} in {OperationName}",
                    isEnabled, operationName);

                return Json(new { isEnabled });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(499, new { message = "Operation cancelled" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return StatusCode(500, new { message = "An error occurred while checking two-factor status" });
            }
        }
        #endregion
    }
    #endregion
}