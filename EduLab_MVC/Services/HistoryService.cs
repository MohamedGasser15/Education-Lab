using EduLab_MVC.Models.DTOs.History;
using Newtonsoft.Json;

namespace EduLab_MVC.Services
{
    public class HistoryService
    {
        private readonly IHttpClientFactory _clientFactory;
        private readonly ILogger<HistoryService> _logger;

        public HistoryService(IHttpClientFactory clientFactory, ILogger<HistoryService> logger)
        {
            _clientFactory = clientFactory;
            _logger = logger;
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
                    return JsonConvert.DeserializeObject<List<HistoryDTO>>(content) ?? new List<HistoryDTO>();
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

        public async Task<List<HistoryDTO>> GetHistoryByUserAsync(string userId)
        {
            try
            {
                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.GetAsync($"History/user/{userId}");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    return JsonConvert.DeserializeObject<List<HistoryDTO>>(content) ?? new List<HistoryDTO>();
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
