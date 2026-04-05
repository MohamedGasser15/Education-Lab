using EduLab_MVC.Models.DTOs.Cart;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// Service implementation for MVC cart operations
    /// </summary>
    public class CartService : ICartService
    {
        private readonly IHttpClientFactory _clientFactory;
        private readonly ILogger<CartService> _logger;
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly IHttpContextAccessor _httpContextAccessor;

        /// <summary>
        /// Initializes a new instance of the CartService class
        /// </summary>
        /// <param name="clientFactory">The HTTP client factory</param>
        /// <param name="logger">The logger instance</param>
        /// <param name="httpClientService">The authorized HTTP client service</param>
        /// <param name="httpContextAccessor">The HTTP context accessor</param>
        public CartService(
            IHttpClientFactory clientFactory,
            ILogger<CartService> logger,
            IAuthorizedHttpClientService httpClientService,
            IHttpContextAccessor httpContextAccessor)
        {
            _clientFactory = clientFactory ?? throw new ArgumentNullException(nameof(clientFactory));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _httpClientService = httpClientService ?? throw new ArgumentNullException(nameof(httpClientService));
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
        }

        #region Private Helper Methods

        /// <summary>
        /// Updates the image URL for a cart item
        /// </summary>
        /// <param name="course">The cart item to update</param>
        private void ImageUrl(CartItemDto course)
        {
            if (course == null) return;

            if (!string.IsNullOrEmpty(course.ThumbnailUrl) && !course.ThumbnailUrl.StartsWith("https"))
            {
                course.ThumbnailUrl = "https://localhost:7292" + course.ThumbnailUrl;
            }
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// Retrieves the current user's cart
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The user's cart DTO</returns>
        public async Task<CartDto> GetUserCartAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving user cart");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("Cart", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var cart = JsonConvert.DeserializeObject<CartDto>(content) ?? new CartDto();

                    if (cart.Items != null && cart.Items.Count > 0)
                    {
                        foreach (var item in cart.Items)
                        {
                            ImageUrl(item);
                        }
                    }

                    _logger.LogInformation("Successfully retrieved user cart with {ItemCount} items", cart.Items.Count);
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

        /// <summary>
        /// Migrates a guest cart to a user cart
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if migration was successful, false otherwise</returns>
        public async Task<bool> MigrateGuestCartAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Migrating guest cart to user cart");

                var client = _httpClientService.CreateClient();
                var response = await client.PostAsync("Cart/migrate", null, cancellationToken);

                var success = response.IsSuccessStatusCode;

                if (success)
                {
                    _logger.LogInformation("Successfully migrated guest cart to user cart");
                }
                else
                {
                    _logger.LogWarning("Failed to migrate guest cart. Status code: {StatusCode}", response.StatusCode);
                }

                return success;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while migrating guest cart");
                return false;
            }
        }

        /// <summary>
        /// Adds an item to the cart
        /// </summary>
        /// <param name="request">The add to cart request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The updated cart DTO</returns>
        public async Task<CartDto> AddItemToCartAsync(AddToCartRequest request, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Adding item to cart, course ID: {CourseId}", request.CourseId);

                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(request);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync("Cart/items", content, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync();
                    return JsonConvert.DeserializeObject<CartDto>(responseContent);
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    _logger.LogWarning("API returned error {StatusCode}: {Error}", response.StatusCode, errorContent);

                    try
                    {
                        var errorObj = JsonConvert.DeserializeObject<dynamic>(errorContent);
                        string message = errorObj?.message?.ToString() ?? "حدث خطأ أثناء إضافة المنتج إلى السلة";
                        throw new InvalidOperationException(message);
                    }
                    catch (JsonException)
                    {
                        throw new InvalidOperationException($"API returned error {response.StatusCode}");
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while adding item to cart, course ID: {CourseId}", request.CourseId);
                throw;
            }
        }


        /// <summary>
        /// Removes an item from the cart
        /// </summary>
        /// <param name="cartItemId">The cart item ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The updated cart DTO</returns>
        public async Task<CartDto> RemoveItemFromCartAsync(int cartItemId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Removing cart item ID: {CartItemId}", cartItemId);

                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync($"Cart/items/{cartItemId}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync();
                    var cart = JsonConvert.DeserializeObject<CartDto>(responseContent);

                    _logger.LogInformation("Successfully removed cart item ID: {CartItemId}", cartItemId);
                    return cart;
                }

                _logger.LogWarning("Failed to remove item from cart. Status code: {StatusCode}", response.StatusCode);
                return new CartDto();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while removing item from cart, cart item ID: {CartItemId}", cartItemId);
                return new CartDto();
            }
        }

        /// <summary>
        /// Clears all items from the cart
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if the cart was cleared successfully, false otherwise</returns>
        public async Task<bool> ClearCartAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Clearing cart");

                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync("Cart/clear", cancellationToken);

                var success = response.IsSuccessStatusCode;

                if (success)
                {
                    _logger.LogInformation("Successfully cleared cart");
                }
                else
                {
                    _logger.LogWarning("Failed to clear cart. Status code: {StatusCode}", response.StatusCode);
                }

                return success;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while clearing cart");
                return false;
            }
        }
        public async Task<bool> IsCourseInCartAsync(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Checking if course ID: {CourseId} is in cart", courseId);

                var cart = await GetUserCartAsync(cancellationToken);

                // التحقق إذا كان الكورس موجود في السلة
                var isInCart = cart.Items?.Any(item => item.CourseId == courseId) ?? false;

                _logger.LogInformation("Course ID: {CourseId} is {Status} in cart",
                    courseId, isInCart ? "already" : "not");

                return isInCart;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error checking if course ID: {CourseId} is in cart", courseId);
                return false;
            }
        }
        /// <summary>
        /// Retrieves a summary of the cart
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Cart summary with total items and total price</returns>
        public async Task<CartSummaryDto> GetCartSummaryAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving cart summary");

                var cart = await GetUserCartAsync(cancellationToken);

                _logger.LogInformation("Successfully retrieved cart summary with {TotalItems} items", cart.TotalItems);
                return new CartSummaryDto
                {
                    TotalItems = cart.TotalItems,
                    TotalPrice = cart.TotalPrice
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting cart summary");
                return new CartSummaryDto { TotalItems = 0, TotalPrice = 0m };
            }
        }

        #endregion
    }
}