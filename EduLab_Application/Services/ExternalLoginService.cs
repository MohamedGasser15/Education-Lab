using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Auth;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using System;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service for handling external authentication operations (Google, Facebook, etc.).
    /// </summary>
    public class ExternalLoginService : IExternalLoginService
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly SignInManager<ApplicationUser> _signInManager;
        private readonly ILogger<ExternalLoginService> _logger;

        /// <summary>
        /// Initializes a new instance of the <see cref="ExternalLoginService"/> class.
        /// </summary>
        /// <param name="userManager">The user manager instance.</param>
        /// <param name="signInManager">The sign-in manager instance.</param>
        /// <param name="logger">The logger instance.</param>
        public ExternalLoginService(
            UserManager<ApplicationUser> userManager,
            SignInManager<ApplicationUser> signInManager,
            ILogger<ExternalLoginService> logger)
        {
            _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
            _signInManager = signInManager ?? throw new ArgumentNullException(nameof(signInManager));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region External Authentication Methods

        /// <summary>
        /// Handles the callback from an external authentication provider.
        /// </summary>
        /// <param name="remoteError">Error message from the external provider, if any.</param>
        /// <param name="returnUrl">The URL to return to after successful authentication.</param>
        /// <returns>An external login callback result containing authentication information.</returns>
        public async Task<ExternalLoginCallbackResultDTO> HandleExternalLoginCallbackAsync(string remoteError, string returnUrl)
        {
            try
            {
                if (remoteError != null)
                {
                    _logger.LogWarning("External login error from provider: {RemoteError}", remoteError);
                    return new ExternalLoginCallbackResultDTO
                    {
                        Message = $"Error from provider: {remoteError}"
                    };
                }

                var info = await _signInManager.GetExternalLoginInfoAsync();
                if (info == null)
                {
                    _logger.LogWarning("Unable to retrieve external login information");
                    return new ExternalLoginCallbackResultDTO
                    {
                        Message = "Unable to retrieve external login info."
                    };
                }

                var user = await _userManager.FindByLoginAsync(info.LoginProvider, info.ProviderKey);
                if (user != null)
                {
                    var result = await _signInManager.ExternalLoginSignInAsync(info.LoginProvider, info.ProviderKey, false);
                    if (result.Succeeded)
                    {
                        await _signInManager.UpdateExternalAuthenticationTokensAsync(info);

                        _logger.LogInformation("User {UserId} logged in successfully via {Provider}", user.Id, info.LoginProvider);

                        return new ExternalLoginCallbackResultDTO
                        {
                            IsNewUser = false,
                            Message = "Logged in successfully via external provider",
                            ReturnUrl = returnUrl,
                        };
                    }
                    else
                    {
                        _logger.LogWarning("External login sign-in failed for user {UserId}", user.Id);
                        return new ExternalLoginCallbackResultDTO
                        {
                            Message = "External login sign-in failed"
                        };
                    }
                }

                var email = info.Principal.FindFirstValue(ClaimTypes.Email);

                _logger.LogInformation("New external user detected with email: {Email}", email);

                return new ExternalLoginCallbackResultDTO
                {
                    IsNewUser = true,
                    Email = email,
                    Message = "New user, please confirm registration",
                    ReturnUrl = returnUrl,
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during external login callback handling");
                return new ExternalLoginCallbackResultDTO
                {
                    Message = "An unexpected error occurred during external login."
                };
            }
        }

        /// <summary>
        /// Confirms and creates a new user from external authentication.
        /// </summary>
        /// <param name="model">The external login confirmation data.</param>
        /// <returns>An identity result indicating success or failure.</returns>
        /// <exception cref="ArgumentNullException">Thrown when model is null.</exception>
        /// <exception cref="InvalidOperationException">Thrown when external login info is invalid or email is already registered.</exception>
        public async Task<IdentityResult> ConfirmExternalUserAsync(ExternalLoginConfirmationDto model)
        {
            try
            {
                if (model == null)
                    throw new ArgumentNullException(nameof(model));

                _logger.LogInformation("Confirming external user registration for email: {Email}", model.Email);

                var info = await _signInManager.GetExternalLoginInfoAsync();
                if (info == null)
                {
                    _logger.LogError("Invalid external login info during confirmation");
                    throw new InvalidOperationException("Invalid external login info.");
                }

                var existingUser = await _userManager.FindByEmailAsync(model.Email);
                if (existingUser != null)
                {
                    _logger.LogWarning("Email {Email} is already registered", model.Email);
                    throw new InvalidOperationException("Email is already registered.");
                }

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
                {
                    _logger.LogError("User creation failed for email {Email}: {Errors}", model.Email, string.Join(", ", result.Errors.Select(e => e.Description)));
                    return result;
                }

                await _userManager.AddToRoleAsync(user, SD.Student);

                var loginResult = await _userManager.AddLoginAsync(user, info);
                if (!loginResult.Succeeded)
                {
                    _logger.LogError("Adding external login failed for user {UserId}: {Errors}", user.Id, string.Join(", ", loginResult.Errors.Select(e => e.Description)));
                    return loginResult;
                }

                await _userManager.UpdateAsync(user);

                _logger.LogInformation("External user confirmed and created successfully for email: {Email}", model.Email);

                return IdentityResult.Success;
            }
            catch (ArgumentNullException ex)
            {
                _logger.LogError(ex, "Null argument in ConfirmExternalUserAsync method");
                throw;
            }
            catch (InvalidOperationException ex)
            {
                _logger.LogError(ex, "Invalid operation during external user confirmation");
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during external user confirmation for email: {Email}", model?.Email);
                throw;
            }
        }

        /// <summary>
        /// Configures authentication properties for external authentication.
        /// </summary>
        /// <param name="provider">The authentication provider name.</param>
        /// <param name="redirectUrl">The redirect URL after authentication.</param>
        /// <returns>Authentication properties for the external provider.</returns>
        /// <exception cref="ArgumentException">Thrown when provider or redirectUrl is null or empty.</exception>
        public AuthenticationProperties ConfigureExternalAuthProperties(string provider, string redirectUrl)
        {
            try
            {
                if (string.IsNullOrEmpty(provider))
                    throw new ArgumentException("Provider cannot be null or empty.", nameof(provider));

                if (string.IsNullOrEmpty(redirectUrl))
                    throw new ArgumentException("Redirect URL cannot be null or empty.", nameof(redirectUrl));

                _logger.LogInformation("Configuring external auth properties for provider: {Provider}", provider);

                return _signInManager.ConfigureExternalAuthenticationProperties(provider, redirectUrl);
            }
            catch (ArgumentException ex)
            {
                _logger.LogError(ex, "Invalid argument in ConfigureExternalAuthProperties method");
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error configuring external auth properties for provider: {Provider}", provider);
                throw;
            }
        }

        #endregion

        #region External Login Info Methods

        /// <summary>
        /// Retrieves external login information from the current context.
        /// </summary>
        /// <returns>External login information.</returns>
        public async Task<ExternalLoginInfo> GetExternalLoginInfoAsync()
        {
            try
            {
                _logger.LogDebug("Retrieving external login information");

                var info = await _signInManager.GetExternalLoginInfoAsync();

                if (info == null)
                    _logger.LogWarning("No external login information found");
                else
                    _logger.LogDebug("External login info retrieved for provider: {Provider}", info.LoginProvider);

                return info;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error retrieving external login information");
                throw;
            }
        }

        /// <summary>
        /// Finds a user by their external login information.
        /// </summary>
        /// <param name="provider">The authentication provider name.</param>
        /// <param name="key">The provider key.</param>
        /// <returns>The application user if found; otherwise, null.</returns>
        /// <exception cref="ArgumentException">Thrown when provider or key is null or empty.</exception>
        public async Task<ApplicationUser> FindByExternalLoginAsync(string provider, string key)
        {
            try
            {
                if (string.IsNullOrEmpty(provider))
                    throw new ArgumentException("Provider cannot be null or empty.", nameof(provider));

                if (string.IsNullOrEmpty(key))
                    throw new ArgumentException("Key cannot be null or empty.", nameof(key));

                _logger.LogDebug("Finding user by external login: Provider={Provider}, Key={Key}", provider, key);

                var user = await _userManager.FindByLoginAsync(provider, key);

                if (user == null)
                    _logger.LogDebug("No user found for external login: Provider={Provider}, Key={Key}", provider, key);
                else
                    _logger.LogDebug("User {UserId} found for external login", user.Id);

                return user;
            }
            catch (ArgumentException ex)
            {
                _logger.LogError(ex, "Invalid argument in FindByExternalLoginAsync method");
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error finding user by external login: Provider={Provider}, Key={Key}", provider, key);
                throw;
            }
        }

        /// <summary>
        /// Signs in a user using external authentication.
        /// </summary>
        /// <param name="provider">The authentication provider name.</param>
        /// <param name="key">The provider key.</param>
        /// <param name="isPersistent">Whether the sign-in should be persistent.</param>
        /// <returns>The result of the sign-in operation.</returns>
        /// <exception cref="ArgumentException">Thrown when provider or key is null or empty.</exception>
        public async Task<SignInResult> ExternalLoginSignInAsync(string provider, string key, bool isPersistent)
        {
            try
            {
                if (string.IsNullOrEmpty(provider))
                    throw new ArgumentException("Provider cannot be null or empty.", nameof(provider));

                if (string.IsNullOrEmpty(key))
                    throw new ArgumentException("Key cannot be null or empty.", nameof(key));

                _logger.LogInformation("Signing in user via external login: Provider={Provider}, Key={Key}", provider, key);

                var result = await _signInManager.ExternalLoginSignInAsync(provider, key, isPersistent);

                _logger.LogInformation("External login sign-in result: {Succeeded}", result.Succeeded);

                return result;
            }
            catch (ArgumentException ex)
            {
                _logger.LogError(ex, "Invalid argument in ExternalLoginSignInAsync method");
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during external login sign-in: Provider={Provider}, Key={Key}", provider, key);
                throw;
            }
        }

        /// <summary>
        /// Updates external authentication tokens for the current user.
        /// </summary>
        /// <param name="info">The external login information.</param>
        /// <returns>A task representing the asynchronous operation.</returns>
        /// <exception cref="ArgumentNullException">Thrown when info is null.</exception>
        public async Task UpdateExternalAuthTokensAsync(ExternalLoginInfo info)
        {
            try
            {
                if (info == null)
                    throw new ArgumentNullException(nameof(info));

                _logger.LogDebug("Updating external authentication tokens for provider: {Provider}", info.LoginProvider);

                await _signInManager.UpdateExternalAuthenticationTokensAsync(info);

                _logger.LogDebug("External authentication tokens updated successfully");
            }
            catch (ArgumentNullException ex)
            {
                _logger.LogError(ex, "Null argument in UpdateExternalAuthTokensAsync method");
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error updating external authentication tokens");
                throw;
            }
        }

        /// <summary>
        /// Adds an external login to an existing user.
        /// </summary>
        /// <param name="user">The application user.</param>
        /// <param name="info">The external login information.</param>
        /// <returns>An identity result indicating success or failure.</returns>
        /// <exception cref="ArgumentNullException">Thrown when user or info is null.</exception>
        public async Task<IdentityResult> AddExternalLoginAsync(ApplicationUser user, ExternalLoginInfo info)
        {
            try
            {
                if (user == null)
                    throw new ArgumentNullException(nameof(user));

                if (info == null)
                    throw new ArgumentNullException(nameof(info));

                _logger.LogInformation("Adding external login for user {UserId} with provider: {Provider}", user.Id, info.LoginProvider);

                var result = await _userManager.AddLoginAsync(user, info);

                if (result.Succeeded)
                    _logger.LogInformation("External login added successfully for user {UserId}", user.Id);
                else
                    _logger.LogError("Failed to add external login for user {UserId}: {Errors}", user.Id, string.Join(", ", result.Errors.Select(e => e.Description)));

                return result;
            }
            catch (ArgumentNullException ex)
            {
                _logger.LogError(ex, "Null argument in AddExternalLoginAsync method");
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error adding external login for user {UserId}", user?.Id);
                throw;
            }
        }

        #endregion
    }
}