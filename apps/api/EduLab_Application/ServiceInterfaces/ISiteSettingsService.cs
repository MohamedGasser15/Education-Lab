using EduLab_Application.DTOs.Settings;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for managing site-wide settings
    /// </summary>
    public interface ISiteSettingsService
    {
        /// <summary>
        /// Retrieves the site settings
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The site settings DTO or null if not configured</returns>
        Task<SiteSettingsDTO?> GetSettingsAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates the site settings
        /// </summary>
        /// <param name="settings">The new settings values</param>
        /// <param name="updatedBy">Unique identifier of the admin performing the update</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the settings were updated, otherwise false</returns>
        Task<bool> UpdateSettingsAsync(SiteSettingsDTO settings, string? updatedBy = null, CancellationToken cancellationToken = default);
    }
}