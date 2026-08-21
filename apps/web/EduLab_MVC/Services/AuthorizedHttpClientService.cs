using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.Extensions.Logging;
using System.Globalization;
using System.Net.Http.Headers;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// Creates HTTP clients pre-configured with the current user's bearer token, culture and guest cookie.
    /// </summary>
    public class AuthorizedHttpClientService : IAuthorizedHttpClientService
    {
        private readonly IHttpClientFactory _clientFactory;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ILogger<AuthorizedHttpClientService> _logger;

        /// <summary>
        /// Initializes a new instance of the <see cref="AuthorizedHttpClientService"/> class.
        /// </summary>
        /// <param name="clientFactory">The HTTP client factory.</param>
        /// <param name="httpContextAccessor">The HTTP context accessor.</param>
        /// <param name="logger">The logger instance.</param>
        public AuthorizedHttpClientService(
            IHttpClientFactory clientFactory,
            IHttpContextAccessor httpContextAccessor,
            ILogger<AuthorizedHttpClientService> logger) 
        {
            _clientFactory = clientFactory;
            _httpContextAccessor = httpContextAccessor;
            _logger = logger;
        }

        /// <summary>
        /// Creates an authorized HTTP client for the EduLab API.
        /// </summary>
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

            var culture = CultureInfo.CurrentUICulture.Name;
            client.DefaultRequestHeaders.AcceptLanguage.ParseAdd(culture);

            // Always forward the GuestId cookie so the API keeps the same guest cart.
            // This is also required for the cart migration request right after login,
            // which carries a Bearer token but must still be matched to the guest cart.
            var guestId = _httpContextAccessor.HttpContext?.Request.Cookies["GuestId"];
            if (!string.IsNullOrEmpty(guestId))
            {
                client.DefaultRequestHeaders.Add("Cookie", $"GuestId={guestId}");
            }

            return client;
        }
    }
}