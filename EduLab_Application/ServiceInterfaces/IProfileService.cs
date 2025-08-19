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
        Task<bool> UpdateUserProfileAsync(UpdateProfileDTO updateProfileDto);
        Task<string> UploadProfileImageAsync(ProfileImageDTO profileImageDto);
    }
}
