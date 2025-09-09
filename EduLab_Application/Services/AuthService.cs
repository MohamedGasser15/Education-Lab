using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Auth;
using EduLab_Shared.DTOs.Token;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Routing;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
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

        public AuthService(ITokenService tokenService, IMapper mapper, IEmailSender emailSender,
                          IIpService ipService, ILinkBuilderService linkGenerator,
                          IEmailTemplateService emailTemplateService,
                          UserManager<ApplicationUser> userManager,
                          IRefreshTokenRepository refreshTokenRepository)
        {
            _tokenService = tokenService;
            _mapper = mapper;
            _emailSender = emailSender;
            _ipService = ipService;
            _linkGenerator = linkGenerator;
            _emailTemplateService = emailTemplateService;
            _userManager = userManager;
            _refreshTokenRepository = refreshTokenRepository;
        }

        public async Task<LoginResponseDTO> Login(LoginRequestDTO request)
        {
            var user = await _userManager.FindByNameAsync(request.Email);
            if (user == null || !await _userManager.CheckPasswordAsync(user, request.Password))
            {
                return new LoginResponseDTO()
                {
                    Token = "",
                    User = null
                };
            }

            var roles = await _userManager.GetRolesAsync(user);
            user.Role = roles.FirstOrDefault();

            // Generate tokens
            var accessToken = await _tokenService.GenerateAccessToken(user);
            var refreshToken = _tokenService.GenerateRefreshToken();
            var refreshTokenExpiry = DateTime.UtcNow.AddDays(7); // Refresh token صالح لمدة 7 أيام

            // Save refresh token to database
            await _refreshTokenRepository.SaveRefreshTokenAsync(user.Id, refreshToken, refreshTokenExpiry);

            var userDTO = _mapper.Map<UserDTO>(user);

            var ipAddress = _ipService.GetClientIpAddress();
            var deviceName = System.Net.Dns.GetHostName();
            var requestTime = DateTime.Now;
            var passwordResetLink = _linkGenerator.GenerateResetPasswordLink(user.Id);

            var emailTemplate = _emailTemplateService.GenerateLoginEmail(
                user, ipAddress, deviceName, requestTime, passwordResetLink
            );
            await _emailSender.SendEmailAsync(user.Email, "تأكيد تسجيل الدخول", emailTemplate);

            await _ipService.CreateUserSessionAsync(user.Id, accessToken);

            return new LoginResponseDTO()
            {
                Token = accessToken,
                RefreshToken = refreshToken,
                RefreshTokenExpiry = refreshTokenExpiry,
                User = userDTO
            };
        }

        public async Task<TokenResponseDTO> RefreshToken(RefreshTokenRequestDTO request)
        {
            var principal = _tokenService.GetPrincipalFromExpiredToken(request.AccessToken);
            var userId = principal.FindFirstValue(ClaimTypes.NameIdentifier);

            var isValidRefreshToken = await _refreshTokenRepository.ValidateRefreshTokenAsync(userId, request.RefreshToken);
            if (!isValidRefreshToken)
            {
                throw new SecurityTokenException("Invalid refresh token");
            }

            var user = await _userManager.FindByIdAsync(userId);
            if (user == null)
            {
                throw new SecurityTokenException("User not found");
            }

            // Generate new tokens
            var newAccessToken = await _tokenService.GenerateAccessToken(user);
            var newRefreshToken = _tokenService.GenerateRefreshToken();
            var newRefreshTokenExpiry = DateTime.UtcNow.AddDays(7);

            // Update refresh token in database
            await _refreshTokenRepository.UpdateRefreshTokenAsync(userId, request.RefreshToken, newRefreshToken, newRefreshTokenExpiry);

            return new TokenResponseDTO
            {
                AccessToken = newAccessToken,
                RefreshToken = newRefreshToken,
                RefreshTokenExpiry = newRefreshTokenExpiry
            };
        }

        public async Task RevokeRefreshToken(string userId, string refreshToken)
        {
            await _refreshTokenRepository.RevokeRefreshTokenAsync(userId, refreshToken);
        }
    }
}
 