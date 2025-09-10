using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service for handling JWT token generation and validation operations.
    /// </summary>
    public class TokenService : ITokenService
    {
        private readonly IConfiguration _config;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly ILogger<TokenService> _logger;

        /// <summary>
        /// Initializes a new instance of the <see cref="TokenService"/> class.
        /// </summary>
        /// <param name="config">The configuration instance.</param>
        /// <param name="userManager">The user manager instance.</param>
        /// <param name="logger">The logger instance.</param>
        public TokenService(IConfiguration config, UserManager<ApplicationUser> userManager, ILogger<TokenService> logger)
        {
            _config = config ?? throw new ArgumentNullException(nameof(config));
            _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region Token Generation Methods

        /// <summary>
        /// Generates an access token for the specified user.
        /// </summary>
        /// <param name="user">The application user for whom to generate the token.</param>
        /// <returns>A JWT access token string.</returns>
        /// <exception cref="ArgumentNullException">Thrown when user is null.</exception>
        /// <exception cref="ArgumentException">Thrown when required configuration values are missing.</exception>
        public async Task<string> GenerateAccessToken(ApplicationUser user)
        {
            try
            {
                if (user == null)
                    throw new ArgumentNullException(nameof(user));

                _logger.LogInformation("Generating access token for user {UserId}", user.Id);

                // Validate configuration values
                var jwtKey = _config["JWT:Key"];
                var jwtAudience = _config["JWT:Audience"];
                var jwtIssuer = _config["JWT:Issuer"];

                if (string.IsNullOrEmpty(jwtKey))
                    throw new ArgumentException("JWT Key is not configured properly.");
                if (string.IsNullOrEmpty(jwtAudience))
                    throw new ArgumentException("JWT Audience is not configured properly.");
                if (string.IsNullOrEmpty(jwtIssuer))
                    throw new ArgumentException("JWT Issuer is not configured properly.");

                var tokenHandler = new JwtSecurityTokenHandler();
                var key = Encoding.ASCII.GetBytes(jwtKey);

                var claims = new List<Claim>
                {
                    new Claim(JwtRegisteredClaimNames.Sub, user.Id.ToString()),
                    new Claim(JwtRegisteredClaimNames.Email, user.Email),
                    new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                    new Claim(JwtRegisteredClaimNames.Aud, jwtAudience),
                    new Claim(JwtRegisteredClaimNames.Iss, jwtIssuer),
                };

                // Add user roles to claims
                var roles = await _userManager.GetRolesAsync(user);
                claims.AddRange(roles.Select(role => new Claim(ClaimTypes.Role, role)));

                var tokenDescriptor = new SecurityTokenDescriptor
                {
                    Subject = new ClaimsIdentity(claims),
                    Expires = DateTime.UtcNow.AddMinutes(15),
                    NotBefore = DateTime.UtcNow,
                    IssuedAt = DateTime.UtcNow,
                    SigningCredentials = new SigningCredentials(
                        new SymmetricSecurityKey(key),
                        SecurityAlgorithms.HmacSha256Signature)
                };

                var token = tokenHandler.CreateToken(tokenDescriptor);
                var tokenString = tokenHandler.WriteToken(token);

                _logger.LogInformation("Access token generated successfully for user {UserId}", user.Id);

                return tokenString;
            }
            catch (ArgumentNullException ex)
            {
                _logger.LogError(ex, "User parameter is null while generating access token");
                throw;
            }
            catch (ArgumentException ex)
            {
                _logger.LogError(ex, "Configuration error while generating access token for user {UserId}", user?.Id);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error occurred while generating access token for user {UserId}", user?.Id);
                throw;
            }
        }

        /// <summary>
        /// Generates a cryptographically secure refresh token.
        /// </summary>
        /// <returns>A base64 encoded refresh token string.</returns>
        public string GenerateRefreshToken()
        {
            try
            {
                _logger.LogInformation("Generating refresh token");

                var randomNumber = new byte[32];
                using var rng = RandomNumberGenerator.Create();
                rng.GetBytes(randomNumber);
                var refreshToken = Convert.ToBase64String(randomNumber);

                _logger.LogInformation("Refresh token generated successfully");

                return refreshToken;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error generating refresh token");
                throw;
            }
        }

        #endregion

        #region Token Validation Methods

        /// <summary>
        /// Extracts the principal from an expired access token for refresh token validation.
        /// </summary>
        /// <param name="token">The expired JWT token.</param>
        /// <returns>The claims principal extracted from the token.</returns>
        /// <exception cref="ArgumentException">Thrown when token is null or empty.</exception>
        /// <exception cref="SecurityTokenException">Thrown when token validation fails.</exception>
        public ClaimsPrincipal GetPrincipalFromExpiredToken(string token)
        {
            try
            {
                if (string.IsNullOrEmpty(token))
                    throw new ArgumentException("Token cannot be null or empty.", nameof(token));

                _logger.LogInformation("Extracting principal from expired token");

                var jwtKey = _config["JWT:Key"];
                if (string.IsNullOrEmpty(jwtKey))
                    throw new ArgumentException("JWT Key is not configured properly.");

                var tokenValidationParameters = new TokenValidationParameters
                {
                    ValidateAudience = false,
                    ValidateIssuer = false,
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.ASCII.GetBytes(jwtKey)),
                    ValidateLifetime = false
                };

                var tokenHandler = new JwtSecurityTokenHandler();
                var principal = tokenHandler.ValidateToken(token, tokenValidationParameters, out var securityToken);

                if (securityToken is not JwtSecurityToken jwtSecurityToken ||
                    !jwtSecurityToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256, StringComparison.InvariantCultureIgnoreCase))
                {
                    _logger.LogWarning("Invalid token security algorithm");
                    throw new SecurityTokenException("Invalid token");
                }

                _logger.LogInformation("Principal extracted successfully from expired token");

                return principal;
            }
            catch (ArgumentException ex)
            {
                _logger.LogError(ex, "Invalid argument while extracting principal from token");
                throw;
            }
            catch (SecurityTokenException ex)
            {
                _logger.LogWarning(ex, "Security token validation failed");
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error occurred while extracting principal from token");
                throw;
            }
        }

        #endregion
    }
}