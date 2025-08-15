using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class FileStorageService : IFileStorageService
    {
        public async Task<string> UploadFileAsync(IFormFile file, string folder)
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
                await file.CopyToAsync(stream);
            }

            return $"/{folder}/{fileName}";
        }

        public async Task<string> UploadBase64FileAsync(string base64String, string folder, string fileExtension)
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

            await File.WriteAllBytesAsync(filePath, bytes);
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