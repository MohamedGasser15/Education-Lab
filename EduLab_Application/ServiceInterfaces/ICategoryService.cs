using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Category;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface ICategoryService
    {
        Task<IEnumerable<CategoryDTO>> GetAllCategoriesAsync();
        Task<CategoryDTO> GetCategoryByIdAsync(int id);
        Task<CategoryDTO> CreateCategoryAsync(CategoryCreateDTO category);
        Task<CategoryDTO> UpdateCategoryAsync(CategoryUpdateDTO category);
        Task<bool> DeleteCategoryAsync(int id);
    }
}
