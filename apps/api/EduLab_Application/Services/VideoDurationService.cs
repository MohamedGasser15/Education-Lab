using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System;
using System.IO;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class VideoDurationService : IVideoDurationService
    {
        private readonly ILogger<VideoDurationService> _logger;

        public VideoDurationService(ILogger<VideoDurationService> logger)
        {
            _logger = logger;
        }

        public async Task<int> GetVideoDurationAsync(IFormFile videoFile, CancellationToken cancellationToken = default)
        {
            if (videoFile == null || videoFile.Length == 0)
                return 0;

            string tempPath = null;
            try
            {
                tempPath = Path.GetTempFileName();
                using (var stream = new FileStream(tempPath, FileMode.Create))
                    await videoFile.CopyToAsync(stream, cancellationToken);

                return GetDurationFromFile(tempPath);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error calculating video duration");
                return 0;
            }
            finally
            {
                if (tempPath != null && File.Exists(tempPath))
                    try { File.Delete(tempPath); } catch { }
            }
        }

        public Task<int> GetVideoDurationFromPathAsync(string filePath, CancellationToken cancellationToken = default)
        {
            if (!File.Exists(filePath))
            {
                _logger.LogWarning("Video file not found: {FilePath}", filePath);
                return Task.FromResult(0);
            }
            return Task.FromResult(GetDurationFromFile(filePath));
        }

        public Task<int> GetVideoDurationFromUrlAsync(string videoUrl, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrEmpty(videoUrl))
                return Task.FromResult(0);

            if (videoUrl.StartsWith("/"))
            {
                var localPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", videoUrl.TrimStart('/'));
                return Task.FromResult(GetDurationFromFile(localPath));
            }

            _logger.LogWarning("External URL duration not supported: {VideoUrl}", videoUrl);
            return Task.FromResult(0);
        }

        private int GetDurationFromFile(string filePath)
        {
            try
            {
                if (!File.Exists(filePath)) return 0;

                using var fs = new FileStream(filePath, FileMode.Open, FileAccess.Read);
                using var reader = new BinaryReader(fs);

                // Try reading moov box duration first, then fall back to mvhd
                long fileSize = fs.Length;
                double? duration = ReadDurationFromMoov(reader, fileSize);

                if (duration == null)
                {
                    fs.Seek(0, SeekOrigin.Begin);
                    duration = ReadDurationFromMvhd(reader);
                }

                if (duration.HasValue && duration.Value > 0)
                {
                    int minutes = (int)Math.Ceiling(duration.Value / 60.0);
                    _logger.LogInformation("Video duration: {Minutes} min ({Seconds}s) from: {File}", minutes, duration.Value, filePath);
                    return minutes;
                }

                // Last resort: estimate from file size for common bitrates (1Mbps avg)
                double estimatedSeconds = fileSize / (1_000_000.0 / 8.0) / 1_000_000.0;
                int estMinutes = Math.Max(1, (int)Math.Ceiling(estimatedSeconds / 60.0));
                _logger.LogInformation("Estimated video duration: {Minutes} min from file size: {Size}MB", estMinutes, fileSize / 1_000_000);
                return estMinutes;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to read video duration from: {File}", filePath);
                return 0;
            }
        }

        private double? ReadDurationFromMoov(BinaryReader reader, long fileSize)
        {
            try
            {
                while (reader.BaseStream.Position + 8 <= fileSize)
                {
                    long boxStart = reader.BaseStream.Position;
                    uint boxSize = ReadUint32(reader);
                    string boxType = ReadFourCC(reader);

                    if (boxSize == 0) break;
                    if (boxSize == 1)
                    {
                        // 64-bit size
                        if (boxStart + 16 > fileSize) break;
                        boxSize = (uint)(reader.ReadUInt64());
                    }

                    if (boxType == "moov")
                    {
                        long moovEnd = boxStart + boxSize;
                        while (reader.BaseStream.Position + 8 <= moovEnd)
                        {
                            long childStart = reader.BaseStream.Position;
                            uint childSize = ReadUint32(reader);
                            string childType = ReadFourCC(reader);
                            if (childSize == 0) break;

                            if (childType == "mvhd")
                            {
                                reader.BaseStream.Seek(childStart + 4, SeekOrigin.Begin); // version(1) + flags(3)
                                byte version = reader.ReadByte();
                                // skip flags
                                reader.ReadBytes(3);

                                if (version == 0)
                                {
                                    reader.ReadBytes(4); // creationTime
                                    reader.ReadBytes(4); // modificationTime
                                    uint timescale = ReadUint32(reader);
                                    uint duration = ReadUint32(reader);
                                    if (timescale > 0) return (double)duration / timescale;
                                }
                                else
                                {
                                    reader.ReadBytes(8); // creationTime
                                    reader.ReadBytes(8); // modificationTime
                                    uint timescale = ReadUint32(reader);
                                    ulong duration = reader.ReadUInt64();
                                    if (timescale > 0) return (double)duration / timescale;
                                }
                                return null;
                            }
                            reader.BaseStream.Seek(childStart + childSize, SeekOrigin.Begin);
                        }
                        return null;
                    }
                    reader.BaseStream.Seek(boxStart + boxSize, SeekOrigin.Begin);
                }
            }
            catch { }
            return null;
        }

        private double? ReadDurationFromMvhd(BinaryReader reader)
        {
            try
            {
                // Scan for 'mvhd' box
                long fileSize = reader.BaseStream.Length;
                while (reader.BaseStream.Position + 8 <= fileSize)
                {
                    long pos = reader.BaseStream.Position;
                    uint size = ReadUint32(reader);
                    string type = ReadFourCC(reader);
                    if (size == 0) break;

                    if (type == "mvhd")
                    {
                        reader.BaseStream.Seek(pos + 4, SeekOrigin.Begin);
                        byte version = reader.ReadByte();
                        reader.ReadBytes(3); // flags

                        if (version == 0)
                        {
                            reader.ReadBytes(4); reader.ReadBytes(4);
                            uint timescale = ReadUint32(reader);
                            uint duration = ReadUint32(reader);
                            if (timescale > 0) return (double)duration / timescale;
                        }
                        else
                        {
                            reader.ReadBytes(8); reader.ReadBytes(8);
                            uint timescale = ReadUint32(reader);
                            ulong duration = reader.ReadUInt64();
                            if (timescale > 0) return (double)duration / timescale;
                        }
                        return null;
                    }
                    reader.BaseStream.Seek(pos + size, SeekOrigin.Begin);
                }
            }
            catch { }
            return null;
        }

        private static uint ReadUint32(BinaryReader reader)
        {
            var bytes = reader.ReadBytes(4);
            if (BitConverter.IsLittleEndian)
                Array.Reverse(bytes);
            return BitConverter.ToUInt32(bytes, 0);
        }

        private static string ReadFourCC(BinaryReader reader)
        {
            return Encoding.ASCII.GetString(reader.ReadBytes(4));
        }
    }
}