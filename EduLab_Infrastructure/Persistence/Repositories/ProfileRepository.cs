using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
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
        private readonly ApplicationDbContext _db;

        public ProfileRepository(UserManager<ApplicationUser> userManager, ApplicationDbContext db)
        {
            _userManager = userManager;
            _db = db;
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
        public async Task<ApplicationUser> GetInstructorProfileAsync(string userId)
        {
            var user = await _db.Users
                .Include(u => u.Certificates)
                .FirstOrDefaultAsync(u => u.Id == userId);

            if (user != null && await _userManager.IsInRoleAsync(user, "Instructor"))
            {
                return user;
            }
            return null;
        }

        public async Task<bool> UpdateInstructorProfileAsync(ApplicationUser user)
        {
            if (!await _userManager.IsInRoleAsync(user, "Instructor"))
                return false;

            _db.Users.Update(user);
            await _db.SaveChangesAsync();
            return true;
        }

        public async Task<bool> UpdateInstructorProfileImageAsync(string userId, string imageUrl)
        {
            var user = await GetInstructorProfileAsync(userId);
            if (user == null) return false;

            user.ProfileImageUrl = imageUrl;
            return await UpdateInstructorProfileAsync(user);
        }

        public async Task<Certificate> AddCertificateAsync(Certificate certificate)
        {
            var user = await GetInstructorProfileAsync(certificate.UserId);
            if (user == null) return null;

            _db.Certificates.Add(certificate);
            await _db.SaveChangesAsync();
            return certificate;
        }

        public async Task<bool> DeleteCertificateAsync(int certId, string userId)
        {
            var cert = await _db.Certificates.FirstOrDefaultAsync(c => c.Id == certId && c.UserId == userId);
            if (cert == null) return false;

            var user = await GetInstructorProfileAsync(userId);
            if (user == null) return false;

            _db.Certificates.Remove(cert);
            await _db.SaveChangesAsync();
            return true;
        }
    }
}
