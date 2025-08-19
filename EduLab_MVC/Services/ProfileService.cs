using EduLab_MVC.Models.DTOs.Profile;
using EduLab_MVC.Services.Helper_Services;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.IdentityModel.Tokens.Jwt;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;

namespace EduLab_MVC.Services
{
    public class ProfileService
    {
        private readonly ILogger<ProfileService> _logger;
        private readonly AuthorizedHttpClientService _httpClientService;
        private readonly IHttpContextAccessor _httpContextAccessor;
        public ProfileService(ILogger<ProfileService> logger, AuthorizedHttpClientService httpClientService, IHttpContextAccessor httpContextAccessor)
        {
            _logger = logger;
            _httpClientService = httpClientService;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<ProfileDTO?> GetProfileAsync()
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("profile");

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning($"فشل في الحصول على البروفايل. StatusCode: {response.StatusCode}");
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                var profile = JsonConvert.DeserializeObject<ProfileDTO>(content);

                // تعديل رابط الصورة لو مش رابط كامل
                if (profile != null && !string.IsNullOrEmpty(profile.ProfileImageUrl) && !profile.ProfileImageUrl.StartsWith("https"))
                {
                    profile.ProfileImageUrl = "https://localhost:7292" + profile.ProfileImageUrl;
                }

                return profile;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء جلب البروفايل");
                return null;
            }
        }


        public async Task<bool> UpdateProfileAsync(UpdateProfileDTO updateProfileDto)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var jsonContent = new StringContent(JsonConvert.SerializeObject(updateProfileDto), Encoding.UTF8, "application/json");

                var response = await client.PutAsync("profile", jsonContent);

                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء تحديث البروفايل");
                return false;
            }
        }

        public async Task<string?> UploadProfileImageAsync(IFormFile imageFile)
        {
            if (imageFile == null || imageFile.Length == 0)
            {
                _logger.LogWarning("لم يتم رفع صورة (imageFile فارغ)");
                return null;
            }

            // جلب التوكن من الكوكيز
            var token = _httpContextAccessor.HttpContext?.Request.Cookies["AuthToken"];
            if (string.IsNullOrEmpty(token))
            {
                _logger.LogWarning("AuthToken فارغ");
                return null;
            }

            // استخراج userId من التوكن
            var handler = new JwtSecurityTokenHandler();
            var jwtToken = handler.ReadJwtToken(token);
            var userId = jwtToken.Claims.FirstOrDefault(c => c.Type == "sub")?.Value; // غالبًا الـ userId بيكون في claim sub

            if (string.IsNullOrEmpty(userId))
            {
                _logger.LogWarning("UserId فارغ داخل التوكن");
                return null;
            }

            try
            {
                var client = _httpClientService.CreateClient();

                using var formData = new MultipartFormDataContent();
                using var fileContent = new StreamContent(imageFile.OpenReadStream());

                fileContent.Headers.ContentType = MediaTypeHeaderValue.Parse(imageFile.ContentType);
                formData.Add(fileContent, "ImageFile", imageFile.FileName);
                formData.Add(new StringContent(userId), "UserId");

                var response = await client.PostAsync("profile/upload-image", formData);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadAsStringAsync();
                    var json = JsonConvert.DeserializeObject<dynamic>(result);
                    return json?.imageUrl;
                }

                _logger.LogWarning($"فشل رفع الصورة. StatusCode: {response.StatusCode}");
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء رفع صورة البروفايل");
                return null;
            }
        }

    }
}
