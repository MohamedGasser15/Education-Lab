using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Role;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service for managing application roles and permissions
    /// </summary>
    public class RoleService : IRoleService
    {
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IHistoryService _historyService;
        private readonly ICurrentUserService _currentUserService;
        private readonly ILogger<RoleService> _logger;

        /// <summary>
        /// Initializes a new instance of the RoleService class
        /// </summary>
        public RoleService(
            RoleManager<IdentityRole> roleManager,
            UserManager<ApplicationUser> userManager,
            IHistoryService historyService,
            ICurrentUserService currentUserService,
            ILogger<RoleService> logger)
        {
            _roleManager = roleManager;
            _userManager = userManager;
            _historyService = historyService;
            _currentUserService = currentUserService;
            _logger = logger;
        }

        #region Role Management Methods

        /// <summary>
        /// Retrieves all roles with user count for each role
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of RoleDto objects</returns>
        public async Task<List<RoleDto>> GetAllRolesAsync(CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("Retrieving all roles with user counts");

            try
            {
                var roles = await _roleManager.Roles
                    .AsNoTracking()
                    .ToListAsync(cancellationToken);

                var roleDtos = new List<RoleDto>();

                foreach (var role in roles)
                {
                    var userCount = (await _userManager.GetUsersInRoleAsync(role.Name)).Count;
                    roleDtos.Add(new RoleDto
                    {
                        Id = role.Id,
                        Name = role.Name,
                        UserCount = userCount
                    });
                }

                _logger.LogInformation("Successfully retrieved {RoleCount} roles", roles.Count);
                return roleDtos;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving all roles");
                throw;
            }
        }

        /// <summary>
        /// Retrieves a specific role by its ID
        /// </summary>
        /// <param name="id">The role ID</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>RoleDto object or null if not found</returns>
        public async Task<RoleDto> GetRoleByIdAsync(string id, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("Retrieving role with ID: {RoleId}", id);

            if (string.IsNullOrEmpty(id))
            {
                _logger.LogWarning("Role ID cannot be null or empty");
                return null;
            }

            try
            {
                var role = await _roleManager.FindByIdAsync(id);
                if (role == null)
                {
                    _logger.LogWarning("Role with ID {RoleId} not found", id);
                    return null;
                }

                var userCount = (await _userManager.GetUsersInRoleAsync(role.Name)).Count;
                var roleDto = new RoleDto
                {
                    Id = role.Id,
                    Name = role.Name,
                    UserCount = userCount
                };

                _logger.LogInformation("Successfully retrieved role: {RoleName}", role.Name);
                return roleDto;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving role with ID: {RoleId}", id);
                throw;
            }
        }

        /// <summary>
        /// Creates a new role
        /// </summary>
        /// <param name="roleName">The name of the role to create</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>True if creation succeeded, false otherwise</returns>
        public async Task<bool> CreateRoleAsync(string roleName, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("Creating new role: {RoleName}", roleName);

            if (string.IsNullOrWhiteSpace(roleName))
            {
                _logger.LogWarning("Role name cannot be null or empty");
                return false;
            }

            try
            {
                var normalizedRoleName = roleName.Trim();
                var role = new IdentityRole(normalizedRoleName);
                var result = await _roleManager.CreateAsync(role);

                if (result.Succeeded)
                {
                    _logger.LogInformation("Role created successfully: {RoleName}", normalizedRoleName);

                    var currentUserId = await _currentUserService.GetUserIdAsync();
                    if (!string.IsNullOrEmpty(currentUserId))
                    {
                        await _historyService.LogOperationAsync(
                            currentUserId,
                            $"قام المستخدم بإنشاء الدور الجديد [ID: {role.Id.Substring(0, 3)}...] باسم \"{normalizedRoleName}\".",
                            cancellationToken);
                    }

                    return true;
                }

                _logger.LogWarning("Failed to create role {RoleName}. Errors: {Errors}",
                    normalizedRoleName, string.Join(", ", result.Errors.Select(e => e.Description)));
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while creating role: {RoleName}", roleName);
                throw;
            }
        }

        /// <summary>
        /// Updates an existing role
        /// </summary>
        /// <param name="id">The role ID to update</param>
        /// <param name="roleName">The new role name</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>True if update succeeded, false otherwise</returns>
        public async Task<bool> UpdateRoleAsync(string id, string roleName, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("Updating role with ID: {RoleId} to name: {NewRoleName}", id, roleName);

            if (string.IsNullOrEmpty(id) || string.IsNullOrWhiteSpace(roleName))
            {
                _logger.LogWarning("Role ID or name cannot be null or empty");
                return false;
            }

            try
            {
                var role = await _roleManager.FindByIdAsync(id);
                if (role == null)
                {
                    _logger.LogWarning("Role with ID {RoleId} not found for update", id);
                    return false;
                }

                var normalizedRoleName = roleName.Trim();
                role.Name = normalizedRoleName;
                var result = await _roleManager.UpdateAsync(role);

                if (result.Succeeded)
                {
                    _logger.LogInformation("Role updated successfully: {RoleName}", normalizedRoleName);

                    var currentUserId = await _currentUserService.GetUserIdAsync();
                    if (!string.IsNullOrEmpty(currentUserId))
                    {
                        await _historyService.LogOperationAsync(
                            currentUserId,
                            $"قام المستخدم بتحديث بيانات الدور [ID: {role.Id.Substring(0, 3)}...] باسم \"{normalizedRoleName}\".",
                            cancellationToken);
                    }

                    return true;
                }

                _logger.LogWarning("Failed to update role {RoleName}. Errors: {Errors}",
                    normalizedRoleName, string.Join(", ", result.Errors.Select(e => e.Description)));
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while updating role with ID: {RoleId}", id);
                throw;
            }
        }

        /// <summary>
        /// Deletes a role by its ID
        /// </summary>
        /// <param name="id">The role ID to delete</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>True if deletion succeeded, false otherwise</returns>
        public async Task<bool> DeleteRoleAsync(string id, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("Deleting role with ID: {RoleId}", id);

            if (string.IsNullOrEmpty(id))
            {
                _logger.LogWarning("Role ID cannot be null or empty");
                return false;
            }

            try
            {
                var role = await _roleManager.FindByIdAsync(id);
                if (role == null)
                {
                    _logger.LogWarning("Role with ID {RoleId} not found for deletion", id);
                    return false;
                }

                // Check if role has users
                var usersInRole = await _userManager.GetUsersInRoleAsync(role.Name);
                if (usersInRole.Any())
                {
                    _logger.LogWarning("Cannot delete role {RoleName} because it has {UserCount} users assigned",
                        role.Name, usersInRole.Count);
                    return false;
                }

                var result = await _roleManager.DeleteAsync(role);

                if (result.Succeeded)
                {
                    _logger.LogInformation("Role deleted successfully: {RoleName}", role.Name);

                    var currentUserId = await _currentUserService.GetUserIdAsync();
                    if (!string.IsNullOrEmpty(currentUserId))
                    {
                        await _historyService.LogOperationAsync(
                            currentUserId,
                            $"قام المستخدم بحذف الدور [ID: {role.Id.Substring(0, 3)}...] باسم \"{role.Name}\".",
                            cancellationToken);
                    }

                    return true;
                }

                _logger.LogWarning("Failed to delete role {RoleName}. Errors: {Errors}",
                    role.Name, string.Join(", ", result.Errors.Select(e => e.Description)));
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while deleting role with ID: {RoleId}", id);
                throw;
            }
        }

        /// <summary>
        /// Deletes multiple roles in bulk
        /// </summary>
        /// <param name="roleIds">List of role IDs to delete</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>True if all deletions succeeded, false otherwise</returns>
        public async Task<bool> BulkDeleteRolesAsync(List<string> roleIds, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("Bulk deleting {RoleCount} roles", roleIds?.Count ?? 0);

            if (roleIds == null || !roleIds.Any())
            {
                _logger.LogWarning("No role IDs provided for bulk deletion");
                return false;
            }

            bool allSucceeded = true;

            foreach (var id in roleIds)
            {
                if (cancellationToken.IsCancellationRequested)
                {
                    _logger.LogWarning("Bulk delete operation cancelled");
                    break;
                }

                try
                {
                    var role = await _roleManager.FindByIdAsync(id);
                    if (role == null)
                    {
                        _logger.LogWarning("Role with ID {RoleId} not found in bulk delete", id);
                        allSucceeded = false;
                        continue;
                    }

                    // Check if role has users
                    var usersInRole = await _userManager.GetUsersInRoleAsync(role.Name);
                    if (usersInRole.Any())
                    {
                        _logger.LogWarning("Skipping role {RoleName} in bulk delete - has {UserCount} users",
                            role.Name, usersInRole.Count);
                        allSucceeded = false;
                        continue;
                    }

                    var result = await _roleManager.DeleteAsync(role);
                    if (result.Succeeded)
                    {
                        _logger.LogInformation("Deleted role in bulk: {RoleName}", role.Name);

                        var currentUserId = await _currentUserService.GetUserIdAsync();
                        if (!string.IsNullOrEmpty(currentUserId))
                        {
                            await _historyService.LogOperationAsync(
                                currentUserId,
                                $"قام المستخدم بحذف الرول [ID: {role.Id.Substring(0, 3)}...] باسم \"{role.Name}\".",
                                cancellationToken);
                        }
                    }
                    else
                    {
                        _logger.LogWarning("Failed to delete role {RoleName} in bulk. Errors: {Errors}",
                            role.Name, string.Join(", ", result.Errors.Select(e => e.Description)));
                        allSucceeded = false;
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error occurred while deleting role with ID: {RoleId} in bulk", id);
                    allSucceeded = false;
                }
            }

            return allSucceeded;
        }

        #endregion

        #region Role Claims Management

        /// <summary>
        /// Retrieves claims for a specific role
        /// </summary>
        /// <param name="roleId">The role ID</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>RoleClaimsDto object or null if role not found</returns>
        public async Task<RoleClaimsDto> GetRoleClaimsAsync(string roleId, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("Retrieving claims for role ID: {RoleId}", roleId);

            if (string.IsNullOrEmpty(roleId))
            {
                _logger.LogWarning("Role ID cannot be null or empty");
                return null;
            }

            try
            {
                var role = await _roleManager.FindByIdAsync(roleId);
                if (role == null)
                {
                    _logger.LogWarning("Role with ID {RoleId} not found", roleId);
                    return null;
                }

                var existingClaims = await _roleManager.GetClaimsAsync(role);
                var allClaims = GetAvailableClaims();

                var roleClaimsDto = new RoleClaimsDto
                {
                    RoleId = role.Id,
                    RoleName = role.Name,
                    Claims = allClaims.Select(c => new ClaimDto
                    {
                        Type = c.Type,
                        Value = c.Value,
                        Selected = existingClaims.Any(ec => ec.Type == c.Type && ec.Value == c.Value)
                    }).ToList()
                };

                _logger.LogInformation("Retrieved {ClaimCount} claims for role: {RoleName}",
                    roleClaimsDto.Claims.Count, role.Name);
                return roleClaimsDto;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving claims for role ID: {RoleId}", roleId);
                throw;
            }
        }

        /// <summary>
        /// Updates claims for a specific role
        /// </summary>
        /// <param name="roleId">The role ID</param>
        /// <param name="claims">List of claims to update</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>True if update succeeded, false otherwise</returns>
        public async Task<bool> UpdateRoleClaimsAsync(string roleId, List<ClaimDto> claims, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("Updating claims for role ID: {RoleId}", roleId);

            if (string.IsNullOrEmpty(roleId) || claims == null)
            {
                _logger.LogWarning("Role ID or claims cannot be null");
                return false;
            }

            try
            {
                var role = await _roleManager.FindByIdAsync(roleId);
                if (role == null)
                {
                    _logger.LogWarning("Role with ID {RoleId} not found for claims update", roleId);
                    return false;
                }

                // Remove all existing claims
                var existingClaims = await _roleManager.GetClaimsAsync(role);
                foreach (var claim in existingClaims)
                {
                    var removeResult = await _roleManager.RemoveClaimAsync(role, claim);
                    if (!removeResult.Succeeded)
                    {
                        _logger.LogWarning("Failed to remove claim {ClaimType}:{ClaimValue} from role {RoleName}",
                            claim.Type, claim.Value, role.Name);
                    }
                }

                // Add new selected claims
                var selectedClaims = claims.Where(c => c.Selected)
                                           .Select(c => new Claim(c.Type, c.Value));

                foreach (var claim in selectedClaims)
                {
                    var addResult = await _roleManager.AddClaimAsync(role, claim);
                    if (!addResult.Succeeded)
                    {
                        _logger.LogWarning("Failed to add claim {ClaimType}:{ClaimValue} to role {RoleName}",
                            claim.Type, claim.Value, role.Name);
                        return false;
                    }
                }

                // Log operation
                var currentUserId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(currentUserId))
                {
                    await _historyService.LogOperationAsync(
                        currentUserId,
                        $"قام المستخدم بتحديث الصلاحيات للدور [ID: {role.Id.Substring(0, 3)}...] باسم \"{role.Name}\".",
                        cancellationToken);
                }

                _logger.LogInformation("Successfully updated {ClaimCount} claims for role: {RoleName}",
                    selectedClaims.Count(), role.Name);
                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while updating claims for role ID: {RoleId}", roleId);
                throw;
            }
        }

        #endregion

        #region User Role Management

        /// <summary>
        /// Retrieves all users in a specific role
        /// </summary>
        /// <param name="roleName">The role name</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of UserRoleDto objects</returns>
        public async Task<List<UserRoleDto>> GetUsersInRoleAsync(string roleName, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("Retrieving users in role: {RoleName}", roleName);

            if (string.IsNullOrEmpty(roleName))
            {
                _logger.LogWarning("Role name cannot be null or empty");
                return new List<UserRoleDto>();
            }

            try
            {
                var users = await _userManager.GetUsersInRoleAsync(roleName);
                var userDtos = users.Select(u => new UserRoleDto
                {
                    UserId = u.Id,
                    UserName = u.UserName,
                    Email = u.Email,
                    FullName = u.FullName,
                    CreatedAt = u.CreatedAt,
                    ProfileImage = $"https://ui-avatars.com/api/?name={Uri.EscapeDataString(u.FullName)}&background=random"
                }).ToList();

                _logger.LogInformation("Retrieved {UserCount} users in role: {RoleName}", userDtos.Count, roleName);
                return userDtos;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving users in role: {RoleName}", roleName);
                throw;
            }
        }

        /// <summary>
        /// Counts users in a specific role
        /// </summary>
        /// <param name="roleName">The role name</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>Number of users in the role</returns>
        public async Task<int> CountUsersInRoleAsync(string roleName, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("Counting users in role: {RoleName}", roleName);

            if (string.IsNullOrEmpty(roleName))
            {
                _logger.LogWarning("Role name cannot be null or empty");
                return 0;
            }

            try
            {
                var users = await _userManager.GetUsersInRoleAsync(roleName);
                _logger.LogInformation("Found {UserCount} users in role: {RoleName}", users.Count, roleName);
                return users.Count;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while counting users in role: {RoleName}", roleName);
                throw;
            }
        }

        #endregion

        #region Statistics Methods

        /// <summary>
        /// Retrieves role statistics
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>Tuple containing role statistics</returns>
        public async Task<(int TotalRoles, int ActiveRoles, int SystemRoles, string LatestRoleDate)> GetRolesStatisticsAsync(CancellationToken cancellationToken = default)
        {
            _logger.LogInformation("Retrieving role statistics");

            try
            {
                var roles = await _roleManager.Roles
                    .AsNoTracking()
                    .ToListAsync(cancellationToken);

                var totalRoles = roles.Count;
                var activeRoles = totalRoles; // All roles are considered active in this implementation

                var systemRoles = roles.Count(r =>
                    r.Name == "Admin" || r.Name == "Supervisor" || r.Name == "Teacher" || r.Name == "Student");

                var latestRoleDate = roles.Any() ?
                    roles.Max(r => r.Id.GetCreationTime()).ToString("yyyy-MM-dd") : "N/A";

                _logger.LogInformation("Role statistics retrieved: Total={Total}, Active={Active}, System={System}, Latest={Latest}",
                    totalRoles, activeRoles, systemRoles, latestRoleDate);

                return (totalRoles, activeRoles, systemRoles, latestRoleDate);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving role statistics");
                throw;
            }
        }

        #endregion

        #region Helper Methods

        /// <summary>
        /// Gets all available claims in the system
        /// </summary>
        /// <returns>List of available claims</returns>
        private List<Claim> GetAvailableClaims()
        {
            return new List<Claim>
            {
                new Claim("Users", "View"),
                new Claim("Users", "Edit"),
                new Claim("Users", "Delete"),
                new Claim("Users", "Lock"),
                new Claim("Roles", "View"),
                new Claim("Roles", "Create"),
                new Claim("Roles", "Edit"),
                new Claim("Roles", "Delete"),
                new Claim("Roles", "Claims"),
                new Claim("Courses", "View"),
                new Claim("Courses", "Create"),
                new Claim("Courses", "Edit"),
                new Claim("Courses", "Delete"),
                new Claim("Categories", "View"),
                new Claim("Categories", "Create"),
                new Claim("Categories", "Edit"),
                new Claim("Categories", "Delete"),
                new Claim("Dashboard", "View"),
                new Claim("Histories", "View"),
                new Claim("Reports", "View")
            };
        }

        #endregion
    }
}