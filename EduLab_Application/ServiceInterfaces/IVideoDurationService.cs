using Microsoft.AspNetCore.Http;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for video duration calculation operations
    /// </summary>
    public interface IVideoDurationService
    {
        /// <summary>
        /// Gets video duration from uploaded file
        /// </summary>
        /// <param name="videoFile">Video file</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Duration in minutes</returns>
        Task<int> GetVideoDurationAsync(IFormFile videoFile, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets video duration from file path
        /// </summary>
        /// <param name="filePath">Path to video file</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Duration in minutes</returns>
        Task<int> GetVideoDurationFromPathAsync(string filePath, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets video duration from URL
        /// </summary>
        /// <param name="videoUrl">Video URL</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Duration in minutes</returns>
        Task<int> GetVideoDurationFromUrlAsync(string videoUrl, CancellationToken cancellationToken = default);
    }
}