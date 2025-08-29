using EduLab_MVC.Models.DTOs.Auth;
using EduLab_MVC.Services.Helper_Services;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

public class UserService
{
    private readonly IHttpClientFactory _clientFactory;
    private readonly ILogger<UserService> _logger;
    private readonly AuthorizedHttpClientService _httpClientService;
    public UserService(IHttpClientFactory clientFactory, ILogger<UserService> logger, AuthorizedHttpClientService httpClientService)
    {
        _clientFactory = clientFactory;
        _logger = logger;
        _httpClientService = httpClientService;
    }

    // دالة لمساعدة على إنشاء HttpClient مع إضافة JWT من الكوكي
    public async Task<List<UserDTO>> GetAllUsersAsync()
    {
        try
        {
            var client = _httpClientService.CreateClient();
            var response = await client.GetAsync("user");

            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                var users = JsonConvert.DeserializeObject<List<UserDTO>>(content) ?? new List<UserDTO>();

                // تعديل رابط الصورة لكل يوزر
                foreach (var user in users)
                {
                    if (!string.IsNullOrEmpty(user.ProfileImageUrl) && !user.ProfileImageUrl.StartsWith("https"))
                    {
                        user.ProfileImageUrl = "https://localhost:7292" + user.ProfileImageUrl;
                    }
                }

                return users;
            }
            else
            {
                _logger.LogWarning($"Failed to get users. Status code: {response.StatusCode}");
                return new List<UserDTO>();
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while fetching users.");
            return new List<UserDTO>();
        }
    }


    public async Task<List<UserDTO>> GetInstructorsAsync()
    {
        try
        {
            var client = _httpClientService.CreateClient();
            var response = await client.GetAsync("user/instructors");

            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                var instructors = JsonConvert.DeserializeObject<List<UserDTO>>(content) ?? new List<UserDTO>();

                foreach (var user in instructors)
                {
                    if (!string.IsNullOrEmpty(user.ProfileImageUrl) && !user.ProfileImageUrl.StartsWith("https"))
                    {
                        user.ProfileImageUrl = "https://localhost:7292" + user.ProfileImageUrl;
                    }
                }

                return instructors;
            }
            else
            {
                _logger.LogWarning($"Failed to get instructors. Status code: {response.StatusCode}");
                return new List<UserDTO>();
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while fetching instructors.");
            return new List<UserDTO>();
        }
    }

    public async Task<List<UserDTO>> GetAdminsAsync()
    {
        try
        {
            var client = _httpClientService.CreateClient();
            var response = await client.GetAsync("user/admins");

            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                var admins = JsonConvert.DeserializeObject<List<UserDTO>>(content) ?? new List<UserDTO>();

                foreach (var user in admins)
                {
                    if (!string.IsNullOrEmpty(user.ProfileImageUrl) && !user.ProfileImageUrl.StartsWith("https"))
                    {
                        user.ProfileImageUrl = "https://localhost:7292" + user.ProfileImageUrl;
                    }
                }

                return admins;
            }
            else
            {
                _logger.LogWarning($"Failed to get admins. Status code: {response.StatusCode}");
                return new List<UserDTO>();
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while fetching admins.");
            return new List<UserDTO>();
        }
    }


    public async Task<bool> DeleteUserAsync(string userId)
    {
        try
        {
            var client = _httpClientService.CreateClient();
            var response = await client.DeleteAsync($"user/{userId}");
            return response.IsSuccessStatusCode;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Exception occurred while deleting user {userId}.");
            return false;
        }
    }

    public async Task<bool> UpdateUserAsync(UpdateUserDTO dto)
    {
        try
        {
            var client = _httpClientService.CreateClient();
            var jsonContent = new StringContent(JsonConvert.SerializeObject(dto), Encoding.UTF8, "application/json");
            var response = await client.PutAsync("user", jsonContent);
            return response.IsSuccessStatusCode;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Exception occurred while updating user {dto.Id}.");
            return false;
        }
    }

    public async Task<bool> DeleteRangeUsersAsync(List<string> userIds)
    {
        try
        {
            var client = _httpClientService.CreateClient();
            var jsonContent = new StringContent(JsonConvert.SerializeObject(userIds), Encoding.UTF8, "application/json");
            var response = await client.PostAsync("user/DeleteUsers", jsonContent);
            return response.IsSuccessStatusCode;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while deleting multiple users.");
            return false;
        }
    }

    public async Task<bool> LockUsersAsync(List<string> userIds, int minutes)
    {
        try
        {
            var client = _httpClientService.CreateClient();
            var request = new { UserIds = userIds, Minutes = minutes };
            var jsonContent = new StringContent(JsonConvert.SerializeObject(request), Encoding.UTF8, "application/json");
            var response = await client.PostAsync("user/LockUsers", jsonContent);
            return response.IsSuccessStatusCode;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while locking users.");
            return false;
        }
    }

    public async Task<bool> UnlockUsersAsync(List<string> userIds)
    {
        try
        {
            var client = _httpClientService.CreateClient();
            var jsonContent = new StringContent(JsonConvert.SerializeObject(userIds), Encoding.UTF8, "application/json");
            var response = await client.PostAsync("user/UnlockUsers", jsonContent);
            return response.IsSuccessStatusCode;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while unlocking users.");
            return false;
        }
    }

    public async Task<UserInfoDTO?> GetUserByIdAsync(string id)
    {
        try
        {
            var client = _httpClientService.CreateClient();
            var response = await client.GetAsync($"user/{id}");

            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                var user = JsonConvert.DeserializeObject<UserInfoDTO>(content);
                if (user != null && !string.IsNullOrEmpty(user.ProfileImageUrl) && !user.ProfileImageUrl.StartsWith("https"))
                {
                    user.ProfileImageUrl = "https://localhost:7292" + user.ProfileImageUrl;
                }
                return user;
            }

            _logger.LogWarning($"Failed to get user by id {id}. Status code: {response.StatusCode}");
            return null;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Exception occurred while fetching user {id}");
            return null;
        }
    }
    public async Task<UserInfoDTO?> GetCurrentUserAsync()
    {
        try
        {
            var client = _httpClientService.CreateClient();
            var response = await client.GetAsync("user/me");

            if (!response.IsSuccessStatusCode) return null;

            var content = await response.Content.ReadAsStringAsync();
            var user = JsonConvert.DeserializeObject<UserInfoDTO>(content);

            if (user != null && !string.IsNullOrEmpty(user.ProfileImageUrl) && !user.ProfileImageUrl.StartsWith("https"))
            {
                user.ProfileImageUrl = "https://localhost:7292" + user.ProfileImageUrl;
            }

            return user;
        }
        catch
        {
            return null;
        }
    }
}
