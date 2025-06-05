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
                // لو الرد فيه رسالة خطأ
                var errorContent = await response.Content.ReadFromJsonAsync<APIResponse>();
                return errorContent ?? new APIResponse
                {
                    IsSuccess = false,
                    ErrorMessages = new List<string> { "حدث خطأ أثناء التسجيل." },
                    StatusCode = response.StatusCode
                };
            }
        }

    }

}
