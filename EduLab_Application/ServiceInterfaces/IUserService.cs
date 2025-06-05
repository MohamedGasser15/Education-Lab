using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Auth;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IUserService
    {
        Task<APIResponse> Register(RegisterRequestDTO request);
        Task<List<UserDTO>> GetAllUsersWithRolesAsync();
        Task<bool> DeleteUserAsync(string id);
    }
}
