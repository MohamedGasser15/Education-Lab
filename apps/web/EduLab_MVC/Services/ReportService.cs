using EduLab_MVC.Models.DTOs.Report;
using EduLab_MVC.Services.ServiceInterfaces;
using Newtonsoft.Json;
using System.Text;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// Service for report management (admin panel + learner submission)
    /// </summary>
    public class ReportService : IReportService
    {
        private readonly ILogger<ReportService> _logger;
        private readonly IAuthorizedHttpClientService _httpClientService;

        public ReportService(
            ILogger<ReportService> logger,
            IAuthorizedHttpClientService httpClientService)
        {
            _logger = logger;
            _httpClientService = httpClientService;
        }

        public async Task<ReportListResultDto?> GetAdminReportsAsync(string? status, string? type, string? search, int page, int pageSize, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var query = new StringBuilder("admin/reports?");
                query.Append($"page={page}&pageSize={pageSize}");
                if (!string.IsNullOrEmpty(status))
                    query.Append($"&status={Uri.EscapeDataString(status)}");
                if (!string.IsNullOrEmpty(type))
                    query.Append($"&type={Uri.EscapeDataString(type)}");
                if (!string.IsNullOrWhiteSpace(search))
                    query.Append($"&search={Uri.EscapeDataString(search.Trim())}");

                var response = await client.GetAsync(query.ToString(), cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to fetch reports. StatusCode: {StatusCode}", response.StatusCode);
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync(cancellationToken);
                return JsonConvert.DeserializeObject<ReportListResultDto>(content);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while getting reports");
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error while fetching reports (Admin)");
                return null;
            }
        }

        public async Task<int> GetPendingCountAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("admin/reports/pending-count", cancellationToken);

                if (!response.IsSuccessStatusCode)
                    return 0;

                var content = await response.Content.ReadAsStringAsync(cancellationToken);
                return JsonConvert.DeserializeObject<int>(content);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error while fetching pending reports count");
                return 0;
            }
        }

        public async Task<string> UpdateStatusAsync(int id, string status, string? note, string? action = null, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var body = JsonConvert.SerializeObject(new { status, adminNote = note ?? "", action = action ?? "" });
                var content = new StringContent(body, Encoding.UTF8, "application/json");
                var response = await client.PostAsync($"admin/reports/{id}/status", content, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);
                    var error = JsonConvert.DeserializeObject<dynamic>(errorContent);
                    return error?.Message?.ToString() ?? "Failed to update report.";
                }

                return "success";
            }
            catch (OperationCanceledException)
            {
                return "cancelled";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error while updating report status (Admin)");
                return "error";
            }
        }

        public async Task<string> DeleteContentAsync(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.PostAsync($"admin/reports/{id}/delete-content", null, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);
                    var error = JsonConvert.DeserializeObject<dynamic>(errorContent);
                    return error?.Message?.ToString() ?? "Failed to delete content.";
                }

                return "success";
            }
            catch (OperationCanceledException)
            {
                return "cancelled";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error while deleting reported content (Admin)");
                return "error";
            }
        }

        public async Task<(bool Success, string? Message)> CreateAsync(string type, int targetId, string reason, string? details, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var body = JsonConvert.SerializeObject(new { type, targetId, reason, details });
                var content = new StringContent(body, Encoding.UTF8, "application/json");
                var response = await client.PostAsync("reports", content, cancellationToken);

                if (response.IsSuccessStatusCode)
                    return (true, null);

                var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);
                var error = JsonConvert.DeserializeObject<dynamic>(errorContent);
                return (false, error?.Message?.ToString() ?? "حدث خطأ أثناء إرسال البلاغ");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error while creating report");
                return (false, "حدث خطأ أثناء إرسال البلاغ");
            }
        }

        public async Task<bool> CheckReportedAsync(string type, int targetId, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"reports/check?type={Uri.EscapeDataString(type)}&targetId={targetId}", cancellationToken);

                if (!response.IsSuccessStatusCode)
                    return false;

                var content = await response.Content.ReadAsStringAsync(cancellationToken);
                var result = JsonConvert.DeserializeObject<dynamic>(content);
                return result?.reported == true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error while checking report status");
                return false;
            }
        }

        public async Task<List<int>> CheckReportedManyAsync(string type, List<int> targetIds, CancellationToken cancellationToken = default)
        {
            try
            {
                if (targetIds == null || targetIds.Count == 0)
                    return new List<int>();

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"reports/check-many?type={Uri.EscapeDataString(type)}&ids={string.Join(",", targetIds)}", cancellationToken);

                if (!response.IsSuccessStatusCode)
                    return new List<int>();

                var content = await response.Content.ReadAsStringAsync(cancellationToken);
                var result = JsonConvert.DeserializeObject<dynamic>(content);
                if (result?.reportedIds == null)
                    return new List<int>();

                var list = new List<int>();
                foreach (var item in (IEnumerable<dynamic>)result.reportedIds)
                    list.Add((int)item);
                return list;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error while checking report statuses");
                return new List<int>();
            }
        }
    }
}
