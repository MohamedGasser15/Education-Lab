using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Auth;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Identity;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for external authentication operations.
    /// </summary>
    public interface IExternalLoginService
    {
        /// <summary>
        /// Configures authentication properties for external authentication.
        /// </summary>
        /// <param name="provider">The authentication provider name.</param>
        /// <param name="redirectUrl">The redirect URL after authentication.</param>
        /// <returns>Authentication properties for the external provider.</returns>
        AuthenticationProperties ConfigureExternalAuthProperties(string provider, string redirectUrl);

        /// <summary>
        /// Retrieves external login information from the current context.
        /// </summary>
        /// <returns>External login information.</returns>
        Task<ExternalLoginInfo> GetExternalLoginInfoAsync();

        /// <summary>
        /// Finds a user by their external login information.
        /// </summary>
        /// <param name="provider">The authentication provider name.</param>
        /// <param name="key">The provider key.</param>
        /// <returns>The application user if found; otherwise, null.</returns>
        Task<ApplicationUser> FindByExternalLoginAsync(string provider, string key);

        /// <summary>
        /// Signs in a user using external authentication.
        /// </summary>
        /// <param name="provider">The authentication provider name.</param>
        /// <param name="key">The provider key.</param>
        /// <param name="isPersistent">Whether the sign-in should be persistent.</param>
        /// <returns>The result of the sign-in operation.</returns>
        Task<SignInResult> ExternalLoginSignInAsync(string provider, string key, bool isPersistent);

        /// <summary>
        /// Updates external authentication tokens for the current user.
        /// </summary>
        /// <param name="info">The external login information.</param>
        /// <returns>A task representing the asynchronous operation.</returns>
        Task UpdateExternalAuthTokensAsync(ExternalLoginInfo info);

        /// <summary>
        /// Handles the callback from an external authentication provider.
        /// </summary>
        /// <param name="remoteError">Error message from the external provider, if any.</param>
        /// <param name="returnUrl">The URL to return to after successful authentication.</param>
        /// <returns>An external login callback result containing authentication information.</returns>
        Task<ExternalLoginCallbackResultDTO> HandleExternalLoginCallbackAsync(string remoteError, string returnUrl);

        /// <summary>
        /// Confirms and creates a new user from external authentication.
        /// </summary>
        /// <param name="model">The external login confirmation data.</param>
        /// <returns>An identity result indicating success or failure.</returns>
        Task<IdentityResult> ConfirmExternalUserAsync(ExternalLoginConfirmationDto model);
    }
}