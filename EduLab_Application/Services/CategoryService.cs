using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Category;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class CategoryService : ICategoryService
    {
        private readonly ICategoryRepository _categoryRepository;
        private readonly IMapper _mapper;
        private readonly ICurrentUserService _currentUserService;
        private readonly IHistoryService _historyService;
        public CategoryService(ICategoryRepository categoryRepository, IMapper mapper, ICurrentUserService currentUserService, IHistoryService historyService)
        {
            _categoryRepository = categoryRepository;
            _mapper = mapper;
            _currentUserService = currentUserService;
            _historyService = historyService;
        }
        public async Task<IEnumerable<CategoryDTO>> GetAllCategoriesAsync()
        {
            // هتعمل Include للـ Courses عشان تقدر تحسب
            var categories = await _categoryRepository.GetAllAsync(includeProperties: "Courses");
            if (categories == null || !categories.Any())
            {
                throw new KeyNotFoundException("No categories found");
            }

            // نرجّع DTO مع CoursesCount
            return categories.Select(c => new CategoryDTO
            {
                Category_Id = c.Category_Id,
                Category_Name = c.Category_Name,
                CreatedAt = c.CreatedAt,
                CoursesCount = c.Courses?.Count ?? 0
            }).ToList();
        }

        public async Task<CategoryDTO> GetCategoryByIdAsync(int id)
        {
            if (id <= 0)
            {
                throw new ArgumentException("Category ID must be greater than zero.", nameof(id));
            }

            var category = await _categoryRepository.GetAsync(
                c => c.Category_Id == id,
                includeProperties: "Courses"
            );

            if (category == null)
            {
                throw new KeyNotFoundException($"No category found with ID {id}");
            }

            // هنا كمان نحسب CoursesCount
            return new CategoryDTO
            {
                Category_Id = category.Category_Id,
                Category_Name = category.Category_Name,
                CreatedAt = category.CreatedAt,
                CoursesCount = category.Courses?.Count ?? 0
            };
        }
        public async Task<IEnumerable<CategoryDTO>> GetTopCategoriesAsync(int count = 6)
        {
            // نجيب كل الكاتيجوريز مع الكورسات
            var categories = await _categoryRepository.GetAllAsync(includeProperties: "Courses");

            if (categories == null || !categories.Any())
            {
                throw new KeyNotFoundException("No categories found");
            }

            // نرتبهم تنازلي حسب عدد الكورسات وناخد أول 6
            return categories
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
        }

        public async Task<CategoryDTO> CreateCategoryAsync(CategoryCreateDTO category)
        {
            if (category == null)
                throw new ArgumentNullException(nameof(category), "Category cannot be null");

            var categoryEntity = _mapper.Map<Category>(category);
            categoryEntity.CreatedAt = DateTime.Now;
            await _categoryRepository.CreateAsync(categoryEntity);

            var currentUserId = await _currentUserService.GetUserIdAsync();
            if (!string.IsNullOrEmpty(currentUserId))
            {
                await _historyService.LogOperationAsync(
                    currentUserId,
                    $"قام المستخدم بإنشاء تصنيف جديد [ID: {categoryEntity.Category_Id}] باسم \"{categoryEntity.Category_Name}\"."
                );

            }

            return _mapper.Map<CategoryDTO>(categoryEntity);
        }

        public async Task<CategoryDTO> UpdateCategoryAsync(CategoryUpdateDTO category)
        {
            if (category == null)
                throw new ArgumentNullException(nameof(category), "Category cannot be null");

            var existingCategory = await _categoryRepository.GetAsync(c => c.Category_Id == category.Category_Id);
            if (existingCategory == null)
                throw new KeyNotFoundException($"No category found with ID {category.Category_Id}");

            var updatedCategory = _mapper.Map(category, existingCategory);
            await _categoryRepository.UpdateAsync(updatedCategory);

            var currentUserId = await _currentUserService.GetUserIdAsync();
            if (!string.IsNullOrEmpty(currentUserId))
            {
                await _historyService.LogOperationAsync(
                    currentUserId,
                    $"قام المستخدم بتحديث التصنيف [ID: {updatedCategory.Category_Id}] باسم \"{updatedCategory.Category_Name}\"."
                );
            }

            return _mapper.Map<CategoryDTO>(updatedCategory);
        }

        public async Task<bool> DeleteCategoryAsync(int id)
        {
            if (id <= 0)
                throw new ArgumentException("Category ID must be greater than zero.", nameof(id));

            var category = await _categoryRepository.GetAsync(c => c.Category_Id == id);
            if (category == null)
                throw new KeyNotFoundException($"No category found with ID {id}");

            await _categoryRepository.DeleteAsync(category);

            var currentUserId = await _currentUserService.GetUserIdAsync();
            if (!string.IsNullOrEmpty(currentUserId))
            {
                await _historyService.LogOperationAsync(
                    currentUserId,
                    $"قام المستخدم بحذف التصنيف [ID: {category.Category_Id}] باسم \"{category.Category_Name}\"."
                );
            }

            return true;
        }
    }
}
