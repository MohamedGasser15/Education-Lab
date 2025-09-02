using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Auth;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Routing;
using System;
using System.Collections.Generic;
using System.Linq;
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

        public AuthService(ITokenService tokenService , IMapper mapper, IEmailSender emailSender, IIpService ipService, ILinkBuilderService linkGenerator, IEmailTemplateService emailTemplateService, ISessionRepository sessionRepository, UserManager<ApplicationUser> userManager)
        {
            _tokenService = tokenService;
            _mapper = mapper;
            _emailSender = emailSender;
            _ipService = ipService;
            _linkGenerator = linkGenerator;
            _emailTemplateService = emailTemplateService;
            _userManager = userManager;
        }
        public async Task<LoginResponseDTO> Login(LoginRequestDTO request)
        {
            var user = await _userManager.FindByNameAsync(request.Email);
            if (user == null)
            {
                return new LoginResponseDTO()
                {
                    Token = "",
                    User = null
                };
            }

            bool isValid = await _userManager.CheckPasswordAsync(user, request.Password);
            if (!isValid)
            {
                return new LoginResponseDTO()
                {
                    Token = "",
                    User = null
                };
            }

            var roles = await _userManager.GetRolesAsync(user);
            user.Role = roles.FirstOrDefault();

            var token = await _tokenService.GenerateJwtToken(user);

            var userDTO = _mapper.Map<UserDTO>(user);

            var ipAddress = _ipService.GetClientIpAddress();
            var deviceName = System.Net.Dns.GetHostName();
            var requestTime = DateTime.Now;
            var passwordResetLink = _linkGenerator.GenerateResetPasswordLink(user.Id);

            var emailTemplate = _emailTemplateService.GenerateLoginEmail(
                user, ipAddress, deviceName, requestTime, passwordResetLink
            );
            await _emailSender.SendEmailAsync(user.Email, "تأكيد عمل نظام البريد الإلكتروني", emailTemplate);

            await _ipService.CreateUserSessionAsync(user.Id, token);

            return new LoginResponseDTO()
            {
                Token = token,
                User = userDTO
            };
        }

    }
}
