using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    public class ProfileRepository : IProfileRepository
    {
        private readonly UserManager<ApplicationUser> _userManager;

        public ProfileRepository(UserManager<ApplicationUser> userManager)
        {
            _userManager = userManager;
        }

        public async Task<ApplicationUser> GetUserProfileAsync(string userId)
        {
            return await _userManager.Users
                .FirstOrDefaultAsync(u => u.Id == userId);
        }

        public async Task<bool> UpdateUserProfileAsync(ApplicationUser user)
        {
            var result = await _userManager.UpdateAsync(user);
            return result.Succeeded;
        }

        public async Task<bool> UpdateProfileImageAsync(string userId, string imageUrl)
        {
            var user = await _userManager.FindByIdAsync(userId);
            if (user == null) return false;

            user.ProfileImageUrl = imageUrl;
            var result = await _userManager.UpdateAsync(user);

            return result.Succeeded;
        }
    }
}
