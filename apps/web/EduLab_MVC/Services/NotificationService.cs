using EduLab_MVC.Models.DTOs.Notifications;
using EduLab_MVC.Services.ServiceInterfaces;
using Newtonsoft.Json;
using System.Text;

namespace EduLab_MVC.Services
{
    public class NotificationService : INotificationService
    {
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly ILogger<NotificationService> _logger;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public NotificationService(
            IAuthorizedHttpClientService httpClientService,
            ILogger<NotificationService> logger,
            IHttpContextAccessor httpContextAccessor)
        {
            _httpClientService = httpClientService;
            _logger = logger;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<List<NotificationDto>> GetUserNotificationsAsync(NotificationFilterDto filter)
        {
            try
            {
                _logger.LogInformation("Getting user notifications with filter");

                var client = _httpClientService.CreateClient();

                // بناء query string للفلتر
                var queryParams = new List<string>();
                if (filter.Type.HasValue)
                    queryParams.Add($"Type={(int)filter.Type.Value}");
                if (filter.Status.HasValue)
                    queryParams.Add($"Status={(int)filter.Status.Value}");

                queryParams.Add($"PageNumber={filter.PageNumber}");
                queryParams.Add($"PageSize={filter.PageSize}");

                var queryString = queryParams.Any() ? "?" + string.Join("&", queryParams) : "";
                var response = await client.GetAsync($"Notifications{queryString}");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var notifications = JsonConvert.DeserializeObject<List<NotificationDto>>(content) ?? new List<NotificationDto>();

                    // حساب الوقت المنقضي
                    foreach (var notification in notifications)
                    {
                        notification.TimeAgo = GetTimeAgo(notification.CreatedAt);
                    }

                    _logger.LogInformation("Retrieved {Count} notifications successfully", notifications.Count);
                    return notifications;
                }

                _logger.LogWarning("Failed to get notifications. Status code: {StatusCode}", response.StatusCode);
                return new List<NotificationDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting user notifications");
                return new List<NotificationDto>();
            }
        }

        public async Task<NotificationSummaryDto> GetUserNotificationSummaryAsync()
        {
            try
            {
                _logger.LogInformation("Getting user notification summary");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("Notifications/summary");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var summary = JsonConvert.DeserializeObject<NotificationSummaryDto>(content);

                    _logger.LogInformation("Retrieved notification summary successfully");
                    return summary;
                }

                _logger.LogWarning("Failed to get notification summary. Status code: {StatusCode}", response.StatusCode);
                return new NotificationSummaryDto();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting notification summary");
                return new NotificationSummaryDto();
            }
        }

        public async Task<int> GetUnreadCountAsync()
        {
            try
            {
                _logger.LogInformation("Getting unread notifications count");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("Notifications/unread-count");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var count = JsonConvert.DeserializeObject<int>(content);

                    _logger.LogInformation("Retrieved unread count: {Count}", count);
                    return count;
                }

                _logger.LogWarning("Failed to get unread count. Status code: {StatusCode}", response.StatusCode);
                return 0;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting unread count");
                return 0;
            }
        }

        public async Task MarkAllNotificationsAsReadAsync()
        {
            try
            {
                _logger.LogInformation("Marking all notifications as read");

                var client = _httpClientService.CreateClient();
                var response = await client.PostAsync("Notifications/mark-all-read", null);

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("All notifications marked as read successfully");
                }
                else
                {
                    _logger.LogWarning("Failed to mark all notifications as read. Status code: {StatusCode}", response.StatusCode);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking all notifications as read");
            }
        }

        public async Task MarkNotificationAsReadAsync(int id)
        {
            try
            {
                _logger.LogInformation("Marking notification {NotificationId} as read", id);

                var client = _httpClientService.CreateClient();
                var response = await client.PutAsync($"Notifications/{id}/read", null);

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("Notification {NotificationId} marked as read successfully", id);
                }
                else
                {
                    _logger.LogWarning("Failed to mark notification {NotificationId} as read. Status code: {StatusCode}",
                        id, response.StatusCode);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking notification {NotificationId} as read", id);
            }
        }

        public async Task DeleteNotificationAsync(int id)
        {
            try
            {
                _logger.LogInformation("Deleting notification {NotificationId}", id);

                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync($"Notifications/{id}");

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("Notification {NotificationId} deleted successfully", id);
                }
                else
                {
                    _logger.LogWarning("Failed to delete notification {NotificationId}. Status code: {StatusCode}",
                        id, response.StatusCode);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting notification {NotificationId}", id);
            }
        }

        public async Task DeleteAllNotificationsAsync()
        {
            try
            {
                _logger.LogInformation("Deleting all notifications");

                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync("Notifications/delete-all");

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("All notifications deleted successfully");
                }
                else
                {
                    _logger.LogWarning("Failed to delete all notifications. Status code: {StatusCode}", response.StatusCode);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting all notifications");
            }
        }
        public async Task<BulkNotificationResultDto> SendBulkNotificationAsync(AdminNotificationRequestDto request)
        {
            try
            {
                _logger.LogInformation("Sending bulk notification: {Title}", request.Title);

                var client = _httpClientService.CreateClient();

                // استخدام Newtonsoft.Json للتسلسل
                var json = JsonConvert.SerializeObject(request, new JsonSerializerSettings
                {
                    NullValueHandling = NullValueHandling.Ignore,
                    DateFormatHandling = DateFormatHandling.IsoDateFormat
                });

                var content = new StringContent(json, Encoding.UTF8, "application/json");

                _logger.LogInformation("Sending request to API: {Json}", json);

                var response = await client.PostAsync("Notifications/send-bulk", content);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync();
                    var result = JsonConvert.DeserializeObject<BulkNotificationResultDto>(responseContent);

                    _logger.LogInformation("Bulk notification sent successfully. Notifications: {Notifications}, Emails: {Emails}",
                        result.NotificationsSent, result.EmailsSent);

                    return result;
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    _logger.LogWarning("Failed to send bulk notification. Status: {StatusCode}, Response: {ErrorContent}",
                        response.StatusCode, errorContent);

                    return new BulkNotificationResultDto
                    {
                        Errors = new List<string> { $"فشل الإرسال: {response.StatusCode} - {errorContent}" }
                    };
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending bulk notification");
                return new BulkNotificationResultDto
                {
                    Errors = new List<string> { $"حدث خطأ: {ex.Message}" }
                };
            }
        }
        private string GetTimeAgo(DateTime dateTime)
        {
            var timeSpan = DateTime.UtcNow - dateTime;

            if (timeSpan.TotalDays >= 30)
            {
                var months = (int)(timeSpan.TotalDays / 30);
                return months == 1 ? "منذ شهر" : $"منذ {months} أشهر";
            }
            else if (timeSpan.TotalDays >= 1)
            {
                var days = (int)timeSpan.TotalDays;
                return days == 1 ? "منذ يوم" : $"منذ {days} أيام";
            }
            else if (timeSpan.TotalHours >= 1)
            {
                var hours = (int)timeSpan.TotalHours;
                return hours == 1 ? "منذ ساعة" : $"منذ {hours} ساعات";
            }
            else if (timeSpan.TotalMinutes >= 1)
            {
                var minutes = (int)timeSpan.TotalMinutes;
                return minutes == 1 ? "منذ دقيقة" : $"منذ {minutes} دقائق";
            }
            else
            {
                return "الآن";
            }
        }
    }
}