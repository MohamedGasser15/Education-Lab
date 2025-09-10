using EduLab_MVC.Models.DTOs.Roles;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for managing roles in the MVC application
    /// </summary>
    public interface IRoleService
    {
        #region Role CRUD Operations

        /// <summary>
        /// Retrieves all roles from the API
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of RoleDto objects</returns>
        Task<List<RoleDto>> GetAllRolesAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a specific role by ID from the API
        /// </summary>
        /// <param name="id">The role ID</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>RoleDto object or null</returns>
        Task<RoleDto> GetRoleByIdAsync(string id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Creates a new role via the API
        /// </summary>
        /// <param name="roleName">The role name</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>True if successful, false otherwise</returns>
        Task<bool> CreateRoleAsync(string roleName, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing role via the API
        /// </summary>
        /// <param name="id">The role ID</param>
        /// <param name="roleName">The new role name</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>True if successful, false otherwise</returns>
        Task<bool> UpdateRoleAsync(string id, string roleName, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a role via the API
        /// </summary>
        /// <param name="id">The role ID</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>True if successful, false otherwise</returns>
        Task<bool> DeleteRoleAsync(string id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes multiple roles in bulk via the API
        /// </summary>
        /// <param name="roleIds">List of role IDs</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>True if successful, false otherwise</returns>
        Task<bool> BulkDeleteRolesAsync(List<string> roleIds, CancellationToken cancellationToken = default);

        #endregion

        #region Role Claims Management

        /// <summary>
        /// Updates role claims via the API
        /// </summary>
        /// <param name="roleId">The role ID</param>
        /// <param name="claims">List of claims</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>True if successful, false otherwise</returns>
        Task<bool> UpdateRoleClaimsAsync(string roleId, List<ClaimDto> claims, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves role claims from the API
        /// </summary>
        /// <param name="roleId">The role ID</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>RoleClaimsDto object</returns>
        Task<RoleClaimsDto> GetRoleClaimsAsync(string roleId, CancellationToken cancellationToken = default);

        #endregion

        #region Role Statistics

        /// <summary>
        /// Retrieves role statistics from the API
        /// </summary>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>RoleStatisticsDto object</returns>
        Task<RoleStatisticsDto> GetRolesStatisticsAsync(CancellationToken cancellationToken = default);

        #endregion

        #region User Role Management

        /// <summary>
        /// Retrieves users in a specific role from the API
        /// </summary>
        /// <param name="roleName">The role name</param>
        /// <param name="cancellationToken">Cancellation token for async operation</param>
        /// <returns>List of UserRoleDto objects</returns>
        Task<List<UserRoleDto>> GetUsersInRoleAsync(string roleName, CancellationToken cancellationToken = default);

        #endregion
    }
}
