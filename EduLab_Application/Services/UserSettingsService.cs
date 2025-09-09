using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Settings;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    #region UserSettingsService Class
    /// <summary>
    /// Service implementation for managing user settings and preferences
    /// </summary>
    public class UserSettingsService : IUserSettingsService
    {
        #region Fields
        private readonly IMapper _mapper;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IEmailSender _emailSender;
        private readonly IIpService _ipService;
        private readonly IEmailTemplateService _emailTemplateService;
        private readonly ILinkBuilderService _linkGenerator;
        private readonly ISessionRepository _sessionRepository;
        private readonly ITokenService _tokenService;
        private readonly ILogger<UserSettingsService> _logger;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the UserSettingsService class
        /// </summary>
        /// <param name="mapper">AutoMapper instance for object mapping</param>
        /// <param name="userManager">UserManager for user operations</param>
        /// <param name="linkGenerator">Link generator service</param>
        /// <param name="emailSender">Email sending service</param>
        /// <param name="emailTemplateService">Email template service</param>
        /// <param name="ipService">IP address service</param>
        /// <param name="sessionRepository">Session repository</param>
        /// <param name="tokenService">Token service</param>
        /// <param name="logger">Logger instance</param>
        public UserSettingsService(
            IMapper mapper,
            UserManager<ApplicationUser> userManager,
            ILinkBuilderService linkGenerator,
            IEmailSender emailSender,
            IEmailTemplateService emailTemplateService,
            IIpService ipService,
            ISessionRepository sessionRepository,
            ITokenService tokenService,
            ILogger<UserSettingsService> logger)
        {
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
            _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
            _linkGenerator = linkGenerator ?? throw new ArgumentNullException(nameof(linkGenerator));
            _emailSender = emailSender ?? throw new ArgumentNullException(nameof(emailSender));
            _emailTemplateService = emailTemplateService ?? throw new ArgumentNullException(nameof(emailTemplateService));
            _ipService = ipService ?? throw new ArgumentNullException(nameof(ipService));
            _sessionRepository = sessionRepository ?? throw new ArgumentNullException(nameof(sessionRepository));
            _tokenService = tokenService ?? throw new ArgumentNullException(nameof(tokenService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }
        #endregion

        #region General Settings Methods
        /// <summary>
        /// Retrieves general settings for a user
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>General settings DTO or null if user not found</returns>
        public async Task<GeneralSettingsDTO?> GetGeneralSettingsAsync(string userId,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "GetGeneralSettingsAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var user = await _userManager.FindByIdAsync(userId);
                if (user == null)
                {
                    _logger.LogWarning("User not found with ID: {UserId} in {OperationName}", userId, operationName);
                    return null;
                }

                var settings = _mapper.Map<GeneralSettingsDTO>(user);

                _logger.LogInformation("Successfully retrieved general settings for user ID: {UserId} in {OperationName}",
                    userId, operationName);

                return settings;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}",
                    operationName, userId);
                throw;
            }
        }

        /// <summary>
        /// Updates general settings for a user
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="generalSettings">General settings DTO containing updated values</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if update was successful, false otherwise</returns>
        public async Task<bool> UpdateGeneralSettingsAsync(string userId, GeneralSettingsDTO generalSettings,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "UpdateGeneralSettingsAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var user = await _userManager.FindByIdAsync(userId);
                if (user == null)
                {
                    _logger.LogWarning("User not found with ID: {UserId} in {OperationName}", userId, operationName);
                    return false;
                }

                // Check if email is being changed
                if (!string.Equals(user.Email, generalSettings.Email, StringComparison.OrdinalIgnoreCase))
                {
                    user.Email = generalSettings.Email;
                    user.EmailConfirmed = false;
                    _logger.LogDebug("Email updated for user ID: {UserId}", userId);
                }

                user.FullName = generalSettings.FullName;
                user.PhoneNumber = generalSettings.PhoneNumber;

                var result = await _userManager.UpdateAsync(user);

                if (result.Succeeded)
                {
                    _logger.LogInformation("Successfully updated general settings for user ID: {UserId} in {OperationName}",
                        userId, operationName);
                }
                else
                {
                    _logger.LogWarning("Failed to update general settings for user ID: {UserId}. Errors: {Errors}",
                        userId, string.Join(", ", result.Errors.Select(e => e.Description)));
                }

                return result.Succeeded;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}",
                    operationName, userId);
                throw;
            }
        }
        #endregion

        #region Password Methods
        /// <summary>
        /// Changes the password for a user
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="changePassword">Change password DTO containing current and new password</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if password change was successful, false otherwise</returns>
        public async Task<bool> ChangePasswordAsync(string userId, ChangePasswordDTO changePassword,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "ChangePasswordAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var user = await _userManager.FindByIdAsync(userId);
                if (user == null)
                {
                    _logger.LogWarning("User not found with ID: {UserId} in {OperationName}", userId, operationName);
                    return false;
                }

                var result = await _userManager.ChangePasswordAsync(
                    user,
                    changePassword.CurrentPassword,
                    changePassword.NewPassword
                );

                if (!result.Succeeded)
                {
                    _logger.LogWarning("Password change failed for user ID: {UserId}. Errors: {Errors}",
                        userId, string.Join(", ", result.Errors.Select(e => e.Description)));
                    return false;
                }

                // Generate new token and create session after password change
                var newToken = await _tokenService.GenerateAccessToken(user);
                await _ipService.CreateUserSessionAsync(user.Id, newToken);

                // Send confirmation email
                var ipAddress = _ipService.GetClientIpAddress();
                var deviceInfo = _ipService.GetDeviceInfo();
                var changeTime = DateTime.UtcNow;
                var passwordResetLink = _linkGenerator.GenerateResetPasswordLink(user.Id);

                var emailTemplate = _emailTemplateService.GeneratePasswordChangeEmail(
                    user, ipAddress, deviceInfo, changeTime, passwordResetLink);

                await _emailSender.SendEmailAsync(user.Email, "تأكيد تغيير كلمة المرور", emailTemplate);

                _logger.LogInformation("Successfully changed password for user ID: {UserId} in {OperationName}",
                    userId, operationName);

                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}",
                    operationName, userId);
                throw;
            }
        }
        #endregion

        #region Two-Factor Authentication Methods
        /// <summary>
        /// Enables two-factor authentication for a user
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="twoFactor">Two-factor DTO containing verification code</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if two-factor was enabled successfully, false otherwise</returns>
        public async Task<bool> EnableTwoFactorAsync(string userId, TwoFactorDTO twoFactor,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "EnableTwoFactorAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var user = await _userManager.FindByIdAsync(userId);
                if (user == null)
                {
                    _logger.LogWarning("User not found with ID: {UserId} in {OperationName}", userId, operationName);
                    return false;
                }

                var isValid = await _userManager.VerifyTwoFactorTokenAsync(
                    user,
                    _userManager.Options.Tokens.AuthenticatorTokenProvider,
                    twoFactor.Code
                );

                if (!isValid)
                {
                    _logger.LogWarning("Invalid two-factor code for user ID: {UserId} in {OperationName}",
                        userId, operationName);
                    return false;
                }

                var result = await _userManager.SetTwoFactorEnabledAsync(user, true);

                if (result.Succeeded)
                {
                    _logger.LogInformation("Successfully enabled two-factor authentication for user ID: {UserId} in {OperationName}",
                        userId, operationName);
                }
                else
                {
                    _logger.LogWarning("Failed to enable two-factor authentication for user ID: {UserId}. Errors: {Errors}",
                        userId, string.Join(", ", result.Errors.Select(e => e.Description)));
                }

                return result.Succeeded;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}",
                    operationName, userId);
                throw;
            }
        }

        /// <summary>
        /// Disables two-factor authentication for a user
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if two-factor was disabled successfully, false otherwise</returns>
        public async Task<bool> DisableTwoFactorAsync(string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = "DisableTwoFactorAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var user = await _userManager.FindByIdAsync(userId);
                if (user == null)
                {
                    _logger.LogWarning("User not found with ID: {UserId} in {OperationName}", userId, operationName);
                    return false;
                }

                var result = await _userManager.SetTwoFactorEnabledAsync(user, false);

                if (result.Succeeded)
                {
                    _logger.LogInformation("Successfully disabled two-factor authentication for user ID: {UserId} in {OperationName}",
                        userId, operationName);
                }
                else
                {
                    _logger.LogWarning("Failed to disable two-factor authentication for user ID: {UserId}. Errors: {Errors}",
                        userId, string.Join(", ", result.Errors.Select(e => e.Description)));
                }

                return result.Succeeded;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}",
                    operationName, userId);
                throw;
            }
        }

        /// <summary>
        /// Verifies a two-factor authentication code
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="code">The verification code to check</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the code is valid, false otherwise</returns>
        public async Task<bool> VerifyTwoFactorCodeAsync(string userId, string code,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "VerifyTwoFactorCodeAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var user = await _userManager.FindByIdAsync(userId);
                if (user == null)
                {
                    _logger.LogWarning("User not found with ID: {UserId} in {OperationName}", userId, operationName);
                    return false;
                }

                var isValid = await _userManager.VerifyTwoFactorTokenAsync(
                    user,
                    _userManager.Options.Tokens.AuthenticatorTokenProvider,
                    code
                );

                _logger.LogInformation("Two-factor code verification {Result} for user ID: {UserId} in {OperationName}",
                    isValid ? "succeeded" : "failed", userId, operationName);

                return isValid;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}",
                    operationName, userId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves two-factor authentication setup information for a user
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Two-factor setup DTO or null if user not found</returns>
        public async Task<TwoFactorSetupDTO?> GetTwoFactorSetupAsync(string userId,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "GetTwoFactorSetupAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var user = await _userManager.FindByIdAsync(userId);
                if (user == null)
                {
                    _logger.LogWarning("User not found with ID: {UserId} in {OperationName}", userId, operationName);
                    return null;
                }

                // Get or generate authenticator key
                var unformattedKey = await _userManager.GetAuthenticatorKeyAsync(user);
                if (string.IsNullOrEmpty(unformattedKey))
                {
                    await _userManager.ResetAuthenticatorKeyAsync(user);
                    unformattedKey = await _userManager.GetAuthenticatorKeyAsync(user);
                }

                // Generate QR code URL
                var email = user.Email;
                var issuer = "EduLab";
                var qrCodeUrl = $"otpauth://totp/{issuer}:{email}?secret={unformattedKey}&issuer={issuer}&digits=6";

                // Generate recovery codes
                var recoveryCodes = await _userManager.GenerateNewTwoFactorRecoveryCodesAsync(user, 5);

                var setupInfo = new TwoFactorSetupDTO
                {
                    QrCodeUrl = qrCodeUrl,
                    Secret = unformattedKey,
                    RecoveryCodes = recoveryCodes?.ToList() ?? new List<string>()
                };

                _logger.LogInformation("Successfully generated two-factor setup for user ID: {UserId} in {OperationName}",
                    userId, operationName);

                return setupInfo;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}",
                    operationName, userId);
                throw;
            }
        }

        /// <summary>
        /// Checks if two-factor authentication is enabled for a user
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if two-factor is enabled, false otherwise</returns>
        public async Task<bool> IsTwoFactorEnabledAsync(string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = "IsTwoFactorEnabledAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var user = await _userManager.FindByIdAsync(userId);
                if (user == null)
                {
                    _logger.LogWarning("User not found with ID: {UserId} in {OperationName}", userId, operationName);
                    return false;
                }

                var isEnabled = await _userManager.GetTwoFactorEnabledAsync(user);

                _logger.LogInformation("Two-factor status for user ID: {UserId} is {Status} in {OperationName}",
                    userId, isEnabled ? "enabled" : "disabled", operationName);

                return isEnabled;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}",
                    operationName, userId);
                throw;
            }
        }
        #endregion

        #region Session Management Methods
        /// <summary>
        /// Retrieves all active sessions for a user
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of active session DTOs</returns>
        public async Task<List<ActiveSessionDTO>> GetActiveSessionsAsync(string userId,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "GetActiveSessionsAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var sessions = await _sessionRepository.GetActiveSessionsForUser(userId, cancellationToken);
                var currentIp = _ipService.GetClientIpAddress();

                var dtoList = _mapper.Map<List<ActiveSessionDTO>>(sessions);

                // Mark current session
                foreach (var dto in dtoList)
                {
                    var session = sessions.FirstOrDefault(s => s.Id == dto.Id);
                    dto.IsCurrent = session?.IPAddress == currentIp;
                }

                _logger.LogInformation("Successfully retrieved {Count} active sessions for user ID: {UserId} in {OperationName}",
                    dtoList.Count, userId, operationName);

                return dtoList;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}",
                    operationName, userId);
                throw;
            }
        }

        /// <summary>
        /// Revokes a specific session for a user
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="sessionId">The unique identifier of the session to revoke</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if session was revoked successfully, false otherwise</returns>
        public async Task<bool> RevokeSessionAsync(string userId, Guid sessionId,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "RevokeSessionAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}, session ID: {SessionId}",
                    operationName, userId, sessionId);

                var session = await _sessionRepository.GetSessionById(sessionId, cancellationToken);
                if (session == null || session.UserId != userId)
                {
                    _logger.LogWarning("Session not found or access denied for user ID: {UserId}, session ID: {SessionId}",
                        userId, sessionId);
                    return false;
                }

                var result = await _sessionRepository.RevokeSession(sessionId, cancellationToken);

                _logger.LogInformation("Session revocation {Result} for user ID: {UserId}, session ID: {SessionId} in {OperationName}",
                    result ? "succeeded" : "failed", userId, sessionId, operationName);

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}, session ID: {SessionId}",
                    operationName, userId, sessionId);
                throw;
            }
        }

        /// <summary>
        /// Revokes all sessions for a user except the current one
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if sessions were revoked successfully, false otherwise</returns>
        public async Task<bool> RevokeAllSessionsAsync(string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = "RevokeAllSessionsAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var revokedCount = await _sessionRepository.RevokeAllSessionsForUser(userId, null, cancellationToken);

                _logger.LogInformation("Successfully revoked {Count} sessions for user ID: {UserId} in {OperationName}",
                    revokedCount, userId, operationName);

                return revokedCount > 0;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}",
                    operationName, userId);
                throw;
            }
        }
        #endregion
    }
    #endregion
}