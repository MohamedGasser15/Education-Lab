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
        public CategoryService(ICategoryRepository categoryRepository, IMapper mapper)
        {
            _categoryRepository = categoryRepository;
            _mapper = mapper;
        }
        public async Task<IEnumerable<CategoryDTO>> GetAllCategoriesAsync()
        {
            var categories = await _categoryRepository.GetAllAsync();
            if (categories == null)
            {
                throw new KeyNotFoundException($"No categories found");
            }
            return _mapper.Map<IEnumerable<CategoryDTO>>(categories);
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
            return _mapper.Map<CategoryDTO>(category);
        }
        public async Task<CategoryDTO> CreateCategoryAsync(CategoryCreateDTO category)
        {
            if (category == null)
            {
                throw new ArgumentNullException(nameof(category), "Category cannot be null");
            }
            var categoryEntity = _mapper.Map<Category>(category);
            categoryEntity.CreatedAt = DateTime.Now;
            await _categoryRepository.CreateAsync(categoryEntity);
            return _mapper.Map<CategoryDTO>(categoryEntity);
        }
        public async Task<CategoryDTO> UpdateCategoryAsync(CategoryUpdateDTO category)
        {
            if (category == null)
            {
                throw new ArgumentNullException(nameof(category), "Category cannot be null");
            }
            var existingCategory = await _categoryRepository.GetAsync(c => c.Category_Id == category.Category_Id);
            if (existingCategory == null)
            {
                throw new KeyNotFoundException($"No category found with ID {category.Category_Id}");
            }
            var updatedCategory = _mapper.Map(category, existingCategory);
            await _categoryRepository.UpdateAsync(updatedCategory);
            return _mapper.Map<CategoryDTO>(updatedCategory);
        }
        public async Task<bool> DeleteCategoryAsync(int id)
        {
            if (id <= 0)
            {
                throw new ArgumentException("Category ID must be greater than zero.", nameof(id));
            }
            var category = await _categoryRepository.GetAsync(c => c.Category_Id == id);
            if (category == null)
            {
                throw new KeyNotFoundException($"No category found with ID {id}");
            }
            await _categoryRepository.DeleteAsync(category);
            return true;
        }
    }
}
