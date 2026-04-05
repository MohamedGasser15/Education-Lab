using EduLab_MVC.Models.DTOs.Profile;
using EduLab_MVC.Services.ServiceInterfaces;
using Newtonsoft.Json;
using System.IdentityModel.Tokens.Jwt;
using System.Net.Http.Headers;
using System.Text;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// Service for managing user profiles in MVC application
    /// </summary>
    public class ProfileService : IProfileService
    {
        #region Fields
        private readonly ILogger<ProfileService> _logger;
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly IHttpContextAccessor _httpContextAccessor;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the ProfileService class
        /// </summary>
        /// <param name="logger">Logger instance</param>
        /// <param name="httpClientService">HTTP client service instance</param>
        /// <param name="httpContextAccessor">HTTP context accessor instance</param>
        public ProfileService(
            ILogger<ProfileService> logger,
            IAuthorizedHttpClientService httpClientService,
            IHttpContextAccessor httpContextAccessor)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _httpClientService = httpClientService ?? throw new ArgumentNullException(nameof(httpClientService));
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
        }
        #endregion

        #region User Profile Operations
        /// <summary>
        /// Retrieves the current user's profile
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The user profile if found, otherwise null</returns>
        public async Task<ProfileDTO?> GetProfileAsync(CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetProfileAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("profile", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to get profile. StatusCode: {StatusCode}", response.StatusCode);
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                var profile = JsonConvert.DeserializeObject<ProfileDTO>(content);

                if (profile != null && !string.IsNullOrEmpty(profile.ProfileImageUrl) && !profile.ProfileImageUrl.StartsWith("https"))
                {
                    profile.ProfileImageUrl = "https://localhost:7292" + profile.ProfileImageUrl;
                }

                _logger.LogInformation("Successfully retrieved profile");
                return profile;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return null;
            }
        }

        /// <summary>
        /// Updates the current user's profile
        /// </summary>
        /// <param name="updateProfileDto">The profile data to update</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if update was successful, otherwise false</returns>
        public async Task<bool> UpdateProfileAsync(UpdateProfileDTO updateProfileDto, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(UpdateProfileAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, updateProfileDto.Id);

                var client = _httpClientService.CreateClient();
                var jsonContent = new StringContent(
                    JsonConvert.SerializeObject(updateProfileDto),
                    Encoding.UTF8,
                    "application/json");

                var response = await client.PutAsync("profile", jsonContent, cancellationToken);

                var success = response.IsSuccessStatusCode;
                _logger.LogInformation("Profile update {Status} for user ID: {UserId}",
                    success ? "succeeded" : "failed", updateProfileDto.Id);

                return success;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, updateProfileDto.Id);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, updateProfileDto.Id);
                return false;
            }
        }

        /// <summary>
        /// Retrieves a public instructor profile
        /// </summary>
        /// <param name="instructorId">The instructor ID</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The public instructor profile if found, otherwise null</returns>
        public async Task<InstructorProfileDTO?> GetPublicInstructorProfileAsync(string instructorId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetPublicInstructorProfileAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName} for instructor ID: {InstructorId}", operationName, instructorId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"profile/public/instructor/{instructorId}", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to get public instructor profile. StatusCode: {StatusCode}", response.StatusCode);
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                var profile = JsonConvert.DeserializeObject<InstructorProfileDTO>(content);

                if (profile != null)
                {
                    // Process profile image URL
                    if (!string.IsNullOrEmpty(profile.ProfileImageUrl) &&
                        !profile.ProfileImageUrl.StartsWith("http", StringComparison.OrdinalIgnoreCase))
                    {
                        profile.ProfileImageUrl = $"https://localhost:7292{profile.ProfileImageUrl}";
                    }

                    // Process course thumbnail URLs
                    if (profile.Courses != null)
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

                _logger.LogInformation("Successfully retrieved public instructor profile for ID: {InstructorId}", instructorId);
                return profile;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for instructor ID: {InstructorId}", operationName, instructorId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for instructor ID: {InstructorId}", operationName, instructorId);
                return null;
            }
        }

        /// <summary>
        /// Uploads a profile image for the current user
        /// </summary>
        /// <param name="imageFile">The image file to upload</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The URL of the uploaded image if successful, otherwise null</returns>
        public async Task<string?> UploadProfileImageAsync(IFormFile imageFile, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(UploadProfileImageAsync);

            var userId = GetCurrentUserId();
            if (string.IsNullOrEmpty(userId) || imageFile == null || imageFile.Length == 0)
            {
                _logger.LogWarning("No image file provided or user ID is empty in {OperationName}", operationName);
                return null;
            }

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var client = _httpClientService.CreateClient();
                using var formData = new MultipartFormDataContent();
                using var fileContent = new StreamContent(imageFile.OpenReadStream());

                fileContent.Headers.ContentType = MediaTypeHeaderValue.Parse(imageFile.ContentType);
                formData.Add(fileContent, "ImageFile", imageFile.FileName);
                formData.Add(new StringContent(userId), "UserId");

                var response = await client.PostAsync("profile/upload-image", formData, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadAsStringAsync();
                    var json = JsonConvert.DeserializeObject<dynamic>(result);
                    var imageUrl = json?.imageUrl;

                    return imageUrl;
                }

                _logger.LogWarning("Failed to upload profile image. StatusCode: {StatusCode}", response.StatusCode);
                return null;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, userId);
                return null;
            }
        }
        #endregion

        #region Instructor Profile Operations
        /// <summary>
        /// Retrieves the current instructor's profile
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The instructor profile if found, otherwise null</returns>
        public async Task<InstructorProfileDTO?> GetInstructorProfileAsync(CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetInstructorProfileAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("profile/instructor", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to get instructor profile. StatusCode: {StatusCode}", response.StatusCode);
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                var profile = JsonConvert.DeserializeObject<InstructorProfileDTO>(content);

                if (profile != null)
                {
                    // Process profile image URL
                    if (!string.IsNullOrEmpty(profile.ProfileImageUrl) &&
                        !profile.ProfileImageUrl.StartsWith("http", StringComparison.OrdinalIgnoreCase))
                    {
                        profile.ProfileImageUrl = $"https://localhost:7292{profile.ProfileImageUrl}";
                    }

                    // Process course thumbnail URLs
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

                _logger.LogInformation("Successfully retrieved instructor profile");
                return profile;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return null;
            }
        }

        /// <summary>
        /// Updates the current instructor's profile
        /// </summary>
        /// <param name="updateProfileDto">The instructor profile data to update</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if update was successful, otherwise false</returns>
        public async Task<bool> UpdateInstructorProfileAsync(UpdateInstructorProfileDTO updateProfileDto, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(UpdateInstructorProfileAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, updateProfileDto.Id);

                var client = _httpClientService.CreateClient();
                var jsonContent = new StringContent(
                    JsonConvert.SerializeObject(updateProfileDto),
                    Encoding.UTF8,
                    "application/json");

                var response = await client.PutAsync("profile/instructor", jsonContent, cancellationToken);

                var success = response.IsSuccessStatusCode;
                _logger.LogInformation("Instructor profile update {Status} for user ID: {UserId}",
                    success ? "succeeded" : "failed", updateProfileDto.Id);

                return success;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, updateProfileDto.Id);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, updateProfileDto.Id);
                return false;
            }
        }

        /// <summary>
        /// Uploads a profile image for the current instructor
        /// </summary>
        /// <param name="imageFile">The image file to upload</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The URL of the uploaded image if successful, otherwise null</returns>
        public async Task<string?> UploadInstructorProfileImageAsync(IFormFile imageFile, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(UploadInstructorProfileImageAsync);

            var userId = GetCurrentUserId();
            if (string.IsNullOrEmpty(userId) || imageFile == null || imageFile.Length == 0)
            {
                _logger.LogWarning("No image file provided or user ID is empty in {OperationName}", operationName);
                return null;
            }

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var client = _httpClientService.CreateClient();
                using var formData = new MultipartFormDataContent();
                using var fileContent = new StreamContent(imageFile.OpenReadStream());

                fileContent.Headers.ContentType = MediaTypeHeaderValue.Parse(imageFile.ContentType);
                formData.Add(fileContent, "ImageFile", imageFile.FileName);
                formData.Add(new StringContent(userId), "UserId");

                var response = await client.PostAsync("profile/instructor/upload-image", formData, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadAsStringAsync();
                    var json = JsonConvert.DeserializeObject<dynamic>(result);
                    var imageUrl = json?.imageUrl;

                    return imageUrl;
                }

                _logger.LogWarning("Failed to upload instructor profile image. StatusCode: {StatusCode}", response.StatusCode);
                return null;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, userId);
                return null;
            }
        }
        #endregion

        #region Certificate Operations
        /// <summary>
        /// Adds a new certificate for the current instructor
        /// </summary>
        /// <param name="certificateDto">The certificate data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The added certificate if successful, otherwise null</returns>
        public async Task<CertificateDTO?> AddCertificateAsync(CertificateDTO certificateDto, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(AddCertificateAsync);

            var userId = GetCurrentUserId();
            if (string.IsNullOrEmpty(userId) || certificateDto == null)
            {
                _logger.LogWarning("Certificate DTO is null or user ID is empty in {OperationName}", operationName);
                return null;
            }

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                var client = _httpClientService.CreateClient();
                var jsonContent = new StringContent(
                    JsonConvert.SerializeObject(certificateDto),
                    Encoding.UTF8,
                    "application/json");

                var response = await client.PostAsync("profile/certificates", jsonContent, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to add certificate. StatusCode: {StatusCode}", response.StatusCode);
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                var addedCertificate = JsonConvert.DeserializeObject<CertificateDTO>(content);

                _logger.LogInformation("Successfully added certificate for user ID: {UserId}. Certificate ID: {CertificateId}",
                    userId, addedCertificate?.Id);

                return addedCertificate;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, userId);
                return null;
            }
        }

        /// <summary>
        /// Deletes a certificate for the current instructor
        /// </summary>
        /// <param name="certId">The certificate ID</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if deletion was successful, otherwise false</returns>
        public async Task<bool> DeleteCertificateAsync(int certId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(DeleteCertificateAsync);

            var userId = GetCurrentUserId();
            if (string.IsNullOrEmpty(userId))
            {
                _logger.LogWarning("User ID is empty in {OperationName}", operationName);
                return false;
            }

            try
            {
                _logger.LogDebug("Starting {OperationName} for certificate ID: {CertificateId}, user ID: {UserId}",
                    operationName, certId, userId);

                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync($"profile/certificates/{certId}", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to delete certificate. StatusCode: {StatusCode}", response.StatusCode);
                    return false;
                }

                _logger.LogInformation("Successfully deleted certificate ID: {CertificateId} for user ID: {UserId}", certId, userId);
                return true;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for certificate ID: {CertificateId}", operationName, certId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for certificate ID: {CertificateId}", operationName, certId);
                return false;
            }
        }
        #endregion

        #region Helper Methods
        /// <summary>
        /// Gets the current user ID from the authentication token
        /// </summary>
        /// <returns>The current user ID if found, otherwise null</returns>
        private string? GetCurrentUserId()
        {
            try
            {
                var token = _httpContextAccessor.HttpContext?.Request.Cookies["AuthToken"];
                if (string.IsNullOrEmpty(token))
                {
                    _logger.LogWarning("Auth token not found in cookies");
                    return null;
                }

                var handler = new JwtSecurityTokenHandler();
                var jwtToken = handler.ReadJwtToken(token);
                return jwtToken.Claims.FirstOrDefault(c => c.Type == "sub")?.Value;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting current user ID");
                return null;
            }
        }
        #endregion
    }
}