using EduLab_Shared.DTOs.Settings;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IUserSettingsService
    {
        Task<GeneralSettingsDTO?> GetGeneralSettingsAsync(string userId,
            CancellationToken cancellationToken = default);
        Task<bool> UpdateGeneralSettingsAsync(string userId, GeneralSettingsDTO generalSettings,
            CancellationToken cancellationToken = default);
        Task<bool> ChangePasswordAsync(string userId, ChangePasswordDTO changePassword,
            CancellationToken cancellationToken = default);
        Task<bool> EnableTwoFactorAsync(string userId, TwoFactorDTO twoFactor,
            CancellationToken cancellationToken = default);
        Task<bool> DisableTwoFactorAsync(string userId, CancellationToken cancellationToken = default);
        Task<bool> VerifyTwoFactorCodeAsync(string userId, string code,
            CancellationToken cancellationToken = default);
        Task<TwoFactorSetupDTO?> GetTwoFactorSetupAsync(string userId,
            CancellationToken cancellationToken = default);
        Task<bool> IsTwoFactorEnabledAsync(string userId, CancellationToken cancellationToken = default);
        Task<List<ActiveSessionDTO>> GetActiveSessionsAsync(string userId,
            CancellationToken cancellationToken = default);
        Task<bool> RevokeSessionAsync(string userId, Guid sessionId,
            CancellationToken cancellationToken = default);
        Task<bool> RevokeAllSessionsAsync(string userId, CancellationToken cancellationToken = default);
    }
}
