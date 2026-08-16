using EduLab_Application.Services;
using EduLab_Domain;
using EduLab_Domain.Entities;
using EduLab.Tests.Fakes;
using Microsoft.AspNetCore.Identity;
using Moq;
using System.Security.Claims;
using Xunit;

namespace EduLab.Tests.Services;

public class RoleClaimsServiceTests
{
    private readonly ApplicationRole _role;
    private readonly Mock<RoleManager<ApplicationRole>> _roleManager;
    private readonly RoleClaimsService _service;

    public RoleClaimsServiceTests()
    {
        _role = new ApplicationRole { Id = "role-1", Name = "Admin" };
        _roleManager = TestInfrastructure.MockRoleManager(new List<ApplicationRole> { _role });
        _service = new RoleClaimsService(_roleManager.Object);
    }

    [Fact]
    public async Task GetClaimsForRoleAsync_MarksExistingClaimsAsSelected()
    {
        _roleManager.Setup(x => x.GetClaimsAsync(_role))
            .ReturnsAsync(new List<Claim> { new("ViewCategories", "true"), new("EditCategory", "true") });

        var model = await _service.GetClaimsForRoleAsync("role-1");

        Assert.NotNull(model);
        Assert.Equal("role-1", model.RoleId);

        var view = Assert.Single(model.CategoryClaimList.Where(c => c.ClaimType == "ViewCategories"));
        Assert.True(view.IsSelected);
        var edit = Assert.Single(model.CategoryClaimList.Where(c => c.ClaimType == "EditCategory"));
        Assert.True(edit.IsSelected);

        var create = Assert.Single(model.CategoryClaimList.Where(c => c.ClaimType == "CreateCategory"));
        Assert.False(create.IsSelected);
    }

    [Fact]
    public async Task GetClaimsForRoleAsync_BuildsAllClaimGroups()
    {
        var model = await _service.GetClaimsForRoleAsync("role-1");

        Assert.NotNull(model);
        Assert.Equal(ClaimStore.DashboardClaims.Count, model.DashboardClaimList.Count);
        Assert.Equal(ClaimStore.CategoryClaims.Count, model.CategoryClaimList.Count);
        Assert.Equal(ClaimStore.CourseClaims.Count, model.CourseClaimList.Count);
        Assert.Equal(ClaimStore.SupportClaims.Count, model.SupportClaimList.Count);
        Assert.All(model.CategoryClaimList, c => Assert.False(c.IsSelected));
        Assert.NotEmpty(model.CategoryClaimList[0].Label);
    }

    [Fact]
    public async Task GetClaimsForRoleAsync_RoleNotFound_ReturnsNull()
    {
        var model = await _service.GetClaimsForRoleAsync("missing-role");

        Assert.Null(model);
    }

    [Theory]
    [InlineData(null)]
    [InlineData("")]
    public async Task GetClaimsForRoleAsync_EmptyRoleId_ThrowsArgumentException(string? roleId)
    {
        await Assert.ThrowsAsync<ArgumentException>(() => _service.GetClaimsForRoleAsync(roleId!));
    }

    [Fact]
    public async Task UpdateRoleClaimsAsync_RemovesOldAndAddsSelectedFromAllGroups()
    {
        _roleManager.Setup(x => x.GetClaimsAsync(_role))
            .ReturnsAsync(new List<Claim> { new("ViewCategories", "true") });

        var removed = new List<Claim>();
        var added = new List<Claim>();
        _roleManager.Setup(x => x.RemoveClaimAsync(It.IsAny<ApplicationRole>(), It.IsAny<Claim>()))
            .Callback<ApplicationRole, Claim>((_, c) => removed.Add(c))
            .ReturnsAsync(IdentityResult.Success);
        _roleManager.Setup(x => x.AddClaimAsync(It.IsAny<ApplicationRole>(), It.IsAny<Claim>()))
            .Callback<ApplicationRole, Claim>((_, c) => added.Add(c))
            .ReturnsAsync(IdentityResult.Success);

        var model = new ClaimsModel
        {
            DashboardClaimList = { new ClaimSelection { ClaimType = "ViewDashboard", IsSelected = true } },
            CategoryClaimList =
            {
                new ClaimSelection { ClaimType = "ViewCategories", IsSelected = true },
                new ClaimSelection { ClaimType = "CreateCategory", IsSelected = false }
            },
            SupportClaimList = { new ClaimSelection { ClaimType = "HandleSupport", IsSelected = true } }
        };

        var result = await _service.UpdateRoleClaimsAsync("role-1", model);

        Assert.True(result);
        var removedClaim = Assert.Single(removed);
        Assert.Equal("ViewCategories", removedClaim.Type);
        Assert.Equal(3, added.Count);
        Assert.Contains(added, c => c.Type == "ViewDashboard" && c.Value == "true");
        Assert.Contains(added, c => c.Type == "ViewCategories");
        Assert.Contains(added, c => c.Type == "HandleSupport");
        Assert.DoesNotContain(added, c => c.Type == "CreateCategory");
    }

    [Fact]
    public async Task UpdateRoleClaimsAsync_RoleNotFound_ReturnsFalse()
    {
        var model = new ClaimsModel
        {
            CategoryClaimList = { new ClaimSelection { ClaimType = "ViewCategories", IsSelected = true } }
        };

        var result = await _service.UpdateRoleClaimsAsync("missing-role", model);

        Assert.False(result);
        _roleManager.Verify(x => x.AddClaimAsync(It.IsAny<ApplicationRole>(), It.IsAny<Claim>()), Times.Never);
    }

    [Fact]
    public async Task UpdateRoleClaimsAsync_NullModel_ThrowsArgumentNull()
    {
        await Assert.ThrowsAsync<ArgumentNullException>(
            () => _service.UpdateRoleClaimsAsync("role-1", null!));
    }

    [Fact]
    public async Task UpdateRoleClaimsAsync_EmptyRoleId_ThrowsArgumentException()
    {
        await Assert.ThrowsAsync<ArgumentException>(
            () => _service.UpdateRoleClaimsAsync("", new ClaimsModel()));
    }

    [Fact]
    public async Task UpdateRoleClaimsAsync_NoSelectedClaims_RemovesAllAndAddsNone()
    {
        _roleManager.Setup(x => x.GetClaimsAsync(_role))
            .ReturnsAsync(new List<Claim> { new("ViewCategories", "true") });
        _roleManager.Setup(x => x.RemoveClaimAsync(It.IsAny<ApplicationRole>(), It.IsAny<Claim>()))
            .ReturnsAsync(IdentityResult.Success);
        var added = 0;
        _roleManager.Setup(x => x.AddClaimAsync(It.IsAny<ApplicationRole>(), It.IsAny<Claim>()))
            .Callback<ApplicationRole, Claim>((_, _) => added++)
            .ReturnsAsync(IdentityResult.Success);

        var model = new ClaimsModel
        {
            CategoryClaimList =
            {
                new ClaimSelection { ClaimType = "ViewCategories", IsSelected = false }
            }
        };

        var result = await _service.UpdateRoleClaimsAsync("role-1", model);

        Assert.True(result);
        Assert.Equal(0, added);
        _roleManager.Verify(x => x.RemoveClaimAsync(It.IsAny<ApplicationRole>(), It.IsAny<Claim>()), Times.Once);
    }
}
