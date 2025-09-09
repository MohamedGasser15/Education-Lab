using EduLab_Domain.Entities;
using EduLab_MVC.Models.DTOs.Auth;
using EduLab_MVC.Models.DTOs.Token;
using System.IdentityModel.Tokens.Jwt;
using System.Net;

namespace EduLab_MVC.Services
{
    public class AuthService
    {
        private readonly IHttpClientFactory _clientFactory;
        private readonly IHttpContextAccessor _httpContextAccessor;
        public AuthService(IHttpClientFactory clientFactory, IHttpContextAccessor httpContextAccessor)
        {
            _clientFactory = clientFactory;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<LoginResponseDTO> Login(LoginRequestDTO model)
        {
            var client = _clientFactory.CreateClient("EduLabAPI");
            var response = await client.PostAsJsonAsync("Auth/Login", model);

            if (response.IsSuccessStatusCode)
            {
                return await response.Content.ReadFromJsonAsync<LoginResponseDTO>();
            }

            return null;
        }

        public async Task<TokenResponseDTO> RefreshToken(RefreshTokenRequestDTO request)
        {
            var client = _clientFactory.CreateClient("EduLabAPI");
            var response = await client.PostAsJsonAsync("Auth/refresh", request);

            if (response.IsSuccessStatusCode)
            {
                return await response.Content.ReadFromJsonAsync<TokenResponseDTO>();
            }
            else if (response.StatusCode == HttpStatusCode.Unauthorized)
            {
                throw new UnauthorizedAccessException("Refresh token غير صالح");
            }

            return null;
        }

        public async Task<bool> RevokeToken(string refreshToken)
        {
            var client = _clientFactory.CreateClient("EduLabAPI");
            var response = await client.PostAsJsonAsync("Auth/revoke", refreshToken);

            return response.IsSuccessStatusCode;
        }

        // دالة مساعدة للتحقق من صلاحية الـ Token
        public bool IsTokenExpired(string token)
        {
            try
            {
                var handler = new JwtSecurityTokenHandler();
                var jwtToken = handler.ReadJwtToken(token);
                return jwtToken.ValidTo < DateTime.UtcNow;
            }
            catch
            {
                return true;
            }
        }

        // دالة للحصول على الـ Refresh Token من الكوكيز
        public string GetRefreshTokenFromCookies()
        {
            return _httpContextAccessor.HttpContext?.Request.Cookies["RefreshToken"];
        }

        // دالة لحفظ التوكنز في الكوكيز
        public void SaveTokensToCookies(string accessToken, string refreshToken, DateTime refreshTokenExpiry)
        {
            var httpContext = _httpContextAccessor.HttpContext;
            if (httpContext == null) return;

            var cookieOptions = new CookieOptions
            {
                HttpOnly = true,
                Secure = true,
                SameSite = SameSiteMode.Strict,
                Expires = refreshTokenExpiry
            };

            httpContext.Response.Cookies.Append("AuthToken", accessToken, cookieOptions);
            httpContext.Response.Cookies.Append("RefreshToken", refreshToken, cookieOptions);
            httpContext.Response.Cookies.Append("RefreshTokenExpiry",
                refreshTokenExpiry.ToString("o"), cookieOptions);
        }

        public async Task<APIResponse> Register(RegisterRequestDTO model)
        {
            var client = _clientFactory.CreateClient("EduLabAPI");
            var response = await client.PostAsJsonAsync("Auth/Register", model);

            var apiResponse = new APIResponse();

            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadFromJsonAsync<APIResponse>();
                return content;
            }
            else
            {
                var errorContent = await response.Content.ReadFromJsonAsync<APIResponse>();
                return errorContent ?? new APIResponse
                {
                    IsSuccess = false,
                    ErrorMessages = new List<string> { "حدث خطأ أثناء التسجيل." },
                    StatusCode = response.StatusCode
                };
            }
        }
        public async Task<APIResponse> VerifyEmailCode(VerifyEmailDTO dto)
        {
            var client = _clientFactory.CreateClient("EduLabAPI");
            var response = await client.PostAsJsonAsync("Auth/verify-email", dto);

            if (response.IsSuccessStatusCode)
            {
                return await response.Content.ReadFromJsonAsync<APIResponse>();
            }
            else
            {
                var errorContent = await response.Content.ReadFromJsonAsync<APIResponse>();
                return errorContent ?? new APIResponse
                {
                    IsSuccess = false,
                    ErrorMessages = new List<string> { "فشل التحقق من الكود" },
                    StatusCode = response.StatusCode
                };
            }
        }
        public async Task<APIResponse> SendVerificationCode(SendCodeDTO dto)
        {
            var client = _clientFactory.CreateClient("EduLabAPI");
            var response = await client.PostAsJsonAsync("Auth/send-code", dto);

            if (response.IsSuccessStatusCode)
            {
                return await response.Content.ReadFromJsonAsync<APIResponse>();
            }
            else
            {
                var errorContent = await response.Content.ReadFromJsonAsync<APIResponse>();
                return errorContent ?? new APIResponse
                {
                    IsSuccess = false,
                    ErrorMessages = new List<string> { "فشل في إعادة إرسال الكود" },
                    StatusCode = response.StatusCode
                };
            }
        }

        public async Task<ExternalLoginCallbackResultDTO> HandleExternalLoginCallback(string returnUrl, string remoteError)
        {
            var client = _clientFactory.CreateClient("EduLabAPI");

            var safeReturnUrl = Uri.EscapeDataString(returnUrl ?? "");
            var safeRemoteError = Uri.EscapeDataString(remoteError ?? "");

            var url = $"Auth/ExternalLoginCallback?returnUrl={safeReturnUrl}&remoteError={safeRemoteError}";
            var response = await client.GetAsync(url);

            if (response.IsSuccessStatusCode)
            {
                return await response.Content.ReadFromJsonAsync<ExternalLoginCallbackResultDTO>();
            }

            return null;
        }

        public async Task<APIResponse> ConfirmExternalUser(ExternalLoginConfirmationDto model)
        {
            var client = _clientFactory.CreateClient("EduLabAPI");
            var response = await client.PostAsJsonAsync("Auth/ExternalLoginConfirmation", model);

            if (response.IsSuccessStatusCode)
            {
                return new APIResponse { IsSuccess = true };
            }

            var error = await response.Content.ReadFromJsonAsync<APIResponse>();
            return error ?? new APIResponse
            {
                IsSuccess = false,
                ErrorMessages = new List<string> { "حدث خطأ أثناء تأكيد المستخدم الخارجي" }
            };
        }

    }
}
