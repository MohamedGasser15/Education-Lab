using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Microsoft.Extensions.Logging;
using EduLab_MVC.Models.DTOs.Auth;

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

}
