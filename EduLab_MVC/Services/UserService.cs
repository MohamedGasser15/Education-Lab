using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Microsoft.Extensions.Logging;
using EduLab_MVC.Models.DTOs.Auth;
using System.Text;

public class UserService
{
    private readonly IHttpClientFactory _clientFactory;
    private readonly ILogger<UserService> _logger;

    public UserService(IHttpClientFactory clientFactory, ILogger<UserService> logger)
    {
        _clientFactory = clientFactory;
        _logger = logger;
    }

    public async Task<List<UserDTO>> GetAllUsersAsync()
    {
        try
        {
            var client = _clientFactory.CreateClient("EduLabAPI"); // اسم العميل يكون نفس اللي مسجل في Startup/Program
            var response = await client.GetAsync("user");

            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                var users = JsonConvert.DeserializeObject<List<UserDTO>>(content);
                return users ?? new List<UserDTO>();
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
            var client = _clientFactory.CreateClient("EduLabAPI");
            var response = await client.GetAsync("user/instructors");
            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                var instructors = JsonConvert.DeserializeObject<List<UserDTO>>(content);
                return instructors ?? new List<UserDTO>();
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
            var client = _clientFactory.CreateClient("EduLabAPI");
            var response = await client.GetAsync("user/admins");
            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                var admins = JsonConvert.DeserializeObject<List<UserDTO>>(content);
                return admins ?? new List<UserDTO>();
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
            var client = _clientFactory.CreateClient("EduLabAPI");
            var response = await client.DeleteAsync($"user/{userId}");

            if (response.IsSuccessStatusCode)
            {
                return true;
            }
            else
            {
                _logger.LogWarning($"Failed to delete user {userId}. Status code: {response.StatusCode}");
                return false;
            }
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
            var client = _clientFactory.CreateClient("EduLabAPI");

            var jsonContent = new StringContent(
                JsonConvert.SerializeObject(dto),
                Encoding.UTF8,
                "application/json");

            var response = await client.PutAsync("user", jsonContent);

            if (response.IsSuccessStatusCode)
                return true;

            _logger.LogWarning($"Failed to update user {dto.Id}. Status code: {response.StatusCode}");
            return false;
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
            var client = _clientFactory.CreateClient("EduLabAPI");

            var jsonContent = new StringContent(
                JsonConvert.SerializeObject(userIds),
                Encoding.UTF8,
                "application/json");

            var response = await client.PostAsync("user/DeleteUsers", jsonContent);

            if (response.IsSuccessStatusCode)
                return true;

            _logger.LogWarning($"Failed to delete multiple users. Status code: {response.StatusCode}");
            return false;
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
            var client = _clientFactory.CreateClient("EduLabAPI");
            var request = new
            {
                UserIds = userIds,
                Minutes = minutes
            };
            var jsonContent = new StringContent(
                JsonConvert.SerializeObject(request),
                Encoding.UTF8,
                "application/json");
            var response = await client.PostAsync("user/LockUsers", jsonContent);
            if (response.IsSuccessStatusCode)
                return true;
            _logger.LogWarning($"Failed to lock users. Status code: {response.StatusCode}");
            return false;
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
            var client = _clientFactory.CreateClient("EduLabAPI");
            var jsonContent = new StringContent(
                JsonConvert.SerializeObject(userIds),
                Encoding.UTF8,
                "application/json");
            var response = await client.PostAsync("user/UnlockUsers", jsonContent);
            if (response.IsSuccessStatusCode)
                return true;
            _logger.LogWarning($"Failed to unlock users. Status code: {response.StatusCode}");
            return false;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while unlocking users.");
            return false;
        }
    }
}
