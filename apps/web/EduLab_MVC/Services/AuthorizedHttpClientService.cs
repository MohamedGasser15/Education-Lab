using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.Extensions.Logging;
using System.Net.Http.Headers;

namespace EduLab_MVC.Services
{
    public class AuthorizedHttpClientService : IAuthorizedHttpClientService
    {
        private readonly IHttpClientFactory _clientFactory;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ILogger<AuthorizedHttpClientService> _logger;

        public AuthorizedHttpClientService(
            IHttpClientFactory clientFactory,
            IHttpContextAccessor httpContextAccessor,
            ILogger<AuthorizedHttpClientService> logger) 
        {
            _clientFactory = clientFactory;
            _httpContextAccessor = httpContextAccessor;
            _logger = logger;
        }

        public HttpClient CreateClient()
        {
            var client = _clientFactory.CreateClient("EduLabAPI");

            var token = _httpContextAccessor.HttpContext?.Items["AuthToken"] as string;
            if (string.IsNullOrEmpty(token))
            {
                token = _httpContextAccessor.HttpContext?.Request.Cookies["AuthToken"];
            }

            _logger.LogInformation(
                "Token from cookie: {Status}",
                string.IsNullOrEmpty(token) ? "NOT FOUND" : $"FOUND ({token.Substring(0, 10)}...)"
            );

            if (!string.IsNullOrEmpty(token))
            {
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
            }

            return client;
        }
    }
}