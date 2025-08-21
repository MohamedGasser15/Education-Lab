using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using Microsoft.AspNetCore.Http;
using System.Net;
using System.Net.Http.Json;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class IpService : IIpService
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ISessionRepository _sessionRepository;

        public IpService(IHttpContextAccessor httpContextAccessor, ISessionRepository sessionRepository)
        {
            _httpContextAccessor = httpContextAccessor;
            _sessionRepository = sessionRepository;
        }

        public string GetClientIpAddress()
        {
            var context = _httpContextAccessor.HttpContext;
            if (context == null) return "Unknown";

            var ip = context.Request.Headers["X-Forwarded-For"].FirstOrDefault();

            if (string.IsNullOrEmpty(ip))
            {
                ip = context.Connection.RemoteIpAddress?.ToString();
            }
            else
            {
                ip = ip.Split(',')[0].Trim();
            }

            if (IPAddress.TryParse(ip, out var address))
            {
                if (address.AddressFamily == System.Net.Sockets.AddressFamily.InterNetworkV6)
                {
                    ip = address.MapToIPv4().ToString();
                }
                else if (ip == "::1")
                {
                    ip = "127.0.0.1";
                }
            }

            return ip ?? "Unknown";
        }

        public async Task<string> GetLocationFromIP(string ipAddress)
        {
            if (ipAddress == "::1" || ipAddress == "127.0.0.0")
                return "Cairo, Egypt (Local Development)";

            try
            {
                using var httpClient = new HttpClient();
                var response = await httpClient.GetFromJsonAsync<IpApiResponse>($"http://ip-api.com/json/{ipAddress}");
                return response.Status == "success" ? $"{response.City}, {response.Country}" : "Unknown Location";
            }
            catch
            {
                return "Location Unknown";
            }
        }

        public string GetDeviceInfo()
        {
            var userAgent = _httpContextAccessor.HttpContext?.Request.Headers["User-Agent"].ToString() ?? "Unknown Device";

            if (string.IsNullOrEmpty(userAgent))
                return "Unknown Device";

            // منطق بسيط لتحليل الـ User-Agent
            string browser = "Unknown Browser";
            string os = "Unknown OS";

            // تحديد المتصفح
            if (userAgent.Contains("Chrome")) browser = "Chrome";
            else if (userAgent.Contains("Firefox")) browser = "Firefox";
            else if (userAgent.Contains("Safari")) browser = "Safari";
            else if (userAgent.Contains("Edge")) browser = "Edge";
            else if (userAgent.Contains("Opera")) browser = "Opera";

            // تحديد نظام التشغيل
            if (userAgent.Contains("Windows")) os = "Windows";
            else if (userAgent.Contains("Mac OS")) os = "macOS";
            else if (userAgent.Contains("Android")) os = "Android";
            else if (userAgent.Contains("iPhone") || userAgent.Contains("iPad")) os = "iOS";
            else if (userAgent.Contains("Linux")) os = "Linux";

            return $"{browser} on {os}";
        }

        public async Task CreateUserSessionAsync(string userId, string jwtToken)
        {
            var ipAddress = GetClientIpAddress();
            var deviceInfo = System.Net.Dns.GetHostName(); // استخدام الدالة الجديدة
            var location = await GetLocationFromIP(ipAddress);

            var newSession = new UserSession
            {
                UserId = userId,
                IPAddress = ipAddress,
                DeviceInfo = deviceInfo,
                Location = location,
                SessionToken = jwtToken
            };

            await _sessionRepository.CreateSession(newSession);
        }

        private record IpApiResponse(string Status, string Country, string City);
    }
}