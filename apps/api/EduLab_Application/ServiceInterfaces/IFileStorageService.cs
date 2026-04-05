using Microsoft.AspNetCore.Http;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IFileStorageService
    {
        Task<string> UploadFileAsync(IFormFile file, string folder, CancellationToken cancellationToken = default);
        Task<string> UploadBase64FileAsync(string base64String, string folder, string fileExtension, CancellationToken cancellationToken = default);
        bool DeleteFile(string fileUrl);
        bool DeleteFileIfExists(string fileUrl);
        bool DeleteVideoFile(string videoUrl);
        bool DeleteVideoFileIfExists(string videoUrl);
    }
}