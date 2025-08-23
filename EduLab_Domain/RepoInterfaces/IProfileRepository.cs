using EduLab_Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    public interface IProfileRepository
    {
        Task<ApplicationUser> GetUserProfileAsync(string userId);
        Task<bool> UpdateUserProfileAsync(ApplicationUser user);
        Task<bool> UpdateProfileImageAsync(string userId, string imageUrl);
        Task<ApplicationUser> GetInstructorProfileAsync(string userId);
        Task<bool> UpdateInstructorProfileAsync(ApplicationUser user);
        Task<bool> UpdateInstructorProfileImageAsync(string userId, string imageUrl);
        Task<Certificate> AddCertificateAsync(Certificate certificate);
        Task<bool> DeleteCertificateAsync(int certId, string userId);
    }
}
