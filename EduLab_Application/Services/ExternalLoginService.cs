using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Auth;
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
        private readonly IUserRepository _userRepository;
        public ExternalLoginService(IUserRepository userRepository)
        {
            _userRepository = userRepository;
        }
        public async Task<ExternalLoginCallbackResultDTO> HandleExternalLoginCallbackAsync(string remoteError, string returnUrl)
        {
            if (remoteError != null)
                return new ExternalLoginCallbackResultDTO { Message = $"Error from provider: {remoteError}" };

            var info = await GetExternalLoginInfoAsync();
            if (info == null)
                return new ExternalLoginCallbackResultDTO { Message = "Unable to retrieve external login info." };

            var user = await FindByExternalLoginAsync(info.LoginProvider, info.ProviderKey);
            if (user != null)
            {
                var result = await ExternalLoginSignInAsync(info.LoginProvider, info.ProviderKey, false);
                if (result.Succeeded)
                {
                    await UpdateExternalAuthTokensAsync(info);
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
            var info = await GetExternalLoginInfoAsync();
            if (info == null)
                throw new Exception("Invalid external login info.");

            var existingUser = await _userRepository.GetUserByEmail(model.Email);
            if (existingUser != null)
                throw new Exception("Email is already registered.");

            var user = new ApplicationUser
            {
                FullName = model.Name,
                Email = model.Email,
                UserName = model.Email
            };

            return await _userRepository.CreateUserWithExternalLoginAsync(user, info);
        }

        public AuthenticationProperties ConfigureExternalAuthProperties(string provider, string redirectUrl)
        {
            return _userRepository.GetExternalAuthProperties(provider, redirectUrl);
        }

        public async Task<ExternalLoginInfo> GetExternalLoginInfoAsync()
        {
            return await _userRepository.GetExternalLoginInfoAsync();
        }

        public async Task<ApplicationUser> FindByExternalLoginAsync(string provider, string key)
        {
            return await _userRepository.FindByExternalLoginAsync(provider, key);
        }

        public async Task<SignInResult> ExternalLoginSignInAsync(string provider, string key, bool isPersistent)
        {
            return await _userRepository.ExternalLoginSignInAsync(provider, key, isPersistent);
        }

        public async Task<IdentityResult> AddExternalLoginAsync(ApplicationUser user, ExternalLoginInfo info)
        {
            return await _userRepository.AddLoginAsync(user, info);
        }

        public async Task UpdateExternalAuthTokensAsync(ExternalLoginInfo info)
        {
            await _userRepository.UpdateExternalAuthTokensAsync(info);
        }

    }
}
