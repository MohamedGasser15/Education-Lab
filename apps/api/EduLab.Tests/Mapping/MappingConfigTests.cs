using AutoMapper;
using EduLab_API.MappingConfig;
using EduLab_Domain.Entities;
using Microsoft.Extensions.DependencyInjection;
using Xunit;

namespace EduLab.Tests.Mapping;

/// <summary>
/// Smoke test: the real AutoMapper profiles must be valid and map key pairs without errors.
/// </summary>
public class MappingConfigTests
{
    private static IMapper BuildRealMapper()
    {
        var services = new ServiceCollection();
        services.AddLogging();
        services.AddAutoMapper(cfg => cfg.AddProfile(new MappingConfig()), typeof(MappingConfig).Assembly);
        return services.BuildServiceProvider().GetRequiredService<IMapper>();
    }

    [Fact]
    public void MappingConfig_IsValid()
    {
        var mapper = BuildRealMapper();
        Assert.NotNull(mapper);
    }

    [Fact]
    public void Map_UserToInstructorDTO_Works()
    {
        var mapper = BuildRealMapper();

        var user = new ApplicationUser
        {
            Id = "u1",
            FullName = "Ahmed",
            Title = "Instructor",
            About = "About me"
        };

        var dto = mapper.Map<EduLab_Application.DTOs.Profile.InstructorProfileDTO>(user);

        Assert.NotNull(dto);
        Assert.Equal("Ahmed", dto.FullName);
        Assert.Equal("Instructor", dto.Title);
    }

    [Fact]
    public void Map_UserToProfileDTO_Works()
    {
        var mapper = BuildRealMapper();

        var user = new ApplicationUser
        {
            Id = "u1",
            FullName = "Ahmed",
            Email = "ahmed@test.com",
            PhoneNumber = "01000000000"
        };

        var dto = mapper.Map<EduLab_Application.DTOs.Profile.ProfileDTO>(user);

        Assert.NotNull(dto);
        Assert.Equal("Ahmed", dto.FullName);
        Assert.Equal("ahmed@test.com", dto.Email);
    }

    [Fact]
    public void Map_CategoryToCategoryDTO_Works()
    {
        var mapper = BuildRealMapper();

        var category = new Category { Category_Id = 1, Category_Name = "Programming" };

        var dto = mapper.Map<EduLab_Application.DTOs.Category.CategoryDTO>(category);

        Assert.NotNull(dto);
        Assert.Equal("Programming", dto.Category_Name);
    }

    [Fact]
    public void Map_CourseToCourseDTO_Works()
    {
        var mapper = BuildRealMapper();

        var course = new Course
        {
            Id = 1,
            Title = "C# Basics",
            Price = 100,
            Level = "Beginner",
            Language = "Arabic"
        };

        var dto = mapper.Map<EduLab_Application.DTOs.Course.CourseDTO>(course);

        Assert.NotNull(dto);
        Assert.Equal("C# Basics", dto.Title);
        Assert.Equal(100, dto.Price);
    }
}
