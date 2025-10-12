using EduLab_Domain.Entities;
using EduLab_MVC.Models.DTOs.Auth;
using EduLab_MVC.Models.DTOs.Token;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for handling authentication operations in the MVC application.
    /// </summary>
    public interface IAuthService
    {
        #region Authentication Methods

        /// <summary>
        /// Authenticates a user with the provided credentials.
        /// </summary>
        /// <param name="model">The login request data.</param>
        /// <returns>Login response containing tokens and user information.</returns>
        /// <exception cref="ArgumentNullException">Thrown when model is null.</exception>
        Task<LoginResponseDTO> Login(LoginRequestDTO model);

        /// <summary>
        /// Refreshes an access token using a valid refresh token.
        /// </summary>
        /// <param name="request">The refresh token request data.</param>
        /// <returns>New access and refresh tokens.</returns>
        /// <exception cref="ArgumentNullException">Thrown when request is null.</exception>
        /// <exception cref="UnauthorizedAccessException">Thrown when refresh token is invalid.</exception>
        Task<TokenResponseDTO> RefreshToken(RefreshTokenRequestDTO request);

        /// <summary>
        /// Revokes a refresh token.
        /// </summary>
        /// <param name="refreshToken">The refresh token to revoke.</param>
        /// <returns>True if revocation was successful; otherwise, false.</returns>
        /// <exception cref="ArgumentException">Thrown when refresh token is null or empty.</exception>
        Task<bool> RevokeToken(string refreshToken);
                Task<APIResponse> ForgotPasswordAsync(ForgotPasswordDTO dto);
        Task<APIResponse> VerifyResetCodeAsync(VerifyEmailDTO dto);
        Task<APIResponse> ResetPasswordAsync(ResetPasswordDTO dto);
        #endregion

        #region Token Management Methods

        /// <summary>
        /// Checks if a JWT token is expired.
        /// </summary>
        /// <param name="token">The JWT token to check.</param>
        /// <returns>True if the token is expired; otherwise, false.</returns>
        bool IsTokenExpired(string token);

        /// <summary>
        /// Retrieves the refresh token from cookies.
        /// </summary>
        /// <returns>The refresh token if found; otherwise, null.</returns>
        string GetRefreshTokenFromCookies();

        /// <summary>
        /// Saves authentication tokens to cookies.
        /// </summary>
        /// <param name="accessToken">The access token.</param>
        /// <param name="refreshToken">The refresh token.</param>
        /// <param name="refreshTokenExpiry">The expiration date of the refresh token.</param>
        void SaveTokensToCookies(string accessToken, string refreshToken, DateTime refreshTokenExpiry);

        #endregion

        #region Registration Methods

        /// <summary>
        /// Registers a new user.
        /// </summary>
        /// <param name="model">The registration request data.</param>
        /// <returns>API response indicating success or failure.</returns>
        /// <exception cref="ArgumentNullException">Thrown when model is null.</exception>
        Task<APIResponse> Register(RegisterRequestDTO model);

        #endregion

        #region Email Verification Methods

        /// <summary>
        /// Verifies an email address using a verification code.
        /// </summary>
        /// <param name="dto">The email verification data.</param>
        /// <returns>API response indicating success or failure.</returns>
        /// <exception cref="ArgumentNullException">Thrown when DTO is null.</exception>
        Task<APIResponse> VerifyEmailCode(VerifyEmailDTO dto);

        /// <summary>
        /// Sends a verification code to the specified email address.
        /// </summary>
        /// <param name="dto">The email address to send the code to.</param>
        /// <returns>API response indicating success or failure.</returns>
        /// <exception cref="ArgumentNullException">Thrown when DTO is null.</exception>
        Task<APIResponse> SendVerificationCode(SendCodeDTO dto);

        #endregion

        #region External Authentication Methods

        /// <summary>
        /// Handles the callback from external authentication providers.
        /// </summary>
        /// <param name="returnUrl">The URL to return to after processing.</param>
        /// <param name="remoteError">Error message from the external provider, if any.</param>
        /// <returns>External login callback result.</returns>
        Task<ExternalLoginCallbackResultDTO> HandleExternalLoginCallback(string returnUrl, string remoteError);

        /// <summary>
        /// Confirms and completes external user registration.
        /// </summary>
        /// <param name="model">The external login confirmation data.</param>
        /// <returns>API response indicating success or failure.</returns>
        /// <exception cref="ArgumentNullException">Thrown when model is null.</exception>
        Task<APIResponse> ConfirmExternalUser(ExternalLoginConfirmationDto model);

        #endregion
    }
}
