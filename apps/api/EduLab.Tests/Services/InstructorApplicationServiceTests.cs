using System.Linq.Expressions;
using EduLab_Application.DTOs.InstructorApplication;
using EduLab_Application.DTOs.Notification;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Domain;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab.Tests.Fakes;
using Microsoft.AspNetCore.Identity;
using Moq;
using Xunit;

namespace EduLab.Tests.Services;

public class InstructorApplicationServiceTests
{
    private readonly Mock<IInstructorApplicationRepository> _appRepo;
    private readonly List<InstructorApplication> _apps;
    private readonly ApplicationUser _user;
    private readonly Mock<UserManager<ApplicationUser>> _userManager;
    private readonly Mock<IEmailSender> _emailSender;
    private readonly Mock<INotificationService> _notifications;
    private readonly InstructorApplicationService _service;

    public InstructorApplicationServiceTests()
    {
        _apps = new List<InstructorApplication>();
        _appRepo = new Mock<IInstructorApplicationRepository>();
        _appRepo.Setup(r => r.GetAllAsync(
                It.IsAny<Expression<Func<InstructorApplication, bool>>>(),
                It.IsAny<string>(),
                It.IsAny<bool>(),
                It.IsAny<Func<IQueryable<InstructorApplication>, IOrderedQueryable<InstructorApplication>>>(),
                It.IsAny<int?>(),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync((Expression<Func<InstructorApplication, bool>> filter, string include, bool tracking,
                Func<IQueryable<InstructorApplication>, IOrderedQueryable<InstructorApplication>> orderBy, int? take,
                CancellationToken ct) =>
                filter == null ? _apps.ToList() : _apps.AsQueryable().Where(filter).ToList());
        _appRepo.Setup(r => r.CreateAsync(It.IsAny<InstructorApplication>(), It.IsAny<CancellationToken>()))
            .Callback<InstructorApplication, CancellationToken>((a, ct) => _apps.Add(a))
            .Returns(Task.CompletedTask);
        _appRepo.Setup(r => r.UpdateStatusAsync(It.IsAny<Guid>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<CancellationToken>()))
            .Callback<Guid, string, string, CancellationToken>((id, status, reviewedBy, ct) =>
            {
                var app = _apps.FirstOrDefault(a => a.Id == id);
                if (app != null) app.Status = status;
            })
            .Returns(Task.CompletedTask);

        _user = TestData.User("user-1", "Ahmed");
        _userManager = TestData.MockUserManager(new List<ApplicationUser> { _user });
        _userManager.Setup(x => x.UpdateAsync(_user)).ReturnsAsync(IdentityResult.Success);
        _userManager.Setup(x => x.AddToRoleAsync(_user, It.IsAny<string>())).ReturnsAsync(IdentityResult.Success);
        _userManager.Setup(x => x.RemoveFromRolesAsync(_user, It.IsAny<IEnumerable<string>>()))
            .ReturnsAsync(IdentityResult.Success);

        var roleManager = TestInfrastructure.MockRoleManager(new List<ApplicationRole>
        {
            new() { Id = "1", Name = "Instructor" },
            new() { Id = "2", Name = "InstructorPending" },
            new() { Id = "3", Name = "Student" }
        });
        roleManager.Setup(x => x.RoleExistsAsync(It.IsAny<string>())).ReturnsAsync(true);
        roleManager.Setup(x => x.CreateAsync(It.IsAny<ApplicationRole>())).ReturnsAsync(IdentityResult.Success);

        var emailTemplates = new Mock<IEmailTemplateService>();
        emailTemplates.Setup(x => x.GetLocalizedText(It.IsAny<string>(), It.IsAny<string>())).Returns("subject");
        emailTemplates.Setup(x => x.GenerateInstructorApprovalEmail(It.IsAny<ApplicationUser>(), It.IsAny<string>()))
            .Returns("<html>approved</html>");
        emailTemplates.Setup(x => x.GenerateInstructorRejectionEmail(It.IsAny<ApplicationUser>(), It.IsAny<string>(), It.IsAny<string>()))
            .Returns("<html>rejected</html>");

        _emailSender = new Mock<IEmailSender>();
        _notifications = new Mock<INotificationService>();
        _notifications.Setup(x => x.CreateNotificationAsync(It.IsAny<CreateNotificationDto>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(new NotificationDto());

        _service = new InstructorApplicationService(
            _userManager.Object,
            TestInfrastructure.MockWebHostEnvironment(),
            _appRepo.Object,
            roleManager.Object,
            emailTemplates.Object,
            _emailSender.Object,
            Mock.Of<ICurrentUserService>(),
            TestData.NullLogger<InstructorApplicationService>(),
            _notifications.Object);
    }

    private static InstructorApplicationDTO ValidDto() => new()
    {
        FullName = "Ahmed Ali",
        Phone = "01012345678",
        Bio = "Experienced developer",
        Specialization = "Web Development",
        Experience = "5",
        Skills = new List<string> { "C#", "ASP.NET" }
    };

    [Fact]
    public async Task SubmitApplication_CreatesPendingApplication_AndAssignsPendingRole()
    {
        var (success, _) = await _service.SubmitApplication(ValidDto(), "user-1");

        Assert.True(success);
        var app = Assert.Single(_apps);
        Assert.Equal("user-1", app.UserId);
        Assert.Equal("Pending", app.Status);
        Assert.Equal("C#,ASP.NET", app.Skills);
        _userManager.Verify(x => x.AddToRoleAsync(_user, "InstructorPending"), Times.Once);
        _notifications.Verify(
            x => x.CreateNotificationAsync(It.IsAny<CreateNotificationDto>(), It.IsAny<CancellationToken>()),
            Times.Once);
    }

    [Fact]
    public async Task SubmitApplication_UnknownUser_ReturnsFailure()
    {
        var (success, _) = await _service.SubmitApplication(ValidDto(), "missing");

        Assert.False(success);
        Assert.Empty(_apps);
    }

    [Fact]
    public async Task SubmitApplication_ExistingPendingApplication_ReturnsFailure()
    {
        _apps.Add(TestData.InstructorApplication(Guid.NewGuid(), "user-1", "Pending"));

        var (success, _) = await _service.SubmitApplication(ValidDto(), "user-1");

        Assert.False(success);
        Assert.Single(_apps);
    }

    [Fact]
    public async Task GetUserApplications_ReturnsOnlyUserApplications()
    {
        var own = TestData.InstructorApplication(Guid.NewGuid(), "user-1", "Pending");
        own.User = _user;
        _apps.Add(own);
        _apps.Add(TestData.InstructorApplication(Guid.NewGuid(), "user-2", "Pending"));

        var result = await _service.GetUserApplications("user-1");

        var dto = Assert.Single(result);
        Assert.Equal(own.Id.ToString(), dto.Id);
        Assert.Equal("Ahmed", dto.FullName);
        Assert.Equal("Ahmed@test.com", dto.Email);
    }

    [Fact]
    public async Task ApproveApplication_AddsInstructorRole_AndUpdatesStatus()
    {
        var app = TestData.InstructorApplication(Guid.NewGuid(), "user-1", "Pending");
        _apps.Add(app);
        _appRepo.Setup(r => r.GetAsync(
                It.IsAny<Expression<Func<InstructorApplication, bool>>>(),
                It.IsAny<string>(),
                It.IsAny<bool>(),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync(app);

        var (success, _) = await _service.ApproveApplication(app.Id.ToString(), "admin-1");

        Assert.True(success);
        Assert.Equal("Approved", app.Status);
        _userManager.Verify(x => x.AddToRoleAsync(_user, "Instructor"), Times.Once);
        _emailSender.Verify(x => x.SendEmailAsync("Ahmed@test.com", It.IsAny<string>(), It.IsAny<string>()),
            Times.Once);
    }

    [Fact]
    public async Task ApproveApplication_InvalidId_ReturnsFailure()
    {
        var (success, _) = await _service.ApproveApplication("not-a-guid", "admin-1");

        Assert.False(success);
        _userManager.Verify(x => x.AddToRoleAsync(_user, It.IsAny<string>()), Times.Never);
    }

    [Fact]
    public async Task RejectApplication_RestoresStudentRole_AndUpdatesStatus()
    {
        var app = TestData.InstructorApplication(Guid.NewGuid(), "user-1", "Pending");
        _apps.Add(app);
        _appRepo.Setup(r => r.GetAsync(
                It.IsAny<Expression<Func<InstructorApplication, bool>>>(),
                It.IsAny<string>(),
                It.IsAny<bool>(),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync(app);

        var (success, _) = await _service.RejectApplication(app.Id.ToString(), "admin-1", "Not enough experience");

        Assert.True(success);
        Assert.Equal("Rejected", app.Status);
        Assert.Equal("Not enough experience", app.RejectionReason);
        _userManager.Verify(x => x.AddToRoleAsync(_user, "Student"), Times.Once);
    }
}
