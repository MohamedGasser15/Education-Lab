using EduLab_Domain.Entities;
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

        // ================= User =================
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
            var userId = GetCurrentUserId();
            if (string.IsNullOrEmpty(userId) || imageFile == null || imageFile.Length == 0)
            {
                _logger.LogWarning("لم يتم رفع صورة أو UserId فارغ");
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

        // ================= Instructor =================
        public async Task<InstructorProfileDTO?> GetInstructorProfileAsync()
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("profile/instructor");

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning($"فشل في الحصول على بروفايل المدرب. StatusCode: {response.StatusCode}");
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                var profile = JsonConvert.DeserializeObject<InstructorProfileDTO>(content);

                if (profile != null)
                {
                    // معالجة صورة البروفايل
                    if (!string.IsNullOrEmpty(profile.ProfileImageUrl) &&
                        !profile.ProfileImageUrl.StartsWith("http", StringComparison.OrdinalIgnoreCase))
                    {
                        profile.ProfileImageUrl = $"https://localhost:7292{profile.ProfileImageUrl}";
                    }

                    // معالجة صور الكورسات
                    if (profile.Courses != null && profile.Courses.Any())
                    {
                        foreach (var course in profile.Courses)
                        {
                            if (!string.IsNullOrEmpty(course.ThumbnailUrl) &&
                                !course.ThumbnailUrl.StartsWith("http", StringComparison.OrdinalIgnoreCase))
                            {
                                course.ThumbnailUrl = $"https://localhost:7292{course.ThumbnailUrl}";
                            }
                        }
                    }
                }

                return profile;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء جلب بروفايل المدرب");
                return null;
            }
        }


        public async Task<bool> UpdateInstructorProfileAsync(UpdateInstructorProfileDTO updateProfileDto)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var jsonContent = new StringContent(JsonConvert.SerializeObject(updateProfileDto), Encoding.UTF8, "application/json");

                var response = await client.PutAsync("profile/instructor", jsonContent);

                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء تحديث بروفايل المدرب");
                return false;
            }
        }

        public async Task<string?> UploadInstructorProfileImageAsync(IFormFile imageFile)
        {
            var userId = GetCurrentUserId();
            if (string.IsNullOrEmpty(userId) || imageFile == null || imageFile.Length == 0)
            {
                _logger.LogWarning("لم يتم رفع صورة أو UserId فارغ");
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

                var response = await client.PostAsync("profile/instructor/upload-image", formData);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadAsStringAsync();
                    var json = JsonConvert.DeserializeObject<dynamic>(result);
                    return json?.imageUrl;
                }

                _logger.LogWarning($"فشل رفع صورة المدرب. StatusCode: {response.StatusCode}");
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء رفع صورة بروفايل المدرب");
                return null;
            }
        }
        // ================= Certificates =================
        public async Task<CertificateDTO?> AddCertificateAsync(CertificateDTO certificateDto)
        {
            var userId = GetCurrentUserId();
            if (string.IsNullOrEmpty(userId) || certificateDto == null)
                return null;

            try
            {
                var client = _httpClientService.CreateClient();
                var jsonContent = new StringContent(JsonConvert.SerializeObject(certificateDto), Encoding.UTF8, "application/json");
                var response = await client.PostAsync("profile/certificates", jsonContent);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning($"فشل في إضافة الشهادة. StatusCode: {response.StatusCode}");
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                var addedCert = JsonConvert.DeserializeObject<CertificateDTO>(content);
                return addedCert;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء إضافة الشهادة");
                return null;
            }
        }

        public async Task<bool> DeleteCertificateAsync(int certId)
        {
            var userId = GetCurrentUserId();
            if (string.IsNullOrEmpty(userId)) return false;

            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync($"profile/certificates/{certId}");

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning($"فشل في حذف الشهادة. StatusCode: {response.StatusCode}");
                    return false;
                }

                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء حذف الشهادة");
                return false;
            }
        }
        // ================= Helper =================
        private string? GetCurrentUserId()
        {
            var token = _httpContextAccessor.HttpContext?.Request.Cookies["AuthToken"];
            if (string.IsNullOrEmpty(token)) return null;

            var handler = new JwtSecurityTokenHandler();
            var jwtToken = handler.ReadJwtToken(token);
            return jwtToken.Claims.FirstOrDefault(c => c.Type == "sub")?.Value;
        }
    }
}
