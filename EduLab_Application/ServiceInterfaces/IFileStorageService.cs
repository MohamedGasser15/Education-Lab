using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IFileStorageService
    {
        Task<string> UploadFileAsync(IFormFile file, string folder);
        Task<string> UploadBase64FileAsync(string base64String, string folder, string fileExtension);
        bool DeleteFile(string fileUrl);
        bool DeleteFileIfExists(string fileUrl);
        bool DeleteVideoFile(string videoUrl);
        bool DeleteVideoFileIfExists(string videoUrl);
    }
}
