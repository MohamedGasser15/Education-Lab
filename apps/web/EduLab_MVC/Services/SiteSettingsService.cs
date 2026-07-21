using EduLab_MVC.Models.DTOs.Settings;
using EduLab_MVC.Services.ServiceInterfaces;
using Newtonsoft.Json;
using System.Text;

namespace EduLab_MVC.Services
{
    public class SiteSettingsService : ISiteSettingsService
    {
        private readonly ILogger<SiteSettingsService> _logger;
        private readonly IAuthorizedHttpClientService _httpClientService;

        public SiteSettingsService(ILogger<SiteSettingsService> logger, IAuthorizedHttpClientService httpClientService)
        {
            _logger = logger;
            _httpClientService = httpClientService;
        }

        public async Task<SiteSettingsDTO?> GetSettingsAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting site settings from API");
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("admin/settings", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var settings = JsonConvert.DeserializeObject<SiteSettingsDTO>(content);
                    _logger.LogInformation("Site settings retrieved successfully");
                    return settings;
                }

                _logger.LogWarning("Failed to get site settings. Status: {StatusCode}", response.StatusCode);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception fetching site settings");
                return null;
            }
        }

        public async Task<bool> UpdateSettingsAsync(SiteSettingsDTO dto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Updating site settings via API");
                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(dto);
                var content = new StringContent(json, Encoding.UTF8, "application/json");
                var response = await client.PutAsync("admin/settings", content, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("Site settings updated successfully");
                    return true;
                }

                _logger.LogWarning("Failed to update settings. Status: {StatusCode}", response.StatusCode);
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception updating site settings");
                return false;
            }
        }
    }
}
