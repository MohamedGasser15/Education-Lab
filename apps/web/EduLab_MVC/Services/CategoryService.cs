using EduLab_MVC.Models.DTOs.Category;
using EduLab_MVC.Services.ServiceInterfaces;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Text;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// Service for managing categories in MVC application
    /// </summary>
    public class CategoryService : ICategoryService
    {
        private readonly ILogger<CategoryService> _logger;
        private readonly IAuthorizedHttpClientService _httpClientService;

        /// <summary>
        /// Initializes a new instance of the CategoryService class
        /// </summary>
        /// <param name="logger">Logger instance</param>
        /// <param name="httpClientService">HTTP client service</param>
        public CategoryService(ILogger<CategoryService> logger, IAuthorizedHttpClientService httpClientService)
        {
            _logger = logger;
            _httpClientService = httpClientService;
        }

        #region Get Operations

        /// <summary>
        /// Retrieves all categories
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of categories</returns>
        public async Task<List<CategoryDTO>> GetAllCategoriesAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting all categories from API");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("Category", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var categories = JsonConvert.DeserializeObject<List<CategoryDTO>>(content);

                    _logger.LogInformation("Retrieved {Count} categories successfully", categories?.Count ?? 0);
                    return categories ?? new List<CategoryDTO>();
                }

                _logger.LogWarning("Failed to get categories. Status code: {StatusCode}", response.StatusCode);
                return new List<CategoryDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching categories");
                return new List<CategoryDTO>();
            }
        }

        /// <summary>
        /// Retrieves top categories by course count
        /// </summary>
        /// <param name="count">Number of categories to retrieve</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of top categories</returns>
        public async Task<List<CategoryDTO>> GetTopCategoriesAsync(int count = 6, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting top {Count} categories from API", count);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"Category/top?count={count}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var categories = JsonConvert.DeserializeObject<List<CategoryDTO>>(content);

                    _logger.LogInformation("Retrieved top {Count} categories successfully", categories?.Count ?? 0);
                    return categories ?? new List<CategoryDTO>();
                }

                _logger.LogWarning("Failed to get top categories. Status code: {StatusCode}", response.StatusCode);
                return new List<CategoryDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching top categories");
                return new List<CategoryDTO>();
            }
        }

        #endregion

        #region Create Operations

        /// <summary>
        /// Creates a new category
        /// </summary>
        /// <param name="dto">Category creation DTO</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Created category DTO</returns>
        public async Task<CategoryDTO?> CreateCategoryAsync(CategoryCreateDTO dto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Creating new category");

                var client = _httpClientService.CreateClient();
                var jsonContent = new StringContent(JsonConvert.SerializeObject(dto), Encoding.UTF8, "application/json");
                var response = await client.PostAsync("Category", jsonContent, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var createdCategory = JsonConvert.DeserializeObject<CategoryDTO>(content);

                    _logger.LogInformation("Category created successfully with ID: {CategoryId}", createdCategory?.Category_Id);
                    return createdCategory;
                }

                _logger.LogWarning("Failed to create category. Status code: {StatusCode}", response.StatusCode);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while creating category");
                return null;
            }
        }

        #endregion

        #region Update Operations

        /// <summary>
        /// Updates an existing category
        /// </summary>
        /// <param name="dto">Category update DTO</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Updated category DTO</returns>
        public async Task<CategoryDTO?> UpdateCategoryAsync(CategoryUpdateDTO dto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Updating category with ID: {CategoryId}", dto.Category_Id);

                var client = _httpClientService.CreateClient();
                var jsonContent = new StringContent(JsonConvert.SerializeObject(dto), Encoding.UTF8, "application/json");
                var response = await client.PutAsync("Category", jsonContent, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var updatedCategory = JsonConvert.DeserializeObject<CategoryDTO>(content);

                    _logger.LogInformation("Category with ID: {CategoryId} updated successfully", dto.Category_Id);
                    return updatedCategory;
                }

                _logger.LogWarning("Failed to update category {CategoryId}. Status code: {StatusCode}", dto.Category_Id, response.StatusCode);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while updating category {CategoryId}", dto.Category_Id);
                return null;
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
                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync($"Category/{id}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    // تم الحذف
                    _logger.LogInformation("Category with ID: {CategoryId} deleted successfully", id);
                    return true;
                }

                // اقرأ محتوى الخطأ من الـ API
                var content = await response.Content.ReadAsStringAsync(cancellationToken);
                _logger.LogWarning("Failed to delete category {CategoryId}. Response: {Content}", id, content);

                // حل: parse JSON واستخدم حقل error فقط
                var json = JsonConvert.DeserializeObject<JObject>(content);
                var userMessage = json?["error"]?.ToString() ?? "حدث خطأ أثناء حذف التصنيف";

                throw new InvalidOperationException(userMessage);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while deleting category {CategoryId}", id);
                throw;
            }
        }

        /// <summary>
        /// Deletes multiple categories in bulk
        /// </summary>
        /// <param name="ids">List of category IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if bulk deletion was successful</returns>
        public async Task<bool> BulkDeleteCategoriesAsync(List<int> ids, CancellationToken cancellationToken = default)
        {
            try
            {
                if (ids == null || !ids.Any())
                {
                    _logger.LogWarning("No category IDs provided for bulk delete");
                    return false;
                }

                var idsString = string.Join(",", ids);
                _logger.LogDebug("Bulk deleting categories with IDs: {Ids}", idsString);

                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync($"Category/bulk?ids={idsString}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("Bulk delete completed successfully for categories: {Ids}", idsString);
                    return true;
                }

                _logger.LogWarning("Failed to bulk delete categories. Status code: {StatusCode}", response.StatusCode);
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while bulk deleting categories");
                return false;
            }
        }
        #endregion
    }
}