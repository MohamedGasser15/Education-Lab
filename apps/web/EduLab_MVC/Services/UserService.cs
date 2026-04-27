using EduLab_MVC.Models.DTOs.Auth;
using EduLab_MVC.Models.Response;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System.Text;
using System.Text.Json;

/// <summary>
/// Service for managing user operations including retrieval, update, and deletion
/// </summary>
public class UserService : IUserService
{
    #region Dependencies

    private readonly IHttpClientFactory _clientFactory;
    private readonly ILogger<UserService> _logger;
    private readonly IAuthorizedHttpClientService _httpClientService;
    private readonly string _baseUrl;

    #endregion

    #region Constructor

    public UserService(
        IHttpClientFactory clientFactory,
        ILogger<UserService> logger,
        IAuthorizedHttpClientService httpClientService,
        IConfiguration configuration)
    {
        _clientFactory = clientFactory;
        _logger = logger;
        _httpClientService = httpClientService;
        _baseUrl = configuration["ApiBaseUrl"];
    }

    #endregion

    #region User Retrieval Methods

    public async Task<List<UserDTO>> GetAllUsersAsync()
    {
        try
        {
            _logger.LogInformation("Retrieving all users from API");

            var client = _httpClientService.CreateClient();
            var response = await client.GetAsync("user");

            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                var users = JsonSerializer.Deserialize<List<UserDTO>>(content) ?? new List<UserDTO>();

                ProcessUsersProfileImages(users);
                _logger.LogInformation("Successfully retrieved {Count} users", users.Count);
                return users;
            }

            _logger.LogWarning("Failed to get users. Status code: {StatusCode}", response.StatusCode);
            return new List<UserDTO>();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while fetching users");
            return new List<UserDTO>();
        }
    }

    public async Task<List<UserDTO>> GetInstructorsAsync()
    {
        try
        {
            _logger.LogInformation("Retrieving all instructors from API");

            var client = _httpClientService.CreateClient();
            var response = await client.GetAsync("user/instructors");

            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                var instructors = JsonSerializer.Deserialize<List<UserDTO>>(content) ?? new List<UserDTO>();
                ProcessUsersProfileImages(instructors);
                return instructors;
            }

            _logger.LogWarning("Failed to get instructors. Status code: {StatusCode}", response.StatusCode);
            return new List<UserDTO>();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while fetching instructors");
            return new List<UserDTO>();
        }
    }

    public async Task<List<UserDTO>> GetAdminsAsync()
    {
        try
        {
            _logger.LogInformation("Retrieving all admins from API");

            var client = _httpClientService.CreateClient();
            var response = await client.GetAsync("user/admins");

            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                var admins = JsonSerializer.Deserialize<List<UserDTO>>(content) ?? new List<UserDTO>();
                ProcessUsersProfileImages(admins);
                return admins;
            }

            _logger.LogWarning("Failed to get admins. Status code: {StatusCode}", response.StatusCode);
            return new List<UserDTO>();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while fetching admins");
            return new List<UserDTO>();
        }
    }

    public async Task<UserInfoDTO?> GetUserByIdAsync(string id)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(id))
            {
                _logger.LogWarning("Get user by ID attempt with empty ID");
                return null;
            }

            var client = _httpClientService.CreateClient();
            var response = await client.GetAsync($"user/{id}");

            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                var user = JsonSerializer.Deserialize<UserInfoDTO>(content);
                ProcessUserProfileImage(user);
                return user;
            }

            _logger.LogWarning("Failed to get user by ID {UserId}. Status code: {StatusCode}", id, response.StatusCode);
            return null;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while fetching user with ID: {UserId}", id);
            return null;
        }
    }

    public async Task<UserInfoDTO?> GetCurrentUserAsync()
    {
        try
        {
            _logger.LogInformation("Retrieving current user from API");

            var client = _httpClientService.CreateClient();
            var response = await client.GetAsync("user/me");

            if (!response.IsSuccessStatusCode)
            {
                _logger.LogWarning("Failed to get current user. Status code: {StatusCode}", response.StatusCode);
                return null;
            }

            var content = await response.Content.ReadAsStringAsync();
            var user = JsonSerializer.Deserialize<UserInfoDTO>(content);
            ProcessUserProfileImage(user);
            return user;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while fetching current user");
            return null;
        }
    }

    #endregion

    #region User Management Methods

    public async Task<string?> DeleteUserAsync(string userId)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(userId))
            {
                _logger.LogWarning("Delete user attempt with empty user ID");
                return "معرف المستخدم غير صالح";
            }

            var client = _httpClientService.CreateClient();
            var response = await client.DeleteAsync($"user/{userId}");

            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                var result = JsonSerializer.Deserialize<ApiResponse<object>>(content, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                return null; // Null means success in this method's logic
            }

            var errorContent = await response.Content.ReadAsStringAsync();
            _logger.LogWarning("Failed to delete user {UserId}. Response: {Error}", userId, errorContent);

            try
            {
                var errorResult = JsonSerializer.Deserialize<ApiResponse<object>>(errorContent, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                return errorResult?.Message ?? "تعذر حذف المستخدم.";
            }
            catch
            {
                return "تعذر حذف المستخدم.";
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while deleting user with ID: {UserId}", userId);
            return "حدث خطأ غير متوقع أثناء الحذف.";
        }
    }

    public async Task<(bool Success, string Message)> DeleteRangeUsersAsync(List<string> userIds)
    {
        try
        {
            if (userIds == null || userIds.Count == 0)
                return (false, "لا توجد معرفات مستخدمين للحذف.");

            var client = _httpClientService.CreateClient();
            var jsonContent = new StringContent(
                JsonSerializer.Serialize(userIds),
                Encoding.UTF8,
                "application/json");

            var response = await client.PostAsync("user/DeleteUsers", jsonContent);
            var content = await response.Content.ReadAsStringAsync();

            if (response.IsSuccessStatusCode)
            {
                try
                {
                    var successResult = JsonSerializer.Deserialize<ApiResponse<object>>(content, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                    return (true, successResult?.Message ?? "تم حذف المستخدمين بنجاح");
                }
                catch
                {
                    return (true, "تم حذف المستخدمين بنجاح");
                }
            }

            _logger.LogWarning("Failed to delete multiple users. Response: {Error}", content);

            try
            {
                var errorResult = JsonSerializer.Deserialize<ApiResponse<object>>(content, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                return (false, errorResult?.Message ?? "تعذر حذف بعض المستخدمين.");
            }
            catch
            {
                return (false, "تعذر حذف بعض المستخدمين.");
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while deleting multiple users");
            return (false, "حدث خطأ غير متوقع أثناء الحذف الجماعي.");
        }
    }

    public async Task<(bool Success, string Message)> UpdateUserAsync(UpdateUserDTO dto)
    {
        try
        {
            if (dto == null) return (false, "بيانات المستخدم غير صحيحة");
            if (string.IsNullOrWhiteSpace(dto.Id)) return (false, "معرف المستخدم مطلوب");
            if (string.IsNullOrWhiteSpace(dto.FullName)) return (false, "اسم المستخدم مطلوب");
            if (string.IsNullOrWhiteSpace(dto.Role)) return (false, "دور المستخدم مطلوب");

            _logger.LogInformation("Updating user with ID: {UserId}", dto.Id);

            var client = _httpClientService.CreateClient();
            var jsonContent = new StringContent(
                JsonSerializer.Serialize(dto),
                Encoding.UTF8,
                "application/json");

            var response = await client.PutAsync("user", jsonContent);

            if (response.IsSuccessStatusCode)
                return (true, "تم تحديث المستخدم بنجاح");

            string errorMessage = "فشل في تحديث المستخدم";
            var errorContent = await response.Content.ReadAsStringAsync();
            try
            {
                var error = JsonSerializer.Deserialize<Dictionary<string, string>>(errorContent);
                errorMessage = error?.GetValueOrDefault("message") ?? errorMessage;
                if (error?.ContainsKey("details") == true)
                    errorMessage += $": {error["details"]}";
            }
            catch { }

            _logger.LogWarning("Failed to update user {UserId}. Status: {StatusCode}, Error: {Error}", dto.Id, response.StatusCode, errorMessage);
            return (false, errorMessage);
        }
        catch (HttpRequestException httpEx)
        {
            _logger.LogError(httpEx, "Network error while updating user {UserId}", dto?.Id);
            return (false, "خطأ في الاتصال بالخادم. يرجى المحاولة لاحقاً");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception while updating user {UserId}", dto?.Id);
            return (false, "حدث خطأ غير متوقع أثناء التحديث");
        }
    }

    #endregion

    #region Account Locking/Unlocking Methods

    public async Task<(bool Success, string Message)> LockUsersAsync(List<string> userIds, int minutes)
    {
        try
        {
            if (userIds == null || userIds.Count == 0 || minutes < 0)
                return (false, "بيانات غير صحيحة للقفل");

            var client = _httpClientService.CreateClient();
            var request = new { UserIds = userIds, Minutes = minutes };
            var jsonContent = new StringContent(
                JsonSerializer.Serialize(request),
                Encoding.UTF8,
                "application/json");

            var response = await client.PostAsync("user/LockUsers", jsonContent);
            var content = await response.Content.ReadAsStringAsync();

            if (response.IsSuccessStatusCode)
            {
                var result = JsonSerializer.Deserialize<ApiResponse<object>>(content, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                return (true, result?.Message ?? "تم قفل الحسابات بنجاح");
            }

            var errorResult = JsonSerializer.Deserialize<ApiResponse<object>>(content, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            return (false, errorResult?.Message ?? "فشل قفل الحسابات");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception while locking users");
            return (false, "حدث خطأ أثناء محاولة قفل الحسابات");
        }
    }

    public async Task<(bool Success, string Message)> UnlockUsersAsync(List<string> userIds)
    {
        try
        {
            if (userIds == null || userIds.Count == 0)
                return (false, "لم يتم اختيار مستخدمين");

            var client = _httpClientService.CreateClient();
            var jsonContent = new StringContent(
                JsonSerializer.Serialize(userIds),
                Encoding.UTF8,
                "application/json");

            var response = await client.PostAsync("user/UnlockUsers", jsonContent);
            var content = await response.Content.ReadAsStringAsync();

            if (response.IsSuccessStatusCode)
            {
                var result = JsonSerializer.Deserialize<ApiResponse<object>>(content, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                return (true, result?.Message ?? "تم فتح قفل الحسابات بنجاح");
            }

            var errorResult = JsonSerializer.Deserialize<ApiResponse<object>>(content, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            return (false, errorResult?.Message ?? "فشل فتح قفل الحسابات");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception while unlocking users");
            return (false, "حدث خطأ أثناء محاولة فتح قفل الحسابات");
        }
    }

    #endregion

    #region Helper Methods

    private string FixProfileImageUrl(string profileImageUrl)
    {
        if (string.IsNullOrEmpty(profileImageUrl) ||
            profileImageUrl.StartsWith("https") ||
            profileImageUrl.StartsWith("http"))
            return profileImageUrl;

        var cleanBaseUrl = _baseUrl?.Replace("/api", "").TrimEnd('/');

        return $"{cleanBaseUrl}/{profileImageUrl.TrimStart('/')}";
    }

    private void ProcessUsersProfileImages(List<UserDTO> users)
    {
        if (users == null) return;
        foreach (var user in users)
            user.ProfileImageUrl = FixProfileImageUrl(user.ProfileImageUrl);
    }

    private void ProcessUserProfileImage(UserInfoDTO user)
    {
        if (user == null) return;
        user.ProfileImageUrl = FixProfileImageUrl(user.ProfileImageUrl);
    }

    #endregion
}