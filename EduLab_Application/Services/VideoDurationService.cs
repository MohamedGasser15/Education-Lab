using EduLab_Application.ServiceInterfaces;
using FFMpegCore;
using Microsoft.AspNetCore.Http;
using System;
using System.Diagnostics;
using System.IO;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class VideoDurationService : IVideoDurationService
    {
        public async Task<int> GetVideoDurationAsync(IFormFile videoFile)
        {
            if (videoFile == null || videoFile.Length == 0)
                return 0;

            try
            {
                var tempPath = Path.GetTempFileName();
                using (var stream = new FileStream(tempPath, FileMode.Create))
                {
                    await videoFile.CopyToAsync(stream);
                }

                var duration = await GetVideoDurationFromPathAsync(tempPath);

                if (File.Exists(tempPath))
                    File.Delete(tempPath);

                return duration;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error calculating video duration: {ex.Message}");
                return 0;
            }
        }


        public async Task<int> GetVideoDurationFromPathAsync(string filePath)
        {
            try
            {
                var processInfo = new ProcessStartInfo
                {
                    FileName = "ffprobe",
                    Arguments = $"-v quiet -show_entries format=duration -of csv=p=0 \"{filePath}\"",
                    RedirectStandardOutput = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                };

                using var process = new Process { StartInfo = processInfo };
                process.Start();
                string output = await process.StandardOutput.ReadToEndAsync();
                await process.WaitForExitAsync();

                if (double.TryParse(output.Trim(), out double seconds))
                {
                    return (int)Math.Round(seconds / 60); // تحويل للدقائق
                }

                return 0;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
                return 0;
            }
        }


        public async Task<int> GetVideoDurationFromUrlAsync(string videoUrl)
        {
            if (string.IsNullOrEmpty(videoUrl))
                return 0;

            try
            {
                if (videoUrl.StartsWith("/"))
                {
                    var localPath = Path.Combine("wwwroot", videoUrl.TrimStart('/'));
                    return await GetVideoDurationFromPathAsync(localPath);
                }

                Console.WriteLine("External URL video duration calculation not implemented yet");
                return 0;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error calculating video duration from URL {videoUrl}: {ex.Message}");
                return 0;
            }
        }
    }
} 