using EduLab_API.Controllers.Admin;
using EduLab_Application.DTOs.Report;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class AdminReportsControllerTests
{
    private readonly Mock<IReportService> _service;
    private readonly ReportsController _controller;

    public AdminReportsControllerTests()
    {
        _service = new Mock<IReportService>();
        _controller = new ReportsController(_service.Object, Mock.Of<ILogger<ReportsController>>());
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
    public async Task GetAll_WithoutViewReportsClaim_ReturnsForbid()
    {
        SetUser("admin-1");

        var result = await _controller.GetAll(null, null, null, 1, 10);

        Assert.IsType<ForbidResult>(result.Result);
        _service.Verify(x => x.GetAdminReportsAsync(
            It.IsAny<string?>(), It.IsAny<string?>(), It.IsAny<string?>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetAll_WithClaim_PassesFiltersAndPaging()
    {
        SetUser("admin-1", ("ViewReports", "true"));
        var reports = new ReportListResultDto { Items = new(), TotalCount = 0, PageNumber = 2, PageSize = 10 };
        _service.Setup(x => x.GetAdminReportsAsync("pending", "Course", "spam", 2, 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(reports);

        var result = await _controller.GetAll("pending", "Course", "spam", 2, 10);

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(reports, ok.Value);
    }

    [Fact]
    public async Task UpdateStatus_WithoutHandleReportsClaim_ReturnsForbid()
    {
        SetUser("admin-1", ("ViewReports", "true"));

        var result = await _controller.UpdateStatus(1, new UpdateReportStatusDto());

        Assert.IsType<ForbidResult>(result);
        _service.Verify(x => x.UpdateStatusAsync(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<UpdateReportStatusDto>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task UpdateStatus_WithoutUserId_ReturnsUnauthorized()
    {
        SetUser("", ("HandleReports", "true"));

        var result = await _controller.UpdateStatus(1, new UpdateReportStatusDto());

        Assert.IsType<UnauthorizedObjectResult>(result);
    }

    [Fact]
    public async Task UpdateStatus_WithClaim_ReturnsOk()
    {
        SetUser("admin-1", ("HandleReports", "true"));
        _service.Setup(x => x.UpdateStatusAsync("admin-1", 1, It.IsAny<UpdateReportStatusDto>(), It.IsAny<CancellationToken>()))
            .Returns(Task.CompletedTask);

        var result = await _controller.UpdateStatus(1, new UpdateReportStatusDto());

        Assert.IsType<OkObjectResult>(result);
    }

    [Fact]
    public async Task DeleteContent_WithoutHandleReportsClaim_ReturnsForbid()
    {
        SetUser("admin-1");

        var result = await _controller.DeleteContent(1);

        Assert.IsType<ForbidResult>(result.Result);
    }

    [Fact]
    public async Task DeleteContent_WithClaim_ReturnsReport()
    {
        SetUser("admin-1", ("HandleReports", "true"));
        var report = new AdminReportDto { Id = 1 };
        _service.Setup(x => x.DeleteReportedContentAsync("admin-1", 1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(report);

        var result = await _controller.DeleteContent(1);

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(report, ok.Value);
    }

    [Fact]
    public async Task GetPendingCount_WithoutViewReportsClaim_ReturnsForbid()
    {
        SetUser("admin-1");

        var result = await _controller.GetPendingCount();

        Assert.IsType<ForbidResult>(result.Result);
    }
}
