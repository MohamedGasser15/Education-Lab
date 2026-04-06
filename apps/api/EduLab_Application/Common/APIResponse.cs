using System.Net;
using System.Text.Json.Serialization;

namespace EduLab_Application.Common
{
    /// <summary>
    /// Unified API Response (Backward Compatible + Enterprise)
    /// </summary>
    public class ApiResponse<T>
    {
        public bool Success { get; set; }

        [JsonIgnore]
        public bool IsSuccess
        {
            get => Success;
            set => Success = value;
        }

        /// <summary>
        /// Message for client
        /// </summary>
        public string Message { get; set; }

        /// <summary>
        /// Single error (old structure)
        /// </summary>
        public string Error { get; set; }

        /// <summary>
        /// Multiple errors (new structure)
        /// </summary>
        public List<string> Errors { get; set; } = new();

        [JsonIgnore]
        public List<string> ErrorMessages
        {
            get => Errors;
            set => Errors = value;
        }

        /// <summary>
        /// Data (type-safe)
        /// </summary>
        public T Data { get; set; }

        [JsonIgnore]
        public object Result
        {
            get => Data;
            set => Data = (T)value;
        }

        /// <summary>
        /// HTTP Status Code
        /// </summary>
        public HttpStatusCode StatusCode { get; set; }

        #region Factory Methods

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
                Errors = errors ?? new List<string>(),
                StatusCode = HttpStatusCode.BadRequest
            };
        }

        #endregion
    }
}