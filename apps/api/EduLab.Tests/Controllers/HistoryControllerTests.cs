using EduLab_API.Controllers.Admin;
using EduLab_Application.DTOs.History;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class HistoryControllerTests
{
    private readonly Mock<IHistoryService> _historyService;
    private readonly Mock<ICurrentUserService> _currentUserService;
    private readonly HistoryController _controller;

    public HistoryControllerTests()
    {
        _historyService = new Mock<IHistoryService>();
        _currentUserService = new Mock<ICurrentUserService>();
        _controller = new HistoryController(
            _historyService.Object,
            _currentUserService.Object,
            Mock.Of<ILogger<HistoryController>>());
    }

    private static HistoryDTO Log(int id) => new() { Id = id, Operation = "عرض", Date = DateOnly.FromDateTime(DateTime.Now) };

    [Fact]
    public async Task GetAllHistory_ReturnsOkWithLogs()
    {
        var logs = new List<HistoryDTO> { Log(1), Log(2) };
        _historyService.Setup(x => x.GetAllHistoryAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(logs);

        var result = await _controller.GetAllHistory();

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(logs, ok.Value);
    }

    [Fact]
    public async Task GetMyHistory_WhenUserNotAuthenticated_ReturnsUnauthorized()
    {
        _currentUserService.Setup(x => x.GetUserIdAsync()).ReturnsAsync((string?)null);

        var result = await _controller.GetMyHistory();

        Assert.IsType<UnauthorizedObjectResult>(result.Result);
        _historyService.Verify(x => x.GetMyHistoryAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetMyHistory_WhenNoLogs_ReturnsNotFound()
    {
        _currentUserService.Setup(x => x.GetUserIdAsync()).ReturnsAsync("admin-1");
        _historyService.Setup(x => x.GetMyHistoryAsync("admin-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<HistoryDTO>());

        var result = await _controller.GetMyHistory();

        Assert.IsType<NotFoundObjectResult>(result.Result);
    }

    [Fact]
    public async Task GetMyHistory_ReturnsOkWithLogs()
    {
        _currentUserService.Setup(x => x.GetUserIdAsync()).ReturnsAsync("admin-1");
        var logs = new List<HistoryDTO> { Log(1) };
        _historyService.Setup(x => x.GetMyHistoryAsync("admin-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(logs);

        var result = await _controller.GetMyHistory();

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(logs, ok.Value);
    }

    [Fact]
    public async Task GetHistoryByUser_WithEmptyUserId_ReturnsBadRequest()
    {
        var result = await _controller.GetHistoryByUser("  ");

        Assert.IsType<BadRequestObjectResult>(result.Result);
        _historyService.Verify(x => x.GetHistoryByUserAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetHistoryByUser_ReturnsOkWithLogs()
    {
        var logs = new List<HistoryDTO> { Log(1) };
        _historyService.Setup(x => x.GetHistoryByUserAsync("u1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(logs);

        var result = await _controller.GetHistoryByUser("u1");

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(logs, ok.Value);
    }
}
