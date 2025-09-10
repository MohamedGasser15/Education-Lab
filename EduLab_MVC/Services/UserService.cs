using EduLab_MVC.Models.DTOs.Auth;
using EduLab_MVC.Services.ServiceInterfaces;
using Newtonsoft.Json;
using System.Text;

/// <summary>
/// Service for managing user operations including retrieval, update, and deletion
/// </summary>
public class UserService : IUserService
{
    #region Dependencies

    private readonly IHttpClientFactory _clientFactory;
    private readonly ILogger<UserService> _logger;
    private readonly IAuthorizedHttpClientService _httpClientService;
    private const string BaseUrl = "https://localhost:7292";

    #endregion

    #region Constructor

    /// <summary>
    /// Initializes a new instance of the UserService class
    /// </summary>
    /// <param name="clientFactory">HTTP client factory for creating HTTP clients</param>
    /// <param name="logger">Logger for tracking operations and errors</param>
    /// <param name="httpClientService">Service for creating authorized HTTP clients</param>
    public UserService(
        IHttpClientFactory clientFactory,
        ILogger<UserService> logger,
        IAuthorizedHttpClientService httpClientService)
    {
        _clientFactory = clientFactory;
        _logger = logger;
        _httpClientService = httpClientService;
    }

    #endregion


    #region User Retrieval Methods

    /// <summary>
    /// Retrieves all users from the API
    /// </summary>
    /// <returns>List of all users</returns>
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
                var users = JsonConvert.DeserializeObject<List<UserDTO>>(content) ?? new List<UserDTO>();

                ProcessUsersProfileImages(users);

                _logger.LogInformation("Successfully retrieved {Count} users", users.Count);
                return users;
            }
            else
            {
                _logger.LogWarning("Failed to get users. Status code: {StatusCode}", response.StatusCode);
                return new List<UserDTO>();
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while fetching users");
            return new List<UserDTO>();
        }
    }

    /// <summary>
    /// Retrieves all instructors from the API
    /// </summary>
    /// <returns>List of all instructors</returns>
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
                var instructors = JsonConvert.DeserializeObject<List<UserDTO>>(content) ?? new List<UserDTO>();

                ProcessUsersProfileImages(instructors);

                _logger.LogInformation("Successfully retrieved {Count} instructors", instructors.Count);
                return instructors;
            }
            else
            {
                _logger.LogWarning("Failed to get instructors. Status code: {StatusCode}", response.StatusCode);
                return new List<UserDTO>();
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while fetching instructors");
            return new List<UserDTO>();
        }
    }

    /// <summary>
    /// Retrieves all administrators from the API
    /// </summary>
    /// <returns>List of all administrators</returns>
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
                var admins = JsonConvert.DeserializeObject<List<UserDTO>>(content) ?? new List<UserDTO>();

                ProcessUsersProfileImages(admins);

                _logger.LogInformation("Successfully retrieved {Count} admins", admins.Count);
                return admins;
            }
            else
            {
                _logger.LogWarning("Failed to get admins. Status code: {StatusCode}", response.StatusCode);
                return new List<UserDTO>();
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while fetching admins");
            return new List<UserDTO>();
        }
    }

    /// <summary>
    /// Retrieves a specific user by ID
    /// </summary>
    /// <param name="id">User identifier</param>
    /// <returns>User information if found, otherwise null</returns>
    public async Task<UserInfoDTO?> GetUserByIdAsync(string id)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(id))
            {
                _logger.LogWarning("Get user by ID attempt with empty ID");
                return null;
            }

            _logger.LogInformation("Retrieving user by ID: {UserId}", id);

            var client = _httpClientService.CreateClient();
            var response = await client.GetAsync($"user/{id}");

            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                var user = JsonConvert.DeserializeObject<UserInfoDTO>(content);

                ProcessUserProfileImage(user);

                _logger.LogInformation("Successfully retrieved user with ID: {UserId}", id);
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

    /// <summary>
    /// Retrieves the currently authenticated user
    /// </summary>
    /// <returns>Current user information if found, otherwise null</returns>
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
            var user = JsonConvert.DeserializeObject<UserInfoDTO>(content);

            ProcessUserProfileImage(user);

            _logger.LogInformation("Successfully retrieved current user");
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
    /// <summary>
    /// Deletes a user by ID
    /// </summary>
    /// <param name="userId">User identifier</param>
    /// <returns>Null if deletion succeeded, otherwise error message</returns>
    public async Task<string?> DeleteUserAsync(string userId)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(userId))
            {
                _logger.LogWarning("Delete user attempt with empty user ID");
                return "معرف المستخدم غير صالح";
            }

            _logger.LogInformation("Deleting user with ID: {UserId}", userId);

            var client = _httpClientService.CreateClient();
            var response = await client.DeleteAsync($"user/{userId}");

            if (response.IsSuccessStatusCode)
            {
                _logger.LogInformation("Successfully deleted user with ID: {UserId}", userId);
                return null;
            }

            // نحاول نقرأ الرسالة من الـ API
            var errorContent = await response.Content.ReadAsStringAsync();
            _logger.LogWarning("Failed to delete user {UserId}. Response: {Error}", userId, errorContent);

            var error = JsonConvert.DeserializeObject<dynamic>(errorContent);
            return error?.message?.ToString() ?? "تعذر حذف المستخدم.";
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while deleting user with ID: {UserId}", userId);
            return "حدث خطأ غير متوقع أثناء الحذف.";
        }
    }

    /// <summary>
    /// Deletes multiple users by their IDs
    /// </summary>
    /// <param name="userIds">List of user identifiers</param>
    /// <returns>Null if success, otherwise error message</returns>
    public async Task<string?> DeleteRangeUsersAsync(List<string> userIds)
    {
        try
        {
            if (userIds == null || userIds.Count == 0)
            {
                _logger.LogWarning("Delete range users attempt with empty list");
                return "لا توجد معرفات مستخدمين للحذف.";
            }

            _logger.LogInformation("Deleting {Count} users", userIds.Count);

            var client = _httpClientService.CreateClient();
            var jsonContent = new StringContent(
                JsonConvert.SerializeObject(userIds),
                Encoding.UTF8,
                "application/json");

            var response = await client.PostAsync("user/DeleteUsers", jsonContent);

            if (response.IsSuccessStatusCode)
            {
                _logger.LogInformation("Successfully deleted {Count} users", userIds.Count);
                return null;
            }

            var errorContent = await response.Content.ReadAsStringAsync();
            _logger.LogWarning("Failed to delete multiple users. Response: {Error}", errorContent);

            var error = JsonConvert.DeserializeObject<dynamic>(errorContent);
            return error?.message?.ToString() ?? "تعذر حذف بعض المستخدمين.";
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while deleting multiple users");
            return "حدث خطأ غير متوقع أثناء الحذف الجماعي.";
        }
    }

    /// <summary>
    /// Updates user information
    /// </summary>
    /// <param name="dto">User update data transfer object</param>
    /// <returns>True if update was successful, otherwise false</returns>
    /// <summary>
    /// Updates user information
    /// </summary>
    /// <param name="dto">User update data transfer object</param>
    /// <returns>True if update was successful, otherwise false</returns>
    public async Task<(bool Success, string Message)> UpdateUserAsync(UpdateUserDTO dto)
    {
        try
        {
            if (dto == null)
            {
                _logger.LogWarning("Update user attempt with null DTO");
                return (false, "بيانات المستخدم غير صحيحة");
            }

            if (string.IsNullOrWhiteSpace(dto.Id))
            {
                _logger.LogWarning("Update user attempt with empty user ID");
                return (false, "معرف المستخدم مطلوب");
            }

            if (string.IsNullOrWhiteSpace(dto.FullName))
            {
                _logger.LogWarning("Update user attempt with empty full name");
                return (false, "اسم المستخدم مطلوب");
            }

            if (string.IsNullOrWhiteSpace(dto.Role))
            {
                _logger.LogWarning("Update user attempt with empty role");
                return (false, "دور المستخدم مطلوب");
            }

            _logger.LogInformation("Updating user with ID: {UserId}", dto.Id);

            var client = _httpClientService.CreateClient();
            var jsonContent = new StringContent(
                JsonConvert.SerializeObject(dto),
                Encoding.UTF8,
                "application/json");

            var response = await client.PutAsync("user", jsonContent);

            if (response.IsSuccessStatusCode)
            {
                _logger.LogInformation("Successfully updated user with ID: {UserId}", dto.Id);
                return (true, "تم تحديث المستخدم بنجاح");
            }

            // قراءة رسالة الخطأ من الـ API إذا كانت متوفرة
            string errorMessage = "فشل في تحديث المستخدم";
            if (response.Content != null)
            {
                var errorContent = await response.Content.ReadAsStringAsync();
                try
                {
                    var errorResponse = JsonConvert.DeserializeObject<dynamic>(errorContent);
                    errorMessage = errorResponse?.message ?? errorMessage;
                    if (errorResponse?.details != null)
                    {
                        errorMessage += $": {errorResponse.details}";
                    }
                }
                catch
                {
                    errorMessage = errorContent.Length > 100 ? errorContent.Substring(0, 100) + "..." : errorContent;
                }
            }

            _logger.LogWarning("Failed to update user with ID: {UserId}. Status: {StatusCode}, Error: {Error}",
                dto.Id, response.StatusCode, errorMessage);

            return (false, errorMessage);
        }
        catch (HttpRequestException httpEx)
        {
            _logger.LogError(httpEx, "Network error occurred while updating user with ID: {UserId}", dto?.Id);
            return (false, "خطأ في الاتصال بالخادم. يرجى المحاولة لاحقاً");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while updating user with ID: {UserId}", dto?.Id);
            return (false, "حدث خطأ غير متوقع أثناء التحديث");
        }
    }

    #endregion

    #region Account Locking/Unlocking Methods

    /// <summary>
    /// Locks user accounts for a specified duration
    /// </summary>
    /// <param name="userIds">List of user identifiers to lock</param>
    /// <param name="minutes">Duration of lock in minutes</param>
    /// <returns>True if locking was successful, otherwise false</returns>
    public async Task<bool> LockUsersAsync(List<string> userIds, int minutes)
    {
        try
        {
            if (userIds == null || userIds.Count == 0)
            {
                _logger.LogWarning("Lock users attempt with empty user IDs list");
                return false;
            }

            if (minutes < 0)
            {
                _logger.LogWarning("Lock users attempt with negative minutes: {Minutes}", minutes);
                return false;
            }

            _logger.LogInformation("Locking {Count} users for {Minutes} minutes", userIds.Count, minutes);

            var client = _httpClientService.CreateClient();
            var request = new { UserIds = userIds, Minutes = minutes };
            var jsonContent = new StringContent(
                JsonConvert.SerializeObject(request),
                Encoding.UTF8,
                "application/json");

            var response = await client.PostAsync("user/LockUsers", jsonContent);

            var success = response.IsSuccessStatusCode;

            if (success)
            {
                _logger.LogInformation("Successfully locked {Count} users for {Minutes} minutes", userIds.Count, minutes);
            }
            else
            {
                _logger.LogWarning("Failed to lock users. Status code: {StatusCode}", response.StatusCode);
            }

            return success;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while locking users");
            return false;
        }
    }

    /// <summary>
    /// Unlocks user accounts
    /// </summary>
    /// <param name="userIds">List of user identifiers to unlock</param>
    /// <returns>True if unlocking was successful, otherwise false</returns>
    public async Task<bool> UnlockUsersAsync(List<string> userIds)
    {
        try
        {
            if (userIds == null || userIds.Count == 0)
            {
                _logger.LogWarning("Unlock users attempt with empty user IDs list");
                return false;
            }

            _logger.LogInformation("Unlocking {Count} users", userIds.Count);

            var client = _httpClientService.CreateClient();
            var jsonContent = new StringContent(
                JsonConvert.SerializeObject(userIds),
                Encoding.UTF8,
                "application/json");

            var response = await client.PostAsync("user/UnlockUsers", jsonContent);

            var success = response.IsSuccessStatusCode;

            if (success)
            {
                _logger.LogInformation("Successfully unlocked {Count} users", userIds.Count);
            }
            else
            {
                _logger.LogWarning("Failed to unlock users. Status code: {StatusCode}", response.StatusCode);
            }

            return success;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while unlocking users");
            return false;
        }
    }

    #endregion

    #region Helper Methods

    /// <summary>
    /// Fixes the profile image URL by adding the base URL if needed
    /// </summary>
    /// <param name="profileImageUrl">The profile image URL to fix</param>
    /// <returns>Fixed profile image URL</returns>
    private string FixProfileImageUrl(string profileImageUrl)
    {
        if (string.IsNullOrEmpty(profileImageUrl) || profileImageUrl.StartsWith("https"))
        {
            return profileImageUrl;
        }

        return $"{BaseUrl}{profileImageUrl}";
    }

    /// <summary>
    /// Processes a list of users by fixing their profile image URLs
    /// </summary>
    /// <param name="users">List of users to process</param>
    private void ProcessUsersProfileImages(List<UserDTO> users)
    {
        if (users == null) return;

        foreach (var user in users)
        {
            user.ProfileImageUrl = FixProfileImageUrl(user.ProfileImageUrl);
        }
    }

    /// <summary>
    /// Processes a single user by fixing their profile image URL
    /// </summary>
    /// <param name="user">User to process</param>
    private void ProcessUserProfileImage(UserInfoDTO user)
    {
        if (user == null) return;

        user.ProfileImageUrl = FixProfileImageUrl(user.ProfileImageUrl);
    }

    #endregion

}