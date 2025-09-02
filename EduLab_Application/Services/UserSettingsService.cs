using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Settings;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Routing;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class UserSettingsService : IUserSettingsService
    {
        private readonly IMapper _mapper;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IEmailSender _emailSender;
        private readonly IIpService _ipService;
        private readonly IEmailTemplateService _emailTemplateService;
        private readonly ILinkBuilderService _linkGenerator;
        private readonly ISessionRepository _sessionRepository;
        private readonly ITokenService _tokenService;

        public UserSettingsService(
            IMapper mapper,
            UserManager<ApplicationUser> userManager,
            ILinkBuilderService linkGenerator,
            IEmailSender emailSender,
            IEmailTemplateService emailTemplateService,
            IIpService ipService,
            ISessionRepository sessionRepository,
            ITokenService tokenService)
        {
            _mapper = mapper;
            _userManager = userManager;
            _emailSender = emailSender;
            _ipService = ipService;
            _emailTemplateService = emailTemplateService;
            _linkGenerator = linkGenerator;
            _sessionRepository = sessionRepository;
            _tokenService = tokenService;
        }

        public async Task<GeneralSettingsDTO> GetGeneralSettingsAsync(string userId)
        {
            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
                return null;

            return new GeneralSettingsDTO
            {
                Email = user.Email,
                FullName = user.FullName,
                PhoneNumber = user.PhoneNumber
            };
        }

        public async Task<bool> UpdateGeneralSettingsAsync(string userId, GeneralSettingsDTO generalSettings)
        {
            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
                return false;

            if (!string.Equals(user.Email, generalSettings.Email, StringComparison.OrdinalIgnoreCase))
            {
                user.Email = generalSettings.Email;
                user.EmailConfirmed = false;
            }

            user.FullName = generalSettings.FullName;
            user.PhoneNumber = generalSettings.PhoneNumber;

            var result = await _userManager.UpdateAsync(user);
            return result.Succeeded;
        }

        public async Task<bool> ChangePasswordAsync(string userId, ChangePasswordDTO changePassword)
        {
            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
                return false;

            var ipAddress = _ipService.GetClientIpAddress();
            var deviceInfo = _ipService.GetDeviceInfo(); // استخدام GetDeviceInfo بدل GetHostName
            var changeTime = DateTime.Now;
            var passwordResetLink = _linkGenerator.GenerateResetPasswordLink(user.Id);

            var result = await _userManager.ChangePasswordAsync(
                user,
                changePassword.CurrentPassword,
                changePassword.NewPassword
            );

            if (!result.Succeeded)
                return false;

            // إنشاء JWT token جديد بعد تغيير كلمة المرور
            var newToken = await _tokenService.GenerateJwtToken(user);

            // تسجيل جلسة جديدة
            await _ipService.CreateUserSessionAsync(user.Id, newToken);

            // إرسال إيميل التأكيد
            var emailTemplate = _emailTemplateService.GeneratePasswordChangeEmail(user, ipAddress, deviceInfo, changeTime, passwordResetLink);
            await _emailSender.SendEmailAsync(user.Email, "تأكيد تغيير كلمة المرور", emailTemplate);

            return true;
        }

        public async Task<bool> EnableTwoFactorAsync(string userId, TwoFactorDTO twoFactor)
        {
            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
                return false;

            var isValid = await _userManager.VerifyTwoFactorTokenAsync(
                user,
                _userManager.Options.Tokens.AuthenticatorTokenProvider,
                twoFactor.Code
            );

            if (!isValid)
                return false;

            var result = await _userManager.SetTwoFactorEnabledAsync(user, true);
            return result.Succeeded;
        }

        public async Task<bool> DisableTwoFactorAsync(string userId)
        {
            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
                return false;

            var result = await _userManager.SetTwoFactorEnabledAsync(user, false);
            return result.Succeeded;
        }

        public async Task<bool> VerifyTwoFactorCodeAsync(string userId, string code)
        {
            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
                return false;

            return await _userManager.VerifyTwoFactorTokenAsync(
                user,
                _userManager.Options.Tokens.AuthenticatorTokenProvider,
                code
            );
        }

        public async Task<List<ActiveSessionDTO>> GetActiveSessionsAsync(string userId)
        {
            var sessions = await _sessionRepository.GetActiveSessionsForUser(userId);
            var currentIp = _ipService.GetClientIpAddress();

            var dtoList = _mapper.Map<List<ActiveSessionDTO>>(sessions);

            foreach (var dto in dtoList)
            {
                dto.IsCurrent = sessions.First(s => s.Id == dto.Id).IPAddress == currentIp;
            }

            return dtoList;
        }

        public async Task<bool> RevokeSessionAsync(string userId, Guid sessionId)
        {
            var session = await _sessionRepository.GetSessionById(sessionId);
            if (session == null || session.UserId != userId)
                return false;

            await _sessionRepository.RevokeSession(sessionId);
            return true;
        }

        public async Task<bool> RevokeAllSessionsAsync(string userId)
        {
            var currentSessionId = Guid.Empty; // يمكن تحسينه لتحديد الجلسة الحالية إذا لزم
            await _sessionRepository.RevokeAllSessionsForUser(userId, currentSessionId);
            return true;
        }
        public async Task<TwoFactorSetupDTO?> GetTwoFactorSetupAsync(string userId)
        {
            var user = await _userManager.FindByIdAsync(userId);

            if (user == null)
                return null;

            // Secret Key (Authenticator Key)
            var unformattedKey = await _userManager.GetAuthenticatorKeyAsync(user);
            if (string.IsNullOrEmpty(unformattedKey))
            {
                await _userManager.ResetAuthenticatorKeyAsync(user);
                unformattedKey = await _userManager.GetAuthenticatorKeyAsync(user);
            }

            // URL لتوليد QR Code (Google Authenticator, Microsoft Authenticator...)
            var email = user.Email;
            var issuer = "EduLab";
            var qrCodeUrl = $"otpauth://totp/{issuer}:{email}?secret={unformattedKey}&issuer={issuer}&digits=6";

            // Generate Recovery Codes (مرة واحدة فقط عند التفعيل الأول)
            var recoveryCodes = await _userManager.GenerateNewTwoFactorRecoveryCodesAsync(user, 5);

            return new TwoFactorSetupDTO
            {
                QrCodeUrl = qrCodeUrl,
                Secret = unformattedKey,
                RecoveryCodes = recoveryCodes.ToList()
            };
        }
        public async Task<bool> IsTwoFactorEnabledAsync(string userId)
        {
            var user = await _userManager.FindByIdAsync(userId);
            if (user == null)
                return false;

            return await _userManager.GetTwoFactorEnabledAsync(user);
        }
    }
}