using EduLab_MVC.Models.DTOs.Settings;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for managing user settings in the MVC application
    /// </summary>
    public interface IUserSettingsService
    {
        #region General Settings Methods

        /// <summary>
        /// Retrieves general settings for the current user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>General settings DTO or null if not found</returns>
        Task<GeneralSettingsDTO?> GetGeneralSettingsAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates general settings for the current user
        /// </summary>
        /// <param name="settings">General settings to update</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if update was successful, false otherwise</returns>
        Task<bool> UpdateGeneralSettingsAsync(GeneralSettingsDTO settings, CancellationToken cancellationToken = default);

        #endregion

        #region Password Methods

        /// <summary>
        /// Changes the password for the current user
        /// </summary>
        /// <param name="changePassword">Change password data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if password change was successful, false otherwise</returns>
        Task<bool> ChangePasswordAsync(ChangePasswordDTO changePassword, CancellationToken cancellationToken = default);

        #endregion

        #region Session Management Methods

        /// <summary>
        /// Retrieves all active sessions for the current user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of active sessions</returns>
        Task<List<ActiveSessionDTO>> GetActiveSessionsAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Revokes a specific session
        /// </summary>
        /// <param name="sessionId">Session ID to revoke</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if session was revoked successfully, false otherwise</returns>
        Task<bool> RevokeSessionAsync(Guid sessionId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Revokes all sessions except the current one
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if sessions were revoked successfully, false otherwise</returns>
        Task<bool> RevokeAllSessionsAsync(CancellationToken cancellationToken = default);

        #endregion

        #region Two-Factor Authentication Methods

        /// <summary>
        /// Retrieves two-factor authentication setup information
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Two-factor setup DTO or null if not found</returns>
        Task<TwoFactorSetupDTO?> GetTwoFactorSetupAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Enables two-factor authentication
        /// </summary>
        /// <param name="twoFactor">Two-factor authentication data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if two-factor was enabled successfully, false otherwise</returns>
        Task<bool> EnableTwoFactorAsync(TwoFactorDTO twoFactor, CancellationToken cancellationToken = default);

        /// <summary>
        /// Disables two-factor authentication
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if two-factor was disabled successfully, false otherwise</returns>
        Task<bool> DisableTwoFactorAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks if two-factor authentication is enabled
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if two-factor is enabled, false otherwise</returns>
        Task<bool> IsTwoFactorEnabledAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Verifies a two-factor authentication code
        /// </summary>
        /// <param name="code">Verification code</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the code is valid, false otherwise</returns>
        Task<bool> VerifyTwoFactorCodeAsync(string code, CancellationToken cancellationToken = default);

        #endregion
    }
}
