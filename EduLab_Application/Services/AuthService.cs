using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Auth;
using Microsoft.AspNetCore.Http;
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
        private readonly IUserRepository _userRepository;
        private readonly ITokenService _tokenService;
        private readonly IEmailSender _emailSender;
        private readonly IMapper _mapper;
        private readonly IIpService _ipService;
        private readonly ILinkBuilderService _linkGenerator;
        private readonly IEmailTemplateService _emailTemplateService;

        public AuthService(IUserRepository userRepository, ITokenService tokenService , IMapper mapper, IEmailSender emailSender, IIpService ipService, ILinkBuilderService linkGenerator, IEmailTemplateService emailTemplateService)
        {
            _userRepository = userRepository;
            _tokenService = tokenService;
            _mapper = mapper;
            _emailSender = emailSender;
            _ipService = ipService;
            _linkGenerator = linkGenerator;
            _emailTemplateService = emailTemplateService;
        }
        public async Task<LoginResponseDTO> Login(LoginRequestDTO request)
        {
            var user = await _userRepository.GetUserByUserName(request.Email);

            bool isValid = await _userRepository.CheckPassword(user, request.Password);

            if (user == null || isValid == false)
            {
                return new LoginResponseDTO()
                {
                    Token = "",
                    User = null
                };
            }

            var roles = await _userRepository.GetUserRoles(user);
            user.Role = roles.FirstOrDefault();

            var token = await _tokenService.GenerateJwtToken(user);

            var userDTO = _mapper.Map<UserDTO>(user);

            var ipAddress = _ipService.GetClientIpAddress();
            var deviceName = System.Net.Dns.GetHostName();
            var requestTime = DateTime.Now;
            var passwordResetLink = _linkGenerator.GenerateResetPasswordLink(user.Id);
            var userrrs = await _userRepository.GetUserById(user.Id);

            var emailTemplate = _emailTemplateService.GenerateLoginEmail(user, ipAddress, deviceName, requestTime, passwordResetLink);
            await _emailSender.SendEmailAsync(user.Email, "تأكيد عمل نظام البريد الإلكتروني", emailTemplate);

            return new LoginResponseDTO()
            {
                Token = token,
                User = userDTO
            };
        }
    }
}
