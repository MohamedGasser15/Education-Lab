using EduLab_Shared.DTOs.Auth;
using EduLab_Shared.DTOs.Token;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IAuthService
    {
        Task<LoginResponseDTO> Login(LoginRequestDTO request);
        Task<TokenResponseDTO> RefreshToken(RefreshTokenRequestDTO request);
        Task RevokeRefreshToken(string userId, string refreshToken);
    }
}
