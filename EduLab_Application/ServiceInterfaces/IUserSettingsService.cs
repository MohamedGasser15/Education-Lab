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
        Task<GeneralSettingsDTO> GetGeneralSettingsAsync(string userId);
        Task<bool> UpdateGeneralSettingsAsync(string userId, GeneralSettingsDTO generalSettings);
        Task<bool> ChangePasswordAsync(string userId, ChangePasswordDTO changePassword);
        Task<bool> EnableTwoFactorAsync(string userId, TwoFactorDTO twoFactor);
        Task<bool> DisableTwoFactorAsync(string userId);
        Task<bool> VerifyTwoFactorCodeAsync(string userId, string code);
        Task<List<ActiveSessionDTO>> GetActiveSessionsAsync(string userId);
        Task<bool> RevokeSessionAsync(string userId, Guid sessionId);
        Task<bool> RevokeAllSessionsAsync(string userId);
        Task<TwoFactorSetupDTO?> GetTwoFactorSetupAsync(string userId);
        Task<bool> IsTwoFactorEnabledAsync(string userId);
    }
}
