using EduLab_Application.DTOs.Notification;
using EduLab_Application.Resources;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab.Tests.Fakes;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Localization;
using Moq;
using Xunit;

namespace EduLab.Tests.Services;

public class CertificateServiceTests
{
    private readonly string _root;
    private readonly Mock<ICourseCertificateRepository> _certificates;
    private readonly Mock<IEnrollmentRepository> _enrollments;
    private readonly CertificateService _service;

    public CertificateServiceTests()
    {
        _root = Path.Combine(Path.GetTempPath(), "edulab-tests", Guid.NewGuid().ToString("N"));
        var templatesDir = Path.Combine(_root, "wwwroot", "templates");
        Directory.CreateDirectory(templatesDir);
        File.WriteAllText(Path.Combine(templatesDir, "certificate-template.svg"),
            "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"1414\" height=\"1000\"><rect width=\"1414\" height=\"1000\" fill=\"#0a1628\"/></svg>");

        _certificates = new Mock<ICourseCertificateRepository>();
        _enrollments = new Mock<IEnrollmentRepository>();

        var links = new Mock<ILinkBuilderService>();
        links.Setup(x => x.GenerateCertificateVerifyLink(It.IsAny<string>()))
            .Returns((string code) => $"https://edulab.runasp.net/Learner/Certificates/Verify/{code}");

        var env = new Mock<IWebHostEnvironment>();
        env.Setup(x => x.ContentRootPath).Returns(_root);
        env.Setup(x => x.WebRootPath).Returns(Path.Combine(_root, "wwwroot"));

        var notifications = new Mock<INotificationService>();
        notifications.Setup(x => x.CreateNotificationAsync(It.IsAny<CreateNotificationDto>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(new NotificationDto());
        var emailTemplates = new Mock<IEmailTemplateService>();
        emailTemplates.Setup(x => x.GenerateCertificateEmail(
                It.IsAny<ApplicationUser>(), It.IsAny<string>(), It.IsAny<string>(),
                It.IsAny<string>(), It.IsAny<string>()))
            .Returns("<html></html>");
        emailTemplates.Setup(x => x.GetLocalizedText(It.IsAny<string>(), It.IsAny<string>()))
            .Returns("subject");

        _service = new CertificateService(
            _certificates.Object,
            _enrollments.Object,
            TestData.MockUserManager().Object,
            env.Object,
            Mock.Of<IEmailSender>(),
            emailTemplates.Object,
            notifications.Object,
            links.Object,
            Mock.Of<IStringLocalizer<SharedResources>>(),
            TestData.NullLogger<CertificateService>());
    }

    [Fact]
    public async Task GenerateCertificateAsync_EnrollmentNotFound_ReturnsNull()
    {
        _certificates.Setup(r => r.GetByEnrollmentIdAsync(99, It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseCertificate)null);
        _enrollments.Setup(r => r.GetEnrollmentByIdAsync(99, It.IsAny<CancellationToken>()))
            .ReturnsAsync((Enrollment)null);

        var result = await _service.GenerateCertificateAsync(99);

        Assert.Null(result);
        _certificates.Verify(r => r.CreateAsync(It.IsAny<CourseCertificate>(), It.IsAny<CancellationToken>()),
            Times.Never);
    }

    [Fact]
    public async Task GenerateCertificateAsync_ExistingCertificate_ReturnsItWithoutRegeneration()
    {
        var existing = new CourseCertificate
        {
            Id = 7,
            EnrollmentId = 1,
            CertificateCode = "EL-EXISTING",
            PdfPath = "/uploads/certificates/x.png",
            IssuedDate = DateTime.UtcNow
        };
        _certificates.Setup(r => r.GetByEnrollmentIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(existing);

        var result = await _service.GenerateCertificateAsync(1);

        Assert.NotNull(result);
        Assert.Equal("EL-EXISTING", result.CertificateCode);
        _enrollments.Verify(r => r.GetEnrollmentByIdAsync(It.IsAny<int>(), It.IsAny<CancellationToken>()),
            Times.Never);
    }

    [Fact]
    public async Task GenerateCertificateAsync_EnrolledStudent_CreatesCertificate()
    {
        _certificates.Setup(r => r.GetByEnrollmentIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseCertificate)null);
        var enrollment = TestData.Enrollment(1, 5, "user-1");
        enrollment.Course = TestData.Course(5, "C# Basics");
        enrollment.User = TestData.User("user-1", "Ahmed");
        _enrollments.Setup(r => r.GetEnrollmentByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(enrollment);
        _certificates.Setup(r => r.CreateAsync(It.IsAny<CourseCertificate>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((CourseCertificate c, CancellationToken ct) =>
            {
                c.Id = 42;
                c.Enrollment = enrollment;
                return c;
            });

        var result = await _service.GenerateCertificateAsync(1);

        Assert.NotNull(result);
        Assert.Equal(42, result.Id);
        Assert.StartsWith("EL-", result.CertificateCode);
        Assert.Contains(result.CertificateCode, result.VerifyUrl);
        Assert.EndsWith(".png", result.PdfPath);
        Assert.Equal("Ahmed", result.StudentName);
        Assert.Equal("C# Basics", result.CourseTitle);
        Assert.True(File.Exists(_service.GetCertificateFilePath(result.CertificateCode)));
    }

    [Fact]
    public async Task GetMyCertificatesAsync_MapsUserCertificates()
    {
        var enrollment = TestData.Enrollment(1, 5, "user-1");
        enrollment.Course = TestData.Course(5, "C# Basics");
        enrollment.User = TestData.User("user-1", "Ahmed");
        var cert = new CourseCertificate
        {
            Id = 1,
            EnrollmentId = 1,
            CertificateCode = "EL-ABC",
            PdfPath = "/uploads/certificates/x.png",
            IssuedDate = DateTime.UtcNow,
            Enrollment = enrollment
        };
        _certificates.Setup(r => r.GetByUserIdAsync("user-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<CourseCertificate> { cert });

        var result = await _service.GetMyCertificatesAsync("user-1");

        var dto = Assert.Single(result);
        Assert.Equal("EL-ABC", dto.CertificateCode);
        Assert.Equal("Ahmed", dto.StudentName);
        Assert.Equal("C# Basics", dto.CourseTitle);
        Assert.Contains("EL-ABC", dto.VerifyUrl);
    }

    [Fact]
    public void GetCertificateFilePath_CombinesWebRootAndCode()
    {
        var path = _service.GetCertificateFilePath("EL-ABC");

        Assert.EndsWith("Certificate_EL-ABC.png", path);
        Assert.Contains(Path.Combine("wwwroot", "uploads", "certificates"), path);
    }
}
