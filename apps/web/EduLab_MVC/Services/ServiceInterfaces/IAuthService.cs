using EduLab_MVC.Models.DTOs.Auth;
using EduLab_MVC.Models.DTOs.Token;
using EduLab_MVC.Models.Response;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for handling authentication operations in the MVC application.
    /// Uses the unified ApiResponse{T} model.
    /// </summary>
    public interface IAuthService
    {
        #region Authentication Methods

        /// <summary>
        /// Authenticates a user with the provided credentials.
        /// </summary>
        Task<LoginResponseDTO> Login(LoginRequestDTO model);

        /// <summary>
        /// Refreshes an access token using a valid refresh token.
        /// </summary>
        Task<TokenResponseDTO> RefreshToken(RefreshTokenRequestDTO request);

        /// <summary>
        /// Revokes a refresh token.
        /// </summary>
        Task<bool> RevokeToken(string refreshToken);

        /// <summary>
        /// Initiates the forgot password process.
        /// </summary>
        Task<ApiResponse<object>> ForgotPasswordAsync(ForgotPasswordDTO dto);

        /// <summary>
        /// Verifies the password reset code.
        /// </summary>
        Task<ApiResponse<object>> VerifyResetCodeAsync(VerifyEmailDTO dto);

        /// <summary>
        /// Resets the user's password.
        /// </summary>
        Task<ApiResponse<object>> ResetPasswordAsync(ResetPasswordDTO dto);

        #endregion

        #region Token Management Methods

        /// <summary>
        /// Checks if a JWT token is expired.
        /// </summary>
        bool IsTokenExpired(string token);

        /// <summary>
        /// Retrieves the refresh token from cookies.
        /// </summary>
        string GetRefreshTokenFromCookies();

        /// <summary>
        /// Saves authentication tokens to cookies.
        /// </summary>
        void SaveTokensToCookies(string accessToken, string refreshToken, DateTime refreshTokenExpiry);

        #endregion

        #region Registration Methods

        /// <summary>
        /// Registers a new user.
        /// </summary>
        Task<ApiResponse<object>> Register(RegisterRequestDTO model);

        #endregion

        #region Email Verification Methods

        /// <summary>
        /// Verifies an email address using a verification code.
        /// </summary>
        Task<ApiResponse<object>> VerifyEmailCode(VerifyEmailDTO dto);

        /// <summary>
        /// Sends a verification code to the specified email address.
        /// </summary>
        Task<ApiResponse<object>> SendVerificationCode(SendCodeDTO dto);

        #endregion

        #region External Authentication Methods

        /// <summary>
        /// Handles the callback from external authentication providers.
        /// </summary>
        Task<ExternalLoginCallbackResultDTO> HandleExternalLoginCallback(string returnUrl, string remoteError);

        /// <summary>
        /// Confirms and completes external user registration.
        /// </summary>
        Task<ApiResponse<LoginResponseDTO>> ConfirmExternalUser(ExternalLoginConfirmationDto model);

        #endregion
    }
}