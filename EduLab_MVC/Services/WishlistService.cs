using EduLab_MVC.Models.DTOs.Wishlist;
using EduLab_MVC.Services.ServiceInterfaces;
using Newtonsoft.Json;
using System.Net.Http.Json;

namespace EduLab_MVC.Services
{
    public class WishlistService : IWishlistService
    {
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly ILogger<WishlistService> _logger;

        public WishlistService(
            IAuthorizedHttpClientService httpClientService,
            ILogger<WishlistService> logger)
        {
            _httpClientService = httpClientService;
            _logger = logger;
        }

        #region Private Helper Methods

        /// <summary>
        /// Updates the image URL for a wishlist item
        /// </summary>
        /// <param name="course">The wishlist item to update</param>
        private void ImageUrl(WishlistItemDto course)
        {
            if (course == null) return;

            if (!string.IsNullOrEmpty(course.ThumbnailUrl) && !course.ThumbnailUrl.StartsWith("https"))
            {
                course.ThumbnailUrl = "https://localhost:7292" + course.ThumbnailUrl;
            }
        }

        #endregion

        public async Task<List<WishlistItemDto>> GetUserWishlistAsync()
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("wishlist"); // ✅ أضفنا api/

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var wishlist = JsonConvert.DeserializeObject<List<WishlistItemDto>>(content) ?? new();

                    // ✅ عدّل الصور هنا
                    foreach (var item in wishlist)
                    {
                        ImageUrl(item);
                    }

                    return wishlist;
                }

                _logger.LogWarning("Failed to get wishlist. Status: {StatusCode}", response.StatusCode);
                return new List<WishlistItemDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting user wishlist");
                return new List<WishlistItemDto>();
            }
        }

        public async Task<WishlistResponse> AddToWishlistAsync(int courseId)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.PostAsJsonAsync($"wishlist/{courseId}", new { }); // ✅ أضفنا api/

                if (response.IsSuccessStatusCode)
                {
                    return await response.Content.ReadFromJsonAsync<WishlistResponse>();
                }
                else
                {
                    // ✅ إضافة logging لمعرفة الخطأ بالضبط
                    var errorContent = await response.Content.ReadAsStringAsync();
                    _logger.LogWarning("Add to wishlist failed. Status: {StatusCode}, Response: {ErrorContent}",
                        response.StatusCode, errorContent);

                    return new WishlistResponse
                    {
                        Success = false,
                        Message = $"Failed to add to wishlist. Status: {response.StatusCode}"
                    };
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while adding to wishlist");
                return new WishlistResponse
                {
                    Success = false,
                    Message = $"An error occurred: {ex.Message}"
                };
            }
        }

        public async Task<WishlistResponse> RemoveFromWishlistAsync(int courseId)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync($"wishlist/{courseId}"); // ✅ أضفنا api/

                if (response.IsSuccessStatusCode)
                {
                    return await response.Content.ReadFromJsonAsync<WishlistResponse>();
                }
                else
                {
                    // ✅ إضافة logging لمعرفة الخطأ بالضبط
                    var errorContent = await response.Content.ReadAsStringAsync();
                    _logger.LogWarning("Remove from wishlist failed. Status: {StatusCode}, Response: {ErrorContent}",
                        response.StatusCode, errorContent);

                    return new WishlistResponse
                    {
                        Success = false,
                        Message = $"Failed to remove from wishlist. Status: {response.StatusCode}"
                    };
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while removing from wishlist");
                return new WishlistResponse
                {
                    Success = false,
                    Message = $"An error occurred: {ex.Message}"
                };
            }
        }

        public async Task<bool> IsCourseInWishlistAsync(int courseId)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"wishlist/check/{courseId}"); // ✅ أضفنا api/

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadFromJsonAsync<dynamic>();
                    return result.isInWishlist;
                }

                _logger.LogWarning("Check wishlist failed. Status: {StatusCode}", response.StatusCode);
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while checking wishlist status");
                return false;
            }
        }

        public async Task<int> GetWishlistCountAsync()
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("wishlist/count"); // ✅ أضفنا api/

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadFromJsonAsync<dynamic>();
                    return result.count;
                }

                _logger.LogWarning("Get wishlist count failed. Status: {StatusCode}", response.StatusCode);
                return 0;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting wishlist count");
                return 0;
            }
        }
    }
}