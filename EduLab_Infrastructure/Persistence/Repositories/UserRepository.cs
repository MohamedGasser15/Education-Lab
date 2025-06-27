using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Auth;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    public class UserRepository : IUserRepository
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;

        public UserRepository(UserManager<ApplicationUser> userManager, RoleManager<IdentityRole> roleManager)
        {
            _userManager = userManager;
            _roleManager = roleManager;
        }

        public async Task<ApplicationUser> GetUserByEmail(string email)
        {
            return await _userManager.FindByEmailAsync(email);
        }

        public async Task<ApplicationUser> GetUserById(string id)
        {
            return await _userManager.FindByIdAsync(id);
        }

        public async Task<bool> CheckPassword(ApplicationUser user, string password)
        {
            return await _userManager.CheckPasswordAsync(user, password);
        }

        public async Task<IList<string>> GetUserRoles(ApplicationUser user)
        {
            return await _userManager.GetRolesAsync(user);
        }

        public async Task<ApplicationUser> GetUserByUserName(string userName)
        {
            var user = await _userManager.FindByNameAsync(userName);
            return user;
        }

        public async Task<IdentityResult> CreateUser(ApplicationUser user, string password)
        {
            if (!_roleManager.RoleExistsAsync(SD.Admin).GetAwaiter().GetResult())
            {
                await _roleManager.CreateAsync(new IdentityRole(SD.Admin));
                await _roleManager.CreateAsync(new IdentityRole(SD.Instructor));
                await _roleManager.CreateAsync(new IdentityRole(SD.Student));
                await _roleManager.CreateAsync(new IdentityRole(SD.Support));
                await _roleManager.CreateAsync(new IdentityRole(SD.Moderator));
            }
            user.CreatedAt = DateTime.UtcNow;
            var result = await _userManager.CreateAsync(user, password);

            if (!result.Succeeded)
            {
                return result;
            }

            await _userManager.AddToRoleAsync(user, SD.Student);

            return IdentityResult.Success;
        }
        public async Task<List<ApplicationUser>> GetAllUsersWithRolesAsync()
        {
            var users = _userManager.Users.ToList();
            var userList = new List<ApplicationUser>();

            foreach (var user in users)
            {
                var roles = await _userManager.GetRolesAsync(user);

                user.Role = roles.Count > 0 ? string.Join(", ", roles) : "None";

                userList.Add(user);
            }

            return userList;
        }
        public async Task<bool> DeleteUserAsync(string id)
        {
            var user = await _userManager.FindByIdAsync(id);
            if (user == null) return false;

            var result = await _userManager.DeleteAsync(user);
            return result.Succeeded;
        }
        public async Task<bool> DeleteRangeUserAsync(List<string> userIds)
        {
            var users = new List<ApplicationUser>();

            foreach (var id in userIds)
            {
                var user = await _userManager.FindByIdAsync(id);
                if (user != null)
                {
                    users.Add(user);
                }
            }

            foreach (var user in users)
            {
                var result = await _userManager.DeleteAsync(user);
                if (!result.Succeeded)
                    return false;
            }

            return true;
        }
        public async Task<bool> IsEmailExistsAsync(string email)
        {
            var emailUser = await _userManager.FindByEmailAsync(email);
            return emailUser != null;
        }
        public async Task<bool> IsFullNameExistsAsync(string fullName)
        {
            var user = await _userManager.Users.FirstOrDefaultAsync(u => u.FullName == fullName);
            return user != null;
        }
        public async Task<IdentityResult> UpdateUserAsync(string userId, string fullName, string role)
        {
            var existingUser = await _userManager.FindByIdAsync(userId);
            if (existingUser == null)
                return IdentityResult.Failed(new IdentityError { Description = "User not found" });

            existingUser.FullName = fullName;

            var updateResult = await _userManager.UpdateAsync(existingUser);
            if (!updateResult.Succeeded)
                return updateResult;

            var currentRoles = await _userManager.GetRolesAsync(existingUser);
            var removeResult = await _userManager.RemoveFromRolesAsync(existingUser, currentRoles);
            if (!removeResult.Succeeded)
                return removeResult;

            var addRoleResult = await _userManager.AddToRoleAsync(existingUser, role);
            if (!addRoleResult.Succeeded)
                return addRoleResult;

            return IdentityResult.Success;
        }
        public async Task UpdateAsync(ApplicationUser user)
        {
            var result = await _userManager.UpdateAsync(user);
            if (!result.Succeeded)
            {
                throw new Exception("فشل في تحديث المستخدم: " + string.Join(", ", result.Errors.Select(e => e.Description)));
            }
        }
        public async Task<List<ApplicationUser>> GetInstructorsAsync()
        {
            var users = _userManager.Users.ToList();
            var instructorList = new List<ApplicationUser>();

            foreach (var user in users)
            {
                var roles = await _userManager.GetRolesAsync(user);

                if (roles.Contains(SD.Instructor))
                {
                    user.Role = string.Join(", ", roles);
                    instructorList.Add(user);
                }
            }

            return instructorList;
        }
        public async Task<List<ApplicationUser>> GetAdminsAsync()
        {
            var users = _userManager.Users.ToList();
            var AdminList = new List<ApplicationUser>();

            foreach (var user in users)
            {
                var roles = await _userManager.GetRolesAsync(user);

                if (roles.Contains(SD.Admin))
                {
                    user.Role = string.Join(", ", roles);
                    AdminList.Add(user);
                }
            }

            return AdminList;
        }
        public async Task<List<UserDTO>> LockUsersAsync(List<string> userIds, int minutes)
        {
            var result = new List<UserDTO>();

            foreach (var userId in userIds)
            {
                var user = await _userManager.FindByIdAsync(userId);
                if (user != null)
                {
                    await _userManager.SetLockoutEnabledAsync(user, true);
                    await _userManager.SetLockoutEndDateAsync(user, DateTimeOffset.UtcNow.AddMinutes(minutes));
                    bool isLocked = await _userManager.IsLockedOutAsync(user);

                    result.Add(new UserDTO
                    {
                        Id = user.Id,
                        FullName = user.FullName,
                        Email = user.Email,
                        IsLocked = isLocked
                    });
                }
            }

            return result;
        }

        public async Task<List<UserDTO>> UnlockUsersAsync(List<string> userIds)
        {
            var result = new List<UserDTO>();

            foreach (var userId in userIds)
            {
                var user = await _userManager.FindByIdAsync(userId);
                if (user != null)
                {
                    await _userManager.SetLockoutEndDateAsync(user, null);
                    await _userManager.SetLockoutEnabledAsync(user, false);
                    bool isLocked = await _userManager.IsLockedOutAsync(user);

                    result.Add(new UserDTO
                    {
                        Id = user.Id,
                        FullName = user.FullName,
                        Email = user.Email,
                        IsLocked = isLocked
                    });
                }
            }

            return result;
        }
    }
}
