using EduLab_Application.Services;
using EduLab.Tests.Fakes;
using Microsoft.AspNetCore.Http;
using Moq;
using Xunit;

namespace EduLab.Tests.Services;

public class VideoDurationServiceTests
{
    private readonly VideoDurationService _service;

    public VideoDurationServiceTests()
    {
        _service = new VideoDurationService(TestData.NullLogger<VideoDurationService>());
    }

    // ========== MP4 fixture builders (big-endian, standard ISO boxes) ==========

    private static void WriteUInt32BE(BinaryWriter writer, uint value)
    {
        writer.Write(new[] { (byte)(value >> 24), (byte)(value >> 16), (byte)(value >> 8), (byte)value });
    }

    private static void WriteBox(BinaryWriter writer, string fourcc, byte[] payload)
    {
        WriteUInt32BE(writer, (uint)(8 + payload.Length));
        writer.Write(System.Text.Encoding.ASCII.GetBytes(fourcc));
        writer.Write(payload);
    }

    /// <summary>
    /// Builds a minimal valid MP4 with an mvhd box carrying a known duration.
    /// </summary>
    private static byte[] BuildMp4(int durationSeconds, int timescale = 1000)
    {
        using var ms = new MemoryStream();
        using var writer = new BinaryWriter(ms);

        // ftyp box (file type)
        WriteBox(writer, "ftyp", new byte[] { 0x69, 0x73, 0x6F, 0x6D, 0, 0, 0x02, 0 }); // isom

        // mvhd box payload: version(1) + flags(3) + creation(4) + modification(4) + timescale(4) + duration(4) + rest
        using var mvhdMs = new MemoryStream();
        using (var mvhd = new BinaryWriter(mvhdMs))
        {
            mvhd.Write((byte)0);              // version 0
            mvhd.Write(new byte[3]);          // flags
            WriteUInt32BE(mvhd, 0);           // creation time
            WriteUInt32BE(mvhd, 0);           // modification time
            WriteUInt32BE(mvhd, (uint)timescale);
            WriteUInt32BE(mvhd, (uint)(durationSeconds * timescale));
            mvhd.Write(new byte[80]);         // rate/volume/matrix/etc — ignored by the parser
        }

        // moov box containing mvhd
        using var moovMs = new MemoryStream();
        using (var moov = new BinaryWriter(moovMs))
        {
            WriteBox(moov, "mvhd", mvhdMs.ToArray());
        }
        WriteBox(writer, "moov", moovMs.ToArray());

        return ms.ToArray();
    }

    // ========== Tests ==========

    [Fact]
    public async Task GetVideoDurationAsync_NullFile_ReturnsZero()
    {
        var result = await _service.GetVideoDurationAsync(null!);

        Assert.Equal(0, result);
    }

    [Fact]
    public async Task GetVideoDurationAsync_EmptyFile_ReturnsZero()
    {
        var file = new Mock<IFormFile>();
        file.Setup(x => x.Length).Returns(0);

        var result = await _service.GetVideoDurationAsync(file.Object);

        Assert.Equal(0, result);
    }

    [Fact]
    public async Task GetVideoDurationAsync_NonVideoBytes_DoesNotThrow()
    {
        var content = System.Text.Encoding.UTF8.GetBytes("this is not a video at all");
        var file = new Mock<IFormFile>();
        file.Setup(x => x.Length).Returns(content.Length);
        file.Setup(x => x.CopyToAsync(It.IsAny<Stream>(), It.IsAny<CancellationToken>()))
            .Callback<Stream, CancellationToken>((stream, _) => stream.Write(content, 0, content.Length))
            .Returns(Task.CompletedTask);

        var result = await _service.GetVideoDurationAsync(file.Object);

        Assert.True(result >= 0);
    }

    [Fact]
    public async Task GetVideoDurationFromPathAsync_NonExistentFile_ReturnsZero()
    {
        var result = await _service.GetVideoDurationFromPathAsync("C:\\no\\such\\video.mp4");

        Assert.Equal(0, result);
    }

    [Fact]
    public async Task GetVideoDurationFromUrlAsync_NullUrl_ReturnsZero()
    {
        var result = await _service.GetVideoDurationFromUrlAsync(null!);

        Assert.Equal(0, result);
    }

    [Fact]
    public async Task GetVideoDurationFromPathAsync_ValidMp4_ReadsDurationFromMvhd()
    {
        var bytes = BuildMp4(300);
        var tempPath = Path.Combine(Path.GetTempPath(), $"edulab-mp4-{Guid.NewGuid():N}.mp4");
        await File.WriteAllBytesAsync(tempPath, bytes);
        try
        {
            var result = await _service.GetVideoDurationFromPathAsync(tempPath);

            Assert.Equal(300, result);
        }
        finally
        {
            if (File.Exists(tempPath)) File.Delete(tempPath);
        }
    }

    [Fact]
    public async Task GetVideoDurationAsync_ValidMp4_ReadsDuration()
    {
        var file = new Mock<IFormFile>();
        file.Setup(x => x.Length).Returns(bytes.Length);
        file.Setup(x => x.CopyToAsync(It.IsAny<Stream>(), It.IsAny<CancellationToken>()))
            .Callback<Stream, CancellationToken>((stream, _) => stream.Write(bytes, 0, bytes.Length))
            .Returns(Task.CompletedTask);

        var result = await _service.GetVideoDurationAsync(file.Object);

        Assert.Equal(120, result);
    }

    [Fact]
    public async Task GetVideoDurationAsync_ShortVideo_ReturnsExactSeconds()
    {
        var bytes = BuildMp4(45);
        var file = new Mock<IFormFile>();
        file.Setup(x => x.Length).Returns(bytes.Length);
        file.Setup(x => x.CopyToAsync(It.IsAny<Stream>(), It.IsAny<CancellationToken>()))
            .Callback<Stream, CancellationToken>((stream, _) => stream.Write(bytes, 0, bytes.Length))
            .Returns(Task.CompletedTask);

        var result = await _service.GetVideoDurationAsync(file.Object);

        Assert.Equal(45, result);
    }

    [Fact]
    public async Task GetVideoDurationAsync_24SecondVideo_Returns24()
    {
        var bytes = BuildMp4(24);
        var file = new Mock<IFormFile>();
        file.Setup(x => x.Length).Returns(bytes.Length);
        file.Setup(x => x.CopyToAsync(It.IsAny<Stream>(), It.IsAny<CancellationToken>()))
            .Callback<Stream, CancellationToken>((stream, _) => stream.Write(bytes, 0, bytes.Length))
            .Returns(Task.CompletedTask);

        var result = await _service.GetVideoDurationAsync(file.Object);

        Assert.Equal(24, result);
    }

    [Fact]
    public async Task GetVideoDurationAsync_FiveMinutesOneSecond_Returns301()
    {
        var bytes = BuildMp4(301);
        var file = new Mock<IFormFile>();
        file.Setup(x => x.Length).Returns(bytes.Length);
        file.Setup(x => x.CopyToAsync(It.IsAny<Stream>(), It.IsAny<CancellationToken>()))
            .Callback<Stream, CancellationToken>((stream, _) => stream.Write(bytes, 0, bytes.Length))
            .Returns(Task.CompletedTask);

        var result = await _service.GetVideoDurationAsync(file.Object);

        Assert.Equal(301, result);
    }
}
