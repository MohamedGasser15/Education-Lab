using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Auth;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class ExternalLoginService : IExternalLoginService
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly SignInManager<ApplicationUser> _signInManager;

        public ExternalLoginService(UserManager<ApplicationUser> userManager, SignInManager<ApplicationUser> signInManager)
        {
            _userManager = userManager;
            _signInManager = signInManager;
        }

        public async Task<ExternalLoginCallbackResultDTO> HandleExternalLoginCallbackAsync(string remoteError, string returnUrl)
        {
            if (remoteError != null)
                return new ExternalLoginCallbackResultDTO { Message = $"Error from provider: {remoteError}" };

            var info = await _signInManager.GetExternalLoginInfoAsync();
            if (info == null)
                return new ExternalLoginCallbackResultDTO { Message = "Unable to retrieve external login info." };

            var user = await _userManager.FindByLoginAsync(info.LoginProvider, info.ProviderKey);
            if (user != null)
            {
                var result = await _signInManager.ExternalLoginSignInAsync(info.LoginProvider, info.ProviderKey, false);
                if (result.Succeeded)
                {
                    await _signInManager.UpdateExternalAuthenticationTokensAsync(info);
                    return new ExternalLoginCallbackResultDTO
                    {
                        IsNewUser = false,
                        Message = "Logged in successfully via external provider",
                        ReturnUrl = returnUrl
                    };
                }
            }

            var email = info.Principal.FindFirstValue(ClaimTypes.Email);
            return new ExternalLoginCallbackResultDTO
            {
                IsNewUser = true,
                Email = email,
                Message = "New user, please confirm registration",
                ReturnUrl = returnUrl
            };
        }

        public async Task<IdentityResult> ConfirmExternalUserAsync(ExternalLoginConfirmationDto model)
        {
            var info = await _signInManager.GetExternalLoginInfoAsync();
            if (info == null)
                throw new Exception("Invalid external login info.");

            var existingUser = await _userManager.FindByEmailAsync(model.Email);
            if (existingUser != null)
                throw new Exception("Email is already registered.");

            var user = new ApplicationUser
            {
                FullName = model.Name,
                Email = model.Email,
                UserName = model.Email,
                CreatedAt = DateTime.UtcNow,
                EmailConfirmed = true
            };

            var result = await _userManager.CreateAsync(user);
            if (!result.Succeeded)
                return result;

            await _userManager.AddToRoleAsync(user, SD.Student);

            var loginResult = await _userManager.AddLoginAsync(user, info);
            if (!loginResult.Succeeded)
                return loginResult;

            await _userManager.UpdateAsync(user);

            return IdentityResult.Success;
        }

        public AuthenticationProperties ConfigureExternalAuthProperties(string provider, string redirectUrl)
        {
            return _signInManager.ConfigureExternalAuthenticationProperties(provider, redirectUrl);
        }

        public async Task<ExternalLoginInfo> GetExternalLoginInfoAsync()
        {
            return await _signInManager.GetExternalLoginInfoAsync();
        }

        public async Task<ApplicationUser> FindByExternalLoginAsync(string provider, string key)
        {
            return await _userManager.FindByLoginAsync(provider, key);
        }

        public async Task<SignInResult> ExternalLoginSignInAsync(string provider, string key, bool isPersistent)
        {
            return await _signInManager.ExternalLoginSignInAsync(provider, key, isPersistent);
        }

        public async Task<IdentityResult> AddExternalLoginAsync(ApplicationUser user, ExternalLoginInfo info)
        {
            return await _userManager.AddLoginAsync(user, info);
        }

        public async Task UpdateExternalAuthTokensAsync(ExternalLoginInfo info)
        {
            await _signInManager.UpdateExternalAuthenticationTokensAsync(info);
        }

    }
}
