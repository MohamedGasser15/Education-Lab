using EduLab_Application.DTOs.Settings;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for managing user settings, security and sessions
    /// </summary>
    public interface IUserSettingsService
    {
        /// <summary>
        /// Retrieves the general settings of a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>General settings DTO or null if the user was not found</returns>
        Task<GeneralSettingsDTO?> GetGeneralSettingsAsync(string userId,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates the general settings of a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="generalSettings">The new settings values</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the settings were updated, otherwise false</returns>
        Task<bool> UpdateGeneralSettingsAsync(string userId, GeneralSettingsDTO generalSettings,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Changes the password of a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="changePassword">Current and new password data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the password was changed, otherwise false</returns>
        Task<bool> ChangePasswordAsync(string userId, ChangePasswordDTO changePassword,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Enables two-factor authentication for a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="twoFactor">Two-factor setup data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if two-factor authentication was enabled, otherwise false</returns>
        Task<bool> EnableTwoFactorAsync(string userId, TwoFactorDTO twoFactor,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Disables two-factor authentication for a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if two-factor authentication was disabled, otherwise false</returns>
        Task<bool> DisableTwoFactorAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Verifies a two-factor authentication code for a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="code">The two-factor code to verify</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the code is valid, otherwise false</returns>
        Task<bool> VerifyTwoFactorCodeAsync(string userId, string code,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the two-factor authentication setup data of a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Two-factor setup DTO or null if not available</returns>
        Task<TwoFactorSetupDTO?> GetTwoFactorSetupAsync(string userId,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks whether two-factor authentication is enabled for a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if two-factor authentication is enabled, otherwise false</returns>
        Task<bool> IsTwoFactorEnabledAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the active sessions of a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of active session DTOs</returns>
        Task<List<ActiveSessionDTO>> GetActiveSessionsAsync(string userId,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Revokes a specific session of a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="sessionId">Unique identifier of the session to revoke</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the session was revoked, otherwise false</returns>
        Task<bool> RevokeSessionAsync(string userId, Guid sessionId,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Revokes all active sessions of a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the sessions were revoked, otherwise false</returns>
        Task<bool> RevokeAllSessionsAsync(string userId, CancellationToken cancellationToken = default);
    }
}