using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Settings;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Learner
{
    #region SettingsController Class
    /// <summary>
    /// API controller for managing user settings and preferences
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    [Produces("application/json")]
    public class SettingsController : ControllerBase
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

        #region Utility Methods
        /// <summary>
        /// Gets the user ID from the current claims principal
        /// </summary>
        /// <returns>User ID as string</returns>
        private string GetUserId()
        {
            return User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        }
        #endregion

        #region General Settings Endpoints
        /// <summary>
        /// Retrieves general settings for the authenticated user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>General settings information</returns>
        /// <response code="200">Returns the general settings</response>
        /// <response code="404">If user is not found</response>
        [HttpGet("general")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(GeneralSettingsDTO))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> GetGeneralSettings(CancellationToken cancellationToken = default)
        {
            const string operationName = "GetGeneralSettings";

            try
            {
                var userId = GetUserId();
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var generalSettings = await _userSettingsService.GetGeneralSettingsAsync(userId, cancellationToken);

                if (generalSettings == null)
                {
                    _logger.LogWarning("General settings not found for user ID: {UserId}", userId);
                    return NotFound(new { message = "User not found" });
                }

                _logger.LogInformation("Successfully retrieved general settings for user ID: {UserId}", userId);
                return Ok(generalSettings);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(499, "Operation cancelled"); // Client closed request
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return StatusCode(500, new { message = "An error occurred while retrieving settings" });
            }
        }

        /// <summary>
        /// Updates general settings for the authenticated user
        /// </summary>
        /// <param name="generalSettings">General settings data to update</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Operation result</returns>
        /// <response code="200">If settings were updated successfully</response>
        /// <response code="400">If the request is invalid or update failed</response>
        [HttpPut("general")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> UpdateGeneralSettings(
            [FromBody] GeneralSettingsDTO generalSettings,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "UpdateGeneralSettings";

            if (!ModelState.IsValid)
            {
                _logger.LogWarning("Invalid model state in {OperationName}", operationName);
                return BadRequest(ModelState);
            }

            try
            {
                var userId = GetUserId();
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var result = await _userSettingsService.UpdateGeneralSettingsAsync(userId, generalSettings, cancellationToken);

                if (!result)
                {
                    _logger.LogWarning("Failed to update general settings for user ID: {UserId}", userId);
                    return BadRequest(new { message = "Failed to update settings" });
                }

                _logger.LogInformation("Successfully updated general settings for user ID: {UserId}", userId);
                return Ok(new { message = "Settings updated successfully" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(499, "Operation cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return StatusCode(500, new { message = "An error occurred while updating settings" });
            }
        }
        #endregion

        #region Password Endpoints
        /// <summary>
        /// Changes the password for the authenticated user
        /// </summary>
        /// <param name="changePassword">Change password data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Operation result</returns>
        /// <response code="200">If password was changed successfully</response>
        /// <response code="400">If the request is invalid or password change failed</response>
        [HttpPost("change-password")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> ChangePassword(
            [FromBody] ChangePasswordDTO changePassword,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "ChangePassword";

            if (!ModelState.IsValid)
            {
                _logger.LogWarning("Invalid model state in {OperationName}", operationName);
                return BadRequest(ModelState);
            }

            try
            {
                var userId = GetUserId();
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var result = await _userSettingsService.ChangePasswordAsync(userId, changePassword, cancellationToken);

                if (!result)
                {
                    _logger.LogWarning("Failed to change password for user ID: {UserId}", userId);
                    return BadRequest(new { message = "Failed to change password. Please check your current password" });
                }

                _logger.LogInformation("Successfully changed password for user ID: {UserId}", userId);
                return Ok(new { message = "Password changed successfully" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(499, "Operation cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return StatusCode(500, new { message = "An error occurred while changing password" });
            }
        }
        #endregion

        #region Two-Factor Authentication Endpoints
        /// <summary>
        /// Enables two-factor authentication for the authenticated user
        /// </summary>
        /// <param name="twoFactor">Two-factor authentication data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Operation result</returns>
        /// <response code="200">If two-factor was enabled successfully</response>
        /// <response code="400">If the request is invalid or enabling failed</response>
        [HttpPost("two-factor/enable")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> EnableTwoFactor(
            [FromBody] TwoFactorDTO twoFactor,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "EnableTwoFactor";

            if (!ModelState.IsValid)
            {
                _logger.LogWarning("Invalid model state in {OperationName}", operationName);
                return BadRequest(ModelState);
            }

            try
            {
                var userId = GetUserId();
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var result = await _userSettingsService.EnableTwoFactorAsync(userId, twoFactor, cancellationToken);

                if (!result)
                {
                    _logger.LogWarning("Failed to enable two-factor authentication for user ID: {UserId}", userId);
                    return BadRequest(new { message = "Failed to enable two-factor authentication. Please check the code" });
                }

                _logger.LogInformation("Successfully enabled two-factor authentication for user ID: {UserId}", userId);
                return Ok(new { message = "Two-factor authentication enabled successfully" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(499, "Operation cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return StatusCode(500, new { message = "An error occurred while enabling two-factor authentication" });
            }
        }

        /// <summary>
        /// Disables two-factor authentication for the authenticated user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Operation result</returns>
        /// <response code="200">If two-factor was disabled successfully</response>
        /// <response code="400">If disabling failed</response>
        [HttpPost("two-factor/disable")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> DisableTwoFactor(CancellationToken cancellationToken = default)
        {
            const string operationName = "DisableTwoFactor";

            try
            {
                var userId = GetUserId();
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var result = await _userSettingsService.DisableTwoFactorAsync(userId, cancellationToken);

                if (!result)
                {
                    _logger.LogWarning("Failed to disable two-factor authentication for user ID: {UserId}", userId);
                    return BadRequest(new { message = "Failed to disable two-factor authentication" });
                }

                _logger.LogInformation("Successfully disabled two-factor authentication for user ID: {UserId}", userId);
                return Ok(new { message = "Two-factor authentication disabled successfully" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(499, "Operation cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return StatusCode(500, new { message = "An error occurred while disabling two-factor authentication" });
            }
        }

        /// <summary>
        /// Verifies a two-factor authentication code
        /// </summary>
        /// <param name="code">Verification code</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Operation result</returns>
        /// <response code="200">If the code is valid</response>
        /// <response code="400">If the code is invalid</response>
        [HttpPost("two-factor/verify")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> VerifyTwoFactorCode(
            [FromBody] string code,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "VerifyTwoFactorCode";

            try
            {
                var userId = GetUserId();
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var result = await _userSettingsService.VerifyTwoFactorCodeAsync(userId, code, cancellationToken);

                if (!result)
                {
                    _logger.LogWarning("Invalid two-factor code for user ID: {UserId}", userId);
                    return BadRequest(new { message = "Invalid code" });
                }

                _logger.LogInformation("Successfully verified two-factor code for user ID: {UserId}", userId);
                return Ok(new { message = "Code is valid" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(499, "Operation cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return StatusCode(500, new { message = "An error occurred while verifying the code" });
            }
        }

        /// <summary>
        /// Retrieves two-factor authentication setup information
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Two-factor setup information</returns>
        /// <response code="200">Returns the setup information</response>
        /// <response code="404">If user is not found</response>
        [HttpGet("two-factor/setup")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(TwoFactorSetupDTO))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> GetTwoFactorSetup(CancellationToken cancellationToken = default)
        {
            const string operationName = "GetTwoFactorSetup";

            try
            {
                var userId = GetUserId();
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var setupInfo = await _userSettingsService.GetTwoFactorSetupAsync(userId, cancellationToken);

                if (setupInfo == null)
                {
                    _logger.LogWarning("User not found for two-factor setup with ID: {UserId}", userId);
                    return NotFound(new { message = "User not found" });
                }

                _logger.LogInformation("Successfully retrieved two-factor setup for user ID: {UserId}", userId);
                return Ok(setupInfo);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(499, "Operation cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return StatusCode(500, new { message = "An error occurred while retrieving two-factor setup" });
            }
        }

        /// <summary>
        /// Checks if two-factor authentication is enabled
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Two-factor status</returns>
        /// <response code="200">Returns the status</response>
        [HttpGet("two-factor/status")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(bool))]
        public async Task<IActionResult> GetTwoFactorStatus(CancellationToken cancellationToken = default)
        {
            const string operationName = "GetTwoFactorStatus";

            try
            {
                var userId = GetUserId();
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var isEnabled = await _userSettingsService.IsTwoFactorEnabledAsync(userId, cancellationToken);

                _logger.LogInformation("Retrieved two-factor status for user ID: {UserId}: {Status}",
                    userId, isEnabled);

                return Ok(isEnabled);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(499, "Operation cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return StatusCode(500, new { message = "An error occurred while checking two-factor status" });
            }
        }
        #endregion

        #region Session Management Endpoints
        /// <summary>
        /// Retrieves all active sessions for the authenticated user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of active sessions</returns>
        /// <response code="200">Returns the active sessions</response>
        [HttpGet("active-sessions")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(List<ActiveSessionDTO>))]
        public async Task<IActionResult> GetActiveSessions(CancellationToken cancellationToken = default)
        {
            const string operationName = "GetActiveSessions";

            try
            {
                var userId = GetUserId();
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var sessions = await _userSettingsService.GetActiveSessionsAsync(userId, cancellationToken);

                _logger.LogInformation("Successfully retrieved {Count} active sessions for user ID: {UserId}",
                    sessions.Count, userId);

                return Ok(sessions);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(499, "Operation cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return StatusCode(500, new { message = "An error occurred while retrieving active sessions" });
            }
        }

        /// <summary>
        /// Revokes a specific session
        /// </summary>
        /// <param name="sessionId">Session ID to revoke</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Operation result</returns>
        /// <response code="200">If session was revoked successfully</response>
        /// <response code="400">If revocation failed</response>
        [HttpPost("active-sessions/revoke/{sessionId}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> RevokeSession(
            Guid sessionId,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "RevokeSession";

            try
            {
                var userId = GetUserId();
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}, session ID: {SessionId}",
                    operationName, userId, sessionId);

                var result = await _userSettingsService.RevokeSessionAsync(userId, sessionId, cancellationToken);

                if (!result)
                {
                    _logger.LogWarning("Failed to revoke session for user ID: {UserId}, session ID: {SessionId}",
                        userId, sessionId);
                    return BadRequest(new { message = "Failed to revoke session" });
                }

                _logger.LogInformation("Successfully revoked session for user ID: {UserId}, session ID: {SessionId}",
                    userId, sessionId);

                return Ok(new { message = "Session revoked successfully" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(499, "Operation cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return StatusCode(500, new { message = "An error occurred while revoking the session" });
            }
        }

        /// <summary>
        /// Revokes all sessions except the current one
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Operation result</returns>
        /// <response code="200">If sessions were revoked successfully</response>
        /// <response code="400">If revocation failed</response>
        [HttpPost("active-sessions/revoke-all")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> RevokeAllSessions(CancellationToken cancellationToken = default)
        {
            const string operationName = "RevokeAllSessions";

            try
            {
                var userId = GetUserId();
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var result = await _userSettingsService.RevokeAllSessionsAsync(userId, cancellationToken);

                if (!result)
                {
                    _logger.LogWarning("Failed to revoke all sessions for user ID: {UserId}", userId);
                    return BadRequest(new { message = "Failed to revoke sessions" });
                }

                _logger.LogInformation("Successfully revoked all sessions for user ID: {UserId}", userId);
                return Ok(new { message = "All sessions revoked successfully" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(499, "Operation cancelled");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return StatusCode(500, new { message = "An error occurred while revoking sessions" });
            }
        }
        #endregion
    }
    #endregion
}