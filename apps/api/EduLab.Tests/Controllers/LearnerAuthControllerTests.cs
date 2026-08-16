using EduLab_API.Controllers.Customer;
using EduLab_Application.Common;
using EduLab_Application.DTOs.Auth;
using EduLab_Application.DTOs.Token;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class LearnerAuthControllerTests
{
    private readonly Mock<IAuthService> _authService;
    private readonly Mock<IUserService> _userService;
    private readonly AuthController _controller;

    public LearnerAuthControllerTests()
    {
        _authService = new Mock<IAuthService>();
        _userService = new Mock<IUserService>();
        _controller = new AuthController(
            _authService.Object,
            _userService.Object,
            Mock.Of<IExternalLoginService>(),
            Mock.Of<ILogger<AuthController>>());
    }

    private void SetUser(string userId)
    {
        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext
            {
                User = new System.Security.Claims.ClaimsPrincipal(new System.Security.Claims.ClaimsIdentity(
                    new[] { new System.Security.Claims.Claim(System.Security.Claims.ClaimTypes.NameIdentifier, userId) }))
            }
        };
    }

    [Fact]
    public async Task Login_WithValidCredentials_ReturnsOkWithTokens()
    {
        var model = new LoginRequestDTO { Email = "student@test.com", Password = "Passw0rd!" };
        var response = new LoginResponseDTO { Token = "access-token", RefreshToken = "refresh-token" };
        _authService.Setup(x => x.Login(model)).ReturnsAsync(response);

        var result = await _controller.Login(model);

        var ok = Assert.IsType<OkObjectResult>(result);
        var apiResponse = Assert.IsType<ApiResponse<LoginResponseDTO>>(ok.Value);
        Assert.True(apiResponse.Success);
        Assert.Same(response, apiResponse.Data);
    }

    [Fact]
    public async Task Login_WithInvalidCredentials_ReturnsUnauthorized()
    {
        var model = new LoginRequestDTO { Email = "student@test.com", Password = "wrong" };
        _authService.Setup(x => x.Login(model)).ReturnsAsync((LoginResponseDTO)null);

        var result = await _controller.Login(model);

        Assert.IsType<UnauthorizedObjectResult>(result);
    }

    [Fact]
    public async Task Login_WithEmptyModel_ReturnsBadRequest()
    {
        _controller.ModelState.AddModelError("Email", "البريد الإلكتروني مطلوب");

        var result = await _controller.Login(new LoginRequestDTO());

        Assert.IsType<BadRequestObjectResult>(result);
        _authService.Verify(x => x.Login(It.IsAny<LoginRequestDTO>()), Times.Never);
    }

    [Fact]
    public async Task Register_WithValidModel_ReturnsOk()
    {
        var model = new RegisterRequestDTO
        {
            FullName = "Ahmed Ali",
            Email = "ahmed@test.com",
            Password = "Passw0rd!",
            ConfirmPassword = "Passw0rd!"
        };
        var response = new ApiResponse<object> { Success = true, Data = new { message = "registered" } };
        _userService.Setup(x => x.Register(model, It.IsAny<string>())).ReturnsAsync(response);

        var result = await _controller.Register(model);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Same(response, ok.Value);
    }

    [Fact]
    public async Task Register_WhenServiceReturnsNull_ReturnsBadRequest()
    {
        var model = new RegisterRequestDTO
        {
            FullName = "Ahmed Ali",
            Email = "ahmed@test.com",
            Password = "Passw0rd!",
            ConfirmPassword = "Passw0rd!"
        };
        _userService.Setup(x => x.Register(model, It.IsAny<string>()))
            .ReturnsAsync((ApiResponse<object>)null);

        var result = await _controller.Register(model);

        Assert.IsType<BadRequestObjectResult>(result);
    }

    [Fact]
    public async Task RefreshToken_WithMissingModel_ReturnsBadRequest()
    {
        _controller.ModelState.AddModelError("RefreshToken", "Refresh token is required");

        var result = await _controller.RefreshToken(new RefreshTokenRequestDTO());

        Assert.IsType<BadRequestObjectResult>(result);
        _authService.Verify(x => x.RefreshToken(It.IsAny<RefreshTokenRequestDTO>()), Times.Never);
    }

    [Fact]
    public async Task RefreshToken_WithInvalidToken_ReturnsUnauthorized()
    {
        var request = new RefreshTokenRequestDTO { AccessToken = "expired", RefreshToken = "stale" };
        _authService.Setup(x => x.RefreshToken(request)).ReturnsAsync((TokenResponseDTO)null);

        var result = await _controller.RefreshToken(request);

        Assert.IsType<UnauthorizedObjectResult>(result);
    }

    [Fact]
    public async Task RevokeToken_WithAuthenticatedUser_RevokesAndReturnsOk()
    {
        SetUser("user-1");
        _authService.Setup(x => x.RevokeRefreshToken("user-1", "refresh-token")).Returns(Task.CompletedTask);

        var result = await _controller.RevokeToken("refresh-token");

        Assert.IsType<OkObjectResult>(result);
        _authService.Verify(x => x.RevokeRefreshToken("user-1", "refresh-token"), Times.Once);
    }
}
