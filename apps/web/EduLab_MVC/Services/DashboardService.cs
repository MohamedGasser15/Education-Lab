using EduLab_MVC.Models.DTOs.Dashboard;
using EduLab_MVC.Resources;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.Extensions.Localization;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// MVC service for retrieving dashboard analytics from the API
    /// </summary>
    public class DashboardService : IDashboardService
    {
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly ILogger<DashboardService> _logger;
        private readonly IStringLocalizer<SharedResources> _localizer;

        public DashboardService(
            IAuthorizedHttpClientService httpClientService,
            ILogger<DashboardService> logger,
            IStringLocalizer<SharedResources> localizer)
        {
            _httpClientService = httpClientService ?? throw new ArgumentNullException(nameof(httpClientService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _localizer = localizer ?? throw new ArgumentNullException(nameof(localizer));
        }

        /// <summary>
        /// Retrieves the admin dashboard data from the API
        /// </summary>
        public async Task<AdminDashboardDto> GetAdminDashboardAsync(CancellationToken cancellationToken = default)
        {
            const string methodName = nameof(GetAdminDashboardAsync);

            try
            {
                _logger.LogInformation("Retrieving admin dashboard from API");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("admin/dashboard", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    var dashboard = JsonConvert.DeserializeObject<AdminDashboardDto>(content);

                    _logger.LogInformation("Successfully retrieved admin dashboard");
                    return dashboard ?? new AdminDashboardDto();
                }

                _logger.LogWarning("Failed to get admin dashboard. Status code: {StatusCode}", response.StatusCode);
                return new AdminDashboardDto();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {MethodName} was cancelled", methodName);
                return new AdminDashboardDto();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching admin dashboard");
                return new AdminDashboardDto();
            }
        }

        /// <summary>
        /// Retrieves the instructor dashboard data from the API
        /// </summary>
        public async Task<InstructorDashboardDto> GetInstructorDashboardAsync(CancellationToken cancellationToken = default)
        {
            const string methodName = nameof(GetInstructorDashboardAsync);

            try
            {
                _logger.LogInformation("Retrieving instructor dashboard from API");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("instructor/dashboard", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    var dashboard = JsonConvert.DeserializeObject<InstructorDashboardDto>(content);

                    if (dashboard != null)
                    {
                        LocalizeNotifications(dashboard.Notifications);
                    }

                    _logger.LogInformation("Successfully retrieved instructor dashboard");
                    return dashboard ?? new InstructorDashboardDto();
                }

                _logger.LogWarning("Failed to get instructor dashboard. Status code: {StatusCode}", response.StatusCode);
                return new InstructorDashboardDto();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {MethodName} was cancelled", methodName);
                return new InstructorDashboardDto();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching instructor dashboard");
                return new InstructorDashboardDto();
            }
        }

        /// <summary>
        /// Retrieves the instructor revenue data from the API for a given period
        /// </summary>
        public async Task<InstructorRevenueDto> GetInstructorRevenueAsync(string period, CancellationToken cancellationToken = default)
        {
            const string methodName = nameof(GetInstructorRevenueAsync);

            try
            {
                var safePeriod = string.IsNullOrWhiteSpace(period) ? "month" : period;

                _logger.LogInformation("Retrieving instructor revenue from API for period {Period}", safePeriod);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"instructor/dashboard/revenue?period={Uri.EscapeDataString(safePeriod)}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    var revenue = JsonConvert.DeserializeObject<InstructorRevenueDto>(content);

                    _logger.LogInformation("Successfully retrieved instructor revenue");
                    return revenue ?? new InstructorRevenueDto();
                }

                _logger.LogWarning("Failed to get instructor revenue. Status code: {StatusCode}", response.StatusCode);
                return new InstructorRevenueDto();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {MethodName} was cancelled", methodName);
                return new InstructorRevenueDto();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching instructor revenue");
                return new InstructorRevenueDto();
            }
        }

        /// <summary>
        /// Retrieves the public site statistics from the API
        /// </summary>
        public async Task<SiteStatsDto> GetPublicStatsAsync(CancellationToken cancellationToken = default)
        {
            const string methodName = nameof(GetPublicStatsAsync);

            try
            {
                _logger.LogInformation("Retrieving public site stats from API");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("public/stats", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    var stats = JsonConvert.DeserializeObject<SiteStatsDto>(content);

                    _logger.LogInformation("Successfully retrieved public site stats");
                    return stats ?? new SiteStatsDto();
                }

                _logger.LogWarning("Failed to get public site stats. Status code: {StatusCode}", response.StatusCode);
                return new SiteStatsDto();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {MethodName} was cancelled", methodName);
                return new SiteStatsDto();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching public site stats");
                return new SiteStatsDto();
            }
        }

        /// <summary>
        /// Localizes dashboard notifications using their TitleKey/MessageKey (falls back to raw text)
        /// </summary>
        private void LocalizeNotifications(List<InstructorNotificationItemDto> notifications)
        {
            foreach (var notification in notifications ?? new List<InstructorNotificationItemDto>())
            {
                notification.Title = LocalizeNotificationPart(notification.TitleKey, notification.Title, notification.Parameters);
                notification.Message = LocalizeNotificationPart(notification.MessageKey, notification.Message, notification.Parameters);
            }
        }

        private string LocalizeNotificationPart(string key, string fallback, string parameters)
        {
            if (string.IsNullOrEmpty(key))
                return fallback ?? string.Empty;

            var template = _localizer[key]?.Value;
            if (string.IsNullOrEmpty(template) || template == key)
                return fallback ?? string.Empty;

            if (string.IsNullOrEmpty(parameters))
                return template;

            try
            {
                var dict = JsonConvert.DeserializeObject<Dictionary<string, object>>(parameters);
                if (dict == null || dict.Count == 0)
                    return template;

                var args = dict.Values.ToArray();

                var maxIndex = 0;
                foreach (System.Text.RegularExpressions.Match m in System.Text.RegularExpressions.Regex.Matches(template, @"\{(\d+)\}"))
                    maxIndex = Math.Max(maxIndex, int.Parse(m.Groups[1].Value));

                if (maxIndex >= args.Length)
                {
                    var padded = new object[maxIndex + 1];
                    Array.Copy(args, padded, args.Length);
                    for (int i = args.Length; i <= maxIndex; i++) padded[i] = "";
                    args = padded;
                }

                return string.Format(template, args);
            }
            catch
            {
                return fallback ?? string.Empty;
            }
        }
    }
}
