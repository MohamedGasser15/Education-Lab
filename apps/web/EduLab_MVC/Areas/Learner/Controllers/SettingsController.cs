using EduLab_MVC.Models.DTOs.Settings;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using EduLab_MVC.Resources;
using Microsoft.Extensions.Localization;

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
        private readonly IStringLocalizer<SharedResources> _localizer;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the SettingsController class
        /// </summary>
        /// <param name="userSettingsService">User settings service</param>
        /// <param name="logger">Logger instance</param>
        public SettingsController(IUserSettingsService userSettingsService, ILogger<SettingsController> logger, IStringLocalizer<SharedResources> localizer)
        {
            _userSettingsService = userSettingsService ?? throw new ArgumentNullException(nameof(userSettingsService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _localizer = localizer ?? throw new ArgumentNullException(nameof(localizer));
        }
        #endregion

        #region General Settings Actions
        /// <summary>
        /// Displays the settings index page with user settings
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Settings view</returns>
        [HttpGet]
        public async Task<IActionResult> Index(string tab = "profile", CancellationToken cancellationToken = default)
        {
            const string operationName = "SettingsIndex";

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var settings = await _userSettingsService.GetGeneralSettingsAsync(cancellationToken);
                var activeSessions = await _userSettingsService.GetActiveSessionsAsync(cancellationToken);
                var isTwoFactorEnabled = await _userSettingsService.IsTwoFactorEnabledAsync(cancellationToken);

                ViewBag.ActiveSessions = activeSessions ?? new List<ActiveSessionDTO>();
                ViewBag.ActiveSessions = activeSessions ?? new List<ActiveSessionDTO>();
                ViewBag.IsTwoFactorEnabled = isTwoFactorEnabled;
                ViewBag.ActiveTab = tab;

                _logger.LogInformation("Successfully loaded settings page in {OperationName}", operationName);

                return View(settings ?? new GeneralSettingsDTO());
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return RedirectToAction("Index", new { tab = tab });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                TempData["ErrorMessage"] = _localizer["ErrorLoadingSettings"].Value;
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
                TempData["ErrorMessage"] = _localizer["InvalidData"].Value;
                return RedirectToAction("Index", new { tab = "profile" });
            }

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var result = await _userSettingsService.UpdateGeneralSettingsAsync(model, cancellationToken);

                if (result)
                {
                    TempData["SuccessMessage"] = _localizer["SettingsUpdated"].Value;
                    _logger.LogInformation("General settings updated successfully in {OperationName}", operationName);
                }
                else
                {
                    TempData["ErrorMessage"] = _localizer["FailedToUpdateSettings"].Value;
                    _logger.LogWarning("Failed to update general settings in {OperationName}", operationName);
                }
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                TempData["WarningMessage"] = _localizer["OperationCancelled"].Value;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                TempData["ErrorMessage"] = _localizer["ErrorUpdatingSettings"].Value;
            }

            return RedirectToAction("Index", new { tab = "profile" });
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
                TempData["ErrorMessage"] = _localizer["InvalidPasswordData"].Value;
                return RedirectToAction("Index", new { tab = "security" });
            }

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var result = await _userSettingsService.ChangePasswordAsync(model, cancellationToken);

                if (result)
                {
                    TempData["SuccessMessage"] = _localizer["PasswordChanged"].Value;
                    _logger.LogInformation("Password changed successfully in {OperationName}", operationName);
                }
                else
                {
                    TempData["ErrorMessage"] = _localizer["FailedToChangePassword"].Value;
                    _logger.LogWarning("Failed to change password in {OperationName}", operationName);
                }
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                TempData["WarningMessage"] = _localizer["OperationCancelled"].Value;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                TempData["ErrorMessage"] = _localizer["ErrorChangingPassword"].Value;
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
                    TempData["SuccessMessage"] = _localizer["SessionEnded"].Value;
                    _logger.LogInformation("Session revoked successfully in {OperationName} for session ID: {SessionId}",
                        operationName, sessionId);
                }
                else
                {
                    TempData["ErrorMessage"] = _localizer["FailedToEndSession"].Value;
                    _logger.LogWarning("Failed to revoke session in {OperationName} for session ID: {SessionId}",
                        operationName, sessionId);
                }
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for session ID: {SessionId}",
                    operationName, sessionId);
                TempData["WarningMessage"] = _localizer["OperationCancelled"].Value;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for session ID: {SessionId}",
                    operationName, sessionId);
                TempData["ErrorMessage"] = _localizer["ErrorEndingSession"].Value;
            }

            return RedirectToAction("Index", new { tab = "security" });
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
                    TempData["SuccessMessage"] = _localizer["AllSessionsEnded"].Value;
                    _logger.LogInformation("All sessions revoked successfully in {OperationName}", operationName);
                }
                else
                {
                    TempData["ErrorMessage"] = _localizer["FailedToEndSessions"].Value;
                    _logger.LogWarning("Failed to revoke all sessions in {OperationName}", operationName);
                }
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                TempData["WarningMessage"] = _localizer["OperationCancelled"].Value;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                TempData["ErrorMessage"] = _localizer["ErrorEndingSessions"].Value;
            }

            return RedirectToAction("Index", new { tab = "security" });
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
        public async Task<IActionResult> EnableTwoFactor([FromForm] TwoFactorDTO model, CancellationToken cancellationToken = default)
        {
            if (!ModelState.IsValid)
            {
                TempData["ErrorMessage"] = _localizer["InvalidTwoFactorData"].Value;
                return RedirectToAction("Index", new { tab = "security" });
            }

            try
            {
                var result = await _userSettingsService.EnableTwoFactorAsync(model, cancellationToken);
                if (result)
                {
                    TempData["SuccessMessage"] = _localizer["TwoFactorEnabled"].Value;
                }
                else
                {
                    TempData["ErrorMessage"] = _localizer["FailedToEnableTwoFactor"].Value;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in EnableTwoFactor");
                TempData["ErrorMessage"] = _localizer["ErrorEnablingTwoFactor"].Value;
            }
            
            return RedirectToAction("Index", new { tab = "security" });
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
            try
            {
                var result = await _userSettingsService.DisableTwoFactorAsync(cancellationToken);
                if (result)
                {
                    TempData["SuccessMessage"] = _localizer["TwoFactorDisabled"].Value;
                }
                else
                {
                    TempData["ErrorMessage"] = _localizer["FailedToDisableTwoFactor"].Value;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in DisableTwoFactor");
                TempData["ErrorMessage"] = _localizer["ErrorDisablingTwoFactor"].Value;
            }
            
            return RedirectToAction("Index", new { tab = "security" });
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