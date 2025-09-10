using EduLab_MVC.Models.DTOs.Category;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for managing categories in MVC application
    /// </summary>
    public interface ICategoryService
    {
        /// <summary>
        /// Retrieves all categories
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of categories</returns>
        Task<List<CategoryDTO>> GetAllCategoriesAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves top categories by course count
        /// </summary>
        /// <param name="count">Number of categories to retrieve</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of top categories</returns>
        Task<List<CategoryDTO>> GetTopCategoriesAsync(int count = 6, CancellationToken cancellationToken = default);

        /// <summary>
        /// Creates a new category
        /// </summary>
        /// <param name="dto">Category creation DTO</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Created category DTO</returns>
        Task<CategoryDTO?> CreateCategoryAsync(CategoryCreateDTO dto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an existing category
        /// </summary>
        /// <param name="dto">Category update DTO</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Updated category DTO</returns>
        Task<CategoryDTO?> UpdateCategoryAsync(CategoryUpdateDTO dto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a category by its ID
        /// </summary>
        /// <param name="id">Category ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if deletion was successful</returns>
        Task<bool> DeleteCategoryAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes multiple categories in bulk
        /// </summary>
        /// <param name="ids">List of category IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if bulk deletion was successful</returns>
        Task<bool> BulkDeleteCategoriesAsync(List<int> ids, CancellationToken cancellationToken = default);
    }
}
