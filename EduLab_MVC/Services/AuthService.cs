using EduLab_Domain.Entities;
using EduLab_MVC.Models.DTOs.Auth;

namespace EduLab_MVC.Services
{
    public class AuthService
    {
        private readonly IHttpClientFactory _clientFactory;

        public AuthService(IHttpClientFactory clientFactory)
        {
            _clientFactory = clientFactory;
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
