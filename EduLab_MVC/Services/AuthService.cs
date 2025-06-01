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

        public async Task<bool> Register(RegisterRequestDTO model)
        {
            var client = _clientFactory.CreateClient("EduLabAPI");
            var response = await client.PostAsJsonAsync("Auth/Register", model);

            return response.IsSuccessStatusCode;
        }
    }

}
