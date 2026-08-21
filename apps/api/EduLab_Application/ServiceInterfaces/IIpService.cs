using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for IP address and device information
    /// </summary>
    public interface IIpService
    {
        /// <summary>
        /// Gets the IP address of the current request client
        /// </summary>
        /// <returns>The client IP address</returns>
        string GetClientIpAddress();

        /// <summary>
        /// Resolves a location description from an IP address
        /// </summary>
        /// <param name="ipAddress">The IP address to resolve</param>
        /// <returns>The location description</returns>
        Task<string> GetLocationFromIP(string ipAddress);

        /// <summary>
        /// Gets the device information (browser and operating system) of the current request
        /// </summary>
        /// <returns>The device information string</returns>
        string GetDeviceInfo();

        /// <summary>
        /// Creates a session record for a user login
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="jwtToken">The JWT token issued for the session</param>
        Task CreateUserSessionAsync(string userId, string jwtToken);
    }
}