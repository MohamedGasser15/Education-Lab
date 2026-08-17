using EduLab_Application.Services;
using SkiaSharp;
using Xunit;

namespace EduLab.Tests.Services;

public class CertificateTypefaceProviderTests
{
    private readonly string _fontsDir;

    public CertificateTypefaceProviderTests()
    {
        _fontsDir = Path.Combine(Path.GetTempPath(), "edulab-fonts-tests", Guid.NewGuid().ToString("N"));
        Directory.CreateDirectory(_fontsDir);
    }

    private static string RealFont(string name) =>
        Path.Combine(@"D:\Programming\MonoRepo Porjects\EducationLab\apps\api\EduLab_API\wwwroot\fonts", name);

    [Fact]
    public void HealthyInter_ResolvesToInter()
    {
        File.Copy(RealFont("Inter-700.ttf"), Path.Combine(_fontsDir, "Inter-700.ttf"));

        var (typeface, path) = CertificateTypefaceProvider.ResolveWithSource("Inter", 700, _fontsDir);

        Assert.NotNull(typeface);
        Assert.Contains("Inter", typeface.FamilyName, StringComparison.OrdinalIgnoreCase);
        Assert.EndsWith("Inter-700.ttf", path);
    }

    [Fact]
    public void MissingInterFile_FallsBackToCairoBold()
    {
        File.Copy(RealFont("Cairo-Bold.ttf"), Path.Combine(_fontsDir, "Cairo-Bold.ttf"));

        var (typeface, path) = CertificateTypefaceProvider.ResolveWithSource("Inter", 700, _fontsDir);

        Assert.NotNull(typeface);
        Assert.Contains("Cairo", typeface.FamilyName, StringComparison.OrdinalIgnoreCase);
        Assert.EndsWith("Cairo-Bold.ttf", path);
    }

    [Fact]
    public void MisnamedFontFile_FallsBackToCairoBold()
    {
        File.Copy(RealFont("Cairo-Bold.ttf"), Path.Combine(_fontsDir, "Inter-700.ttf"));
        File.Copy(RealFont("Cairo-Bold.ttf"), Path.Combine(_fontsDir, "Cairo-Bold.ttf"));

        var (typeface, path) = CertificateTypefaceProvider.ResolveWithSource("Inter", 700, _fontsDir);

        Assert.NotNull(typeface);
        Assert.Contains("Cairo", typeface.FamilyName, StringComparison.OrdinalIgnoreCase);
        Assert.EndsWith("Cairo-Bold.ttf", path);
    }

    [Fact]
    public void NoFontFilesAtAll_ReturnsOsDefaultWithNullPath()
    {
        var (typeface, path) = CertificateTypefaceProvider.ResolveWithSource("Inter", 700, _fontsDir);

        Assert.NotNull(typeface);
        Assert.Null(path);
    }

    [Fact]
    public void UnknownFamily_ReturnsOsDefaultWithNullPath()
    {
        File.Copy(RealFont("Inter-700.ttf"), Path.Combine(_fontsDir, "Inter-700.ttf"));

        var (typeface, path) = CertificateTypefaceProvider.ResolveWithSource("SomeOther", 700, _fontsDir);

        Assert.NotNull(typeface);
        Assert.Null(path);
    }
}