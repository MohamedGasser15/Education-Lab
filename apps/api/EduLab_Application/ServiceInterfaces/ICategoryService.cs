using EduLab_Domain.Entities;
using EduLab_Application.DTOs.Category;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for managing course categories
    /// </summary>
    public interface ICategoryService
    {
        /// <summary>
        /// Retrieves all categories
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of category DTOs</returns>
        Task<IEnumerable<CategoryDTO>> GetAllCategoriesAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a category by its ID
        /// </summary>
        /// <param name="id">Unique identifier of the category</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Category DTO or null if not found</returns>
        Task<CategoryDTO> GetCategoryByIdAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the top categories by popularity
        /// </summary>
        /// <param name="count">Maximum number of categories to return</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of top category DTOs</returns>
        Task<IEnumerable<CategoryDTO>> GetTopCategoriesAsync(int count = 6, CancellationToken cancellationToken = default);

        /// <summary>
        /// Creates a new category
        /// </summary>
        /// <param name="category">Category creation DTO</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The created category DTO</returns>
        Task<CategoryDTO> CreateCategoryAsync(CategoryCreateDTO category, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing category
        /// </summary>
        /// <param name="category">Category update DTO</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The updated category DTO</returns>
        Task<CategoryDTO> UpdateCategoryAsync(CategoryUpdateDTO category, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a category by its ID
        /// </summary>
        /// <param name="id">Unique identifier of the category</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the category was deleted, otherwise false</returns>
        Task<bool> DeleteCategoryAsync(int id, CancellationToken cancellationToken = default);
    }
}