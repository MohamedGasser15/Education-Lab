using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    public interface IRefreshTokenRepository
    {
        Task SaveRefreshTokenAsync(string userId, string refreshToken, DateTime expiry);
        Task<bool> ValidateRefreshTokenAsync(string userId, string refreshToken);
        Task UpdateRefreshTokenAsync(string userId, string oldRefreshToken, string newRefreshToken, DateTime newExpiry);
        Task RevokeRefreshTokenAsync(string userId, string refreshToken);
        Task RevokeAllRefreshTokensAsync(string userId);
    }
}
