using EduLab_MVC.Models.DTOs.Roles;
using EduLab_MVC.Services.Helper_Services;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// Service for managing roles in the MVC application
    /// </summary>
    public class RoleService
    {
        private readonly ILogger<RoleService> _logger;
        private readonly AuthorizedHttpClientService _httpClientService;

        /// <summary>
        /// Initializes a new instance of the RoleService class
        /// </summary>
        public RoleService(ILogger<RoleService> logger, AuthorizedHttpClientService httpClientService)
        {
            _logger = logger;
            _httpClientService = httpClientService;
        }

        #region Role CRUD Operations

        /// <summary>
        /// Retrieves all roles from the API
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of RoleDto objects</returns>
        public async Task<List<RoleDto>> GetAllRolesAsync(CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC: Getting all roles from API");

            try
            {
                using var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("role", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var roles = JsonConvert.DeserializeObject<List<RoleDto>>(content) ?? new List<RoleDto>();
                    _logger.LogInformation("MVC: Successfully retrieved {RoleCount} roles", roles.Count);
                    return roles;
                }

                _logger.LogWarning("MVC: Failed to get roles. Status: {StatusCode}", response.StatusCode);
                return new List<RoleDto>();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC: Get all roles operation was cancelled");
                return new List<RoleDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC: Exception occurred while fetching roles");
                return new List<RoleDto>();
            }
        }

        /// <summary>
        /// Retrieves a specific role by ID from the API
        /// </summary>
        /// <param name="id">The role ID</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>RoleDto object or null</returns>
        public async Task<RoleDto> GetRoleByIdAsync(string id, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC: Getting role by ID: {RoleId}", id);

            if (string.IsNullOrEmpty(id))
            {
                _logger.LogWarning("MVC: Role ID cannot be null or empty");
                return null;
            }

            try
            {
                using var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"role/{id}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var role = JsonConvert.DeserializeObject<RoleDto>(content);
                    _logger.LogInformation("MVC: Successfully retrieved role: {RoleName}", role?.Name);
                    return role;
                }

                _logger.LogWarning("MVC: Failed to get role with ID {RoleId}. Status: {StatusCode}", id, response.StatusCode);
                return null;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC: Get role by ID operation was cancelled");
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC: Exception occurred while fetching role with ID: {RoleId}", id);
                return null;
            }
        }

        /// <summary>
        /// Creates a new role via the API
        /// </summary>
        /// <param name="roleName">The role name</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>True if successful, false otherwise</returns>
        public async Task<bool> CreateRoleAsync(string roleName, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC: Creating new role: {RoleName}", roleName);

            if (string.IsNullOrWhiteSpace(roleName))
            {
                _logger.LogWarning("MVC: Role name cannot be null or empty");
                return false;
            }

            try
            {
                using var client = _httpClientService.CreateClient();
                var content = new StringContent($"\"{roleName}\"", Encoding.UTF8, "application/json");
                var response = await client.PostAsync("role", content, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("MVC: Role created successfully: {RoleName}", roleName);
                    return true;
                }

                var errorContent = await response.Content.ReadAsStringAsync();
                _logger.LogWarning("MVC: Failed to create role. Status: {StatusCode}, Error: {Error}",
                    response.StatusCode, errorContent);
                return false;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC: Create role operation was cancelled");
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC: Exception occurred while creating role: {RoleName}", roleName);
                return false;
            }
        }

        /// <summary>
        /// Updates an existing role via the API
        /// </summary>
        /// <param name="id">The role ID</param>
        /// <param name="roleName">The new role name</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>True if successful, false otherwise</returns>
        public async Task<bool> UpdateRoleAsync(string id, string roleName, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC: Updating role with ID: {RoleId} to name: {NewRoleName}", id, roleName);

            if (string.IsNullOrEmpty(id) || string.IsNullOrWhiteSpace(roleName))
            {
                _logger.LogWarning("MVC: Role ID or name cannot be null or empty");
                return false;
            }

            try
            {
                using var client = _httpClientService.CreateClient();
                var response = await client.PutAsJsonAsync($"role/{id}", roleName, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("MVC: Role updated successfully: {RoleName}", roleName);
                    return true;
                }

                var errorContent = await response.Content.ReadAsStringAsync();
                _logger.LogWarning("MVC: Failed to update role. Status: {StatusCode}, Error: {Error}",
                    response.StatusCode, errorContent);
                return false;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC: Update role operation was cancelled");
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC: Exception occurred while updating role with ID: {RoleId}", id);
                return false;
            }
        }

        /// <summary>
        /// Deletes a role via the API
        /// </summary>
        /// <param name="id">The role ID</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>True if successful, false otherwise</returns>
        public async Task<bool> DeleteRoleAsync(string id, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC: Deleting role with ID: {RoleId}", id);

            if (string.IsNullOrEmpty(id))
            {
                _logger.LogWarning("MVC: Role ID cannot be null or empty");
                return false;
            }

            try
            {
                using var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync($"role/{id}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("MVC: Role deleted successfully: {RoleId}", id);
                    return true;
                }

                var errorContent = await response.Content.ReadAsStringAsync();
                _logger.LogWarning("MVC: Failed to delete role. Status: {StatusCode}, Error: {Error}",
                    response.StatusCode, errorContent);
                return false;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC: Delete role operation was cancelled");
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC: Exception occurred while deleting role with ID: {RoleId}", id);
                return false;
            }
        }

        /// <summary>
        /// Deletes multiple roles in bulk via the API
        /// </summary>
        /// <param name="roleIds">List of role IDs</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>True if successful, false otherwise</returns>
        public async Task<bool> BulkDeleteRolesAsync(List<string> roleIds, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC: Bulk deleting {RoleCount} roles", roleIds?.Count ?? 0);

            if (roleIds == null || !roleIds.Any())
            {
                _logger.LogWarning("MVC: No role IDs provided for bulk delete");
                return false;
            }

            try
            {
                using var client = _httpClientService.CreateClient();
                var response = await client.PostAsJsonAsync("role/bulk-delete", roleIds, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("MVC: Bulk delete completed successfully for {RoleCount} roles", roleIds.Count);
                    return true;
                }

                var errorContent = await response.Content.ReadAsStringAsync();
                _logger.LogWarning("MVC: Failed to bulk delete roles. Status: {StatusCode}, Error: {Error}",
                    response.StatusCode, errorContent);
                return false;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC: Bulk delete roles operation was cancelled");
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC: Exception occurred while bulk deleting roles");
                return false;
            }
        }

        #endregion

        #region Role Claims Management

        /// <summary>
        /// Updates role claims via the API
        /// </summary>
        /// <param name="roleId">The role ID</param>
        /// <param name="claims">List of claims</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>True if successful, false otherwise</returns>
        public async Task<bool> UpdateRoleClaimsAsync(string roleId, List<ClaimDto> claims, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC: Updating claims for role ID: {RoleId}", roleId);

            if (string.IsNullOrEmpty(roleId) || claims == null)
            {
                _logger.LogWarning("MVC: Role ID or claims cannot be null");
                return false;
            }

            try
            {
                using var client = _httpClientService.CreateClient();
                var response = await client.PostAsJsonAsync($"role/{roleId}/claims",
                    new { RoleId = roleId, Claims = claims }, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("MVC: Claims updated successfully for role ID: {RoleId}", roleId);
                    return true;
                }

                var errorContent = await response.Content.ReadAsStringAsync();
                _logger.LogError("MVC: Failed to update claims. Status: {StatusCode}, Error: {Error}",
                    response.StatusCode, errorContent);
                return false;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC: Update role claims operation was cancelled");
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC: Error updating role claims for role ID: {RoleId}", roleId);
                return false;
            }
        }

        /// <summary>
        /// Retrieves role claims from the API
        /// </summary>
        /// <param name="roleId">The role ID</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>RoleClaimsDto object</returns>
        public async Task<RoleClaimsDto> GetRoleClaimsAsync(string roleId, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC: Getting claims for role ID: {RoleId}", roleId);

            if (string.IsNullOrEmpty(roleId))
            {
                _logger.LogWarning("MVC: Role ID cannot be null or empty");
                return new RoleClaimsDto();
            }

            try
            {
                using var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"role/{roleId}/claims", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var result = JsonConvert.DeserializeObject<RoleClaimsDto>(content);

                    _logger.LogInformation("MVC: Received claims for role {RoleId}: {ClaimCount} claims",
                        roleId, result?.Claims?.Count ?? 0);
                    return result ?? new RoleClaimsDto();
                }

                _logger.LogWarning("MVC: Failed to get role claims. Status: {StatusCode}", response.StatusCode);
                return new RoleClaimsDto();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC: Get role claims operation was cancelled");
                return new RoleClaimsDto();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC: Exception occurred while fetching role claims for role ID: {RoleId}", roleId);
                return new RoleClaimsDto();
            }
        }

        #endregion

        #region Role Statistics

        /// <summary>
        /// Retrieves role statistics from the API
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>RoleStatisticsDto object</returns>
        public async Task<RoleStatisticsDto> GetRolesStatisticsAsync(CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC: Getting role statistics");

            try
            {
                using var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("role/statistics", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var stats = JsonConvert.DeserializeObject<RoleStatisticsDto>(content);
                    _logger.LogInformation("MVC: Successfully retrieved role statistics");
                    return stats ?? new RoleStatisticsDto();
                }

                _logger.LogWarning("MVC: Failed to get role statistics. Status: {StatusCode}", response.StatusCode);
                return new RoleStatisticsDto();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC: Get role statistics operation was cancelled");
                return new RoleStatisticsDto();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC: Exception occurred while fetching role statistics");
                return new RoleStatisticsDto();
            }
        }

        #endregion

        #region User Role Management

        /// <summary>
        /// Retrieves users in a specific role from the API
        /// </summary>
        /// <param name="roleName">The role name</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of UserRoleDto objects</returns>
        public async Task<List<UserRoleDto>> GetUsersInRoleAsync(string roleName, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("MVC: Getting users in role: {RoleName}", roleName);

            if (string.IsNullOrEmpty(roleName))
            {
                _logger.LogWarning("MVC: Role name cannot be null or empty");
                return new List<UserRoleDto>();
            }

            try
            {
                using var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"role/{roleName}/users", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var users = JsonConvert.DeserializeObject<List<UserRoleDto>>(content) ?? new List<UserRoleDto>();
                    _logger.LogInformation("MVC: Retrieved {UserCount} users in role: {RoleName}", users.Count, roleName);
                    return users;
                }

                _logger.LogWarning("MVC: Failed to get users in role. Status: {StatusCode}", response.StatusCode);
                return new List<UserRoleDto>();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("MVC: Get users in role operation was cancelled");
                return new List<UserRoleDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "MVC: Exception occurred while fetching users in role: {RoleName}", roleName);
                return new List<UserRoleDto>();
            }
        }

        #endregion
    }
}