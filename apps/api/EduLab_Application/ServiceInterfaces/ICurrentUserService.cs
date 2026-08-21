using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for accessing the currently authenticated user
    /// </summary>
    public interface ICurrentUserService
    {
        /// <summary>
        /// Gets the ID of the currently authenticated user
        /// </summary>
        /// <returns>The user ID, or null if not authenticated</returns>
        Task<string?> GetUserIdAsync();

        /// <summary>
        /// Gets the full name of the currently authenticated user
        /// </summary>
        /// <returns>The user full name, or null if not authenticated</returns>
        Task<string?> GetUserFullNameAsync();
    }
}