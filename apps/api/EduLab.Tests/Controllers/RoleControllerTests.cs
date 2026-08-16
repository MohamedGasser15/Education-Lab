using EduLab_API.Controllers.Admin;
using EduLab_Application.DTOs.Role;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class RoleControllerTests
{
    private readonly Mock<IRoleService> _roleService;
    private readonly Mock<IRoleClaimsService> _roleClaimsService;
    private readonly Mock<ICurrentUserService> _currentUserService;
    private readonly Mock<IHistoryService> _historyService;
    private readonly RoleController _controller;

    public RoleControllerTests()
    {
        _roleService = new Mock<IRoleService>();
        _roleClaimsService = new Mock<IRoleClaimsService>();
        _currentUserService = new Mock<ICurrentUserService>();
        _historyService = new Mock<IHistoryService>();
        _controller = new RoleController(
            _roleService.Object,
            _roleClaimsService.Object,
            _currentUserService.Object,
            _historyService.Object,
            Mock.Of<ILogger<RoleController>>());
    }

    [Fact]
    public async Task GetAllRoles_ReturnsOkWithRoles()
    {
        var roles = new List<RoleDto> { new() { Id = "1", Name = "Admin", UserCount = 2 } };
        _roleService.Setup(x => x.GetAllRolesAsync(It.IsAny<CancellationToken>())).ReturnsAsync(roles);

        var result = await _controller.GetAllRoles();

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(roles, ok.Value);
    }

    [Fact]
    public async Task GetRoleById_WithEmptyId_ReturnsBadRequest()
    {
        var result = await _controller.GetRoleById("");

        Assert.IsType<BadRequestObjectResult>(result.Result);
        _roleService.Verify(x => x.GetRoleByIdAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetRoleById_WhenNotFound_ReturnsNotFound()
    {
        _roleService.Setup(x => x.GetRoleByIdAsync("missing", It.IsAny<CancellationToken>()))
            .ReturnsAsync((RoleDto?)null);

        var result = await _controller.GetRoleById("missing");

        Assert.IsType<NotFoundResult>(result.Result);
    }

    [Fact]
    public async Task CreateRole_WithEmptyName_ReturnsBadRequest()
    {
        var result = await _controller.CreateRole("   ");

        Assert.IsType<BadRequestObjectResult>(result);
        _roleService.Verify(x => x.CreateRoleAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task CreateRole_Success_ReturnsOk()
    {
        _roleService.Setup(x => x.CreateRoleAsync("Instructor", It.IsAny<CancellationToken>())).ReturnsAsync(true);
        _roleService.Setup(x => x.GetAllRolesAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<RoleDto> { new() { Id = "2", Name = "Instructor" } });

        var result = await _controller.CreateRole("Instructor");

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal("Role created successfully", ok.Value);
    }

    [Fact]
    public async Task UpdateRole_WhenRoleDoesNotExist_ReturnsBadRequest()
    {
        _roleService.Setup(x => x.UpdateRoleAsync("missing", "Instructor", It.IsAny<CancellationToken>()))
            .ReturnsAsync(false);

        var result = await _controller.UpdateRole("missing", "Instructor");

        Assert.IsType<BadRequestObjectResult>(result);
    }

    [Fact]
    public async Task DeleteRole_WhenRoleInUse_ReturnsBadRequest()
    {
        _roleService.Setup(x => x.GetRoleByIdAsync("1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new RoleDto { Id = "1", Name = "CustomRole" });
        _roleService.Setup(x => x.DeleteRoleAsync("1", It.IsAny<CancellationToken>())).ReturnsAsync(false);

        var result = await _controller.DeleteRole("1");

        Assert.IsType<BadRequestObjectResult>(result);
    }

    [Fact]
    public async Task DeleteRole_WhenProtectedRole_ReturnsBadRequest_AndDoesNotDelete()
    {
        _roleService.Setup(x => x.GetRoleByIdAsync("1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new RoleDto { Id = "1", Name = "Admin" });

        var result = await _controller.DeleteRole("1");

        var badRequest = Assert.IsType<BadRequestObjectResult>(result);
        Assert.Contains("protected", badRequest.Value?.ToString() ?? "", StringComparison.OrdinalIgnoreCase);
        _roleService.Verify(x => x.DeleteRoleAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task DeleteRole_WhenInstructorRole_ReturnsBadRequest_AndDoesNotDelete()
    {
        _roleService.Setup(x => x.GetRoleByIdAsync("2", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new RoleDto { Id = "2", Name = "Instructor" });

        var result = await _controller.DeleteRole("2");

        Assert.IsType<BadRequestObjectResult>(result);
        _roleService.Verify(x => x.DeleteRoleAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task BulkDeleteRoles_WhenIncludesProtectedRole_ReturnsBadRequest_AndDoesNotDelete()
    {
        _roleService.Setup(x => x.GetAllRolesAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<RoleDto>
            {
                new() { Id = "1", Name = "Support" },
                new() { Id = "9", Name = "CustomRole" }
            });

        var result = await _controller.BulkDeleteRoles(new List<string> { "1", "9" });

        var badRequest = Assert.IsType<BadRequestObjectResult>(result);
        Assert.Contains("protected", badRequest.Value?.ToString() ?? "", StringComparison.OrdinalIgnoreCase);
        _roleService.Verify(x => x.BulkDeleteRolesAsync(It.IsAny<List<string>>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task BulkDeleteRoles_AllDeletable_Succeeds()
    {
        _roleService.Setup(x => x.GetAllRolesAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<RoleDto>
            {
                new() { Id = "1", Name = "CustomRole" },
                new() { Id = "9", Name = "AnotherRole" }
            });
        _roleService.Setup(x => x.BulkDeleteRolesAsync(It.IsAny<List<string>>(), It.IsAny<CancellationToken>())).ReturnsAsync(true);

        var result = await _controller.BulkDeleteRoles(new List<string> { "1", "9" });

        Assert.IsType<OkObjectResult>(result);
        _roleService.Verify(x => x.BulkDeleteRolesAsync(It.IsAny<List<string>>(), It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task GetRoleClaims_WhenRoleNotFound_ReturnsNotFound()
    {
        _roleClaimsService.Setup(x => x.GetClaimsForRoleAsync("missing", It.IsAny<CancellationToken>()))
            .ReturnsAsync((ClaimsModel?)null);

        var result = await _controller.GetRoleClaims("missing");

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task GetRoleClaims_ReturnsOkWithClaims()
    {
        var claims = new ClaimsModel { RoleId = "1" };
        _roleClaimsService.Setup(x => x.GetClaimsForRoleAsync("1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(claims);

        var result = await _controller.GetRoleClaims("1");

        Assert.IsType<OkObjectResult>(result);
    }

    [Fact]
    public async Task UpdateRoleClaims_WhenRoleNotFound_ReturnsNotFound()
    {
        _roleService.Setup(x => x.GetRoleByIdAsync("missing", It.IsAny<CancellationToken>()))
            .ReturnsAsync((RoleDto?)null);

        var result = await _controller.UpdateRoleClaims("missing", new ClaimsModel { RoleId = "missing" });

        Assert.IsType<NotFoundObjectResult>(result);
        _roleClaimsService.Verify(x => x.UpdateRoleClaimsAsync(It.IsAny<string>(), It.IsAny<ClaimsModel>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task UpdateRoleClaims_Success_ReturnsOk()
    {
        _roleService.Setup(x => x.GetRoleByIdAsync("1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new RoleDto { Id = "1", Name = "Moderator" });
        _roleClaimsService.Setup(x => x.UpdateRoleClaimsAsync("1", It.IsAny<ClaimsModel>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);

        var result = await _controller.UpdateRoleClaims("1", new ClaimsModel { RoleId = "1" });

        Assert.IsType<OkObjectResult>(result);
    }
}
