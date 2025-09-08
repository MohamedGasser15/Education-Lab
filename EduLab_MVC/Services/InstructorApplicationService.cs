using EduLab_MVC.Models.DTOs.Instructor;
using EduLab_MVC.Services.Helper_Services;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// Service for handling instructor application operations in MVC
    /// </summary>
    public class InstructorApplicationService
    {
        private readonly ILogger<InstructorApplicationService> _logger;
        private readonly AuthorizedHttpClientService _httpClientService;

        /// <summary>
        /// Initializes a new instance of the InstructorApplicationService class
        /// </summary>
        /// <param name="logger">Logger instance</param>
        /// <param name="httpClientService">HTTP client service</param>
        public InstructorApplicationService(
            ILogger<InstructorApplicationService> logger,
            AuthorizedHttpClientService httpClientService)
        {
            _logger = logger;
            _httpClientService = httpClientService;
        }

        #region User Endpoints

        /// <summary>
        /// Submits a new instructor application
        /// </summary>
        /// <param name="dto">Application data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation result message</returns>
        public async Task<string> ApplyAsync(InstructorApplicationDTO dto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Submitting instructor application");

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

                var response = await client.PostAsync("InstructorApplication/apply", formData, cancellationToken);

                var result = await response.Content.ReadAsStringAsync();
                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("Application submitted successfully");
                    return JsonConvert.DeserializeObject<dynamic>(result)?.message ?? "تم تقديم الطلب بنجاح.";
                }

                // read error
                var errorContent = await response.Content.ReadAsStringAsync();
                _logger.LogWarning("API Error: {Error}", errorContent);
                return $"فشل: {errorContent}";
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while submitting application");
                return "تم إلغاء العملية";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء تقديم طلب مدرب");
                return "حدث خطأ غير متوقع أثناء تقديم الطلب.";
            }
        }

        /// <summary>
        /// Gets all applications for the current user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of user applications or null if failed</returns>
        public async Task<List<InstructorApplicationResponseDto>?> GetMyApplicationsAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting user applications");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("InstructorApplication/my-applications", cancellationToken);

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
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while getting user applications");
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء جلب الطلبات الخاصة بالمستخدم");
                return null;
            }
        }

        /// <summary>
        /// Gets application details by ID for the current user
        /// </summary>
        /// <param name="id">Application identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Application details or null if failed</returns>
        public async Task<InstructorApplicationResponseDto?> GetApplicationDetailsAsync(string id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting application details for application {ApplicationId}", id);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"InstructorApplication/application-details/{id}", cancellationToken);

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
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while getting application details for {ApplicationId}", id);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء جلب تفاصيل الطلب");
                return null;
            }
        }

        #endregion

        #region Admin Endpoints

        /// <summary>
        /// Gets all applications for admin review
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of all applications or null if failed</returns>
        public async Task<List<AdminInstructorApplicationDto>?> GetAllApplicationsAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting all applications for admin");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("InstructorApplications", cancellationToken);

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
                        // Process profile image
                        if (!string.IsNullOrEmpty(app.ProfileImageUrl) &&
                            !app.ProfileImageUrl.StartsWith("https"))
                        {
                            app.ProfileImageUrl = "https://localhost:7292" + app.ProfileImageUrl;
                        }

                        // Process CV
                        if (!string.IsNullOrEmpty(app.CvUrl) &&
                            !app.CvUrl.StartsWith("https"))
                        {
                            app.CvUrl = "https://localhost:7292" + app.CvUrl;
                        }
                    }
                }

                return applications;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while getting all applications");
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء جلب كل الطلبات (Admin)");
                return null;
            }
        }

        /// <summary>
        /// Gets application details by ID for admin
        /// </summary>
        /// <param name="id">Application identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Application details or null if failed</returns>
        public async Task<AdminInstructorApplicationDto?> GetApplicationDetailsAdminAsync(string id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting application details for admin for application {ApplicationId}", id);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"InstructorApplications/{id}", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning($"فشل في جلب تفاصيل الطلب (Admin). StatusCode: {response.StatusCode}");
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                var application = JsonConvert.DeserializeObject<AdminInstructorApplicationDto>(content);

                if (application != null)
                {
                    // Process profile image
                    if (!string.IsNullOrEmpty(application.ProfileImageUrl) &&
                        !application.ProfileImageUrl.StartsWith("https"))
                    {
                        application.ProfileImageUrl = "https://localhost:7292" + application.ProfileImageUrl;
                    }

                    // Process CV
                    if (!string.IsNullOrEmpty(application.CvUrl) &&
                        !application.CvUrl.StartsWith("https"))
                    {
                        application.CvUrl = "https://localhost:7292" + application.CvUrl;
                    }
                }

                return application;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while getting application details for admin for {ApplicationId}", id);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ أثناء جلب تفاصيل الطلب (Admin)");
                return null;
            }
        }

        /// <summary>
        /// Approves an instructor application
        /// </summary>
        /// <param name="id">Application identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation result message</returns>
        public async Task<string> ApproveApplicationAsync(string id, CancellationToken cancellationToken = default)
        {
            return await ProcessApplicationAsync(id, "approve", "تم قبول الطلب", cancellationToken);
        }

        /// <summary>
        /// Rejects an instructor application
        /// </summary>
        /// <param name="id">Application identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation result message</returns>
        public async Task<string> RejectApplicationAsync(string id, CancellationToken cancellationToken = default)
        {
            return await ProcessApplicationAsync(id, "reject", "تم رفض الطلب", cancellationToken);
        }

        /// <summary>
        /// Processes an application (approve/reject)
        /// </summary>
        /// <param name="id">Application identifier</param>
        /// <param name="action">Action to perform (approve/reject)</param>
        /// <param name="defaultMessage">Default success message</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation result message</returns>
        private async Task<string> ProcessApplicationAsync(string id, string action, string defaultMessage, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Processing application {ApplicationId} with action {Action}", id, action);

                var client = _httpClientService.CreateClient();
                var response = await client.PutAsync($"InstructorApplications/{id}/{action}", null, cancellationToken);

                var content = await response.Content.ReadAsStringAsync();

                if (response.IsSuccessStatusCode)
                {
                    try
                    {
                        var json = JsonConvert.DeserializeObject<dynamic>(content);

                        // Convert skills from JSON string to List<string> if exists
                        List<string>? skillsArray = null;
                        if (json.skills != null)
                        {
                            skillsArray = JsonConvert.DeserializeObject<List<string>>(json.skills.ToString());
                        }

                        // Build text for display in view
                        string skillsText = skillsArray != null ? $" المهارات: {string.Join(", ", skillsArray)}" : string.Empty;
                        string reviewedBy = json.reviewedBy ?? "";
                        string reviewedDate = json.reviewedDate != null ? DateTime.Parse(json.reviewedDate.ToString()).ToString("yyyy-MM-dd HH:mm") : "";

                        return $"{defaultMessage} من قبل {reviewedBy} بتاريخ {reviewedDate}{skillsText}";
                    }
                    catch
                    {
                        // If not valid JSON
                        return content ?? defaultMessage;
                    }
                }
                else
                {
                    _logger.LogWarning("Failed to process application {ApplicationId}: {Error}", id, content);
                    return $"فشل: {content}";
                }
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation cancelled while processing application {ApplicationId}", id);
                return "تم إلغاء العملية";
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