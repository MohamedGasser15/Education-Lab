using EduLab_API.Controllers.Admin;
using EduLab_Application.DTOs.Category;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class CategoryControllerTests
{
    private readonly Mock<ICategoryService> _categoryService;
    private readonly Mock<ICurrentUserService> _currentUserService;
    private readonly Mock<IHistoryService> _historyService;
    private readonly CategoryController _controller;

    public CategoryControllerTests()
    {
        _categoryService = new Mock<ICategoryService>();
        _currentUserService = new Mock<ICurrentUserService>();
        _historyService = new Mock<IHistoryService>();
        _controller = new CategoryController(
            _categoryService.Object,
            _currentUserService.Object,
            _historyService.Object,
            Mock.Of<ILogger<CategoryController>>());
    }

    private static CategoryDTO Category(int id, string name) =>
        new() { Category_Id = id, Category_Name = name, CreatedAt = DateTime.UtcNow };

    [Fact]
    public async Task GetCategories_WhenNone_ReturnsNotFound()
    {
        _categoryService.Setup(x => x.GetAllCategoriesAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<CategoryDTO>());

        var result = await _controller.GetCategories();

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task GetCategories_ReturnsOkWithCategories()
    {
        var categories = new List<CategoryDTO> { Category(1, "برمجة") };
        _categoryService.Setup(x => x.GetAllCategoriesAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(categories);

        var result = await _controller.GetCategories();

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(categories, ok.Value);
    }

    [Fact]
    public async Task GetCategoryById_WhenNotFound_ReturnsNotFound()
    {
        _categoryService.Setup(x => x.GetCategoryByIdAsync(99, It.IsAny<CancellationToken>()))
            .ReturnsAsync((CategoryDTO?)null);

        var result = await _controller.GetCategoryById(99);

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task GetCategoryById_ReturnsOkWithCategory()
    {
        var category = Category(1, "برمجة");
        _categoryService.Setup(x => x.GetCategoryByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(category);

        var result = await _controller.GetCategoryById(1);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(category, ok.Value);
    }

    [Fact]
    public async Task CreateCategory_WithNullName_ReturnsBadRequest()
    {
        _controller.ModelState.AddModelError("Category_Name", "The Category_Name field is required.");

        var result = await _controller.CreateCategory(new CategoryCreateDTO { Category_Name = null! });

        Assert.IsType<BadRequestObjectResult>(result);
        _categoryService.Verify(x => x.CreateCategoryAsync(It.IsAny<CategoryCreateDTO>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task CreateCategory_ReturnsCreatedAtAction()
    {
        var dto = new CategoryCreateDTO { Category_Name = "تصميم" };
        var created = Category(5, "تصميم");
        _categoryService.Setup(x => x.CreateCategoryAsync(dto, It.IsAny<CancellationToken>()))
            .ReturnsAsync(created);

        var result = await _controller.CreateCategory(dto);

        var createdResult = Assert.IsType<CreatedAtActionResult>(result);
        Assert.Equal(created, createdResult.Value);
        Assert.Equal(nameof(CategoryController.GetCategoryById), createdResult.ActionName);
    }

    [Fact]
    public async Task UpdateCategory_ReturnsOkWithUpdatedCategory()
    {
        var dto = new CategoryUpdateDTO { Category_Id = 1, Category_Name = "برمجة متقدمة" };
        var updated = Category(1, "برمجة متقدمة");
        _categoryService.Setup(x => x.UpdateCategoryAsync(dto, It.IsAny<CancellationToken>()))
            .ReturnsAsync(updated);

        var result = await _controller.UpdateCategory(dto);

        var ok = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(updated, ok.Value);
    }

    [Fact]
    public async Task DeleteCategory_WhenCategoryHasCourses_ReturnsServerError()
    {
        _categoryService.Setup(x => x.GetCategoryByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(Category(1, "برمجة"));
        _categoryService.Setup(x => x.DeleteCategoryAsync(1, It.IsAny<CancellationToken>()))
            .ThrowsAsync(new InvalidOperationException("لا يمكن حذف هذا التصنيف لأنه مرتبط بكورسات."));

        var result = await _controller.DeleteCategory(1);

        var statusCode = Assert.IsType<ObjectResult>(result);
        Assert.Equal(500, statusCode.StatusCode);
    }

    [Fact]
    public async Task DeleteCategory_WhenCategoryNotFound_ReturnsNotFound()
    {
        _categoryService.Setup(x => x.GetCategoryByIdAsync(99, It.IsAny<CancellationToken>()))
            .ReturnsAsync((CategoryDTO?)null);
        _categoryService.Setup(x => x.DeleteCategoryAsync(99, It.IsAny<CancellationToken>()))
            .ReturnsAsync(false);

        var result = await _controller.DeleteCategory(99);

        Assert.IsType<NotFoundObjectResult>(result);
    }

    [Fact]
    public async Task DeleteCategory_Success_ReturnsNoContent()
    {
        _categoryService.Setup(x => x.GetCategoryByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(Category(1, "برمجة"));
        _categoryService.Setup(x => x.DeleteCategoryAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);

        var result = await _controller.DeleteCategory(1);

        Assert.IsType<NoContentResult>(result);
    }

    [Fact]
    public async Task DeleteCategory_WhenProtectedCategory_ReturnsBadRequest_AndDoesNotDelete()
    {
        _categoryService.Setup(x => x.GetCategoryByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(new CategoryDTO { Category_Id = 1, Category_Name = "برمجة", Category_EnglishName = "Programming", CreatedAt = DateTime.UtcNow });

        var result = await _controller.DeleteCategory(1);

        var badRequest = Assert.IsType<BadRequestObjectResult>(result);
        Assert.Contains("protected", badRequest.Value?.ToString() ?? "", StringComparison.OrdinalIgnoreCase);
        _categoryService.Verify(x => x.DeleteCategoryAsync(It.IsAny<int>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task BulkDeleteCategories_WhenIncludesProtected_ReturnsBadRequest_AndDoesNotDelete()
    {
        _categoryService.Setup(x => x.GetAllCategoriesAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<CategoryDTO>
            {
                new CategoryDTO { Category_Id = 1, Category_Name = "برمجة", Category_EnglishName = "Programming", CreatedAt = DateTime.UtcNow },
                new CategoryDTO { Category_Id = 9, Category_Name = "Custom", Category_EnglishName = "Custom Category", CreatedAt = DateTime.UtcNow }
            });

        var result = await _controller.BulkDeleteCategories("1,9");

        var badRequest = Assert.IsType<BadRequestObjectResult>(result);
        Assert.Contains("protected", badRequest.Value?.ToString() ?? "", StringComparison.OrdinalIgnoreCase);
        _categoryService.Verify(x => x.DeleteCategoryAsync(It.IsAny<int>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task BulkDeleteCategories_AllDeletable_Succeeds()
    {
        _categoryService.Setup(x => x.GetAllCategoriesAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<CategoryDTO>
            {
                new CategoryDTO { Category_Id = 9, Category_Name = "Custom", Category_EnglishName = "Custom Category", CreatedAt = DateTime.UtcNow },
                new CategoryDTO { Category_Id = 10, Category_Name = "Another", Category_EnglishName = "Another Category", CreatedAt = DateTime.UtcNow }
            });
        _categoryService.Setup(x => x.DeleteCategoryAsync(It.IsAny<int>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);

        var result = await _controller.BulkDeleteCategories("9,10");

        Assert.IsType<OkObjectResult>(result);
        _categoryService.Verify(x => x.DeleteCategoryAsync(It.IsAny<int>(), It.IsAny<CancellationToken>()), Times.Exactly(2));
    }
}
