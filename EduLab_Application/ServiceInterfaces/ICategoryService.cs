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
        Task<IEnumerable<CategoryDTO>> GetAllCategoriesAsync(CancellationToken cancellationToken = default);
        Task<CategoryDTO> GetCategoryByIdAsync(int id, CancellationToken cancellationToken = default);
        Task<IEnumerable<CategoryDTO>> GetTopCategoriesAsync(int count = 6, CancellationToken cancellationToken = default);
        Task<CategoryDTO> CreateCategoryAsync(CategoryCreateDTO category, CancellationToken cancellationToken = default);
        Task<CategoryDTO> UpdateCategoryAsync(CategoryUpdateDTO category, CancellationToken cancellationToken = default);
        Task<bool> DeleteCategoryAsync(int id, CancellationToken cancellationToken = default);
    }
}
