using EduLab_Shared.DTOs.Role;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Interface for role management services
    /// </summary>
    public interface IRoleService
    {
        #region Role Management

        /// <summary>
        /// Retrieves all roles with user counts
        /// </summary>
        Task<List<RoleDto>> GetAllRolesAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a specific role by ID
        /// </summary>
        Task<RoleDto> GetRoleByIdAsync(string id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Creates a new role
        /// </summary>
        Task<bool> CreateRoleAsync(string roleName, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing role
        /// </summary>
        Task<bool> UpdateRoleAsync(string id, string roleName, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a role by ID
        /// </summary>
        Task<bool> DeleteRoleAsync(string id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes multiple roles in bulk
        /// </summary>
        Task<bool> BulkDeleteRolesAsync(List<string> roleIds, CancellationToken cancellationToken = default);

        /// <summary>
        /// Counts users in a specific role
        /// </summary>
        Task<int> CountUsersInRoleAsync(string roleName, CancellationToken cancellationToken = default);

        #endregion

        #region Role Claims Management

        /// <summary>
        /// Retrieves claims for a specific role
        /// </summary>
        Task<RoleClaimsDto> GetRoleClaimsAsync(string roleId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates claims for a specific role
        /// </summary>
        Task<bool> UpdateRoleClaimsAsync(string roleId, List<ClaimDto> claims, CancellationToken cancellationToken = default);

        #endregion

        #region User Role Management

        /// <summary>
        /// Retrieves users in a specific role
        /// </summary>
        Task<List<UserRoleDto>> GetUsersInRoleAsync(string roleName, CancellationToken cancellationToken = default);

        #endregion

        #region Statistics

        /// <summary>
        /// Retrieves role statistics
        /// </summary>
        Task<(int TotalRoles, int ActiveRoles, int SystemRoles, string LatestRoleDate)> GetRolesStatisticsAsync(CancellationToken cancellationToken = default);

        #endregion
    }
}