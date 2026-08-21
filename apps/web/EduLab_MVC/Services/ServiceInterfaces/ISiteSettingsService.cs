using EduLab_MVC.Models.DTOs.Settings;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for site settings operations in the MVC application.
    /// </summary>
    public interface ISiteSettingsService
    {
        /// <summary>
        /// Retrieves the current site settings.
        /// </summary>
        Task<SiteSettingsDTO?> GetSettingsAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates the site settings.
        /// </summary>
        Task<bool> UpdateSettingsAsync(SiteSettingsDTO settings, CancellationToken cancellationToken = default);
    }
}
