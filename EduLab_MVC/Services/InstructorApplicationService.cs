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

        public InstructorApplicationService(
            ILogger<InstructorApplicationService> logger,
            AuthorizedHttpClientService httpClientService)
        {
            _logger = logger;
            _httpClientService = httpClientService;
        }

        #region ============= User Endpoints =============

        // ---------- Apply (Submit Application) ----------
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
                        formData.Add(new StringContent(skill), "Skills");
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

                // read error
                var errorContent = await response.Content.ReadAsStringAsync();
                _logger.LogWarning("API Error: {Error}", errorContent);
                return $"فشل: {errorContent}";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء تقديم طلب مدرب");
                return "حدث خطأ غير متوقع أثناء تقديم الطلب.";
            }
        }

        // ---------- Get My Applications ----------
        // ---------- Get My Applications ----------
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
                var applications = JsonConvert.DeserializeObject<List<InstructorApplicationResponseDto>>(content);

                if (applications != null)
                {
                    foreach (var app in applications)
                    {
                        if (!string.IsNullOrEmpty(app.CvUrl) &&
                            !app.CvUrl.StartsWith("https"))
                        {
                            app.CvUrl = "https://localhost:7292" + app.CvUrl;
                        }
                    }
                }

                return applications;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء جلب الطلبات الخاصة بالمستخدم");
                return null;
            }
        }

        // ---------- Get Application Details (User) ----------
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
                var application = JsonConvert.DeserializeObject<InstructorApplicationResponseDto>(content);

                if (application != null && !string.IsNullOrEmpty(application.CvUrl) &&
                    !application.CvUrl.StartsWith("https"))
                {
                    application.CvUrl = "https://localhost:7292" + application.CvUrl;
                }

                return application;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء جلب تفاصيل الطلب");
                return null;
            }
        }


        #endregion

        #region ============= Admin Endpoints =============

        // ---------- Get All Applications ----------
        public async Task<List<AdminInstructorApplicationDto>?> GetAllApplicationsAsync()
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("InstructorApplications");

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning($"فشل في جلب كل الطلبات. StatusCode: {response.StatusCode}");
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                var applications = JsonConvert.DeserializeObject<List<AdminInstructorApplicationDto>>(content);

                if (applications != null)
                {
                    foreach (var app in applications)
                    {
                        // معالجة الصورة
                        if (!string.IsNullOrEmpty(app.ProfileImageUrl) &&
                            !app.ProfileImageUrl.StartsWith("https"))
                        {
                            app.ProfileImageUrl = "https://localhost:7292" + app.ProfileImageUrl;
                        }

                        // معالجة الـ CV
                        if (!string.IsNullOrEmpty(app.CvUrl) &&
                            !app.CvUrl.StartsWith("https"))
                        {
                            app.CvUrl = "https://localhost:7292" + app.CvUrl;
                        }
                    }
                }

                return applications;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء جلب كل الطلبات (Admin)");
                return null;
            }
        }



        // ---------- Get Application Details ----------
        public async Task<AdminInstructorApplicationDto?> GetApplicationDetailsAdminAsync(string id)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"InstructorApplications/{id}");

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning($"فشل في جلب تفاصيل الطلب (Admin). StatusCode: {response.StatusCode}");
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                var application = JsonConvert.DeserializeObject<AdminInstructorApplicationDto>(content);

                if (application != null)
                {
                    // معالجة الصورة
                    if (!string.IsNullOrEmpty(application.ProfileImageUrl) &&
                        !application.ProfileImageUrl.StartsWith("https"))
                    {
                        application.ProfileImageUrl = "https://localhost:7292" + application.ProfileImageUrl;
                    }

                    // معالجة الـ CV
                    if (!string.IsNullOrEmpty(application.CvUrl) &&
                        !application.CvUrl.StartsWith("https"))
                    {
                        application.CvUrl = "https://localhost:7292" + application.CvUrl;
                    }
                }

                return application;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء جلب تفاصيل الطلب (Admin)");
                return null;
            }
        }


        // ---------- Approve ----------
        public async Task<string> ApproveApplicationAsync(string id)
        {
            return await ProcessApplicationAsync(id, "approve", "تم قبول الطلب");
        }

        // ---------- Reject ----------
        public async Task<string> RejectApplicationAsync(string id)
        {
            return await ProcessApplicationAsync(id, "reject", "تم رفض الطلب");
        }

        // ---------- Helper Method ----------
        private async Task<string> ProcessApplicationAsync(string id, string action, string defaultMessage)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.PutAsync($"InstructorApplications/{id}/{action}", null);

                var content = await response.Content.ReadAsStringAsync();

                if (response.IsSuccessStatusCode)
                {
                    try
                    {
                        var json = JsonConvert.DeserializeObject<dynamic>(content);

                        // تحويل skills من string JSON إلى List<string> لو موجود
                        List<string>? skillsArray = null;
                        if (json.skills != null)
                        {
                            skillsArray = JsonConvert.DeserializeObject<List<string>>(json.skills.ToString());
                        }

                        // بناء نص للعرض في view
                        string skillsText = skillsArray != null ? $" المهارات: {string.Join(", ", skillsArray)}" : string.Empty;
                        string reviewedBy = json.reviewedBy ?? "";
                        string reviewedDate = json.reviewedDate != null ? DateTime.Parse(json.reviewedDate.ToString()).ToString("yyyy-MM-dd HH:mm") : "";

                        return $"{defaultMessage} من قبل {reviewedBy} بتاريخ {reviewedDate}{skillsText}";
                    }
                    catch
                    {
                        // لو مش JSON صالح
                        return content ?? defaultMessage;
                    }
                }
                else
                {
                    return $"فشل: {content}";
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"خطأ أثناء معالجة الطلب ({action})");
                return $"حدث خطأ أثناء {defaultMessage.ToLower()}";
            }
        }

        #endregion

    }
}
