using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Auth;
using EduLab_Shared.DTOs.Token;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service for handling authentication operations including login, token refresh, and token revocation.
    /// </summary>
    public class AuthService : IAuthService
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly ITokenService _tokenService;
        private readonly IEmailSender _emailSender;
        private readonly IMapper _mapper;
        private readonly IIpService _ipService;
        private readonly ILinkBuilderService _linkGenerator;
        private readonly IEmailTemplateService _emailTemplateService;
        private readonly IRefreshTokenRepository _refreshTokenRepository;
        private readonly ILogger<AuthService> _logger;

        /// <summary>
        /// Initializes a new instance of the <see cref="AuthService"/> class.
        /// </summary>
        /// <param name="tokenService">The token service instance.</param>
        /// <param name="mapper">The AutoMapper instance.</param>
        /// <param name="emailSender">The email sender service.</param>
        /// <param name="ipService">The IP service instance.</param>
        /// <param name="linkGenerator">The link generator service.</param>
        /// <param name="emailTemplateService">The email template service.</param>
        /// <param name="userManager">The user manager instance.</param>
        /// <param name="refreshTokenRepository">The refresh token repository.</param>
        /// <param name="logger">The logger instance.</param>
        public AuthService(
            ITokenService tokenService,
            IMapper mapper,
            IEmailSender emailSender,
            IIpService ipService,
            ILinkBuilderService linkGenerator,
            IEmailTemplateService emailTemplateService,
            UserManager<ApplicationUser> userManager,
            IRefreshTokenRepository refreshTokenRepository,
            ILogger<AuthService> logger)
        {
            _tokenService = tokenService ?? throw new ArgumentNullException(nameof(tokenService));
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
            _emailSender = emailSender ?? throw new ArgumentNullException(nameof(emailSender));
            _ipService = ipService ?? throw new ArgumentNullException(nameof(ipService));
            _linkGenerator = linkGenerator ?? throw new ArgumentNullException(nameof(linkGenerator));
            _emailTemplateService = emailTemplateService ?? throw new ArgumentNullException(nameof(emailTemplateService));
            _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
            _refreshTokenRepository = refreshTokenRepository ?? throw new ArgumentNullException(nameof(refreshTokenRepository));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region Authentication Methods

        /// <summary>
        /// Authenticates a user and generates access and refresh tokens.
        /// </summary>
        /// <param name="request">The login request containing user credentials.</param>
        /// <returns>A login response containing tokens and user information.</returns>
        /// <exception cref="ArgumentNullException">Thrown when request is null.</exception>
        public async Task<LoginResponseDTO> Login(LoginRequestDTO request)
        {
            try
            {
                if (request == null)
                    throw new ArgumentNullException(nameof(request));

                _logger.LogInformation("Login attempt for email: {Email}", request.Email);

                var user = await _userManager.FindByNameAsync(request.Email);
                if (user == null || !await _userManager.CheckPasswordAsync(user, request.Password))
                {
                    _logger.LogWarning("Invalid login attempt for email: {Email}", request.Email);
                    return new LoginResponseDTO()
                    {
                        Token = "",
                        User = null,

                    };
                }

                var roles = await _userManager.GetRolesAsync(user);
                user.Role = roles.FirstOrDefault();

                // Generate tokens
                var accessToken = await _tokenService.GenerateAccessToken(user);
                var refreshToken = _tokenService.GenerateRefreshToken();
                var refreshTokenExpiry = DateTime.UtcNow.AddDays(7);

                // Save refresh token to database
                await _refreshTokenRepository.SaveRefreshTokenAsync(user.Id, refreshToken, refreshTokenExpiry);

                var userDTO = _mapper.Map<UserDTO>(user);

                // Send login notification email
                await SendLoginNotificationEmail(user);

                await _ipService.CreateUserSessionAsync(user.Id, accessToken);

                _logger.LogInformation("User {UserId} logged in successfully", user.Id);

                return new LoginResponseDTO()
                {
                    Token = accessToken,
                    RefreshToken = refreshToken,
                    RefreshTokenExpiry = refreshTokenExpiry,
                    User = userDTO
                };
            }
            catch (ArgumentNullException ex)
            {
                _logger.LogError(ex, "Null argument in Login method");
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during login for email: {Email}", request?.Email);
                throw;
            }
        }

        /// <summary>
        /// Refreshes an access token using a valid refresh token.
        /// </summary>
        /// <param name="request">The refresh token request containing the expired access token and refresh token.</param>
        /// <returns>A token response containing new access and refresh tokens.</returns>
        /// <exception cref="ArgumentNullException">Thrown when request is null.</exception>
        /// <exception cref="SecurityTokenException">Thrown when token validation fails.</exception>
        public async Task<TokenResponseDTO> RefreshToken(RefreshTokenRequestDTO request)
        {
            try
            {
                if (request == null)
                    throw new ArgumentNullException(nameof(request));

                _logger.LogInformation("Refresh token request received");

                var principal = _tokenService.GetPrincipalFromExpiredToken(request.AccessToken);
                var userId = principal.FindFirstValue(ClaimTypes.NameIdentifier);

                if (string.IsNullOrEmpty(userId))
                    throw new SecurityTokenException("Invalid token: User identifier not found");

                var isValidRefreshToken = await _refreshTokenRepository.ValidateRefreshTokenAsync(userId, request.RefreshToken);
                if (!isValidRefreshToken)
                {
                    _logger.LogWarning("Invalid refresh token for user {UserId}", userId);
                    throw new SecurityTokenException("Invalid refresh token");
                }

                var user = await _userManager.FindByIdAsync(userId);
                if (user == null)
                {
                    _logger.LogWarning("User not found during token refresh: {UserId}", userId);
                    throw new SecurityTokenException("User not found");
                }

                // Generate new tokens
                var newAccessToken = await _tokenService.GenerateAccessToken(user);
                var newRefreshToken = _tokenService.GenerateRefreshToken();
                var newRefreshTokenExpiry = DateTime.UtcNow.AddDays(7);

                // Update refresh token in database
                await _refreshTokenRepository.UpdateRefreshTokenAsync(
                    userId, request.RefreshToken, newRefreshToken, newRefreshTokenExpiry);

                _logger.LogInformation("Tokens refreshed successfully for user {UserId}", userId);

                return new TokenResponseDTO
                {
                    AccessToken = newAccessToken,
                    RefreshToken = newRefreshToken,
                    RefreshTokenExpiry = newRefreshTokenExpiry
                };
            }
            catch (ArgumentNullException ex)
            {
                _logger.LogError(ex, "Null argument in RefreshToken method");
                throw;
            }
            catch (SecurityTokenException ex)
            {
                _logger.LogWarning(ex, "Security token validation failed during token refresh");
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during token refresh");
                throw;
            }
        }

        /// <summary>
        /// Revokes a specific refresh token for a user.
        /// </summary>
        /// <param name="userId">The unique identifier of the user.</param>
        /// <param name="refreshToken">The refresh token to revoke.</param>
        /// <returns>A task representing the asynchronous operation.</returns>
        /// <exception cref="ArgumentException">Thrown when input parameters are invalid.</exception>
        public async Task RevokeRefreshToken(string userId, string refreshToken)
        {
            try
            {
                if (string.IsNullOrEmpty(userId))
                    throw new ArgumentException("User ID cannot be null or empty.", nameof(userId));

                if (string.IsNullOrEmpty(refreshToken))
                    throw new ArgumentException("Refresh token cannot be null or empty.", nameof(refreshToken));

                _logger.LogInformation("Revoking refresh token for user {UserId}", userId);

                await _refreshTokenRepository.RevokeRefreshTokenAsync(userId, refreshToken);

                _logger.LogInformation("Refresh token revoked successfully for user {UserId}", userId);
            }
            catch (ArgumentException ex)
            {
                _logger.LogWarning(ex, "Invalid argument while revoking refresh token");
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error while revoking refresh token for user {UserId}", userId);
                throw;
            }
        }

        #endregion

        #region Private Helper Methods

        /// <summary>
        /// Sends a login notification email to the user.
        /// </summary>
        /// <param name="user">The user who logged in.</param>
        /// <returns>A task representing the asynchronous operation.</returns>
        private async Task SendLoginNotificationEmail(ApplicationUser user)
        {
            try
            {
                var ipAddress = _ipService.GetClientIpAddress();
                var deviceName = System.Net.Dns.GetHostName();
                var requestTime = DateTime.Now;
                var passwordResetLink = _linkGenerator.GenerateResetPasswordLink(user.Id);

                var emailTemplate = _emailTemplateService.GenerateLoginEmail(
                    user, ipAddress, deviceName, requestTime, passwordResetLink
                );

                await _emailSender.SendEmailAsync(user.Email, "تأكيد تسجيل الدخول", emailTemplate);

                _logger.LogInformation("Login notification email sent to user {UserId}", user.Id);
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "Failed to send login notification email to user {UserId}", user.Id);
                // Continue without throwing to not break the login flow
            }
        }

        #endregion
    }
}