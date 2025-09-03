using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Category;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for category operations
    /// </summary>
    public class CategoryService : ICategoryService
    {
        private readonly ICategoryRepository _categoryRepository;
        private readonly IMapper _mapper;
        private readonly ICurrentUserService _currentUserService;
        private readonly IHistoryService _historyService;
        private readonly ILogger<CategoryService> _logger;

        /// <summary>
        /// Initializes a new instance of the CategoryService class
        /// </summary>
        /// <param name="categoryRepository">Category repository</param>
        /// <param name="mapper">AutoMapper instance</param>
        /// <param name="currentUserService">Current user service</param>
        /// <param name="historyService">History service</param>
        /// <param name="logger">Logger instance</param>
        public CategoryService(
            ICategoryRepository categoryRepository,
            IMapper mapper,
            ICurrentUserService currentUserService,
            IHistoryService historyService,
            ILogger<CategoryService> logger)
        {
            _categoryRepository = categoryRepository;
            _mapper = mapper;
            _currentUserService = currentUserService;
            _historyService = historyService;
            _logger = logger;
        }

        #region Get Operations

        /// <summary>
        /// Retrieves all categories with their course counts
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of category DTOs</returns>
        public async Task<IEnumerable<CategoryDTO>> GetAllCategoriesAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting all categories");

                var categories = await _categoryRepository.GetAllAsync(
                    includeProperties: "Courses",
                    cancellationToken: cancellationToken);

                if (categories == null || !categories.Any())
                {
                    _logger.LogWarning("No categories found");
                    throw new KeyNotFoundException("No categories found");
                }

                _logger.LogInformation("Retrieved {Count} categories successfully", categories.Count());

                return categories.Select(c => new CategoryDTO
                {
                    Category_Id = c.Category_Id,
                    Category_Name = c.Category_Name,
                    CreatedAt = c.CreatedAt,
                    CoursesCount = c.Courses?.Count ?? 0
                }).ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting all categories");
                throw;
            }
        }

        /// <summary>
        /// Retrieves a category by its ID
        /// </summary>
        /// <param name="id">Category ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Category DTO</returns>
        public async Task<CategoryDTO> GetCategoryByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting category by ID: {CategoryId}", id);

                if (id <= 0)
                {
                    _logger.LogWarning("Invalid category ID: {CategoryId}", id);
                    throw new ArgumentException("Category ID must be greater than zero.", nameof(id));
                }

                var category = await _categoryRepository.GetAsync(
                    c => c.Category_Id == id,
                    includeProperties: "Courses",
                    cancellationToken: cancellationToken
                );

                if (category == null)
                {
                    _logger.LogWarning("Category with ID: {CategoryId} not found", id);
                    throw new KeyNotFoundException($"No category found with ID {id}");
                }

                _logger.LogInformation("Category with ID: {CategoryId} retrieved successfully", id);

                return new CategoryDTO
                {
                    Category_Id = category.Category_Id,
                    Category_Name = category.Category_Name,
                    CreatedAt = category.CreatedAt,
                    CoursesCount = category.Courses?.Count ?? 0
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting category by ID: {CategoryId}", id);
                throw;
            }
        }

        /// <summary>
        /// Retrieves top categories by course count
        /// </summary>
        /// <param name="count">Number of categories to retrieve</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of top category DTOs</returns>
        public async Task<IEnumerable<CategoryDTO>> GetTopCategoriesAsync(int count = 6, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting top {Count} categories", count);

                var categories = await _categoryRepository.GetAllAsync(
                    includeProperties: "Courses",
                    cancellationToken: cancellationToken);

                if (categories == null || !categories.Any())
                {
                    _logger.LogWarning("No categories found");
                    throw new KeyNotFoundException("No categories found");
                }

                var topCategories = categories
                    .Select(c => new CategoryDTO
                    {
                        Category_Id = c.Category_Id,
                        Category_Name = c.Category_Name,
                        CreatedAt = c.CreatedAt,
                        CoursesCount = c.Courses?.Count ?? 0
                    })
                    .OrderByDescending(c => c.CoursesCount)
                    .Take(count)
                    .ToList();

                _logger.LogInformation("Top {Count} categories retrieved successfully", count);

                return topCategories;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting top categories");
                throw;
            }
        }

        #endregion

        #region Create Operations

        /// <summary>
        /// Creates a new category, preventing duplicates by name
        /// </summary>
        /// <param name="category">Category creation DTO</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Created category DTO</returns>
        public async Task<CategoryDTO> CreateCategoryAsync(CategoryCreateDTO category, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Creating new category");

                if (category == null)
                {
                    _logger.LogWarning("Category data is null");
                    throw new ArgumentNullException(nameof(category), "Category cannot be null");
                }

                // تحقق من وجود تصنيف بنفس الاسم
                bool exists = await _categoryRepository.AnyAsync(c => c.Category_Name == category.Category_Name, cancellationToken);
                if (exists)
                {
                    _logger.LogWarning("Category with the same name already exists: {CategoryName}", category.Category_Name);
                    throw new InvalidOperationException($"تصنيف باسم '{category.Category_Name}' موجود بالفعل.");
                }

                var categoryEntity = _mapper.Map<Category>(category);
                categoryEntity.CreatedAt = DateTime.Now;

                await _categoryRepository.CreateAsync(categoryEntity, cancellationToken);

                var currentUserId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(currentUserId))
                {
                    await _historyService.LogOperationAsync(
                        currentUserId,
                        $"قام المستخدم بإنشاء تصنيف جديد [ID: {categoryEntity.Category_Id}] باسم \"{categoryEntity.Category_Name}\".",
                        cancellationToken
                    );
                }

                _logger.LogInformation("Category created successfully with ID: {CategoryId}", categoryEntity.Category_Id);

                return _mapper.Map<CategoryDTO>(categoryEntity);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while creating category");
                throw;
            }
        }

        #endregion


        #region Update Operations

        /// <summary>
        /// Updates an existing category, preventing duplicates by name
        /// </summary>
        /// <param name="category">Category update DTO</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Updated category DTO</returns>
        public async Task<CategoryDTO> UpdateCategoryAsync(CategoryUpdateDTO category, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Updating category with ID: {CategoryId}", category.Category_Id);

                if (category == null)
                {
                    _logger.LogWarning("Category data is null");
                    throw new ArgumentNullException(nameof(category), "Category cannot be null");
                }

                var existingCategory = await _categoryRepository.GetAsync(
                    c => c.Category_Id == category.Category_Id,
                    cancellationToken: cancellationToken);

                if (existingCategory == null)
                {
                    _logger.LogWarning("Category with ID: {CategoryId} not found", category.Category_Id);
                    throw new KeyNotFoundException($"No category found with ID {category.Category_Id}");
                }

                // تحقق من وجود تصنيف بنفس الاسم (غير هذا التصنيف)
                bool exists = await _categoryRepository.AnyAsync(
                    c => c.Category_Name == category.Category_Name && c.Category_Id != category.Category_Id,
                    cancellationToken);

                if (exists)
                {
                    _logger.LogWarning("Another category with the same name already exists: {CategoryName}", category.Category_Name);
                    throw new InvalidOperationException($"تصنيف باسم '{category.Category_Name}' موجود بالفعل.");
                }

                var updatedCategory = _mapper.Map(category, existingCategory);
                await _categoryRepository.UpdateAsync(updatedCategory, cancellationToken);

                var currentUserId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(currentUserId))
                {
                    await _historyService.LogOperationAsync(
                        currentUserId,
                        $"قام المستخدم بتحديث التصنيف [ID: {updatedCategory.Category_Id}] باسم \"{updatedCategory.Category_Name}\".",
                        cancellationToken
                    );
                }

                _logger.LogInformation("Category with ID: {CategoryId} updated successfully", category.Category_Id);

                return _mapper.Map<CategoryDTO>(updatedCategory);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while updating category with ID: {CategoryId}", category.Category_Id);
                throw;
            }
        }

        #endregion

        #region Delete Operations

        /// <summary>
        /// Deletes a category by its ID
        /// </summary>
        /// <param name="id">Category ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if deletion was successful</returns>
        public async Task<bool> DeleteCategoryAsync(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Deleting category with ID: {CategoryId}", id);

                if (id <= 0)
                {
                    _logger.LogWarning("Invalid category ID: {CategoryId}", id);
                    throw new ArgumentException("Category ID must be greater than zero.", nameof(id));
                }

                var category = await _categoryRepository.GetAsync(
                    c => c.Category_Id == id,
                    includeProperties: "Courses", // assuming navigation property name is Courses
                    cancellationToken: cancellationToken);

                if (category == null)
                {
                    _logger.LogWarning("Category with ID: {CategoryId} not found", id);
                    throw new KeyNotFoundException($"No category found with ID {id}");
                }

                // تحقق إذا التصنيف مرتبط بكورسات
                if (category.Courses != null && category.Courses.Any())
                {
                    _logger.LogWarning("Cannot delete category with ID {CategoryId} because it has related courses", id);
                    throw new InvalidOperationException("لا يمكن حذف هذا التصنيف لأنه مرتبط بكورسات.");
                }

                await _categoryRepository.DeleteAsync(category, cancellationToken);

                var currentUserId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(currentUserId))
                {
                    await _historyService.LogOperationAsync(
                        currentUserId,
                        $"قام المستخدم بحذف التصنيف [ID: {category.Category_Id}] باسم \"{category.Category_Name}\".",
                        cancellationToken
                    );
                }

                _logger.LogInformation("Category with ID: {CategoryId} deleted successfully", id);

                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while deleting category with ID: {CategoryId}", id);
                throw;
            }
        }

        #endregion

    }
}