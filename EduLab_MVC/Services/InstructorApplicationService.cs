using EduLab_MVC.Models.DTOs.Instructor;
using EduLab_MVC.Services.Helper_Services;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;

namespace EduLab_MVC.Services
{
    public class InstructorApplicationService
    {
        private readonly ILogger<InstructorApplicationService> _logger;
        private readonly AuthorizedHttpClientService _httpClientService;

        public InstructorApplicationService(ILogger<InstructorApplicationService> logger, AuthorizedHttpClientService httpClientService)
        {
            _logger = logger;
            _httpClientService = httpClientService;
        }

        // ============= Apply (Submit Application) =============
        public async Task<string> ApplyAsync(InstructorApplicationDTO dto)
        {
            try
            {
                var client = _httpClientService.CreateClient();

                using var formData = new MultipartFormDataContent();

                formData.Add(new StringContent(dto.FullName ?? ""), "FullName");
                formData.Add(new StringContent(dto.Phone ?? ""), "Phone");
                formData.Add(new StringContent(dto.Bio ?? ""), "Bio");
                formData.Add(new StringContent(dto.Specialization ?? ""), "Specialization");
                formData.Add(new StringContent(dto.Experience ?? ""), "Experience");

                if (dto.Skills != null && dto.Skills.Any())
                {
                    foreach (var skill in dto.Skills)
                    {
                        formData.Add(new StringContent(skill), "Skills");
                    }
                }

                if (dto.ProfileImage != null)
                {
                    var profileImageContent = new StreamContent(dto.ProfileImage.OpenReadStream());
                    profileImageContent.Headers.ContentType = MediaTypeHeaderValue.Parse(dto.ProfileImage.ContentType);
                    formData.Add(profileImageContent, "ProfileImage", dto.ProfileImage.FileName);
                }

                if (dto.CvFile != null)
                {
                    var cvContent = new StreamContent(dto.CvFile.OpenReadStream());
                    cvContent.Headers.ContentType = MediaTypeHeaderValue.Parse(dto.CvFile.ContentType);
                    formData.Add(cvContent, "CvFile", dto.CvFile.FileName);
                }

                var response = await client.PostAsync("InstructorApplication/apply", formData);

                var result = await response.Content.ReadAsStringAsync();
                if (response.IsSuccessStatusCode)
                {
                    return JsonConvert.DeserializeObject<dynamic>(result)?.message ?? "تم تقديم الطلب بنجاح.";
                }
                if (!response.IsSuccessStatusCode)
                {
                    // اقرا الـ body اللي فيه التفاصيل
                    var errorContent = await response.Content.ReadAsStringAsync();

                    try
                    {
                        // جرب تشوف لو فيه ModelState Errors
                        var errorObj = JsonConvert.DeserializeObject<Dictionary<string, object>>(errorContent);
                        if (errorObj != null && errorObj.ContainsKey("errors"))
                        {
                            var errors = errorObj["errors"].ToString();
                            _logger.LogWarning("Validation errors: {Errors}", errors);
                            return $"فشل: {errors}";
                        }
                    }
                    catch
                    {
                        // لو مش json (ممكن plain text)
                        _logger.LogWarning("API Error: {Error}", errorContent);
                        return $"فشل: {errorContent}";
                    }
                }
                return JsonConvert.DeserializeObject<dynamic>(result)?.message ?? "فشل في تقديم الطلب.";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء تقديم طلب مدرب");
                return "حدث خطأ غير متوقع أثناء تقديم الطلب.";
            }
        }

        // ============= Get My Applications =============
        public async Task<List<InstructorApplicationResponseDto>?> GetMyApplicationsAsync()
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("InstructorApplication/my-applications");

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning($"فشل في جلب الطلبات. StatusCode: {response.StatusCode}");
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                return JsonConvert.DeserializeObject<List<InstructorApplicationResponseDto>>(content);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء جلب الطلبات الخاصة بالمستخدم");
                return null;
            }
        }

        // ============= Get Application Details =============
        public async Task<InstructorApplicationResponseDto?> GetApplicationDetailsAsync(string id)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"InstructorApplication/application-details/{id}");

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning($"فشل في جلب تفاصيل الطلب. StatusCode: {response.StatusCode}");
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                return JsonConvert.DeserializeObject<InstructorApplicationResponseDto>(content);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء جلب تفاصيل الطلب");
                return null;
            }
        }
    }
}
