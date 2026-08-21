using EduLab_MVC.Models.DTOs.Settings;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.Extensions.Caching.Memory;
using Newtonsoft.Json;
using System.Text;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// Service implementation for site settings operations, with short-term caching.
    /// </summary>
    public class SiteSettingsService : ISiteSettingsService
    {
        private readonly ILogger<SiteSettingsService> _logger;
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly IMemoryCache _cache;
        private const string CacheKey = "SiteSettings";

        /// <summary>
        /// Initializes a new instance of the <see cref="SiteSettingsService"/> class.
        /// </summary>
        /// <param name="logger">The logger instance.</param>
        /// <param name="httpClientService">The authorized HTTP client service.</param>
        /// <param name="cache">The in-memory cache.</param>
        public SiteSettingsService(
            ILogger<SiteSettingsService> logger,
            IAuthorizedHttpClientService httpClientService,
            IMemoryCache cache)
        {
            _logger = logger;
            _httpClientService = httpClientService;
            _cache = cache;
        }

        /// <summary>
        /// Retrieves the current site settings, using the cache when available.
        /// </summary>
        public async Task<SiteSettingsDTO?> GetSettingsAsync(CancellationToken cancellationToken = default)
        {
            if (_cache.TryGetValue(CacheKey, out SiteSettingsDTO? cached))
                return cached;

            try
            {
                _logger.LogDebug("Fetching site settings from API");
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("admin/settings", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var settings = JsonConvert.DeserializeObject<SiteSettingsDTO>(content);
                    if (settings != null)
                    {
                        _cache.Set(CacheKey, settings, TimeSpan.FromMinutes(5));
                        _logger.LogInformation("Site settings cached for 5 minutes");
                    }
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

        /// <summary>
        /// Updates the site settings and refreshes the cached copy.
        /// </summary>
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
                    _cache.Set(CacheKey, dto, TimeSpan.FromMinutes(5));
                    _logger.LogInformation("Site settings updated and cache refreshed");
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
