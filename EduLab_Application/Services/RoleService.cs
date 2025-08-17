using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Role;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class RoleService : IRoleService
    {
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly UserManager<ApplicationUser> _userManager;

        public RoleService(RoleManager<IdentityRole> roleManager, UserManager<ApplicationUser> userManager)
        {
            _roleManager = roleManager;
            _userManager = userManager;
        }

        public async Task<List<RoleDto>> GetAllRolesAsync()
        {
            var roles = await _roleManager.Roles.ToListAsync();
            var roleDtos = new List<RoleDto>();

            foreach (var role in roles)
            {
                var userCount = await _userManager.GetUsersInRoleAsync(role.Name);
                roleDtos.Add(new RoleDto
                {
                    Id = role.Id,
                    Name = role.Name,
                    UserCount = userCount.Count
                });
            }

            return roleDtos;
        }

        public async Task<RoleDto> GetRoleByIdAsync(string id)
        {
            var role = await _roleManager.FindByIdAsync(id);
            if (role == null) return null;

            var userCount = await _userManager.GetUsersInRoleAsync(role.Name);
            return new RoleDto
            {
                Id = role.Id,
                Name = role.Name,
                UserCount = userCount.Count
            };
        }

        public async Task<IdentityResult> CreateRoleAsync(string roleName)
        {
            return await _roleManager.CreateAsync(new IdentityRole(roleName.Trim()));
        }

        public async Task<IdentityResult> UpdateRoleAsync(string id, string roleName)
        {
            var role = await _roleManager.FindByIdAsync(id);
            if (role == null) return IdentityResult.Failed(new IdentityError { Description = "Role not found" });

            role.Name = roleName.Trim();
            return await _roleManager.UpdateAsync(role);
        }

        public async Task<IdentityResult> DeleteRoleAsync(string id)
        {
            var role = await _roleManager.FindByIdAsync(id);
            if (role == null) return IdentityResult.Failed(new IdentityError { Description = "Role not found" });

            // Check if any users are in this role
            var usersInRole = await _userManager.GetUsersInRoleAsync(role.Name);
            if (usersInRole.Any())
            {
                return IdentityResult.Failed(new IdentityError { Description = "Cannot delete role with assigned users" });
            }

            return await _roleManager.DeleteAsync(role);
        }

        public async Task<int> CountUsersInRoleAsync(string roleName)
        {
            var users = await _userManager.GetUsersInRoleAsync(roleName);
            return users.Count;
        }

        public async Task<RoleClaimsDto> GetRoleClaimsAsync(string roleId)
        {
            var role = await _roleManager.FindByIdAsync(roleId);
            if (role == null) return null;

            var existingClaims = await _roleManager.GetClaimsAsync(role);
            var allClaims = GetAvailableClaims();

            return new RoleClaimsDto
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
        }

        public async Task<IdentityResult> UpdateRoleClaimsAsync(string roleId, List<ClaimDto> claims)
        {
            var role = await _roleManager.FindByIdAsync(roleId);
            if (role == null) return IdentityResult.Failed(new IdentityError { Description = "Role not found" });

            // Remove all existing claims
            var existingClaims = await _roleManager.GetClaimsAsync(role);
            foreach (var claim in existingClaims)
            {
                await _roleManager.RemoveClaimAsync(role, claim);
            }

            // Add selected claims
            var selectedClaims = claims.Where(c => c.Selected)
                .Select(c => new Claim(c.Type, c.Value));

            foreach (var claim in selectedClaims)
            {
                var result = await _roleManager.AddClaimAsync(role, claim);
                if (!result.Succeeded) return result;
            }

            return IdentityResult.Success;
        }

        public async Task<List<UserRoleDto>> GetUsersInRoleAsync(string roleName)
        {
            var users = await _userManager.GetUsersInRoleAsync(roleName);
            return users.Select(u => new UserRoleDto
            {
                UserId = u.Id,
                UserName = u.UserName,
                Email = u.Email,
                FullName = u.FullName,
                CreatedAt = u.CreatedAt,
                ProfileImage = $"https://ui-avatars.com/api/?name={u.FullName}&background=random"
            }).ToList();
        }

        public async Task<(int TotalRoles, int ActiveRoles, int SystemRoles, string LatestRoleDate)> GetRolesStatisticsAsync()
        {
            var roles = await _roleManager.Roles.ToListAsync();
            var totalRoles = roles.Count;

            // For this example, we'll consider all roles as active
            var activeRoles = totalRoles;

            // System roles are the default ones
            var systemRoles = roles.Count(r =>
                r.Name == "Admin" || r.Name == "Supervisor" || r.Name == "Teacher" || r.Name == "Student");

            var latestRoleDate = roles.Any() ?
                roles.Max(r => r.Id.GetCreationTime()).ToString("yyyy-MM-dd") : "N/A";

            return (totalRoles, activeRoles, systemRoles, latestRoleDate);
        }

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
    }
}

