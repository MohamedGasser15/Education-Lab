using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    /// <summary>
    /// Repository implementation for managing refresh tokens in the database.
    /// </summary>
    public class RefreshTokenRepository : IRefreshTokenRepository
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<RefreshTokenRepository> _logger;

        /// <summary>
        /// Initializes a new instance of the <see cref="RefreshTokenRepository"/> class.
        /// </summary>
        /// <param name="context">The application database context.</param>
        /// <param name="logger">The logger instance.</param>
        public RefreshTokenRepository(ApplicationDbContext context, ILogger<RefreshTokenRepository> logger)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region Token Management Methods

        /// <summary>
        /// Saves a new refresh token for the specified user.
        /// </summary>
        /// <param name="userId">The unique identifier of the user.</param>
        /// <param name="refreshToken">The refresh token value.</param>
        /// <param name="expiry">The expiration date and time of the token.</param>
        /// <returns>A task representing the asynchronous operation.</returns>
        /// <exception cref="ArgumentException">Thrown when input parameters are invalid.</exception>
        /// <exception cref="DbUpdateException">Thrown when database update fails.</exception>
        public async Task SaveRefreshTokenAsync(string userId, string refreshToken, DateTime expiry)
        {
            try
            {
                // Validate input parameters
                if (string.IsNullOrEmpty(userId))
                    throw new ArgumentException("User ID cannot be null or empty.", nameof(userId));

                if (string.IsNullOrEmpty(refreshToken))
                    throw new ArgumentException("Refresh token cannot be null or empty.", nameof(refreshToken));

                if (expiry <= DateTime.UtcNow)
                    throw new ArgumentException("Expiry date must be in the future.", nameof(expiry));

                _logger.LogInformation("Saving refresh token for user {UserId}", userId);

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

                _logger.LogInformation("Refresh token saved successfully for user {UserId}", userId);
            }
            catch (ArgumentException ex)
            {
                _logger.LogWarning(ex, "Invalid argument while saving refresh token for user {UserId}", userId);
                throw;
            }
            catch (DbUpdateException ex)
            {
                _logger.LogError(ex, "Database update failed while saving refresh token for user {UserId}", userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error occurred while saving refresh token for user {UserId}", userId);
                throw;
            }
        }

        /// <summary>
        /// Validates whether a refresh token is valid for the specified user.
        /// </summary>
        /// <param name="userId">The unique identifier of the user.</param>
        /// <param name="refreshToken">The refresh token to validate.</param>
        /// <returns>True if the token is valid; otherwise, false.</returns>
        /// <exception cref="ArgumentException">Thrown when input parameters are invalid.</exception>
        public async Task<bool> ValidateRefreshTokenAsync(string userId, string refreshToken)
        {
            try
            {
                // Validate input parameters
                if (string.IsNullOrEmpty(userId))
                    throw new ArgumentException("User ID cannot be null or empty.", nameof(userId));

                if (string.IsNullOrEmpty(refreshToken))
                    throw new ArgumentException("Refresh token cannot be null or empty.", nameof(refreshToken));

                _logger.LogInformation("Validating refresh token for user {UserId}", userId);

                var token = await _context.RefreshTokens
                    .Where(rt => rt.UserId == userId &&
                                rt.Token == refreshToken &&
                                rt.Expiry > DateTime.UtcNow &&
                                !rt.IsRevoked)
                    .FirstOrDefaultAsync();

                bool isValid = token != null;

                _logger.LogInformation("Refresh token validation for user {UserId}: {IsValid}", userId, isValid);

                return isValid;
            }
            catch (ArgumentException ex)
            {
                _logger.LogWarning(ex, "Invalid argument while validating refresh token for user {UserId}", userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error occurred while validating refresh token for user {UserId}", userId);
                throw;
            }
        }

        #endregion

        #region Token Update and Revocation Methods

        /// <summary>
        /// Updates an existing refresh token with a new one.
        /// </summary>
        /// <param name="userId">The unique identifier of the user.</param>
        /// <param name="oldRefreshToken">The old refresh token to be revoked.</param>
        /// <param name="newRefreshToken">The new refresh token.</param>
        /// <param name="newExpiry">The expiration date and time of the new token.</param>
        /// <returns>A task representing the asynchronous operation.</returns>
        /// <exception cref="ArgumentException">Thrown when input parameters are invalid.</exception>
        /// <exception cref="InvalidOperationException">Thrown when old token is not found.</exception>
        public async Task UpdateRefreshTokenAsync(string userId, string oldRefreshToken, string newRefreshToken, DateTime newExpiry)
        {
            try
            {
                // Validate input parameters
                if (string.IsNullOrEmpty(userId))
                    throw new ArgumentException("User ID cannot be null or empty.", nameof(userId));

                if (string.IsNullOrEmpty(oldRefreshToken))
                    throw new ArgumentException("Old refresh token cannot be null or empty.", nameof(oldRefreshToken));

                if (string.IsNullOrEmpty(newRefreshToken))
                    throw new ArgumentException("New refresh token cannot be null or empty.", nameof(newRefreshToken));

                if (newExpiry <= DateTime.UtcNow)
                    throw new ArgumentException("New expiry date must be in the future.", nameof(newExpiry));

                _logger.LogInformation("Updating refresh token for user {UserId}", userId);

                var oldToken = await _context.RefreshTokens
                    .Where(rt => rt.UserId == userId && rt.Token == oldRefreshToken)
                    .FirstOrDefaultAsync();

                if (oldToken != null)
                {
                    oldToken.IsRevoked = true;
                    _logger.LogDebug("Old refresh token revoked for user {UserId}", userId);
                }
                else
                {
                    _logger.LogWarning("Old refresh token not found for user {UserId} during update", userId);
                    throw new InvalidOperationException("Old refresh token not found.");
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

                _logger.LogInformation("Refresh token updated successfully for user {UserId}", userId);
            }
            catch (ArgumentException ex)
            {
                _logger.LogWarning(ex, "Invalid argument while updating refresh token for user {UserId}", userId);
                throw;
            }
            catch (InvalidOperationException ex)
            {
                _logger.LogWarning(ex, "Operation failed while updating refresh token for user {UserId}", userId);
                throw;
            }
            catch (DbUpdateException ex)
            {
                _logger.LogError(ex, "Database update failed while updating refresh token for user {UserId}", userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error occurred while updating refresh token for user {UserId}", userId);
                throw;
            }
        }

        /// <summary>
        /// Revokes a specific refresh token for the specified user.
        /// </summary>
        /// <param name="userId">The unique identifier of the user.</param>
        /// <param name="refreshToken">The refresh token to revoke.</param>
        /// <returns>A task representing the asynchronous operation.</returns>
        /// <exception cref="ArgumentException">Thrown when input parameters are invalid.</exception>
        public async Task RevokeRefreshTokenAsync(string userId, string refreshToken)
        {
            try
            {
                // Validate input parameters
                if (string.IsNullOrEmpty(userId))
                    throw new ArgumentException("User ID cannot be null or empty.", nameof(userId));

                if (string.IsNullOrEmpty(refreshToken))
                    throw new ArgumentException("Refresh token cannot be null or empty.", nameof(refreshToken));

                _logger.LogInformation("Revoking refresh token for user {UserId}", userId);

                var token = await _context.RefreshTokens
                    .Where(rt => rt.UserId == userId && rt.Token == refreshToken)
                    .FirstOrDefaultAsync();

                if (token != null)
                {
                    token.IsRevoked = true;
                    await _context.SaveChangesAsync();
                    _logger.LogInformation("Refresh token revoked successfully for user {UserId}", userId);
                }
                else
                {
                    _logger.LogWarning("Refresh token not found for user {UserId} during revocation", userId);
                }
            }
            catch (ArgumentException ex)
            {
                _logger.LogWarning(ex, "Invalid argument while revoking refresh token for user {UserId}", userId);
                throw;
            }
            catch (DbUpdateException ex)
            {
                _logger.LogError(ex, "Database update failed while revoking refresh token for user {UserId}", userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error occurred while revoking refresh token for user {UserId}", userId);
                throw;
            }
        }

        /// <summary>
        /// Revokes all refresh tokens for the specified user.
        /// </summary>
        /// <param name="userId">The unique identifier of the user.</param>
        /// <returns>A task representing the asynchronous operation.</returns>
        /// <exception cref="ArgumentException">Thrown when user ID is invalid.</exception>
        public async Task RevokeAllRefreshTokensAsync(string userId)
        {
            try
            {
                // Validate input parameter
                if (string.IsNullOrEmpty(userId))
                    throw new ArgumentException("User ID cannot be null or empty.", nameof(userId));

                _logger.LogInformation("Revoking all refresh tokens for user {UserId}", userId);

                var tokens = await _context.RefreshTokens
                    .Where(rt => rt.UserId == userId && !rt.IsRevoked)
                    .ToListAsync();

                if (tokens.Any())
                {
                    foreach (var token in tokens)
                    {
                        token.IsRevoked = true;
                    }

                    await _context.SaveChangesAsync();
                    _logger.LogInformation("All {TokenCount} refresh tokens revoked for user {UserId}", tokens.Count, userId);
                }
                else
                {
                    _logger.LogInformation("No active refresh tokens found for user {UserId}", userId);
                }
            }
            catch (ArgumentException ex)
            {
                _logger.LogWarning(ex, "Invalid argument while revoking all refresh tokens for user {UserId}", userId);
                throw;
            }
            catch (DbUpdateException ex)
            {
                _logger.LogError(ex, "Database update failed while revoking all refresh tokens for user {UserId}", userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error occurred while revoking all refresh tokens for user {UserId}", userId);
                throw;
            }
        }

        #endregion
    }
}