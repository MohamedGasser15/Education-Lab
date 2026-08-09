using EduLab_MVC.Models.DTOs.Certificates;
using EduLab_MVC.Services.ServiceInterfaces;
using Newtonsoft.Json;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// Service for course certificate operations
    /// </summary>
    public class CertificateService : ICertificateService
    {
        private readonly ILogger<CertificateService> _logger;
        private readonly IAuthorizedHttpClientService _httpClientService;

        public CertificateService(
            ILogger<CertificateService> logger,
            IAuthorizedHttpClientService httpClientService)
        {
            _logger = logger;
            _httpClientService = httpClientService;
        }

        /// <summary>
        /// Gets all certificates earned by the current user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of certificates or empty list if failed</returns>
        public async Task<List<CertificateDto>> GetMyCertificatesAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting certificates for current user");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("certificates/my", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning($"Failed to fetch certificates. StatusCode: {response.StatusCode}");
                    return new List<CertificateDto>();
                }

                var content = await response.Content.ReadAsStringAsync(cancellationToken);
                return JsonConvert.DeserializeObject<List<CertificateDto>>(content) ?? new List<CertificateDto>();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while getting certificates");
                return new List<CertificateDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error while fetching certificates");
                return new List<CertificateDto>();
            }
        }
    }
}
