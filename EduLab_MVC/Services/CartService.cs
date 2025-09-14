// CartService.cs في مشروع MVC
using EduLab_MVC.Models.DTOs.Cart;
using EduLab_MVC.Services.ServiceInterfaces;
using Newtonsoft.Json;
using System.Text;

namespace EduLab_MVC.Services
{
    public class CartService : ICartService
    {
        private readonly IHttpClientFactory _clientFactory;
        private readonly ILogger<CartService> _logger;
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public CartService(
            IHttpClientFactory clientFactory,
            ILogger<CartService> logger,
            IAuthorizedHttpClientService httpClientService,
            IHttpContextAccessor httpContextAccessor)
        {
            _clientFactory = clientFactory;
            _logger = logger;
            _httpClientService = httpClientService;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<CartDto> GetUserCartAsync()
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("Cart");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var cart = JsonConvert.DeserializeObject<CartDto>(content) ?? new CartDto();

                    if (cart.Items != null && cart.Items.Any())
                    {
                        foreach (var item in cart.Items)
                        {
                            ImageUrl(item);
                        }
                    }

                    return cart;
                }

                _logger.LogWarning("Failed to get cart. Status code: {StatusCode}", response.StatusCode);
                return new CartDto();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting user cart");
                return new CartDto();
            }
        }
        public async Task<bool> MigrateGuestCartAsync()
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.PostAsync("Cart/migrate", null);

                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while migrating guest cart");
                return false;
            }
        }


        public async Task<CartDto> AddItemToCartAsync(AddToCartRequest request)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(request);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync("Cart/items", content);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync();
                    return JsonConvert.DeserializeObject<CartDto>(responseContent);
                }

                _logger.LogWarning("Failed to add item to cart. Status code: {StatusCode}", response.StatusCode);
                return new CartDto();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while adding item to cart");
                return new CartDto();
            }
        }

        public async Task<CartDto> UpdateCartItemAsync(int cartItemId, UpdateCartItemRequest request)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(request);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PutAsync($"Cart/items/{cartItemId}", content);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync();
                    return JsonConvert.DeserializeObject<CartDto>(responseContent);
                }

                _logger.LogWarning("Failed to update cart item. Status code: {StatusCode}", response.StatusCode);
                return new CartDto();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while updating cart item");
                return new CartDto();
            }
        }

        public async Task<CartDto> RemoveItemFromCartAsync(int cartItemId)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync($"Cart/items/{cartItemId}");

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync();
                    return JsonConvert.DeserializeObject<CartDto>(responseContent);
                }

                _logger.LogWarning("Failed to remove item from cart. Status code: {StatusCode}", response.StatusCode);
                return new CartDto();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while removing item from cart");
                return new CartDto();
            }
        }
        private void ImageUrl(CartItemDto course)
        {
            if (course == null) return;

            if (!string.IsNullOrEmpty(course.ThumbnailUrl) && !course.ThumbnailUrl.StartsWith("https"))
            {
                course.ThumbnailUrl = "https://localhost:7292" + course.ThumbnailUrl;
            }
        }
        public async Task<bool> ClearCartAsync()
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync("Cart/clear");

                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while clearing cart");
                return false;
            }
        }
    }
}