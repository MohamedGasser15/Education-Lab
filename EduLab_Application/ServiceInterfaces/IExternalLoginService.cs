using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Auth;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IExternalLoginService
    {
        AuthenticationProperties ConfigureExternalAuthProperties(string provider, string redirectUrl);
        Task<ExternalLoginInfo> GetExternalLoginInfoAsync();
        Task<ApplicationUser> FindByExternalLoginAsync(string provider, string key);
        Task<SignInResult> ExternalLoginSignInAsync(string provider, string key, bool isPersistent);
        Task UpdateExternalAuthTokensAsync(ExternalLoginInfo info);
        Task<ExternalLoginCallbackResultDTO> HandleExternalLoginCallbackAsync(string remoteError, string returnUrl);
        Task<IdentityResult> ConfirmExternalUserAsync(ExternalLoginConfirmationDto model);
    }
}
