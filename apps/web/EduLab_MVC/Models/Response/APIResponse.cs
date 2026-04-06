using System;
using System.Collections.Generic;
using System.Net;

namespace EduLab_MVC.Models.Response
{
    /// <summary>
    /// Unified API Response for MVC
    /// Combines old ApiResponse + APIResponse structure
    /// </summary>
    public class ApiResponse<T>
    {
        /// <summary>
        /// Success flag (old + new)
        /// </summary>
        public bool Success { get; set; }

        /// <summary>
        /// Compatibility property for IsSuccess
        /// </summary>
        public bool IsSuccess
        {
            get => Success;
            set => Success = value;
        }

        /// <summary>
        /// Main message for client
        /// </summary>
        public string Message { get; set; }

        /// <summary>
        /// Single error (old structure)
        /// </summary>
        public string Error { get; set; }

        /// <summary>
        /// Multiple errors (new structure)
        /// </summary>
        public List<string> ErrorMessages { get; set; } = new();

        /// <summary>
        /// The actual data
        /// </summary>
        public T Data { get; set; }

        /// <summary>
        /// Compatibility property for Result
        /// </summary>
        public object Result
        {
            get => Data;
            set => Data = (T)value;
        }

        /// <summary>
        /// HTTP status code (optional, can be null for MVC usage)
        /// </summary>
        public HttpStatusCode StatusCode { get; set; } = HttpStatusCode.OK;

        #region Factory Methods (Optional)
        public static ApiResponse<T> SuccessResponse(T data, string message = null)
        {
            return new ApiResponse<T>
            {
                Success = true,
                Data = data,
                Message = message,
                StatusCode = HttpStatusCode.OK
            };
        }

        public static ApiResponse<T> FailResponse(string message, List<string> errors = null)
        {
            return new ApiResponse<T>
            {
                Success = false,
                Message = message,
                Error = message,
                ErrorMessages = errors ?? new List<string>(),
                StatusCode = HttpStatusCode.BadRequest
            };
        }
        #endregion
    }
}