using Microsoft.AspNetCore.Http;
using System;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IVideoDurationService
    {
        Task<int> GetVideoDurationAsync(IFormFile videoFile);

        Task<int> GetVideoDurationFromPathAsync(string filePath);
        Task<int> GetVideoDurationFromUrlAsync(string videoUrl);
    }
}