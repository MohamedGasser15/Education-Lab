using EduLab_MVC.Models.DTOs.Settings;
using EduLab_MVC.Services.ServiceInterfaces;
using Newtonsoft.Json;
using System.Text;

namespace EduLab_MVC.Services
{
    #region UserSettingsService Class
    /// <summary>
    /// Service for managing user settings in the MVC application
    /// </summary>
    public class UserSettingsService : IUserSettingsService
    {
        #region Fields
        private readonly ILogger<UserSettingsService> _logger;
        private readonly IAuthorizedHttpClientService _httpClientService;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the UserSettingsService class
        /// </summary>
        /// <param name="logger">Logger instance for logging operations</param>
        /// <param name="httpClientService">HTTP client service for API communication</param>
        public UserSettingsService(ILogger<UserSettingsService> logger, IAuthorizedHttpClientService httpClientService)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _httpClientService = httpClientService ?? throw new ArgumentNullException(nameof(httpClientService));
        }
        #endregion

        #region General Settings Methods
        /// <summary>
        /// Retrieves general settings for the current user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>General settings DTO or null if not found</returns>
        public async Task<GeneralSettingsDTO?> GetGeneralSettingsAsync(CancellationToken cancellationToken = default)
        {
            const string operationName = "GetGeneralSettingsAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                using var client = _httpClientService.CreateClient();
                using var response = await client.GetAsync("settings/general", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to get general settings. StatusCode: {StatusCode}", response.StatusCode);
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                var settings = JsonConvert.DeserializeObject<GeneralSettingsDTO>(content);

                _logger.LogInformation("Successfully retrieved general settings in {OperationName}", operationName);
                return settings;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return null;
            }
        }

        /// <summary>
        /// Updates general settings for the current user
        /// </summary>
        /// <param name="settings">General settings to update</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if update was successful, false otherwise</returns>
        public async Task<bool> UpdateGeneralSettingsAsync(GeneralSettingsDTO settings,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "UpdateGeneralSettingsAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                using var client = _httpClientService.CreateClient();
                var jsonContent = new StringContent(
                    JsonConvert.SerializeObject(settings),
                    Encoding.UTF8,
                    "application/json");

                using var response = await client.PutAsync("settings/general", jsonContent, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to update general settings. StatusCode: {StatusCode}", response.StatusCode);
                }

                _logger.LogInformation("General settings update {Result} in {OperationName}",
                    response.IsSuccessStatusCode ? "succeeded" : "failed", operationName);

                return response.IsSuccessStatusCode;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return false;
            }
        }
        #endregion

        #region Password Methods
        /// <summary>
        /// Changes the password for the current user
        /// </summary>
        /// <param name="changePassword">Change password data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if password change was successful, false otherwise</returns>
        public async Task<bool> ChangePasswordAsync(ChangePasswordDTO changePassword,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "ChangePasswordAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                using var client = _httpClientService.CreateClient();
                var jsonContent = new StringContent(
                    JsonConvert.SerializeObject(changePassword),
                    Encoding.UTF8,
                    "application/json");

                using var response = await client.PostAsync("settings/change-password", jsonContent, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to change password. StatusCode: {StatusCode}", response.StatusCode);
                }

                _logger.LogInformation("Password change {Result} in {OperationName}",
                    response.IsSuccessStatusCode ? "succeeded" : "failed", operationName);

                return response.IsSuccessStatusCode;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return false;
            }
        }
        #endregion

        #region Session Management Methods
        /// <summary>
        /// Retrieves all active sessions for the current user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of active sessions</returns>
        public async Task<List<ActiveSessionDTO>> GetActiveSessionsAsync(CancellationToken cancellationToken = default)
        {
            const string operationName = "GetActiveSessionsAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                using var client = _httpClientService.CreateClient();
                using var response = await client.GetAsync("settings/active-sessions", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to get active sessions. StatusCode: {StatusCode}", response.StatusCode);
                    return new List<ActiveSessionDTO>();
                }

                var content = await response.Content.ReadAsStringAsync();
                var sessions = JsonConvert.DeserializeObject<List<ActiveSessionDTO>>(content) ?? new List<ActiveSessionDTO>();

                _logger.LogInformation("Successfully retrieved {Count} active sessions in {OperationName}",
                    sessions.Count, operationName);

                return sessions;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return new List<ActiveSessionDTO>();
            }
        }

        /// <summary>
        /// Revokes a specific session
        /// </summary>
        /// <param name="sessionId">Session ID to revoke</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if session was revoked successfully, false otherwise</returns>
        public async Task<bool> RevokeSessionAsync(Guid sessionId, CancellationToken cancellationToken = default)
        {
            const string operationName = "RevokeSessionAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for session ID: {SessionId}", operationName, sessionId);

                using var client = _httpClientService.CreateClient();
                using var response = await client.PostAsync(
                    $"settings/active-sessions/revoke/{sessionId}",
                    null,
                    cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to revoke session. StatusCode: {StatusCode}", response.StatusCode);
                }

                _logger.LogInformation("Session revocation {Result} in {OperationName} for session ID: {SessionId}",
                    response.IsSuccessStatusCode ? "succeeded" : "failed", operationName, sessionId);

                return response.IsSuccessStatusCode;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for session ID: {SessionId}",
                    operationName, sessionId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for session ID: {SessionId}",
                    operationName, sessionId);
                return false;
            }
        }

        /// <summary>
        /// Revokes all sessions except the current one
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if sessions were revoked successfully, false otherwise</returns>
        public async Task<bool> RevokeAllSessionsAsync(CancellationToken cancellationToken = default)
        {
            const string operationName = "RevokeAllSessionsAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                using var client = _httpClientService.CreateClient();
                using var response = await client.PostAsync(
                    "settings/active-sessions/revoke-all",
                    null,
                    cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to revoke all sessions. StatusCode: {StatusCode}", response.StatusCode);
                }

                _logger.LogInformation("Revoke all sessions {Result} in {OperationName}",
                    response.IsSuccessStatusCode ? "succeeded" : "failed", operationName);

                return response.IsSuccessStatusCode;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return false;
            }
        }
        #endregion

        #region Two-Factor Authentication Methods
        /// <summary>
        /// Retrieves two-factor authentication setup information
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Two-factor setup DTO or null if not found</returns>
        public async Task<TwoFactorSetupDTO?> GetTwoFactorSetupAsync(CancellationToken cancellationToken = default)
        {
            const string operationName = "GetTwoFactorSetupAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                using var client = _httpClientService.CreateClient();
                using var response = await client.GetAsync("settings/two-factor/setup", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to get two-factor setup. StatusCode: {StatusCode}", response.StatusCode);
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                var setupInfo = JsonConvert.DeserializeObject<TwoFactorSetupDTO>(content);

                _logger.LogInformation("Successfully retrieved two-factor setup in {OperationName}", operationName);
                return setupInfo;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return null;
            }
        }

        /// <summary>
        /// Enables two-factor authentication
        /// </summary>
        /// <param name="twoFactor">Two-factor authentication data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if two-factor was enabled successfully, false otherwise</returns>
        public async Task<bool> EnableTwoFactorAsync(TwoFactorDTO twoFactor, CancellationToken cancellationToken = default)
        {
            const string operationName = "EnableTwoFactorAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                using var client = _httpClientService.CreateClient();
                var jsonContent = new StringContent(
                    JsonConvert.SerializeObject(twoFactor),
                    Encoding.UTF8,
                    "application/json");

                using var response = await client.PostAsync("settings/two-factor/enable", jsonContent, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to enable two-factor. StatusCode: {StatusCode}", response.StatusCode);
                }

                _logger.LogInformation("Two-factor enable {Result} in {OperationName}",
                    response.IsSuccessStatusCode ? "succeeded" : "failed", operationName);

                return response.IsSuccessStatusCode;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return false;
            }
        }

        /// <summary>
        /// Disables two-factor authentication
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if two-factor was disabled successfully, false otherwise</returns>
        public async Task<bool> DisableTwoFactorAsync(CancellationToken cancellationToken = default)
        {
            const string operationName = "DisableTwoFactorAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                using var client = _httpClientService.CreateClient();
                using var response = await client.PostAsync(
                    "settings/two-factor/disable",
                    null,
                    cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to disable two-factor. StatusCode: {StatusCode}", response.StatusCode);
                }

                _logger.LogInformation("Two-factor disable {Result} in {OperationName}",
                    response.IsSuccessStatusCode ? "succeeded" : "failed", operationName);

                return response.IsSuccessStatusCode;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return false;
            }
        }

        /// <summary>
        /// Checks if two-factor authentication is enabled
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if two-factor is enabled, false otherwise</returns>
        public async Task<bool> IsTwoFactorEnabledAsync(CancellationToken cancellationToken = default)
        {
            const string operationName = "IsTwoFactorEnabledAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                using var client = _httpClientService.CreateClient();
                using var response = await client.GetAsync("settings/two-factor/status", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to get two-factor status. StatusCode: {StatusCode}", response.StatusCode);
                    return false;
                }

                var content = await response.Content.ReadAsStringAsync();
                var isEnabled = JsonConvert.DeserializeObject<bool>(content);

                _logger.LogInformation("Retrieved two-factor status: {Status} in {OperationName}",
                    isEnabled, operationName);

                return isEnabled;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return false;
            }
        }

        /// <summary>
        /// Verifies a two-factor authentication code
        /// </summary>
        /// <param name="code">Verification code</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the code is valid, false otherwise</returns>
        public async Task<bool> VerifyTwoFactorCodeAsync(string code, CancellationToken cancellationToken = default)
        {
            const string operationName = "VerifyTwoFactorCodeAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                using var client = _httpClientService.CreateClient();
                var jsonContent = new StringContent(
                    JsonConvert.SerializeObject(new { code }),
                    Encoding.UTF8,
                    "application/json");

                using var response = await client.PostAsync("settings/two-factor/verify", jsonContent, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to verify two-factor code. StatusCode: {StatusCode}", response.StatusCode);
                }

                _logger.LogInformation("Two-factor code verification {Result} in {OperationName}",
                    response.IsSuccessStatusCode ? "succeeded" : "failed", operationName);

                return response.IsSuccessStatusCode;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName}", operationName);
                return false;
            }
        }
        #endregion
    }
    #endregion
}