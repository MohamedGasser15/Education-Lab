using EduLab_Application.ServiceInterfaces;
using FFMpegCore;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Diagnostics;
using System.IO;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for video duration calculation operations
    /// </summary>
    public class VideoDurationService : IVideoDurationService
    {
        private readonly ILogger<VideoDurationService> _logger;

        /// <summary>
        /// Initializes a new instance of the VideoDurationService class
        /// </summary>
        /// <param name="logger">Logger instance</param>
        public VideoDurationService(ILogger<VideoDurationService> logger)
        {
            _logger = logger;
        }

        /// <summary>
        /// Gets video duration from uploaded file
        /// </summary>
        public async Task<int> GetVideoDurationAsync(IFormFile videoFile, CancellationToken cancellationToken = default)
        {
            if (videoFile == null || videoFile.Length == 0)
                return 0;

            string tempPath = null;
            
            try
            {
                _logger.LogDebug("Calculating video duration for file: {FileName}, Size: {Size} bytes", 
                    videoFile.FileName, videoFile.Length);

                tempPath = Path.GetTempFileName();
                
                using (var stream = new FileStream(tempPath, FileMode.Create))
                {
                    await videoFile.CopyToAsync(stream, cancellationToken);
                }

                var duration = await GetVideoDurationFromPathAsync(tempPath, cancellationToken);
                
                _logger.LogDebug("Video duration calculated: {Duration} minutes for file: {FileName}", 
                    duration, videoFile.FileName);
                
                return duration;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Video duration calculation was cancelled for file: {FileName}", videoFile.FileName);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error calculating video duration for file: {FileName}", videoFile.FileName);
                return 0;
            }
            finally
            {
                // Clean up temporary file
                if (tempPath != null && File.Exists(tempPath))
                {
                    try
                    {
                        File.Delete(tempPath);
                    }
                    catch (Exception ex)
                    {
                        _logger.LogWarning(ex, "Failed to delete temporary file: {TempPath}", tempPath);
                    }
                }
            }
        }

        /// <summary>
        /// Gets video duration from file path
        /// </summary>
        public async Task<int> GetVideoDurationFromPathAsync(string filePath, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Calculating video duration from path: {FilePath}", filePath);

                if (!File.Exists(filePath))
                {
                    _logger.LogWarning("Video file not found at path: {FilePath}", filePath);
                    return 0;
                }

                var processInfo = new ProcessStartInfo
                {
                    FileName = "ffprobe",
                    Arguments = $"-v quiet -show_entries format=duration -of csv=p=0 \"{filePath}\"",
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                };

                using var process = new Process { StartInfo = processInfo };
                
                process.Start();
                
                string output = await process.StandardOutput.ReadToEndAsync();
                string error = await process.StandardError.ReadToEndAsync();
                
                await process.WaitForExitAsync(cancellationToken);

                if (process.ExitCode != 0)
                {
                    _logger.LogError("FFprobe process failed with exit code {ExitCode}. Error: {Error}", 
                        process.ExitCode, error);
                    return 0;
                }

                if (double.TryParse(output.Trim(), out double seconds))
                {
                    var minutes = (int)Math.Round(seconds / 60);
                    _logger.LogDebug("Video duration calculated: {Minutes} minutes from path: {FilePath}", 
                        minutes, filePath);
                    return minutes;
                }

                _logger.LogWarning("Failed to parse video duration output: {Output}", output);
                return 0;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Video duration calculation was cancelled for path: {FilePath}", filePath);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error calculating video duration from path: {FilePath}", filePath);
                return 0;
            }
        }

        /// <summary>
        /// Gets video duration from URL
        /// </summary>
        public async Task<int> GetVideoDurationFromUrlAsync(string videoUrl, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Calculating video duration from URL: {VideoUrl}", videoUrl);

                if (string.IsNullOrEmpty(videoUrl))
                {
                    _logger.LogWarning("Video URL is null or empty");
                    return 0;
                }

                if (videoUrl.StartsWith("/"))
                {
                    var localPath = Path.Combine("wwwroot", videoUrl.TrimStart('/'));
                    return await GetVideoDurationFromPathAsync(localPath, cancellationToken);
                }

                _logger.LogWarning("External URL video duration calculation not implemented yet for URL: {VideoUrl}", videoUrl);
                return 0;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Video duration calculation was cancelled for URL: {VideoUrl}", videoUrl);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error calculating video duration from URL: {VideoUrl}", videoUrl);
                return 0;
            }
        }
    }
}