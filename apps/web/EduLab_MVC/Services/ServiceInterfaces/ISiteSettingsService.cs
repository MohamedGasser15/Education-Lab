using EduLab_MVC.Models.DTOs.Settings;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    public interface ISiteSettingsService
    {
        Task<SiteSettingsDTO?> GetSettingsAsync(CancellationToken cancellationToken = default);
        Task<bool> UpdateSettingsAsync(SiteSettingsDTO settings, CancellationToken cancellationToken = default);
    }
}
