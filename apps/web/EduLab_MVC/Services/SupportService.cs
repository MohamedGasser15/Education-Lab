using EduLab_MVC.Models.DTOs.Support;
using EduLab_MVC.Services.ServiceInterfaces;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// MVC service for the real-time support system (proxies the support API)
    /// </summary>
    public class SupportService : ISupportService
    {
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly ILogger<SupportService> _logger;

        public SupportService(
            IAuthorizedHttpClientService httpClientService,
            ILogger<SupportService> logger)
        {
            _httpClientService = httpClientService;
            _logger = logger;
        }

        #region User Side

        public async Task<List<SupportConversationDto>> GetUserConversationsAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("support/conversations", cancellationToken);
                if (!response.IsSuccessStatusCode) return new List<SupportConversationDto>();

                var content = await response.Content.ReadAsStringAsync(cancellationToken);
                return JsonConvert.DeserializeObject<List<SupportConversationDto>>(content) ?? new List<SupportConversationDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting user conversations");
                return new List<SupportConversationDto>();
            }
        }

        public async Task<SupportConversationDto> CreateConversationAsync(string subject, string message, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(new CreateConversationRequest { Subject = subject, Message = message });
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync("support/conversations", content, cancellationToken);
                if (!response.IsSuccessStatusCode) return null;

                var responseContent = await response.Content.ReadAsStringAsync(cancellationToken);
                return JsonConvert.DeserializeObject<SupportConversationDto>(responseContent);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating conversation");
                return null;
            }
        }

        public async Task<List<SupportMessageDto>> GetConversationMessagesAsync(int conversationId, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"support/conversations/{conversationId}/messages", cancellationToken);
                if (!response.IsSuccessStatusCode) return new List<SupportMessageDto>();

                var content = await response.Content.ReadAsStringAsync(cancellationToken);
                return JsonConvert.DeserializeObject<List<SupportMessageDto>>(content) ?? new List<SupportMessageDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting conversation messages");
                return new List<SupportMessageDto>();
            }
        }

        public async Task<SupportMessageDto> SendUserMessageAsync(int conversationId, string content, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(new SendSupportMessageRequest { Content = content });
                var payload = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync($"support/conversations/{conversationId}/messages", payload, cancellationToken);
                if (!response.IsSuccessStatusCode) return null;

                var responseContent = await response.Content.ReadAsStringAsync(cancellationToken);
                return JsonConvert.DeserializeObject<SupportMessageDto>(responseContent);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending user message");
                return null;
            }
        }

        public async Task<bool> CloseConversationAsync(int conversationId, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.PostAsync($"support/conversations/{conversationId}/close", null, cancellationToken);
                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error closing conversation");
                return false;
            }
        }

        public async Task<bool> ReopenConversationAsync(int conversationId, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.PostAsync($"support/conversations/{conversationId}/reopen", null, cancellationToken);
                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error reopening conversation");
                return false;
            }
        }

        public async Task<int> GetUserUnreadCountAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("support/unread-count", cancellationToken);
                if (!response.IsSuccessStatusCode) return 0;

                var content = await response.Content.ReadAsStringAsync(cancellationToken);
                return JsonConvert.DeserializeObject<int>(content);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting user unread count");
                return 0;
            }
        }

        #endregion

        #region Admin Side

        public async Task<List<AdminSupportConversationDto>> GetAllConversationsAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("admin/support/conversations", cancellationToken);
                if (!response.IsSuccessStatusCode) return new List<AdminSupportConversationDto>();

                var content = await response.Content.ReadAsStringAsync(cancellationToken);
                return JsonConvert.DeserializeObject<List<AdminSupportConversationDto>>(content) ?? new List<AdminSupportConversationDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting all conversations");
                return new List<AdminSupportConversationDto>();
            }
        }

        public async Task<AdminSupportConversationDetailDto> GetConversationDetailAsync(int conversationId, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"admin/support/conversations/{conversationId}", cancellationToken);
                if (!response.IsSuccessStatusCode) return null;

                var content = await response.Content.ReadAsStringAsync(cancellationToken);
                return JsonConvert.DeserializeObject<AdminSupportConversationDetailDto>(content);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting conversation detail");
                return null;
            }
        }

        public async Task<SupportMessageDto> SendAgentMessageAsync(int conversationId, string content, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(new SendSupportMessageRequest { Content = content });
                var payload = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync($"admin/support/conversations/{conversationId}/messages", payload, cancellationToken);
                if (!response.IsSuccessStatusCode) return null;

                var responseContent = await response.Content.ReadAsStringAsync(cancellationToken);
                return JsonConvert.DeserializeObject<SupportMessageDto>(responseContent);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending agent message");
                return null;
            }
        }

        public async Task<bool> SetConversationStatusAsync(int conversationId, bool open, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(new { open });
                var payload = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync($"admin/support/conversations/{conversationId}/status", payload, cancellationToken);
                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error setting conversation status");
                return false;
            }
        }

        public async Task<int> GetAgentUnreadCountAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("admin/support/unread-count", cancellationToken);
                if (!response.IsSuccessStatusCode) return 0;

                var content = await response.Content.ReadAsStringAsync(cancellationToken);
                return JsonConvert.DeserializeObject<int>(content);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting agent unread count");
                return 0;
            }
        }

        public async Task<int> MarkAllReadAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.PostAsync("admin/support/mark-all-read", null, cancellationToken);
                if (!response.IsSuccessStatusCode) return 0;

                var content = await response.Content.ReadAsStringAsync(cancellationToken);
                return JsonConvert.DeserializeObject<int>(content);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking all conversations read");
                return 0;
            }
        }

        #endregion
    }
}
