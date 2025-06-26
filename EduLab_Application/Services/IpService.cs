using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using System.Net;

namespace EduLab_Application.Services
{
    public class IpService : IIpService
    {
        private readonly IHttpContextAccessor _httpContextAccessor;

        public IpService(IHttpContextAccessor httpContextAccessor)
        {
            _httpContextAccessor = httpContextAccessor;
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
    }
}
