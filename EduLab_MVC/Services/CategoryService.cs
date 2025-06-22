using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Microsoft.Extensions.Logging;
using EduLab_MVC.Models.DTOs.Category;
using System.Text;

public class CategoryService
{
    private readonly IHttpClientFactory _clientFactory;
    private readonly ILogger<CategoryService> _logger;

    public CategoryService(IHttpClientFactory clientFactory, ILogger<CategoryService> logger)
    {
        _clientFactory = clientFactory;
        _logger = logger;
    }

    public async Task<List<CategoryDTO>> GetAllCategoriesAsync()
    {
        try
        {
            var client = _clientFactory.CreateClient("EduLabAPI");
            var response = await client.GetAsync("Category");

            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                var categories = JsonConvert.DeserializeObject<List<CategoryDTO>>(content);
                return categories ?? new List<CategoryDTO>();
            }
            else
            {
                _logger.LogWarning($"Failed to get categories. Status code: {response.StatusCode}");
                return new List<CategoryDTO>();
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while fetching categories.");
            return new List<CategoryDTO>();
        }
    }

    public async Task<CategoryDTO?> CreateCategoryAsync(CategoryCreateDTO dto)
    {
        try
        {
            var client = _clientFactory.CreateClient("EduLabAPI");

            var jsonContent = new StringContent(
                JsonConvert.SerializeObject(dto),
                Encoding.UTF8,
                "application/json");

            var response = await client.PostAsync("Category", jsonContent);

            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                return JsonConvert.DeserializeObject<CategoryDTO>(content);
            }

            _logger.LogWarning($"Failed to create category. Status code: {response.StatusCode}");
            return null;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Exception occurred while creating category.");
            return null;
        }
    }

    public async Task<CategoryDTO?> UpdateCategoryAsync(CategoryUpdateDTO dto)
    {
        try
        {
            var client = _clientFactory.CreateClient("EduLabAPI");

            var jsonContent = new StringContent(
                JsonConvert.SerializeObject(dto),
                Encoding.UTF8,
                "application/json");

            var response = await client.PutAsync("Category", jsonContent);

            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                return JsonConvert.DeserializeObject<CategoryDTO>(content);
            }

            _logger.LogWarning($"Failed to update category {dto.Category_Id}. Status code: {response.StatusCode}");
            return null;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Exception occurred while updating category {dto.Category_Id}.");
            return null;
        }
    }

    public async Task<bool> DeleteCategoryAsync(int id)
    {
        try
        {
            var client = _clientFactory.CreateClient("EduLabAPI");
            var response = await client.DeleteAsync($"Category/{id}");

            if (response.IsSuccessStatusCode)
            {
                return true;
            }

            _logger.LogWarning($"Failed to delete category {id}. Status code: {response.StatusCode}");
            return false;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Exception occurred while deleting category {id}.");
            return false;
        }
    }
}
