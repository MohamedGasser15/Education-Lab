using EduLab_MVC.Common;
using EduLab_MVC.Models.DTOs.Category;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.Extensions.Caching.Memory;
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
        private readonly IMemoryCache _cache;
        private const string AllCategoriesCacheKey = "Mvc_All_Categories";
        private static readonly TimeSpan DefaultCacheDuration = TimeSpan.FromMinutes(15);

        /// <summary>
        /// Initializes a new instance of the CategoryService class
        /// </summary>
        /// <param name="logger">Logger instance</param>
        /// <param name="httpClientService">HTTP client service</param>
        /// <param name="cache">Memory cache instance</param>
        public CategoryService(
            ILogger<CategoryService> logger,
            IAuthorizedHttpClientService httpClientService,
            IMemoryCache cache)
        {
            _logger = logger;
            _httpClientService = httpClientService;
            _cache = cache;
        }

        private void InvalidateCategoryCache()
        {
            _cache.Remove(AllCategoriesCacheKey);
            _cache.Remove("Mvc_Top_Categories_4");
            _cache.Remove("Mvc_Top_Categories_6");
            _cache.Remove("Mvc_Top_Categories_8");
            _cache.Remove("Mvc_Top_Categories_10");
            _cache.Remove("Learner_Categories_With_Courses");
            _cache.Remove("Learner_Categories_Suggest");
            _logger.LogInformation("Category caches invalidated");
        }

        #region Get Operations

        /// <summary>
        /// Retrieves all categories
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of categories</returns>
        public async Task<List<CategoryDTO>> GetAllCategoriesAsync(CancellationToken cancellationToken = default)
        {
            if (_cache.TryGetValue(AllCategoriesCacheKey, out List<CategoryDTO>? cached) && cached != null)
            {
                return cached;
            }

            try
            {
                _logger.LogDebug("Getting all categories from API");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync(ApiEndpoints.Categories.Base, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var categories = JsonConvert.DeserializeObject<List<CategoryDTO>>(content) ?? new List<CategoryDTO>();

                    _logger.LogInformation("Retrieved {Count} categories successfully", categories.Count);
                    _cache.Set(AllCategoriesCacheKey, categories, DefaultCacheDuration);
                    return categories;
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
            var cacheKey = $"Mvc_Top_Categories_{count}";
            if (_cache.TryGetValue(cacheKey, out List<CategoryDTO>? cached) && cached != null)
            {
                return cached;
            }

            try
            {
                _logger.LogDebug("Getting top {Count} categories from API", count);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"{ApiEndpoints.Categories.Top}?count={count}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var categories = JsonConvert.DeserializeObject<List<CategoryDTO>>(content) ?? new List<CategoryDTO>();

                    _logger.LogInformation("Retrieved top {Count} categories successfully", categories.Count);
                    _cache.Set(cacheKey, categories, DefaultCacheDuration);
                    return categories;
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
                var response = await client.PostAsync(ApiEndpoints.Categories.Base, jsonContent, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var createdCategory = JsonConvert.DeserializeObject<CategoryDTO>(content);

                    _logger.LogInformation("Category created successfully with ID: {CategoryId}", createdCategory?.Category_Id);
                    InvalidateCategoryCache();
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
                var response = await client.PutAsync(ApiEndpoints.Categories.Base, jsonContent, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var updatedCategory = JsonConvert.DeserializeObject<CategoryDTO>(content);

                    _logger.LogInformation("Category with ID: {CategoryId} updated successfully", dto.Category_Id);
                    InvalidateCategoryCache();
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
                var response = await client.DeleteAsync($"{ApiEndpoints.Categories.Base}/{id}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    // Deletion succeeded
                    _logger.LogInformation("Category with ID: {CategoryId} deleted successfully", id);
                    InvalidateCategoryCache();
                    return true;
                }

                // Read the error content returned by the API
                var content = await response.Content.ReadAsStringAsync(cancellationToken);
                _logger.LogWarning("Failed to delete category {CategoryId}. Response: {Content}", id, content);

                // Workaround: parse the JSON and use only the "error" field
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
                var response = await client.DeleteAsync($"{ApiEndpoints.Categories.BulkDelete}?ids={idsString}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("Bulk delete completed successfully for categories: {Ids}", idsString);
                    InvalidateCategoryCache();
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