using Microsoft.AspNetCore.Http;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for file storage operations
    /// </summary>
    public interface IFileStorageService
    {
        /// <summary>
        /// Uploads an uploaded file to the storage
        /// </summary>
        /// <param name="file">The file to upload</param>
        /// <param name="folder">Destination folder within the storage</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The URL of the uploaded file</returns>
        Task<string> UploadFileAsync(IFormFile file, string folder, CancellationToken cancellationToken = default);

        /// <summary>
        /// Uploads a base64-encoded file to the storage
        /// </summary>
        /// <param name="base64String">Base64 content of the file</param>
        /// <param name="folder">Destination folder within the storage</param>
        /// <param name="fileExtension">Extension of the file</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The URL of the uploaded file</returns>
        Task<string> UploadBase64FileAsync(string base64String, string folder, string fileExtension, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a file from the storage
        /// </summary>
        /// <param name="fileUrl">URL of the file to delete</param>
        /// <returns>True if the file was deleted, otherwise false</returns>
        bool DeleteFile(string fileUrl);

        /// <summary>
        /// Deletes a file from the storage if it exists
        /// </summary>
        /// <param name="fileUrl">URL of the file to delete</param>
        /// <returns>True if the file was deleted, otherwise false</returns>
        bool DeleteFileIfExists(string fileUrl);

        /// <summary>
        /// Deletes a video file from the storage
        /// </summary>
        /// <param name="videoUrl">URL of the video to delete</param>
        /// <returns>True if the video was deleted, otherwise false</returns>
        bool DeleteVideoFile(string videoUrl);

        /// <summary>
        /// Deletes a video file from the storage if it exists
        /// </summary>
        /// <param name="videoUrl">URL of the video to delete</param>
        /// <returns>True if the video was deleted, otherwise false</returns>
        bool DeleteVideoFileIfExists(string videoUrl);
    }
}