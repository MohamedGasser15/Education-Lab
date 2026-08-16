using EduLab_Application.DTOs.Category;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab.Tests.Fakes;
using Moq;
using System.Linq.Expressions;
using Xunit;

namespace EduLab.Tests.Services;

public class CategoryServiceTests
{
    private class FakeCategoryRepository : FakeRepository<Category>, ICategoryRepository
    {
        public Task<Category> UpdateAsync(Category entity, CancellationToken cancellationToken = default)
        {
            var index = Items.FindIndex(c => c.Category_Id == entity.Category_Id);
            if (index >= 0)
                Items[index] = entity;
            else
                Items.Add(entity);
            return Task.FromResult(entity);
        }
    }

    private static Category Category(int id, string name, string? englishName = null, int courseCount = 0)
    {
        var category = new Category
        {
            Category_Id = id,
            Category_Name = name,
            Category_EnglishName = englishName,
            CreatedAt = DateTime.UtcNow.AddDays(-id)
        };
        for (var i = 0; i < courseCount; i++)
            category.Courses.Add(TestData.Course(100 + id * 10 + i, $"Course {id}-{i}", categoryId: id));
        return category;
    }

    private readonly FakeCategoryRepository _repository;
    private readonly CategoryService _service;

    public CategoryServiceTests()
    {
        _repository = new FakeCategoryRepository();
        _service = new CategoryService(
            _repository,
            TestInfrastructure.RealMapper(),
            Mock.Of<ICurrentUserService>(),
            TestData.NullLogger<CategoryService>());
    }

    [Fact]
    public async Task GetAllCategoriesAsync_ReturnsCategoriesWithCourseCounts()
    {
        _repository.Items.Add(Category(1, "برمجة", "Programming", 2));
        _repository.Items.Add(Category(2, "تصميم", "Design", 0));

        var result = (await _service.GetAllCategoriesAsync()).ToList();

        Assert.Equal(2, result.Count);
        Assert.Equal(2, result[0].CoursesCount);
        Assert.Equal(0, result[1].CoursesCount);
        Assert.Equal("برمجة", result[0].Category_Name);
        Assert.Equal("Programming", result[0].Category_EnglishName);
    }

    [Fact]
    public async Task GetAllCategoriesAsync_WhenEmpty_ThrowsKeyNotFound()
    {
        await Assert.ThrowsAsync<KeyNotFoundException>(() => _service.GetAllCategoriesAsync());
    }

    [Fact]
    public async Task GetCategoryByIdAsync_ReturnsCategory()
    {
        _repository.Items.Add(Category(5, "تسويق", "Marketing", 3));

        var result = await _service.GetCategoryByIdAsync(5);

        Assert.Equal(5, result.Category_Id);
        Assert.Equal("تسويق", result.Category_Name);
        Assert.Equal(3, result.CoursesCount);
    }

    [Theory]
    [InlineData(0)]
    [InlineData(-1)]
    public async Task GetCategoryByIdAsync_InvalidId_ThrowsArgumentException(int id)
    {
        await Assert.ThrowsAsync<ArgumentException>(() => _service.GetCategoryByIdAsync(id));
    }

    [Fact]
    public async Task GetCategoryByIdAsync_NotFound_ThrowsKeyNotFound()
    {
        await Assert.ThrowsAsync<KeyNotFoundException>(() => _service.GetCategoryByIdAsync(99));
    }

    [Fact]
    public async Task CreateCategoryAsync_AddsNewCategory()
    {
        var dto = new CategoryCreateDTO { Category_Name = "أمن سيبراني", Category_EnglishName = "Cybersecurity" };

        var result = await _service.CreateCategoryAsync(dto);

        Assert.Equal("أمن سيبراني", result.Category_Name);
        Assert.Equal("Cybersecurity", result.Category_EnglishName);
        Assert.True(result.CreatedAt > DateTime.MinValue);

        var stored = Assert.Single(_repository.Items);
        Assert.Equal("أمن سيبراني", stored.Category_Name);
    }

    [Fact]
    public async Task CreateCategoryAsync_DuplicateName_ThrowsInvalidOperation()
    {
        _repository.Items.Add(Category(1, "برمجة"));
        var dto = new CategoryCreateDTO { Category_Name = "برمجة" };

        await Assert.ThrowsAsync<InvalidOperationException>(() => _service.CreateCategoryAsync(dto));
    }

    [Fact]
    public async Task CreateCategoryAsync_NullDto_ThrowsArgumentNull()
    {
        await Assert.ThrowsAsync<ArgumentNullException>(() => _service.CreateCategoryAsync(null!));
    }

    [Fact]
    public async Task UpdateCategoryAsync_UpdatesExistingCategory()
    {
        _repository.Items.Add(Category(1, "برمجة", "Programming", 2));

        var result = await _service.UpdateCategoryAsync(new CategoryUpdateDTO
        {
            Category_Id = 1,
            Category_Name = "البرمجة",
            Category_EnglishName = "Programming"
        });

        Assert.Equal("البرمجة", result.Category_Name);
        var stored = Assert.Single(_repository.Items);
        Assert.Equal("البرمجة", stored.Category_Name);
        Assert.Equal(2, stored.Courses.Count);
    }

    [Fact]
    public async Task UpdateCategoryAsync_NotFound_ThrowsKeyNotFound()
    {
        await Assert.ThrowsAsync<KeyNotFoundException>(() => _service.UpdateCategoryAsync(
            new CategoryUpdateDTO { Category_Id = 42, Category_Name = "X" }));
    }

    [Fact]
    public async Task UpdateCategoryAsync_DuplicateNameOnOtherCategory_ThrowsInvalidOperation()
    {
        _repository.Items.Add(Category(1, "برمجة"));
        _repository.Items.Add(Category(2, "تصميم"));

        await Assert.ThrowsAsync<InvalidOperationException>(() => _service.UpdateCategoryAsync(
            new CategoryUpdateDTO { Category_Id = 2, Category_Name = "برمجة" }));
    }

    [Fact]
    public async Task DeleteCategoryAsync_RemovesCategory()
    {
        _repository.Items.Add(Category(1, "برمجة"));

        var result = await _service.DeleteCategoryAsync(1);

        Assert.True(result);
        Assert.Empty(_repository.Items);
    }

    [Fact]
    public async Task DeleteCategoryAsync_WithRelatedCourses_ThrowsInvalidOperation()
    {
        _repository.Items.Add(Category(1, "برمجة", courseCount: 1));

        await Assert.ThrowsAsync<InvalidOperationException>(() => _service.DeleteCategoryAsync(1));
        Assert.Single(_repository.Items);
    }

    [Fact]
    public async Task DeleteCategoryAsync_NotFound_ThrowsKeyNotFound()
    {
        await Assert.ThrowsAsync<KeyNotFoundException>(() => _service.DeleteCategoryAsync(77));
    }

    [Theory]
    [InlineData(0)]
    [InlineData(-5)]
    public async Task DeleteCategoryAsync_InvalidId_ThrowsArgumentException(int id)
    {
        await Assert.ThrowsAsync<ArgumentException>(() => _service.DeleteCategoryAsync(id));
    }

    [Fact]
    public async Task GetTopCategoriesAsync_OrdersByCourseCountDescending()
    {
        _repository.Items.Add(Category(1, "A", courseCount: 1));
        _repository.Items.Add(Category(2, "B", courseCount: 3));
        _repository.Items.Add(Category(3, "C", courseCount: 2));

        var result = (await _service.GetTopCategoriesAsync(2)).ToList();

        Assert.Equal(2, result.Count);
        Assert.Equal("B", result[0].Category_Name);
        Assert.Equal("C", result[1].Category_Name);
    }
}
