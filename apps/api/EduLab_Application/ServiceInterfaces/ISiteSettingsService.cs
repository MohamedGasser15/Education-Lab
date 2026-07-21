using EduLab_Application.DTOs.Settings;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface ISiteSettingsService
    {
        Task<SiteSettingsDTO?> GetSettingsAsync(CancellationToken cancellationToken = default);
        Task<bool> UpdateSettingsAsync(SiteSettingsDTO settings, string? updatedBy = null, CancellationToken cancellationToken = default);
    }
}
