using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab.Tests.Fakes;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Services;

public class FileStorageServiceTests
{
    private readonly FileStorageService _service;

    public FileStorageServiceTests()
    {
        _service = new FileStorageService();
    }

    [Fact]
    public async Task UploadFileAsync_NullFile_ReturnsNull()
    {
        var result = await _service.UploadFileAsync(null!, "users");

        Assert.Null(result);
    }

    [Fact]
    public async Task UploadFileAsync_EmptyFile_ReturnsNull()
    {
        var file = new Mock<IFormFile>();
        file.Setup(x => x.Length).Returns(0);

        var result = await _service.UploadFileAsync(file.Object, "users");

        Assert.Null(result);
    }

    [Fact]
    public async Task UploadFileAsync_SavesFileAndReturnsUrl()
    {
        var originalDir = Directory.GetCurrentDirectory();
        var tempRoot = Path.Combine(Path.GetTempPath(), $"edulab-test-{Guid.NewGuid():N}");
        Directory.CreateDirectory(tempRoot);
        try
        {
            Directory.SetCurrentDirectory(tempRoot);

            var content = new byte[] { 1, 2, 3, 4, 5 };
            var file = new Mock<IFormFile>();
            file.Setup(x => x.Length).Returns(content.Length);
            file.Setup(x => x.FileName).Returns("avatar.png");
            file.Setup(x => x.CopyToAsync(It.IsAny<Stream>(), It.IsAny<CancellationToken>()))
                .Callback<Stream, CancellationToken>((stream, _) => stream.Write(content, 0, content.Length))
                .Returns(Task.CompletedTask);

            var result = await _service.UploadFileAsync(file.Object, "users");

            Assert.NotNull(result);
            Assert.StartsWith("/users/", result);
            Assert.EndsWith(".png", result);

            var savedPath = Path.Combine(tempRoot, "wwwroot", "users", Path.GetFileName(result));
            Assert.True(File.Exists(savedPath));
            Assert.Equal(content, File.ReadAllBytes(savedPath));
        }
        finally
        {
            Directory.SetCurrentDirectory(originalDir);
            if (Directory.Exists(tempRoot))
                Directory.Delete(tempRoot, true);
        }
    }

    [Fact]
    public async Task UploadBase64FileAsync_WithoutDataPrefix_Throws()
    {
        // الكود الحقيقي بيفترض صيغة "data:...;base64,xxx" — من غير الفاصلة بيحصل IndexOutOfRange
        await Assert.ThrowsAsync<IndexOutOfRangeException>(
            () => _service.UploadBase64FileAsync("not-base64!!", "users", "test.png"));
    }

    [Fact]
    public async Task UploadBase64FileAsync_ValidBase64_SavesFile()
    {
        var originalDir = Directory.GetCurrentDirectory();
        var tempRoot = Path.Combine(Path.GetTempPath(), $"edulab-test-{Guid.NewGuid():N}");
        Directory.CreateDirectory(tempRoot);
        try
        {
            Directory.SetCurrentDirectory(tempRoot);

            var result = await _service.UploadBase64FileAsync(
                $"data:application/pdf;base64,{Convert.ToBase64String(new byte[] { 9, 8, 7 })}", "cvs", ".pdf");

            Assert.NotNull(result);
            Assert.StartsWith("/cvs/", result);
            Assert.True(File.Exists(Path.Combine(tempRoot, "wwwroot", "cvs", Path.GetFileName(result))));
        }
        finally
        {
            Directory.SetCurrentDirectory(originalDir);
            if (Directory.Exists(tempRoot))
                Directory.Delete(tempRoot, true);
        }
    }

    [Fact]
    public void DeleteFile_NonExistingUrl_ReturnsFalse()
    {
        var result = _service.DeleteFile("/users/does-not-exist.png");

        Assert.False(result);
    }

    [Fact]
    public void DeleteFile_ExistingFile_ReturnsTrue()
    {
        var originalDir = Directory.GetCurrentDirectory();
        var tempRoot = Path.Combine(Path.GetTempPath(), $"edulab-test-{Guid.NewGuid():N}");
        var folder = Path.Combine(tempRoot, "wwwroot", "users");
        Directory.CreateDirectory(folder);
        var filePath = Path.Combine(folder, "file.txt");
        File.WriteAllText(filePath, "x");
        try
        {
            Directory.SetCurrentDirectory(tempRoot);

            var result = _service.DeleteFile("/users/file.txt");

            Assert.True(result);
            Assert.False(File.Exists(filePath));
        }
        finally
        {
            Directory.SetCurrentDirectory(originalDir);
            if (Directory.Exists(tempRoot))
                Directory.Delete(tempRoot, true);
        }
    }
}
