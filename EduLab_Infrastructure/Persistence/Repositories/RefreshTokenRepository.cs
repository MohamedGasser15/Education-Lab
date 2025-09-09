using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    public class RefreshTokenRepository : IRefreshTokenRepository
    {
        private readonly ApplicationDbContext _context;

        public RefreshTokenRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task SaveRefreshTokenAsync(string userId, string refreshToken, DateTime expiry)
        {
            var token = new RefreshToken
            {
                UserId = userId,
                Token = refreshToken,
                Expiry = expiry,
                CreatedAt = DateTime.UtcNow,
                IsRevoked = false
            };

            _context.RefreshTokens.Add(token);
            await _context.SaveChangesAsync();
        }

        public async Task<bool> ValidateRefreshTokenAsync(string userId, string refreshToken)
        {
            var token = await _context.RefreshTokens
                .Where(rt => rt.UserId == userId &&
                            rt.Token == refreshToken &&
                            rt.Expiry > DateTime.UtcNow &&
                            !rt.IsRevoked)
                .FirstOrDefaultAsync();

            return token != null;
        }

        public async Task UpdateRefreshTokenAsync(string userId, string oldRefreshToken, string newRefreshToken, DateTime newExpiry)
        {
            var oldToken = await _context.RefreshTokens
                .Where(rt => rt.UserId == userId && rt.Token == oldRefreshToken)
                .FirstOrDefaultAsync();

            if (oldToken != null)
            {
                oldToken.IsRevoked = true;
            }

            var newToken = new RefreshToken
            {
                UserId = userId,
                Token = newRefreshToken,
                Expiry = newExpiry,
                CreatedAt = DateTime.UtcNow,
                IsRevoked = false
            };

            _context.RefreshTokens.Add(newToken);
            await _context.SaveChangesAsync();
        }

        public async Task RevokeRefreshTokenAsync(string userId, string refreshToken)
        {
            var token = await _context.RefreshTokens
                .Where(rt => rt.UserId == userId && rt.Token == refreshToken)
                .FirstOrDefaultAsync();

            if (token != null)
            {
                token.IsRevoked = true;
                await _context.SaveChangesAsync();
            }
        }

        public async Task RevokeAllRefreshTokensAsync(string userId)
        {
            var tokens = await _context.RefreshTokens
                .Where(rt => rt.UserId == userId && !rt.IsRevoked)
                .ToListAsync();

            foreach (var token in tokens)
            {
                token.IsRevoked = true;
            }

            await _context.SaveChangesAsync();
        }
    }
}
