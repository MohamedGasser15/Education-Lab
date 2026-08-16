using EduLab_Application.Services;
using Xunit;

namespace EduLab.Tests.Services;

public class LinkBuilderServiceTests
{
    private readonly LinkBuilderService _service = new(null!, null!);

    [Fact]
    public void GenerateResetPasswordLink_ReturnsForgotPasswordPage()
    {
        Assert.Equal("https://edulab.runasp.net/Learner/Auth/ForgotPassword",
            _service.GenerateResetPasswordLink("user-1"));
    }

    [Fact]
    public void GenerateCertificateVerifyLink_ContainsBaseUrlAndCode()
    {
        var link = _service.GenerateCertificateVerifyLink("EL-2026-ABC");

        Assert.Equal("https://edulab.runasp.net/Learner/Certificates/Verify/EL-2026-ABC", link);
        Assert.Contains("EL-2026-ABC", link);
    }

    [Fact]
    public void GenerateResetPasswordLink_IsStableForAnyUser()
    {
        var first = _service.GenerateResetPasswordLink("user-1");
        var second = _service.GenerateResetPasswordLink("user-2");

        Assert.Equal(first, second);
    }
}
