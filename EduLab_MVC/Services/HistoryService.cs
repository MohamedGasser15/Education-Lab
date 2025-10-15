using EduLab_MVC.Models.DTOs.History;
using EduLab_MVC.Services.ServiceInterfaces;
using Newtonsoft.Json;
using System.Buffers.Text;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// Service for handling history-related operations in MVC
    /// </summary>
    public class HistoryService : IHistoryService
    {
        #region Fields

        private readonly IHttpClientFactory _clientFactory;
        private readonly ILogger<HistoryService> _logger;
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly IWebHostEnvironment _env;
        private readonly string BaseApiUrl;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the HistoryService class
        /// </summary>
        /// <param name="clientFactory">HTTP client factory</param>
        /// <param name="logger">Logger for logging operations</param>
        /// <param name="httpClientService">Authorized HTTP client service</param>
        public HistoryService(
            IHttpClientFactory clientFactory,
            ILogger<HistoryService> logger,
            IAuthorizedHttpClientService httpClientService,
            IWebHostEnvironment env)
        {
            _clientFactory = clientFactory ?? throw new ArgumentNullException(nameof(clientFactory));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _httpClientService = httpClientService ?? throw new ArgumentNullException(nameof(httpClientService));
            _env = env;
            BaseApiUrl = _env.IsDevelopment()
                    ? "https://localhost:7292"
                    : "https://edulabapi.runasp.net";
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// Logs an operation to the history API
        /// </summary>
        /// <param name="userId">The ID of the user performing the operation</param>
        /// <param name="operation">Description of the operation</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>Task representing the asynchronous operation</returns>
        public async Task LogOperationAsync(string userId, string operation, CancellationToken cancellationToken = default)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(userId))
                {
                    _logger.LogWarning("LogOperationAsync called with null or empty userId");
                    throw new ArgumentException("User ID cannot be null or empty", nameof(userId));
                }

                if (string.IsNullOrWhiteSpace(operation))
                {
                    _logger.LogWarning("LogOperationAsync called with null or empty operation");
                    throw new ArgumentException("Operation cannot be null or empty", nameof(operation));
                }

                _logger.LogInformation("Logging operation for user: {UserId}, Operation: {Operation}", userId, operation);

                var client = _clientFactory.CreateClient("EduLabAPI");
                var url = $"History/log?userId={Uri.EscapeDataString(userId)}&operation={Uri.EscapeDataString(operation)}";

                var response = await client.PostAsync(url, null, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to log history. Status code: {StatusCode}, User: {UserId}",
                        response.StatusCode, userId);
                }
                else
                {
                    _logger.LogInformation("Operation logged successfully for user: {UserId}", userId);
                }
            }
            catch (HttpRequestException httpEx)
            {
                _logger.LogError(httpEx, "HTTP request failed while logging history for user: {UserId}", userId);
                throw;
            }
            catch (TaskCanceledException)
            {
                _logger.LogWarning("History logging operation was cancelled for user: {UserId}", userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while logging history for user: {UserId}", userId);
                throw;
            }
        }

        /// <summary>
        /// Gets all history logs from the API
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of history DTOs</returns>
        public async Task<List<HistoryDTO>> GetAllHistoryAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving all history logs from API");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("History/all", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var histories = JsonConvert.DeserializeObject<List<HistoryDTO>>(content) ?? new List<HistoryDTO>();

                    // Fix profile image URLs if needed
                    FixProfileImageUrls(histories);

                    _logger.LogInformation("Retrieved {Count} history logs successfully", histories.Count);
                    return histories;
                }

                _logger.LogWarning("Failed to get history. Status code: {StatusCode}", response.StatusCode);
                return new List<HistoryDTO>();
            }
            catch (HttpRequestException httpEx)
            {
                _logger.LogError(httpEx, "HTTP request failed while retrieving all history logs");
                return new List<HistoryDTO>();
            }
            catch (TaskCanceledException)
            {
                _logger.LogWarning("Get all history operation was cancelled");
                return new List<HistoryDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching all history logs");
                return new List<HistoryDTO>();
            }
        }

        /// <summary>
        /// Gets history logs for the current user from the API
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of history DTOs for the current user</returns>
        public async Task<List<HistoryDTO>> GetMyHistoryAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving history logs for current user");

                // Use authorized HTTP client service
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("History/MyHistory", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var histories = JsonConvert.DeserializeObject<List<HistoryDTO>>(content) ?? new List<HistoryDTO>();

                    // Fix profile image URLs if needed
                    FixProfileImageUrls(histories);

                    _logger.LogInformation("Retrieved {Count} history logs for current user successfully", histories.Count);
                    return histories;
                }

                _logger.LogWarning("Failed to get current user history. Status code: {StatusCode}", response.StatusCode);
                return new List<HistoryDTO>();
            }
            catch (HttpRequestException httpEx)
            {
                _logger.LogError(httpEx, "HTTP request failed while retrieving current user history");
                return new List<HistoryDTO>();
            }
            catch (TaskCanceledException)
            {
                _logger.LogWarning("Get current user history operation was cancelled");
                return new List<HistoryDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching current user history");
                return new List<HistoryDTO>();
            }
        }

        /// <summary>
        /// Gets history logs for a specific user from the API
        /// </summary>
        /// <param name="userId">The ID of the user</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of history DTOs for the specified user</returns>
        public async Task<List<HistoryDTO>> GetHistoryByUserAsync(string userId, CancellationToken cancellationToken = default)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(userId))
                {
                    _logger.LogWarning("GetHistoryByUserAsync called with null or empty userId");
                    return new List<HistoryDTO>();
                }

                _logger.LogInformation("Retrieving history logs for user: {UserId}", userId);

                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.GetAsync($"History/user/{Uri.EscapeDataString(userId)}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var histories = JsonConvert.DeserializeObject<List<HistoryDTO>>(content) ?? new List<HistoryDTO>();

                    // Fix profile image URLs if needed
                    FixProfileImageUrls(histories);

                    _logger.LogInformation("Retrieved {Count} history logs for user: {UserId}", histories.Count, userId);
                    return histories;
                }

                _logger.LogWarning("Failed to get history for user {UserId}. Status code: {StatusCode}",
                    userId, response.StatusCode);
                return new List<HistoryDTO>();
            }
            catch (HttpRequestException httpEx)
            {
                _logger.LogError(httpEx, "HTTP request failed while retrieving history for user: {UserId}", userId);
                return new List<HistoryDTO>();
            }
            catch (TaskCanceledException)
            {
                _logger.LogWarning("Get history for user {UserId} operation was cancelled", userId);
                return new List<HistoryDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching history for user: {UserId}", userId);
                return new List<HistoryDTO>();
            }
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// Fixes profile image URLs by ensuring they have the correct base URL
        /// </summary>
        /// <param name="histories">List of history DTOs to fix</param>
        private void FixProfileImageUrls(List<HistoryDTO> histories)
        {
            foreach (var history in histories)
            {
                if (!string.IsNullOrEmpty(history.ProfileImageUrl) &&
                    !history.ProfileImageUrl.StartsWith("https", StringComparison.OrdinalIgnoreCase))
                {
                    history.ProfileImageUrl = $"{BaseApiUrl}{history.ProfileImageUrl}";
                }
            }
        }

        #endregion
    }
}