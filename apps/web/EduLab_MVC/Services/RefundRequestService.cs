using EduLab_MVC.Models.DTOs.Payment;
using EduLab_MVC.Services.ServiceInterfaces;
using Newtonsoft.Json;
using System.Text;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// Service for admin refund request management
    /// </summary>
    public class RefundRequestService : IRefundRequestService
    {
        private readonly ILogger<RefundRequestService> _logger;
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly string _imageBaseUrl;

        /// <summary>
        /// Initializes a new instance of the RefundRequestService class
        /// </summary>
        /// <param name="logger">Logger instance</param>
        /// <param name="httpClientService">HTTP client service</param>
        /// <param name="configuration">Configuration instance</param>
        public RefundRequestService(
            ILogger<RefundRequestService> logger,
            IAuthorizedHttpClientService httpClientService,
            IConfiguration configuration)
        {
            _logger = logger;
            _httpClientService = httpClientService;
            var apiBaseUrl = configuration["ApiBaseUrl"];
            _imageBaseUrl = apiBaseUrl.Replace("/api/", "/");
        }

        /// <summary>
        /// Gets all refund requests for admin review
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of refund requests or null if failed</returns>
        public async Task<List<AdminRefundRequestDto>?> GetRefundRequestsAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting all refund requests for admin");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("admin/refunds", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning($"Failed to fetch refund requests. StatusCode: {response.StatusCode}");
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                var requests = JsonConvert.DeserializeObject<List<AdminRefundRequestDto>>(content);

                if (requests != null)
                {
                    foreach (var request in requests)
                    {
                        if (!string.IsNullOrEmpty(request.CourseThumbnail) &&
                            !request.CourseThumbnail.StartsWith("https") &&
                            !request.CourseThumbnail.StartsWith("data:"))
                        {
                            request.CourseThumbnail = _imageBaseUrl + request.CourseThumbnail;
                        }
                    }
                }

                return requests;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while getting refund requests");
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error while fetching refund requests (Admin)");
                return null;
            }
        }

        /// <summary>
        /// Approves a refund request
        /// </summary>
        /// <param name="id">Refund request identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Result message</returns>
        public async Task<string> ApproveRefundAsync(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Admin approving refund request {RequestId}", id);

                var client = _httpClientService.CreateClient();
                var response = await client.PostAsync($"admin/refunds/{id}/accept", null, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);
                    var error = JsonConvert.DeserializeObject<dynamic>(errorContent);
                    var message = error?.Message?.ToString();
                    return message ?? "Failed to approve refund request.";
                }

                return "success";
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while approving refund request");
                return "cancelled";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error while approving refund request (Admin)");
                return "error";
            }
        }

        /// <summary>
        /// Rejects a refund request
        /// </summary>
        /// <param name="id">Refund request identifier</param>
        /// <param name="reason">Rejection reason</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Result message</returns>
        public async Task<string> RejectRefundAsync(int id, string? reason = null, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Admin rejecting refund request {RequestId}", id);

                var client = _httpClientService.CreateClient();
                var body = JsonConvert.SerializeObject(new { reason = reason ?? "" });
                var content = new StringContent(body, Encoding.UTF8, "application/json");
                var response = await client.PostAsync($"admin/refunds/{id}/reject", content, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);
                    var error = JsonConvert.DeserializeObject<dynamic>(errorContent);
                    var message = error?.Message?.ToString();
                    return message ?? "Failed to reject refund request.";
                }

                return "success";
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while rejecting refund request");
                return "cancelled";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error while rejecting refund request (Admin)");
                return "error";
            }
        }
    }
}
