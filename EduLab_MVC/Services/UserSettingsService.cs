using EduLab_MVC.Models.DTOs.Settings;
using EduLab_MVC.Services.Helper_Services;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Text;

namespace EduLab_MVC.Services
{
    public class UserSettingsService
    {
        private readonly ILogger<UserSettingsService> _logger;
        private readonly AuthorizedHttpClientService _httpClientService;

        public UserSettingsService(ILogger<UserSettingsService> logger, AuthorizedHttpClientService httpClientService)
        {
            _logger = logger;
            _httpClientService = httpClientService;
        }

        public async Task<GeneralSettingsDTO?> GetGeneralSettingsAsync()
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("settings/general");

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning($"فشل في جلب الإعدادات العامة. StatusCode: {response.StatusCode}");
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                return JsonConvert.DeserializeObject<GeneralSettingsDTO>(content);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء جلب الإعدادات العامة");
                return null;
            }
        }

        public async Task<bool> UpdateGeneralSettingsAsync(GeneralSettingsDTO settings)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var jsonContent = new StringContent(JsonConvert.SerializeObject(settings), Encoding.UTF8, "application/json");

                var response = await client.PutAsync("settings/general", jsonContent);

                if (!response.IsSuccessStatusCode)
                    _logger.LogWarning($"فشل تحديث الإعدادات. StatusCode: {response.StatusCode}");

                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء تحديث الإعدادات العامة");
                return false;
            }
        }

        public async Task<bool> ChangePasswordAsync(ChangePasswordDTO changePassword)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var jsonContent = new StringContent(JsonConvert.SerializeObject(changePassword), Encoding.UTF8, "application/json");

                var response = await client.PostAsync("settings/change-password", jsonContent);

                if (!response.IsSuccessStatusCode)
                    _logger.LogWarning($"فشل تغيير كلمة المرور. StatusCode: {response.StatusCode}");

                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء تغيير كلمة المرور");
                return false;
            }
        }

        public async Task<List<ActiveSessionDTO>> GetActiveSessionsAsync()
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("settings/active-sessions");

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning($"فشل جلب الجلسات النشطة. StatusCode: {response.StatusCode}");
                    return new List<ActiveSessionDTO>();
                }

                var content = await response.Content.ReadAsStringAsync();
                return JsonConvert.DeserializeObject<List<ActiveSessionDTO>>(content) ?? new List<ActiveSessionDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء جلب الجلسات النشطة");
                return new List<ActiveSessionDTO>();
            }
        }

        public async Task<bool> RevokeSessionAsync(Guid sessionId)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.PostAsync($"settings/active-sessions/revoke/{sessionId}", null);

                if (!response.IsSuccessStatusCode)
                    _logger.LogWarning($"فشل إنهاء الجلسة. StatusCode: {response.StatusCode}");

                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء إنهاء الجلسة");
                return false;
            }
        }

        public async Task<bool> RevokeAllSessionsAsync()
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.PostAsync("settings/active-sessions/revoke-all", null);

                if (!response.IsSuccessStatusCode)
                    _logger.LogWarning($"فشل إنهاء جميع الجلسات. StatusCode: {response.StatusCode}");

                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء إنهاء جميع الجلسات");
                return false;
            }
        }

        public async Task<TwoFactorSetupDTO?> GetTwoFactorSetupAsync()
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("settings/two-factor/setup");

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning($"فشل جلب إعدادات المصادقة الثنائية. StatusCode: {response.StatusCode}");
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                return JsonConvert.DeserializeObject<TwoFactorSetupDTO>(content);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء جلب إعدادات المصادقة الثنائية");
                return null;
            }
        }

        public async Task<bool> EnableTwoFactorAsync(TwoFactorDTO twoFactor)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var jsonContent = new StringContent(JsonConvert.SerializeObject(twoFactor), Encoding.UTF8, "application/json");

                var response = await client.PostAsync("settings/two-factor/enable", jsonContent);

                if (!response.IsSuccessStatusCode)
                    _logger.LogWarning($"فشل تفعيل المصادقة الثنائية. StatusCode: {response.StatusCode}");

                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء تفعيل المصادقة الثنائية");
                return false;
            }
        }

        public async Task<bool> DisableTwoFactorAsync()
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.PostAsync("settings/two-factor/disable", null);

                if (!response.IsSuccessStatusCode)
                    _logger.LogWarning($"فشل تعطيل المصادقة الثنائية. StatusCode: {response.StatusCode}");

                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء تعطيل المصادقة الثنائية");
                return false;
            }
        }
        public async Task<bool> IsTwoFactorEnabledAsync()
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("settings/two-factor/status");

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning($"فشل في التحقق من حالة المصادقة الثنائية. StatusCode: {response.StatusCode}");
                    return false;
                }

                var content = await response.Content.ReadAsStringAsync();
                return JsonConvert.DeserializeObject<bool>(content);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء التحقق من حالة المصادقة الثنائية");
                return false;
            }
        }
        public async Task<bool> VerifyTwoFactorCodeAsync(string code)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var jsonContent = new StringContent(JsonConvert.SerializeObject(new { code }), Encoding.UTF8, "application/json");

                var response = await client.PostAsync("settings/two-factor/verify", jsonContent);

                if (!response.IsSuccessStatusCode)
                    _logger.LogWarning($"فشل التحقق من رمز المصادقة الثنائية. StatusCode: {response.StatusCode}");

                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء التحقق من رمز المصادقة الثنائية");
                return false;
            }
        }
    }
}
