using EduLab_Application.Services;
using EduLab_Domain;
using EduLab_Domain.Entities;
using EduLab.Tests.Fakes;
using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using Moq;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Xunit;

namespace EduLab.Tests.Services;

public class TokenServiceTests
{
    private readonly ApplicationUser _user;
    private readonly ApplicationRole _adminRole;
    private readonly TokenService _service;

    public TokenServiceTests()
    {
        _user = TestData.User("user-1", "Ahmed", role: "Admin");
        _user.Email = "ahmed@test.com";

        var userManager = TestData.MockUserManager(new List<ApplicationUser> { _user });
        userManager.Setup(x => x.GetClaimsAsync(It.IsAny<ApplicationUser>()))
            .ReturnsAsync(new List<Claim> { new("ViewDashboard", "true") });

        _adminRole = new ApplicationRole { Id = "role-1", Name = "Admin" };
        var roleManager = TestInfrastructure.MockRoleManager(new List<ApplicationRole> { _adminRole });
        roleManager.Setup(x => x.GetClaimsAsync(_adminRole))
            .ReturnsAsync(new List<Claim> { new("ViewCourses", "true") });

        _service = new TokenService(
            TestInfrastructure.MockConfiguration(),
            userManager.Object,
            roleManager.Object,
            TestData.NullLogger<TokenService>());
    }

    [Fact]
    public async Task GenerateAccessToken_ContainsUserAndRoleClaims()
    {
        var token = await _service.GenerateAccessToken(_user);

        var handler = new JwtSecurityTokenHandler();
        var jwt = handler.ReadJwtToken(token);

        // ClaimTypes.Role is rewritten by the JWT outbound claim type map (e.g. to "role")
        var roleType = handler.OutboundClaimTypeMap.TryGetValue(ClaimTypes.Role, out var mapped)
            ? mapped
            : ClaimTypes.Role;

        Assert.Equal("user-1", jwt.Subject);
        Assert.Contains(jwt.Claims, c => c.Type == JwtRegisteredClaimNames.Email && c.Value == "ahmed@test.com");
        Assert.Contains(jwt.Claims, c => c.Type == roleType && c.Value == "Admin");
        Assert.Contains(jwt.Claims, c => c.Type == "ViewDashboard"); // user claim
        Assert.Contains(jwt.Claims, c => c.Type == "ViewCourses");   // role claim
        Assert.Equal("EduLabAPI", jwt.Issuer);
        Assert.Contains("EduLabUsers", jwt.Audiences);
    }

    [Fact]
    public async Task GenerateAccessToken_HasConfiguredLifetime()
    {
        var token = await _service.GenerateAccessToken(_user);

        var jwt = new JwtSecurityTokenHandler().ReadJwtToken(token);

        Assert.True(jwt.ValidTo > DateTime.UtcNow.AddDays(6));    // 7 days configured
        Assert.True(jwt.ValidTo < DateTime.UtcNow.AddDays(8));
    }

    [Fact]
    public async Task GenerateAccessToken_NullUser_ThrowsArgumentNull()
    {
        await Assert.ThrowsAsync<ArgumentNullException>(() => _service.GenerateAccessToken(null!));
    }

    [Fact]
    public async Task GenerateAccessToken_MissingJwtKey_ThrowsArgumentException()
    {
        var service = new TokenService(
            TestInfrastructure.MockConfiguration(new Dictionary<string, string> { ["JWT:Key"] = "" }),
            TestData.MockUserManager(new List<ApplicationUser> { _user }).Object,
            TestInfrastructure.MockRoleManager().Object,
            TestData.NullLogger<TokenService>());

        await Assert.ThrowsAsync<ArgumentException>(() => service.GenerateAccessToken(_user));
    }

    [Fact]
    public void GenerateRefreshToken_ReturnsUniqueBase64Tokens()
    {
        var token1 = _service.GenerateRefreshToken();
        var token2 = _service.GenerateRefreshToken();

        Assert.False(string.IsNullOrWhiteSpace(token1));
        Assert.Equal(44, token1.Length); // 32 random bytes -> base64
        Assert.NotEqual(token1, token2);
    }

    [Fact]
    public async Task GetPrincipalFromExpiredToken_ExtractsClaims()
    {
        var token = await _service.GenerateAccessToken(_user);

        var principal = _service.GetPrincipalFromExpiredToken(token);

        Assert.NotNull(principal);
        Assert.True(principal.Identity!.IsAuthenticated);
        // claim types may be rewritten by the JWT handler's inbound claim map, so assert on values
        Assert.Contains(principal.Claims, c => c.Value == "user-1");
        Assert.Contains(principal.Claims, c => c.Value == "Admin");
    }

    [Fact]
    public void GetPrincipalFromExpiredToken_NullOrEmpty_ThrowsArgumentException()
    {
        Assert.Throws<ArgumentException>(() => _service.GetPrincipalFromExpiredToken(null!));
        Assert.Throws<ArgumentException>(() => _service.GetPrincipalFromExpiredToken(""));
    }

    [Fact]
    public void GetPrincipalFromExpiredToken_MalformedToken_ThrowsSecurityTokenMalformedException()
    {
        Assert.Throws<SecurityTokenMalformedException>(() => _service.GetPrincipalFromExpiredToken("not-a-jwt"));
    }

    [Fact]
    public void GetPrincipalFromExpiredToken_WrongSigningKey_ThrowsSecurityTokenException()
    {
        var handler = new JwtSecurityTokenHandler();
        var wrongKey = Encoding.ASCII.GetBytes("ANOTHER-SUPER-LONG-SECRET-KEY-1234567890!!!!");
        var descriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(new[] { new Claim(ClaimTypes.Name, "attacker") }),
            Expires = DateTime.UtcNow.AddHours(1),
            SigningCredentials = new SigningCredentials(
                new SymmetricSecurityKey(wrongKey),
                SecurityAlgorithms.HmacSha256Signature)
        };
        var forged = handler.WriteToken(handler.CreateToken(descriptor));

        Assert.ThrowsAny<SecurityTokenException>(() => _service.GetPrincipalFromExpiredToken(forged));
    }
}
