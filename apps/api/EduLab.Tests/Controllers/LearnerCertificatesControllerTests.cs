using EduLab_API.Controllers.Learner;
using EduLab_Application.DTOs.Certificates;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class LearnerCertificatesControllerTests
{
    private readonly Mock<ICertificateService> _service;
    private readonly Mock<ICurrentUserService> _currentUser;
    private readonly CertificatesController _controller;

    public LearnerCertificatesControllerTests()
    {
        _service = new Mock<ICertificateService>();
        _currentUser = new Mock<ICurrentUserService>();
        _controller = new CertificatesController(
            _service.Object,
            _currentUser.Object,
            Mock.Of<ILogger<CertificatesController>>());
    }

    private void SetUser(string? userId)
    {
        _currentUser.Setup(x => x.GetUserIdAsync()).ReturnsAsync(userId);
        _controller.ControllerContext = new ControllerContext { HttpContext = new DefaultHttpContext() };
    }

    [Fact]
    public async Task GetMyCertificates_WithoutUser_ReturnsUnauthorized()
    {
        SetUser(null);

        var result = await _controller.GetMyCertificates();

        Assert.IsType<UnauthorizedObjectResult>(result);
        _service.Verify(x => x.GetMyCertificatesAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetMyCertificates_Success_ReturnsCertificates()
    {
        SetUser("user-1");
        var certificates = new List<CertificateDto>
        {
            new() { Id = 1, CertificateCode = "EDU-ABC", CourseTitle = "C# Basics" }
        };
        _service.Setup(x => x.GetMyCertificatesAsync("user-1", It.IsAny<CancellationToken>())).ReturnsAsync(certificates);

        var result = await _controller.GetMyCertificates();

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(certificates, ok.Value);
    }

    [Fact]
    public async Task GetMyCertificates_OnServiceError_Returns500()
    {
        SetUser("user-1");
        _service.Setup(x => x.GetMyCertificatesAsync("user-1", It.IsAny<CancellationToken>()))
            .ThrowsAsync(new InvalidOperationException("boom"));

        var result = await _controller.GetMyCertificates();

        var status = Assert.IsType<ObjectResult>(result);
        Assert.Equal(500, status.StatusCode);
    }

    [Fact]
    public async Task Verify_WhenCertificateMissing_ReturnsNotFound()
    {
        _service.Setup(x => x.GetByCodeAsync("INVALID", It.IsAny<CancellationToken>()))
            .ReturnsAsync((CertificateDto)null!);

        var result = await _controller.Verify("INVALID");

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task Verify_WithValidCode_ReturnsCertificateDetails()
    {
        var certificate = new CertificateDto
        {
            Id = 1,
            CertificateCode = "EDU-ABC",
            StudentName = "Ahmed",
            CourseTitle = "C# Basics",
            IssuedDate = new DateTime(2026, 1, 15)
        };
        _service.Setup(x => x.GetByCodeAsync("EDU-ABC", It.IsAny<CancellationToken>())).ReturnsAsync(certificate);

        var result = await _controller.Verify("EDU-ABC");

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.NotNull(ok.Value);
    }

    [Fact]
    public async Task Verify_OnServiceError_Returns500()
    {
        _service.Setup(x => x.GetByCodeAsync("EDU-ABC", It.IsAny<CancellationToken>()))
            .ThrowsAsync(new InvalidOperationException("boom"));

        var result = await _controller.Verify("EDU-ABC");

        var status = Assert.IsType<ObjectResult>(result);
        Assert.Equal(500, status.StatusCode);
    }
}
