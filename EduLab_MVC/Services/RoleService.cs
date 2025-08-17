using EduLab_MVC.Models.DTOs.Roles;
using EduLab_MVC.Services.Helper_Services;
using Microsoft.AspNetCore.Identity;
using Newtonsoft.Json;
using System.Net.Http.Headers;
using System.Text;

namespace EduLab_MVC.Services
{
    public class RoleService
    {
        private readonly ILogger<RoleService> _logger;
        private readonly AuthorizedHttpClientService _httpClientService;
        public RoleService(ILogger<RoleService> logger, AuthorizedHttpClientService httpClientService)
        {
            _logger = logger;
            _httpClientService = httpClientService;
        }

        public async Task<List<RoleDto>> GetAllRolesAsync()
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("role");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    return JsonConvert.DeserializeObject<List<RoleDto>>(content) ?? new List<RoleDto>();
                }

                _logger.LogWarning($"Failed to get roles. Status code: {response.StatusCode}");
                return new List<RoleDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching roles.");
                return new List<RoleDto>();
            }
        }

        public async Task<RoleDto> GetRoleByIdAsync(string id)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"role/{id}");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    return JsonConvert.DeserializeObject<RoleDto>(content);
                }

                _logger.LogWarning($"Failed to get role with ID {id}. Status code: {response.StatusCode}");
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Exception occurred while fetching role with ID {id}.");
                return null;
            }
        }

        public async Task<bool> CreateRoleAsync(string roleName)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var content = new StringContent($"\"{roleName}\"", Encoding.UTF8, "application/json");
                var response = await client.PostAsync("role", content);

                if (response.IsSuccessStatusCode) return true;

                var errorContent = await response.Content.ReadAsStringAsync();
                _logger.LogWarning($"Failed to create role. Error: {errorContent}");
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while creating role.");
                return false;
            }
        }

        public async Task<bool> UpdateRoleAsync(string id, string roleName)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.PutAsJsonAsync($"role/{id}", roleName);

                if (response.IsSuccessStatusCode) return true;

                var errorContent = await response.Content.ReadAsStringAsync();
                _logger.LogWarning($"Failed to update role. Error: {errorContent}");
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while updating role.");
                return false;
            }
        }

        public async Task<bool> DeleteRoleAsync(string id)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync($"role/{id}");

                if (response.IsSuccessStatusCode) return true;

                var errorContent = await response.Content.ReadAsStringAsync();
                _logger.LogWarning($"Failed to delete role. Error: {errorContent}");
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while deleting role.");
                return false;
            }
        }

        public async Task<bool> BulkDeleteRolesAsync(List<string> roleIds)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.PostAsJsonAsync("role/bulk-delete", roleIds);

                if (response.IsSuccessStatusCode) return true;

                var errorContent = await response.Content.ReadAsStringAsync();
                _logger.LogWarning($"Failed to bulk delete roles. Error: {errorContent}");
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while bulk deleting roles.");
                return false;
            }
        }

        public async Task<bool> UpdateRoleClaimsAsync(string roleId, List<ClaimDto> claims)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.PostAsJsonAsync($"role/{roleId}/claims", new { RoleId = roleId, Claims = claims });

                if (response.IsSuccessStatusCode) return true;

                var errorContent = await response.Content.ReadAsStringAsync();
                _logger.LogError($"Failed to update claims: {errorContent}");
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating role claims");
                return false;
            }
        }


        public async Task<RoleStatisticsDto> GetRolesStatisticsAsync()
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("role/statistics");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    return JsonConvert.DeserializeObject<RoleStatisticsDto>(content);
                }

                _logger.LogWarning($"Failed to get role statistics. Status code: {response.StatusCode}");
                return new RoleStatisticsDto();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching role statistics.");
                return new RoleStatisticsDto();
            }
        }

        public async Task<RoleClaimsDto> GetRoleClaimsAsync(string roleId)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"role/{roleId}/claims");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var result = JsonConvert.DeserializeObject<RoleClaimsDto>(content);

                    // تسجيل البيانات للتحقق منها
                    _logger.LogInformation($"Received claims for role {roleId}: {JsonConvert.SerializeObject(result)}");

                    return result;
                }

                _logger.LogWarning($"Failed to get role claims. Status code: {response.StatusCode}");
                return new RoleClaimsDto();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching role claims.");
                return new RoleClaimsDto();
            }
        }

        public async Task<List<UserRoleDto>> GetUsersInRoleAsync(string roleName)
        {
            try
            {
               var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"role/{roleName}/users");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    return JsonConvert.DeserializeObject<List<UserRoleDto>>(content) ?? new List<UserRoleDto>();
                }

                _logger.LogWarning($"Failed to get users in role. Status code: {response.StatusCode}");
                return new List<UserRoleDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching users in role.");
                return new List<UserRoleDto>();
            }
        }
    }
}
