using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.Utitlites
{
    /// <summary>
    /// Generic API response model
    /// </summary>
    public class ApiResponse
    {
        /// <summary>
        /// Indicates if the request was successful
        /// </summary>
        public bool Success { get; set; }

        /// <summary>
        /// Response message
        /// </summary>
        public string Message { get; set; }

        /// <summary>
        /// Error message (if any)
        /// </summary>
        public string Error { get; set; }
    }

    /// <summary>
    /// Generic API response model with data
    /// </summary>
    /// <typeparam name="T">Data type</typeparam>
    public class ApiResponse<T> : ApiResponse
    {
        /// <summary>
        /// Response data
        /// </summary>
        public T Data { get; set; }
    }
}
