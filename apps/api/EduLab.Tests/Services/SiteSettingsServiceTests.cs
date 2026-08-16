using EduLab_Application.DTOs.Settings;
using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab.Tests.Fakes;
using Xunit;

namespace EduLab.Tests.Services;

public class SiteSettingsServiceTests
{
    private readonly FakeRepository<SiteSettings> _repository;
    private readonly SiteSettingsService _service;

    public SiteSettingsServiceTests()
    {
        _repository = new FakeRepository<SiteSettings>();
        _service = new SiteSettingsService(
            _repository,
            TestInfrastructure.RealMapper(),
            TestData.NullLogger<SiteSettingsService>());
    }

    [Fact]
    public async Task GetSettingsAsync_ReturnsExistingSettings()
    {
        _repository.Items.Add(TestData.Settings(1));

        var result = await _service.GetSettingsAsync();

        Assert.NotNull(result);
        Assert.Equal(1, result.Id);
        Assert.Equal("EduLab", result.SiteName);
        Assert.Equal("ar", result.DefaultLanguage);
        Assert.Equal("#2563eb", result.PrimaryColor);
    }

    [Fact]
    public async Task GetSettingsAsync_WhenMissing_CreatesDefaults()
    {
        var result = await _service.GetSettingsAsync();

        Assert.NotNull(result);
        Assert.Equal("EduLab", result.SiteName);
        Assert.Equal("en", result.DefaultLanguage);
        var stored = Assert.Single(_repository.Items);
        Assert.Equal("EduLab", stored.SiteName);
    }

    [Fact]
    public async Task GetSettingsAsync_IgnoresNonId1Settings()
    {
        _repository.Items.Add(TestData.Settings(5));
        _repository.Items[0].SiteName = "Other row";

        var result = await _service.GetSettingsAsync();

        Assert.NotNull(result);
        Assert.Equal("EduLab", result.SiteName); // default row created, id 5 row ignored
        Assert.Equal(2, _repository.Items.Count);
    }

    [Fact]
    public async Task UpdateSettingsAsync_UpdatesExistingSettings()
    {
        _repository.Items.Add(TestData.Settings(1));

        var dto = new SiteSettingsDTO
        {
            Id = 1,
            SiteName = "EduLab Pro",
            DefaultLanguage = "en",
            DefaultTheme = "dark",
            MaintenanceMode = true,
            MaintenanceMessage = "Under maintenance"
        };

        var result = await _service.UpdateSettingsAsync(dto, "admin-1");

        Assert.True(result);
        var stored = Assert.Single(_repository.Items);
        Assert.Equal("EduLab Pro", stored.SiteName);
        Assert.Equal("en", stored.DefaultLanguage);
        Assert.Equal("dark", stored.DefaultTheme);
        Assert.True(stored.MaintenanceMode);
        Assert.Equal("admin-1", stored.UpdatedBy);
        Assert.True(stored.UpdatedAt > DateTime.UtcNow.AddMinutes(-1));
    }

    [Fact]
    public async Task UpdateSettingsAsync_WhenMissing_CreatesNewRow()
    {
        var dto = new SiteSettingsDTO
        {
            SiteName = "Fresh Start",
            DefaultLanguage = "ar",
            PrimaryColor = "#ff0000"
        };

        var result = await _service.UpdateSettingsAsync(dto, "admin-2");

        Assert.True(result);
        var stored = Assert.Single(_repository.Items);
        Assert.Equal("Fresh Start", stored.SiteName);
        Assert.Equal("#ff0000", stored.PrimaryColor);
        Assert.Equal("admin-2", stored.UpdatedBy);
    }

    [Fact]
    public async Task GetSettingsAsync_ThenUpdate_RoundTripsChanges()
    {
        _repository.Items.Add(TestData.Settings(1));

        var current = await _service.GetSettingsAsync();
        current!.SiteDescription = "Updated description";

        var ok = await _service.UpdateSettingsAsync(current, "admin-3");

        Assert.True(ok);
        var updated = await _service.GetSettingsAsync();
        Assert.Equal("Updated description", updated!.SiteDescription);
    }
}
