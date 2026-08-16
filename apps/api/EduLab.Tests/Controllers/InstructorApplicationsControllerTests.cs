using EduLab_API.Controllers.Admin;
using EduLab_API.Models;
using EduLab_Application.DTOs.InstructorApplication;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;
using Fakes = EduLab.Tests.Fakes;

namespace EduLab.Tests.Controllers;

public class InstructorApplicationsControllerTests
{
    private readonly Mock<IInstructorApplicationService> _service;
    private readonly Mock<ICurrentUserService> _currentUserService;
    private readonly Mock<IHistoryService> _historyService;
    private readonly InstructorApplicationsController _controller;

    public InstructorApplicationsControllerTests()
    {
        _service = new Mock<IInstructorApplicationService>();
        _currentUserService = new Mock<ICurrentUserService>();
        _historyService = new Mock<IHistoryService>();
        _controller = new InstructorApplicationsController(
            _service.Object,
            Fakes.TestInfrastructure.MockHttpContextAccessor(),
            Fakes.TestData.MockUserManager().Object,
            _currentUserService.Object,
            _historyService.Object,
            Mock.Of<ILogger<InstructorApplicationsController>>());
    }

    private void SetUser(string userId, params (string Type, string Value)[] claims)
    {
        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext
            {
                User = new System.Security.Claims.ClaimsPrincipal(new System.Security.Claims.ClaimsIdentity(
                    new[] { new System.Security.Claims.Claim(System.Security.Claims.ClaimTypes.NameIdentifier, userId) }
                        .Concat(claims.Select(c => new System.Security.Claims.Claim(c.Type, c.Value)))))
            }
        };
    }

    [Fact]
    public async Task GetAllApplications_ReturnsOkWithApplications()
    {
        var apps = new List<AdminInstructorApplicationDto>
        {
            new() { Id = "app-1", FullName = "Ahmed", UserId = "u1" }
        };
        _service.Setup(x => x.GetAllApplicationsForAdmin(It.IsAny<CancellationToken>()))
            .ReturnsAsync(apps);

        var result = await _controller.GetAllApplications();

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(apps, ok.Value);
    }

    [Fact]
    public async Task ApproveApplication_WhenServiceFails_ReturnsBadRequest()
    {
        SetUser("admin-1");
        _service.Setup(x => x.ApproveApplication("app-1", "admin-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync((false, "Failed to approve"));

        var result = await _controller.ApproveApplication("app-1");

        var badRequest = Assert.IsType<BadRequestObjectResult>(result);
        Assert.Equal("Failed to approve", badRequest.Value);
    }

    [Fact]
    public async Task ApproveApplication_Success_ReturnsOkWithMessage()
    {
        SetUser("admin-1");
        _service.Setup(x => x.ApproveApplication("app-1", "admin-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync((true, "Application approved"));
        _service.Setup(x => x.GetAllApplicationsForAdmin(It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<AdminInstructorApplicationDto>
            {
                new() { Id = "app-1", FullName = "Ahmed", UserId = "u1" }
            });

        var result = await _controller.ApproveApplication("app-1");

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal("Application approved", ok.Value);
    }

    [Fact]
    public async Task RejectApplication_WhenServiceFails_ReturnsBadRequest()
    {
        SetUser("admin-1");
        _service.Setup(x => x.RejectApplication("app-1", "admin-1", "not qualified", It.IsAny<CancellationToken>()))
            .ReturnsAsync((false, "Failed to reject"));

        var result = await _controller.RejectApplication("app-1", new RejectApplicationRequest { RejectionReason = "not qualified" });

        var badRequest = Assert.IsType<BadRequestObjectResult>(result);
        Assert.Equal("Failed to reject", badRequest.Value);
    }

    [Fact]
    public async Task RejectApplication_Success_ReturnsOkWithMessage()
    {
        SetUser("admin-1");
        _service.Setup(x => x.RejectApplication("app-1", "admin-1", null, It.IsAny<CancellationToken>()))
            .ReturnsAsync((true, "Application rejected"));
        _service.Setup(x => x.GetAllApplicationsForAdmin(It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<AdminInstructorApplicationDto>
            {
                new() { Id = "app-1", FullName = "Ahmed", UserId = "u1" }
            });

        var result = await _controller.RejectApplication("app-1");

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal("Application rejected", ok.Value);
    }
}
