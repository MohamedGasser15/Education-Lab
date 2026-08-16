using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab.Tests.Fakes;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Localization;
using Moq;
using Xunit;

namespace EduLab.Tests.Services;

public class EmailTemplateServiceTests
{
    private static Mock<IStringLocalizer<EduLab_Application.Resources.SharedResources>> MockLocalizer()
    {
        var localizer = new Mock<IStringLocalizer<EduLab_Application.Resources.SharedResources>>();
        // أي key بترجع نفسها كقيمة — عدا الـ dir اللي بيتبع ثقافة اللغة الحالية
        localizer.Setup(x => x[It.IsAny<string>()])
            .Returns((string key) => new LocalizedString(key, key));
        localizer.Setup(x => x["EmailHtmlDir"])
            .Returns(() => new LocalizedString("EmailHtmlDir",
                System.Globalization.CultureInfo.CurrentUICulture.Name.StartsWith("ar") ? "rtl" : "ltr"));
        return localizer;
    }

    private static EmailTemplateService CreateService(Mock<IStringLocalizer<EduLab_Application.Resources.SharedResources>>? localizer = null)
        => new((localizer ?? MockLocalizer()).Object);

    [Fact]
    public void GenerateVerificationEmail_ContainsCode()
    {
        var service = CreateService();

        var html = service.GenerateVerificationEmail("123456", "en");

        Assert.Contains("123456", html);
        Assert.Contains("<html", html);
    }

    [Fact]
    public void GenerateVerificationEmail_Arabic_IsRtl()
    {
        var service = CreateService();

        var html = service.GenerateVerificationEmail("123456", "ar");

        Assert.Contains("dir='rtl'", html);
        Assert.Contains("lang='ar'", html);
    }

    [Fact]
    public void GenerateVerificationEmail_English_IsLtr()
    {
        var service = CreateService();

        var html = service.GenerateVerificationEmail("123456", "en");

        Assert.Contains("dir='ltr'", html);
        Assert.Contains("lang='en'", html);
    }

    [Fact]
    public void GenerateLoginEmail_ContainsUserAndIpAndDevice()
    {
        var service = CreateService();
        var user = TestData.User("u1", "Ahmed");

        var html = service.GenerateLoginEmail(user, "41.1.2.3", "Chrome on Windows", DateTime.UtcNow, "https://example.com/reset");

        Assert.Contains("Ahmed", html);
        Assert.Contains("41.1.2.3", html);
        Assert.Contains("Chrome on Windows", html);
    }

    [Fact]
    public void GeneratePasswordResetEmail_ContainsResetCode()
    {
        var service = CreateService();

        var html = service.GeneratePasswordResetEmail("ABC123", "en");

        Assert.Contains("ABC123", html);
    }

    [Fact]
    public void GeneratePasswordResetConfirmationEmail_ProducesHtml()
    {
        var service = CreateService();

        var html = service.GeneratePasswordResetConfirmationEmail("ar");

        Assert.Contains("<html", html);
    }

    [Fact]
    public void GenerateInstructorApprovalEmail_ContainsUserName()
    {
        var service = CreateService();
        var user = TestData.User("u1", "Sara");

        var html = service.GenerateInstructorApprovalEmail(user, "ar");

        Assert.Contains("Sara", html);
    }

    [Fact]
    public void GenerateInstructorRejectionEmail_ContainsReason()
    {
        var service = CreateService();
        var user = TestData.User("u1", "Sara");

        var html = service.GenerateInstructorRejectionEmail(user, "Not enough experience");

        Assert.Contains("Not enough experience", html);
    }
}
