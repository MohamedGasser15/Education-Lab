using EduLab_Domain.Entities;
using System;
using System.Security.Claims;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for token generation and validation operations.
    /// </summary>
    public interface ITokenService
    {
        /// <summary>
        /// Generates a JWT access token for the specified user.
        /// </summary>
        /// <param name="user">The application user.</param>
        /// <returns>A JWT access token string.</returns>
        Task<string> GenerateAccessToken(ApplicationUser user);

        /// <summary>
        /// Generates a cryptographically secure refresh token.
        /// </summary>
        /// <returns>A base64 encoded refresh token string.</returns>
        string GenerateRefreshToken();

        /// <summary>
        /// Extracts the principal from an expired access token.
        /// </summary>
        /// <param name="token">The expired JWT token.</param>
        /// <returns>The claims principal extracted from the token.</returns>
        ClaimsPrincipal GetPrincipalFromExpiredToken(string token);
    }
}