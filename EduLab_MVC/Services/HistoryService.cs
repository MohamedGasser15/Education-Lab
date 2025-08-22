using EduLab_MVC.Models.DTOs.History;
using EduLab_MVC.Services.Helper_Services;
using Newtonsoft.Json;

namespace EduLab_MVC.Services
{
    public class HistoryService
    {
        private readonly IHttpClientFactory _clientFactory;
        private readonly ILogger<HistoryService> _logger;
        private readonly AuthorizedHttpClientService _httpClientService;
        public HistoryService(IHttpClientFactory clientFactory, ILogger<HistoryService> logger, AuthorizedHttpClientService httpClientService)
        {
            _clientFactory = clientFactory;
            _logger = logger;
            _httpClientService = httpClientService;
        }

        public async Task LogOperationAsync(string userId, string operation)
        {
            try
            {
                var client = _clientFactory.CreateClient("EduLabAPI");
                var url = $"History/History?userId={userId}&operation={Uri.EscapeDataString(operation)}";

                var response = await client.PostAsync(url, null);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning($"Failed to log history. Status code: {response.StatusCode}");
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while logging history.");
            }
        }

        public async Task<List<HistoryDTO>> GetAllHistoryAsync()
        {
            try
            {
                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.GetAsync("History/all");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var histories = JsonConvert.DeserializeObject<List<HistoryDTO>>(content) ?? new List<HistoryDTO>();

                    foreach (var h in histories)
                    {
                        if (!string.IsNullOrEmpty(h.ProfileImageUrl) && !h.ProfileImageUrl.StartsWith("https"))
                        {
                            h.ProfileImageUrl = "https://localhost:7292" + h.ProfileImageUrl;
                        }
                    }

                    return histories;
                }

                _logger.LogWarning($"Failed to get history. Status code: {response.StatusCode}");
                return new List<HistoryDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching history.");
                return new List<HistoryDTO>();
            }
        }
        public async Task<List<HistoryDTO>> GetMyHistoryAsync()
        {
            try
            {
                // استخدام AuthorizedHttpClientService
                var client = _httpClientService.CreateClient();

                // طلب الـ API الخاص بالـ user الحالي
                var response = await client.GetAsync("History/MyHistory");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var histories = JsonConvert.DeserializeObject<List<HistoryDTO>>(content) ?? new List<HistoryDTO>();

                    // تعديل رابط الصورة لو مش كامل
                    foreach (var h in histories)
                    {
                        if (!string.IsNullOrEmpty(h.ProfileImageUrl) && !h.ProfileImageUrl.StartsWith("https"))
                        {
                            h.ProfileImageUrl = "https://localhost:7292" + h.ProfileImageUrl;
                        }
                    }

                    return histories;
                }

                _logger.LogWarning($"Failed to get current user history. Status code: {response.StatusCode}");
                return new List<HistoryDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching current user history.");
                return new List<HistoryDTO>();
            }
        }

        public async Task<List<HistoryDTO>> GetHistoryByUserAsync(string userId)
        {
            try
            {
                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.GetAsync($"History/user/{userId}");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var histories = JsonConvert.DeserializeObject<List<HistoryDTO>>(content) ?? new List<HistoryDTO>();

                    foreach (var h in histories)
                    {
                        if (!string.IsNullOrEmpty(h.ProfileImageUrl) && !h.ProfileImageUrl.StartsWith("https"))
                        {
                            h.ProfileImageUrl = "https://localhost:7292" + h.ProfileImageUrl;
                        }
                    }

                    return histories;
                }

                _logger.LogWarning($"Failed to get history for user {userId}. Status code: {response.StatusCode}");
                return new List<HistoryDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Exception occurred while fetching history for user {userId}.");
                return new List<HistoryDTO>();
            }
        }

    }
}
