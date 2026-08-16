using EduLab_API.Controllers.Admin;
using EduLab_Application.Common;
using EduLab_Application.DTOs.Auth;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class UserControllerTests
{
    private readonly Mock<IUserService> _userService;
    private readonly Mock<ICurrentUserService> _currentUserService;
    private readonly Mock<IHistoryService> _historyService;
    private readonly UserController _controller;

    public UserControllerTests()
    {
        _userService = new Mock<IUserService>();
        _currentUserService = new Mock<ICurrentUserService>();
        _historyService = new Mock<IHistoryService>();
        _controller = new UserController(
            _userService.Object,
            _currentUserService.Object,
            _historyService.Object,
            Mock.Of<ILogger<UserController>>());
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
    public async Task GetAllUsers_ReturnsOkWithUsers()
    {
        SetUser("admin-1");
        _currentUserService.Setup(x => x.GetUserIdAsync()).ReturnsAsync("admin-1");
        var users = new List<UserDTO> { new() { Id = "u1", FullName = "Ahmed", Role = "Student" } };
        _userService.Setup(x => x.GetAllUsersWithRolesAsync()).ReturnsAsync(users);

        var result = await _controller.GetAllUsers();

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(users, ok.Value);
        _historyService.Verify(x => x.LogOperationAsync(
            "admin-1", It.IsAny<string>(), It.IsAny<OperationType?>(), It.IsAny<string?>(), It.IsAny<string?>(), It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task GetById_WhenUserNotFound_ReturnsNotFound()
    {
        _userService.Setup(x => x.GetUserByIdAsync("missing")).ReturnsAsync((UserInfoDTO?)null);

        var result = await _controller.GetById("missing");

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task GetById_ReturnsOkWithUser()
    {
        var user = new UserInfoDTO { Id = "u1", FullName = "Ahmed", Email = "ahmed@test.com", Role = "Student" };
        _userService.Setup(x => x.GetUserByIdAsync("u1")).ReturnsAsync(user);

        var result = await _controller.GetById("u1");

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(user, ok.Value);
    }

    [Fact]
    public async Task UpdateUser_WhenUserNotFound_ReturnsBadRequest()
    {
        var dto = new UpdateUserDTO { Id = "missing", FullName = "Ahmed", Role = "Student" };
        _userService.Setup(x => x.UpdateUserAsync(dto))
            .ReturnsAsync(ApiResponse<object>.FailResponse("User not found"));

        var result = await _controller.UpdateUser(dto);

        var badRequest = Assert.IsType<BadRequestObjectResult>(result);
        Assert.False(((ApiResponse<object>)badRequest.Value!).Success);
    }

    [Fact]
    public async Task UpdateUser_WhenDataIncomplete_ReturnsBadRequest()
    {
        var result = await _controller.UpdateUser(new UpdateUserDTO { Id = "u1" });

        Assert.IsType<BadRequestObjectResult>(result);
        _userService.Verify(x => x.UpdateUserAsync(It.IsAny<UpdateUserDTO>()), Times.Never);
    }

    [Fact]
    public async Task DeleteUser_WhenUserNotFound_ReturnsBadRequest()
    {
        _userService.Setup(x => x.GetUserByIdAsync("missing")).ReturnsAsync((UserInfoDTO?)null);
        _userService.Setup(x => x.DeleteUserAsync("missing"))
            .ReturnsAsync(ApiResponse<object>.FailResponse("User not found"));

        var result = await _controller.DeleteUser("missing");

        Assert.IsType<BadRequestObjectResult>(result);
    }

    [Fact]
    public async Task LockUsers_WithValidRequest_ReturnsOk()
    {
        var request = new LockUsersRequestDto { UserIds = new List<string> { "u1" }, Minutes = 30 };
        _userService.Setup(x => x.LockUsersAsync(request.UserIds, 30))
            .ReturnsAsync(ApiResponse<object>.SuccessResponse(new object(), "Users locked"));

        var result = await _controller.LockUsers(request);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.True(((ApiResponse<object>)ok.Value!).Success);
    }

    [Fact]
    public async Task UnlockUsers_WithEmptyList_ReturnsBadRequest()
    {
        var result = await _controller.UnlockUsers(new List<string>());

        Assert.IsType<BadRequestObjectResult>(result);
        _userService.Verify(x => x.UnlockUsersAsync(It.IsAny<List<string>>()), Times.Never);
    }

    [Fact]
    public async Task UnlockUsers_WithValidList_ReturnsOk()
    {
        _userService.Setup(x => x.UnlockUsersAsync(It.IsAny<List<string>>()))
            .ReturnsAsync(ApiResponse<object>.SuccessResponse(new object(), "Users unlocked"));

        var result = await _controller.UnlockUsers(new List<string> { "u1" });

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.True(((ApiResponse<object>)ok.Value!).Success);
    }
}
