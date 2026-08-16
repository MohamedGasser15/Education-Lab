using EduLab_Application.Common;
using EduLab_Application.DTOs.Auth;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Domain;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab.Tests.Fakes;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Caching.Memory;
using Moq;
using Xunit;

namespace EduLab.Tests.Services;

public class UserServiceTests
{
    private readonly List<ApplicationUser> _users;
    private readonly IMemoryCache _cache;
    private readonly Mock<ICurrentUserService> _currentUser;
    private readonly Mock<IEmailSender> _emailSender;
    private readonly Mock<IEmailTemplateService> _emailTemplates;
    private readonly UserService _service;
    private readonly Mock<UserManager<ApplicationUser>> _userManager;

    public UserServiceTests()
    {
        _users = new List<ApplicationUser>
        {
            TestData.User("user-1", "Ahmed"),
            TestData.User("user-2", "Sara", role: "Instructor")
        };
        _cache = new MemoryCache(new MemoryCacheOptions());
        _currentUser = new Mock<ICurrentUserService>();
        _currentUser.Setup(x => x.GetUserIdAsync()).ReturnsAsync((string?)null);
        _emailSender = new Mock<IEmailSender>();
        _emailTemplates = new Mock<IEmailTemplateService>();

        _userManager = TestData.MockUserManager(_users);
        _service = CreateService(_userManager, _cache, _currentUser.Object, _emailSender.Object, _emailTemplates.Object);
    }

    private static UserService CreateService(
        Mock<UserManager<ApplicationUser>> userManager,
        IMemoryCache cache,
        ICurrentUserService currentUser,
        IEmailSender emailSender,
        IEmailTemplateService emailTemplates)
    {
        userManager.Setup(x => x.UpdateAsync(It.IsAny<ApplicationUser>())).ReturnsAsync(IdentityResult.Success);
        userManager.Setup(x => x.CreateAsync(It.IsAny<ApplicationUser>(), It.IsAny<string>())).ReturnsAsync(IdentityResult.Success);
        userManager.Setup(x => x.AddToRoleAsync(It.IsAny<ApplicationUser>(), It.IsAny<string>())).ReturnsAsync(IdentityResult.Success);
        userManager.Setup(x => x.RemoveFromRolesAsync(It.IsAny<ApplicationUser>(), It.IsAny<IEnumerable<string>>()))
            .ReturnsAsync(IdentityResult.Success);
        userManager.Setup(x => x.DeleteAsync(It.IsAny<ApplicationUser>())).ReturnsAsync(IdentityResult.Success);
        userManager.Setup(x => x.IsLockedOutAsync(It.IsAny<ApplicationUser>())).ReturnsAsync(false);
        userManager.Setup(x => x.SetLockoutEnabledAsync(It.IsAny<ApplicationUser>(), It.IsAny<bool>()))
            .ReturnsAsync(IdentityResult.Success);
        userManager.Setup(x => x.SetLockoutEndDateAsync(It.IsAny<ApplicationUser>(), It.IsAny<DateTimeOffset?>()))
            .Callback<ApplicationUser, DateTimeOffset?>((u, d) => u.LockoutEnd = d)
            .ReturnsAsync(IdentityResult.Success);
        userManager.Setup(x => x.FindByEmailAsync(It.IsAny<string>()))
            .ReturnsAsync((string email) => userManager.Object.Users.FirstOrDefault(u => u.Email == email));
        userManager.Setup(x => x.GetRolesAsync(It.IsAny<ApplicationUser>()))
            .ReturnsAsync((ApplicationUser u) =>
            {
                var id = u?.Id;
                var original = userManager.Object.Users.FirstOrDefault(x => x.Id == id);
                return new List<string> { original?.Role ?? "Student" };
            });

        var roleManager = TestInfrastructure.MockRoleManager(new List<ApplicationRole>
        {
            new() { Id = "1", Name = "Admin" },
            new() { Id = "2", Name = "Instructor" },
            new() { Id = "3", Name = "Student" },
            new() { Id = "4", Name = "Support" },
            new() { Id = "5", Name = "Moderator " }
        });

        var signInManager = new Mock<SignInManager<ApplicationUser>>(
            userManager.Object,
            Mock.Of<IHttpContextAccessor>(),
            Mock.Of<IUserClaimsPrincipalFactory<ApplicationUser>>(),
            null!, null!, null!, null!);

        return new UserService(
            userManager.Object,
            roleManager.Object,
            signInManager.Object,
            Mock.Of<ITokenService>(),
            TestInfrastructure.RealMapper(),
            cache,
            emailSender,
            emailTemplates,
            currentUser,
            Mock.Of<IInstructorApplicationRepository>(),
            TestData.NullLogger<UserService>());
    }

    [Fact]
    public async Task Register_ValidRequest_CreatesUserAndReturnsDto()
    {
        _cache.Set("emailConfirmed:newuser@test.com", true);

        var response = await _service.Register(new RegisterRequestDTO
        {
            FullName = "New Student",
            Email = "newuser@test.com",
            Password = "Passw0rd!123",
            ConfirmPassword = "Passw0rd!123"
        }, "en");

        Assert.True(response.Success);
        var userDto = Assert.IsType<UserDTO>(response.Data);
        Assert.Equal("newuser@test.com", userDto.Email);
        Assert.Equal("New Student", userDto.FullName);
        _userManager.Verify(x => x.CreateAsync(
            It.Is<ApplicationUser>(u => u.Email == "newuser@test.com" && u.FullName == "New Student"), "Passw0rd!123"), Times.Once);
        _userManager.Verify(x => x.AddToRoleAsync(It.IsAny<ApplicationUser>(), "Student"), Times.Once);
        Assert.False(_cache.TryGetValue("emailConfirmed:newuser@test.com", out _));
    }

    [Fact]
    public async Task Register_DuplicateEmail_ReturnsFailure()
    {
        _cache.Set("emailConfirmed:Ahmed@test.com", true);

        var response = await _service.Register(new RegisterRequestDTO
        {
            FullName = "Ahmed Again",
            Email = "Ahmed@test.com",
            Password = "Passw0rd!123",
            ConfirmPassword = "Passw0rd!123"
        });

        Assert.False(response.Success);
        Assert.Contains("Duplicate email", response.Errors);
        _userManager.Verify(x => x.CreateAsync(It.IsAny<ApplicationUser>(), It.IsAny<string>()), Times.Never);
    }

    [Fact]
    public async Task Register_EmailNotConfirmed_ReturnsFailure()
    {
        var response = await _service.Register(new RegisterRequestDTO
        {
            FullName = "New Student",
            Email = "unconfirmed@test.com",
            Password = "Passw0rd!123",
            ConfirmPassword = "Passw0rd!123"
        });

        Assert.False(response.Success);
        Assert.Contains("Email not confirmed", response.Errors);
        _userManager.Verify(x => x.CreateAsync(It.IsAny<ApplicationUser>(), It.IsAny<string>()), Times.Never);
    }

    [Fact]
    public async Task GetUserByIdAsync_ExistingUser_ReturnsUserInfo()
    {
        var info = await _service.GetUserByIdAsync("user-1");

        Assert.NotNull(info);
        Assert.Equal("Ahmed", info.FullName);
        Assert.Equal("Ahmed@test.com", info.Email);
        Assert.Equal("Student", info.Role);
        Assert.False(info.IsLocked);
    }

    [Fact]
    public async Task GetUserByIdAsync_UnknownUser_ReturnsNull()
    {
        var info = await _service.GetUserByIdAsync("ghost");

        Assert.Null(info);
    }

    [Fact]
    public async Task GetAllUsersWithRolesAsync_ReturnsUsersWithRoleNames()
    {
        var users = await _service.GetAllUsersWithRolesAsync();

        Assert.Equal(2, users.Count);
        var instructor = Assert.Single(users, u => u.Id == "user-2");
        Assert.Equal("Instructor", instructor.Role);
        var student = Assert.Single(users, u => u.Id == "user-1");
        Assert.Equal("Student", student.Role);
    }

    [Fact]
    public async Task UpdateUserAsync_RoleChange_UpdatesNameAndRoles()
    {
        var response = await _service.UpdateUserAsync(new UpdateUserDTO
        {
            Id = "user-1",
            FullName = "Ahmed Updated",
            Role = "Instructor"
        });

        Assert.True(response.Success);
        Assert.Equal("Ahmed Updated", _users[0].FullName);
        _userManager.Verify(x => x.AddToRoleAsync(_users[0], "Instructor"), Times.Once);
        _userManager.Verify(x => x.RemoveFromRolesAsync(_users[0], It.IsAny<IEnumerable<string>>()), Times.Once);
    }

    [Fact]
    public async Task UpdateUserAsync_UnknownRole_ReturnsFailure()
    {
        var response = await _service.UpdateUserAsync(new UpdateUserDTO
        {
            Id = "user-1",
            FullName = "Ahmed X",
            Role = "Ghost"
        });

        Assert.False(response.Success);
        Assert.Contains("Ghost", response.Message);
        _userManager.Verify(x => x.UpdateAsync(It.IsAny<ApplicationUser>()), Times.Never);
    }

    [Fact]
    public async Task DeleteUserAsync_SelfDelete_ReturnsFailure()
    {
        _currentUser.Setup(x => x.GetUserIdAsync()).ReturnsAsync("user-1");

        var response = await _service.DeleteUserAsync("user-1");

        Assert.False(response.Success);
        Assert.Contains("حسابك الشخصي", response.Message);
        _userManager.Verify(x => x.DeleteAsync(It.IsAny<ApplicationUser>()), Times.Never);
    }

    [Fact]
    public async Task DeleteUserAsync_UserWithEnrollments_ReturnsFailure()
    {
        var enrolled = TestData.User("user-3", "Omar");
        enrolled.Enrollments = new List<Enrollment> { TestData.Enrollment(1, 1, "user-3") };
        var users = new List<ApplicationUser> { enrolled };
        var userManager = TestData.MockUserManager(users);
        var service = CreateService(userManager, _cache, _currentUser.Object, _emailSender.Object, _emailTemplates.Object);

        var response = await service.DeleteUserAsync("user-3");

        Assert.False(response.Success);
        Assert.Contains("مسجل في كورسات", response.Message);
        userManager.Verify(x => x.DeleteAsync(It.IsAny<ApplicationUser>()), Times.Never);
    }

    [Fact]
    public async Task DeleteUserAsync_UserWithoutRelations_Succeeds()
    {
        var response = await _service.DeleteUserAsync("user-1");

        Assert.True(response.Success);
        _userManager.Verify(x => x.DeleteAsync(_users[0]), Times.Once);
    }

    [Fact]
    public async Task LockUsersAsync_LocksOthersAndSkipsSelf()
    {
        _currentUser.Setup(x => x.GetUserIdAsync()).ReturnsAsync("user-2");
        _userManager.Setup(x => x.IsLockedOutAsync(It.IsAny<ApplicationUser>()))
            .ReturnsAsync((ApplicationUser u) => u.LockoutEnd.HasValue && u.LockoutEnd.Value > DateTimeOffset.UtcNow);
        _emailTemplates.Setup(x => x.GenerateAccountLockoutEmail(It.IsAny<ApplicationUser>(), It.IsAny<DateTimeOffset?>(), It.IsAny<string>()))
            .Returns("<html>locked</html>");

        var response = await _service.LockUsersAsync(new List<string> { "user-1", "user-2" }, 30);

        Assert.True(response.Success);
        var locked = Assert.IsType<List<UserDTO>>(response.Data);
        var dto = Assert.Single(locked);
        Assert.Equal("user-1", dto.Id);
        Assert.True(dto.IsLocked);

        Assert.True(_users[0].LockoutEnd > DateTimeOffset.UtcNow.AddMinutes(29));
        Assert.True(_users[0].LockoutEnd < DateTimeOffset.UtcNow.AddMinutes(31));
        Assert.Null(_users[1].LockoutEnd); // self was skipped

        _userManager.Verify(x => x.SetLockoutEndDateAsync(_users[1], It.IsAny<DateTimeOffset?>()), Times.Never);
    }

    [Fact]
    public async Task UnlockUsersAsync_ClearsLockoutEnd()
    {
        _users[0].LockoutEnd = DateTimeOffset.UtcNow.AddMinutes(30);
        _emailTemplates.Setup(x => x.GenerateAccountUnlockEmail(It.IsAny<ApplicationUser>(), It.IsAny<string>()))
            .Returns("<html>unlocked</html>");

        var response = await _service.UnlockUsersAsync(new List<string> { "user-1" });

        Assert.True(response.Success);
        var unlocked = Assert.IsType<List<UserDTO>>(response.Data);
        var dto = Assert.Single(unlocked);
        Assert.Equal("user-1", dto.Id);
        Assert.False(dto.IsLocked);
        Assert.Null(_users[0].LockoutEnd);
        _userManager.Verify(x => x.SetLockoutEndDateAsync(_users[0], null), Times.Once);
    }

    [Fact]
    public async Task ForgotPasswordAsync_KnownEmail_SendsResetCode_AndCachesIt()
    {
        _emailTemplates.Setup(x => x.GeneratePasswordResetEmail(It.IsAny<string>(), It.IsAny<string>()))
            .Returns("<html>code</html>");
        _emailTemplates.Setup(x => x.GetLocalizedText(It.IsAny<string>(), It.IsAny<string>()))
            .Returns("subject");

        var result = await _service.ForgotPasswordAsync("Ahmed@test.com");

        Assert.True(result.Success);
        Assert.True(_cache.TryGetValue("passwordReset:Ahmed@test.com", out string code));
        Assert.Equal(6, code.Length);
        _emailSender.Verify(x => x.SendEmailAsync("Ahmed@test.com", It.IsAny<string>(), It.IsAny<string>()),
            Times.Once);
    }

    [Fact]
    public async Task ForgotPasswordAsync_UnknownEmail_DoesNotRevealExistence()
    {
        var result = await _service.ForgotPasswordAsync("ghost@test.com");

        Assert.True(result.Success);
        _emailSender.Verify(x => x.SendEmailAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()),
            Times.Never);
        Assert.False(_cache.TryGetValue("passwordReset:ghost@test.com", out _));
    }

    [Fact]
    public async Task ResetPasswordAsync_CodeNotVerified_Fails()
    {
        var result = await _service.ResetPasswordAsync(new ResetPasswordDTO
        {
            Email = "Ahmed@test.com",
            NewPassword = "NewPass123!",
            ConfirmPassword = "NewPass123!"
        });

        Assert.False(result.Success);
        _userManager.Verify(
            x => x.ResetPasswordAsync(It.IsAny<ApplicationUser>(), It.IsAny<string>(), It.IsAny<string>()),
            Times.Never);
    }

    [Fact]
    public async Task ResetPasswordAsync_VerifiedCodeButInvalidToken_Fails()
    {
        _cache.Set("passwordResetVerified:Ahmed@test.com", true, TimeSpan.FromMinutes(10));
        _userManager.Setup(x => x.GeneratePasswordResetTokenAsync(_users[0])).ReturnsAsync("reset-token");
        _userManager.Setup(x => x.ResetPasswordAsync(_users[0], "reset-token", "NewPass123!"))
            .ReturnsAsync(IdentityResult.Failed(new IdentityError { Description = "Invalid or expired token." }));

        var result = await _service.ResetPasswordAsync(new ResetPasswordDTO
        {
            Email = "Ahmed@test.com",
            NewPassword = "NewPass123!",
            ConfirmPassword = "NewPass123!"
        });

        Assert.False(result.Success);
        Assert.NotEmpty(result.Errors);
    }

    [Fact]
    public async Task ResetPasswordAsync_VerifiedCode_Success_ClearsCacheAndSendsConfirmation()
    {
        _cache.Set("passwordResetVerified:Ahmed@test.com", true, TimeSpan.FromMinutes(10));
        _userManager.Setup(x => x.GeneratePasswordResetTokenAsync(_users[0])).ReturnsAsync("reset-token");
        _userManager.Setup(x => x.ResetPasswordAsync(_users[0], "reset-token", "NewPass123!"))
            .ReturnsAsync(IdentityResult.Success);
        _emailTemplates.Setup(x => x.GeneratePasswordResetConfirmationEmail(It.IsAny<string>()))
            .Returns("<html></html>");
        _emailTemplates.Setup(x => x.GetLocalizedText(It.IsAny<string>(), It.IsAny<string>()))
            .Returns("subject");

        var result = await _service.ResetPasswordAsync(new ResetPasswordDTO
        {
            Email = "Ahmed@test.com",
            NewPassword = "NewPass123!",
            ConfirmPassword = "NewPass123!"
        });

        Assert.True(result.Success);
        Assert.False(_cache.TryGetValue("passwordResetVerified:Ahmed@test.com", out _));
        _emailSender.Verify(x => x.SendEmailAsync("Ahmed@test.com", It.IsAny<string>(), It.IsAny<string>()),
            Times.Once);
    }
}
