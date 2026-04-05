using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using System;
using System.IO;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class FileStorageService : IFileStorageService
    {
        /// <summary>
        /// Uploads a file to the specified folder
        /// </summary>
        /// <param name="file">File to upload</param>
        /// <param name="folder">Target folder</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>File URL</returns>
        public async Task<string> UploadFileAsync(IFormFile file, string folder, CancellationToken cancellationToken = default)
        {
            if (file == null || file.Length == 0)
                return null;

            var folderPath = Path.Combine("wwwroot", folder);
            if (!Directory.Exists(folderPath))
            {
                Directory.CreateDirectory(folderPath);
            }

            var fileName = $"{Guid.NewGuid()}{Path.GetExtension(file.FileName)}";
            var filePath = Path.Combine(folderPath, fileName);

            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await file.CopyToAsync(stream, cancellationToken);
            }

            return $"/{folder}/{fileName}";
        }

        /// <summary>
        /// Uploads a base64 file to the specified folder
        /// </summary>
        /// <param name="base64String">Base64 string</param>
        /// <param name="folder">Target folder</param>
        /// <param name="fileExtension">File extension</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>File URL</returns>
        public async Task<string> UploadBase64FileAsync(string base64String, string folder, string fileExtension, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrEmpty(base64String))
                return null;

            var folderPath = Path.Combine("wwwroot", folder);
            if (!Directory.Exists(folderPath))
            {
                Directory.CreateDirectory(folderPath);
            }

            var base64Data = base64String.Split(",")[1] ?? base64String;
            var bytes = Convert.FromBase64String(base64Data);
            var fileName = $"{Guid.NewGuid()}{fileExtension}";
            var filePath = Path.Combine(folderPath, fileName);

            await File.WriteAllBytesAsync(filePath, bytes, cancellationToken);
            return $"/{folder}/{fileName}";
        }

        public bool DeleteFile(string fileUrl)
        {
            if (string.IsNullOrEmpty(fileUrl) || fileUrl == "/Images/Courses/default.jpg")
                return false;

            try
            {
                var filePath = Path.Combine("wwwroot", fileUrl.TrimStart('/'));
                if (System.IO.File.Exists(filePath))
                {
                    System.IO.File.Delete(filePath);
                    return true;
                }
                return false;
            }
            catch
            {
                return false;
            }
        }

        public bool DeleteFileIfExists(string fileUrl)
        {
            if (string.IsNullOrEmpty(fileUrl) || fileUrl == "/Images/Courses/default.jpg")
                return false;

            var filePath = Path.Combine("wwwroot", fileUrl.TrimStart('/'));
            if (System.IO.File.Exists(filePath))
            {
                try
                {
                    System.IO.File.Delete(filePath);
                    return true;
                }
                catch
                {
                    return false;
                }
            }
            return false;
        }

        public bool DeleteVideoFile(string videoUrl)
        {
            if (string.IsNullOrEmpty(videoUrl))
                return false;

            try
            {
                var filePath = Path.Combine("wwwroot", videoUrl.TrimStart('/'));
                if (System.IO.File.Exists(filePath))
                {
                    System.IO.File.Delete(filePath);
                    return true;
                }
                return false;
            }
            catch
            {
                return false;
            }
        }

        public bool DeleteVideoFileIfExists(string videoUrl)
        {
            if (string.IsNullOrEmpty(videoUrl))
                return false;

            var filePath = Path.Combine("wwwroot", videoUrl.TrimStart('/'));
            if (System.IO.File.Exists(filePath))
            {
                try
                {
                    System.IO.File.Delete(filePath);
                    return true;
                }
                catch
                {
                    return false;
                }
            }
            return false;
        }
    }
}