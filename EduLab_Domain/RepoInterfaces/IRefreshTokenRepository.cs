using System;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    /// <summary>
    /// Repository interface for managing refresh tokens operations.
    /// </summary>
    public interface IRefreshTokenRepository
    {
        /// <summary>
        /// Saves a new refresh token for the specified user.
        /// </summary>
        /// <param name="userId">The unique identifier of the user.</param>
        /// <param name="refreshToken">The refresh token value.</param>
        /// <param name="expiry">The expiration date and time of the token.</param>
        /// <returns>A task representing the asynchronous operation.</returns>
        Task SaveRefreshTokenAsync(string userId, string refreshToken, DateTime expiry);

        /// <summary>
        /// Validates whether a refresh token is valid for the specified user.
        /// </summary>
        /// <param name="userId">The unique identifier of the user.</param>
        /// <param name="refreshToken">The refresh token to validate.</param>
        /// <returns>True if the token is valid; otherwise, false.</returns>
        Task<bool> ValidateRefreshTokenAsync(string userId, string refreshToken);

        /// <summary>
        /// Updates an existing refresh token with a new one.
        /// </summary>
        /// <param name="userId">The unique identifier of the user.</param>
        /// <param name="oldRefreshToken">The old refresh token to be revoked.</param>
        /// <param name="newRefreshToken">The new refresh token.</param>
        /// <param name="newExpiry">The expiration date and time of the new token.</param>
        /// <returns>A task representing the asynchronous operation.</returns>
        Task UpdateRefreshTokenAsync(string userId, string oldRefreshToken, string newRefreshToken, DateTime newExpiry);

        /// <summary>
        /// Revokes a specific refresh token for the specified user.
        /// </summary>
        /// <param name="userId">The unique identifier of the user.</param>
        /// <param name="refreshToken">The refresh token to revoke.</param>
        /// <returns>A task representing the asynchronous operation.</returns>
        Task RevokeRefreshTokenAsync(string userId, string refreshToken);

        /// <summary>
        /// Revokes all refresh tokens for the specified user.
        /// </summary>
        /// <param name="userId">The unique identifier of the user.</param>
        /// <returns>A task representing the asynchronous operation.</returns>
        Task RevokeAllRefreshTokensAsync(string userId);
    }
}