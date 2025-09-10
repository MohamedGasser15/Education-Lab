using EduLab_Shared.DTOs.Auth;
using EduLab_Shared.DTOs.Token;
using System;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for authentication operations.
    /// </summary>
    public interface IAuthService
    {
        /// <summary>
        /// Authenticates a user and generates access and refresh tokens.
        /// </summary>
        /// <param name="request">The login request containing user credentials.</param>
        /// <returns>A login response containing tokens and user information.</returns>
        Task<LoginResponseDTO> Login(LoginRequestDTO request);

        /// <summary>
        /// Refreshes an access token using a valid refresh token.
        /// </summary>
        /// <param name="request">The refresh token request containing the expired access token and refresh token.</param>
        /// <returns>A token response containing new access and refresh tokens.</returns>
        Task<TokenResponseDTO> RefreshToken(RefreshTokenRequestDTO request);

        /// <summary>
        /// Revokes a specific refresh token for a user.
        /// </summary>
        /// <param name="userId">The unique identifier of the user.</param>
        /// <param name="refreshToken">The refresh token to revoke.</param>
        /// <returns>A task representing the asynchronous operation.</returns>
        Task RevokeRefreshToken(string userId, string refreshToken);
    }
}