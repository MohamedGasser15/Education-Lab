using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
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

            var fileName = $"{Guid.NewGuid()}{Path.GetExtension(file.FileName)}";
            var filePath = Path.Combine("wwwroot", folder, fileName);

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

            var base64Data = base64String.Split(",")[1] ?? base64String;
            var bytes = Convert.FromBase64String(base64Data);
            var fileName = $"{Guid.NewGuid()}{fileExtension}";
            var filePath = Path.Combine("wwwroot", folder, fileName);

            await File.WriteAllBytesAsync(filePath, bytes);
            return $"/{folder}/{fileName}";
        }
    }
}
