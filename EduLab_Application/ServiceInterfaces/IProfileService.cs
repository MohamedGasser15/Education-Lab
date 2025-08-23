using EduLab_Shared.DTOs.Profile;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IProfileService
    {
        Task<ProfileDTO> GetUserProfileAsync(string userId);
        Task<InstructorProfileDTO> GetInstructorProfileAsync(string userId, int latestCoursesCount = 2);
        Task<bool> UpdateInstructorProfileAsync(UpdateInstructorProfileDTO updateProfileDto);
        Task<string> UploadInstructorProfileImageAsync(ProfileImageDTO profileImageDto);
        Task<bool> UpdateUserProfileAsync(UpdateProfileDTO updateProfileDto);
        Task<string> UploadProfileImageAsync(ProfileImageDTO profileImageDto);
        Task<CertificateDTO> AddCertificateAsync(string userId, CertificateDTO dto);
        Task<bool> DeleteCertificateAsync(string userId, int certId);
    }
}
