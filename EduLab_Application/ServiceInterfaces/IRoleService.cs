using EduLab_Shared.DTOs.Role;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IRoleService
    {
        Task<List<RoleDto>> GetAllRolesAsync();
        Task<RoleDto> GetRoleByIdAsync(string id);
        Task<IdentityResult> CreateRoleAsync(string roleName);
        Task<IdentityResult> UpdateRoleAsync(string id, string roleName);
        Task<IdentityResult> DeleteRoleAsync(string id);
        Task<IdentityResult> BulkDeleteRolesAsync(List<string> roleIds);
        Task<int> CountUsersInRoleAsync(string roleName);
        Task<RoleClaimsDto> GetRoleClaimsAsync(string roleId);
        Task<IdentityResult> UpdateRoleClaimsAsync(string roleId, List<ClaimDto> claims);
        Task<List<UserRoleDto>> GetUsersInRoleAsync(string roleName);
        Task<(int TotalRoles, int ActiveRoles, int SystemRoles, string LatestRoleDate)> GetRolesStatisticsAsync();
    }
}
