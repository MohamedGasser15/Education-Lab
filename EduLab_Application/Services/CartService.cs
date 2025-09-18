using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Cart;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for shopping cart operations
    /// </summary>
    public class CartService : ICartService
    {
        private readonly ICartRepository _cartRepository;
        private readonly IMapper _mapper;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ILogger<CartService> _logger;

        /// <summary>
        /// Initializes a new instance of the CartService class
        /// </summary>
        /// <param name="cartRepository">The cart repository</param>
        /// <param name="mapper">The AutoMapper instance</param>
        /// <param name="httpContextAccessor">The HTTP context accessor</param>
        /// <param name="logger">The logger instance</param>
        public CartService(
            ICartRepository cartRepository,
            IMapper mapper,
            IHttpContextAccessor httpContextAccessor,
            ILogger<CartService> logger)
        {
            _cartRepository = cartRepository ?? throw new ArgumentNullException(nameof(cartRepository));
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
            _httpContextAccessor = httpContextAccessor ?? throw new ArgumentNullException(nameof(httpContextAccessor));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region Private Helper Methods

        /// <summary>
        /// Retrieves the guest ID from cookies or creates a new one
        /// </summary>
        /// <returns>The guest ID</returns>
        private string GetGuestId()
        {
            try
            {
                var httpContext = _httpContextAccessor.HttpContext;
                if (httpContext.Request.Cookies.TryGetValue("GuestId", out var guestId))
                {
                    return guestId;
                }

                // Create new guest ID if not exists
                var newGuestId = Guid.NewGuid().ToString();
                httpContext.Response.Cookies.Append("GuestId", newGuestId, new CookieOptions
                {
                    Expires = DateTime.Now.AddDays(30),
                    HttpOnly = true,
                    IsEssential = true,
                    Secure = true,
                    SameSite = SameSiteMode.Lax
                });

                return newGuestId;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting or creating guest ID");
                throw;
            }
        }

        /// <summary>
        /// Gets or creates a user cart
        /// </summary>
        /// <param name="userId">The user ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The user cart</returns>
        private async Task<Cart> GetOrCreateUserCart(string userId, CancellationToken cancellationToken = default)
        {
            var cart = await _cartRepository.GetCartByUserIdAsync(userId, cancellationToken);
            return cart ?? await _cartRepository.CreateUserCartAsync(userId, cancellationToken);
        }

        /// <summary>
        /// Gets or creates a guest cart
        /// </summary>
        /// <param name="guestId">The guest ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The guest cart</returns>
        private async Task<Cart> GetOrCreateGuestCart(string guestId, CancellationToken cancellationToken = default)
        {
            var cart = await _cartRepository.GetCartByGuestIdAsync(guestId, cancellationToken);
            return cart ?? await _cartRepository.CreateGuestCartAsync(guestId, cancellationToken);
        }

        /// <summary>
        /// Maps a Cart entity to a CartDto
        /// </summary>
        /// <param name="cart">The cart entity</param>
        /// <returns>The cart DTO</returns>
        private CartDto MapToCartDto(Cart cart)
        {
            if (cart == null) return new CartDto();

            var cartDto = new CartDto
            {
                Id = cart.Id,
                UserId = cart.UserId,
                TotalPrice = cart.TotalPrice
            };

            foreach (var item in cart.CartItems)
            {
                cartDto.Items.Add(new CartItemDto
                {
                    Id = item.Id,
                    CourseId = item.CourseId,
                    CourseTitle = item.Course.Title,
                    CoursePrice = item.Course.Price,
                    ThumbnailUrl = item.Course.ThumbnailUrl,
                    InstructorName = item.Course.Instructor?.FullName,
                    TotalPrice = item.TotalPrice
                });
            }

            return cartDto;
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// Retrieves the cart for a registered user
        /// </summary>
        /// <param name="userId">The user ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The user's cart DTO</returns>
        public async Task<CartDto> GetUserCartAsync(string userId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting cart for user ID: {UserId}", userId);

                var cart = await _cartRepository.GetCartByUserIdAsync(userId, cancellationToken);
                if (cart == null)
                {
                    _logger.LogInformation("Cart not found for user ID: {UserId}, creating new cart", userId);
                    cart = await _cartRepository.CreateUserCartAsync(userId, cancellationToken);
                }

                return MapToCartDto(cart);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting cart for user ID: {UserId}", userId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves the cart for a guest user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The guest's cart DTO</returns>
        public async Task<CartDto> GetGuestCartAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                var guestId = GetGuestId();
                _logger.LogInformation("Getting cart for guest ID: {GuestId}", guestId);

                var cart = await _cartRepository.GetCartByGuestIdAsync(guestId, cancellationToken);
                if (cart == null)
                {
                    _logger.LogInformation("Cart not found for guest ID: {GuestId}, creating new cart", guestId);
                    cart = await _cartRepository.CreateGuestCartAsync(guestId, cancellationToken);
                }

                return MapToCartDto(cart);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting guest cart");
                throw;
            }
        }

        /// <summary>
        /// Adds an item to the cart
        /// </summary>
        /// <param name="userId">The user ID (null for guest)</param>
        /// <param name="request">The add to cart request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The updated cart DTO</returns>
        public async Task<CartDto> AddItemToCartAsync(string userId, AddToCartRequest request, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation(
                    "Adding item to cart for user ID: {UserId}, course ID: {CourseId}",
                    userId, request.CourseId);

                Cart cart;
                if (string.IsNullOrEmpty(userId))
                {
                    // Guest user
                    var guestId = GetGuestId();
                    cart = await GetOrCreateGuestCart(guestId, cancellationToken);
                }
                else
                {
                    // Registered user
                    cart = await GetOrCreateUserCart(userId, cancellationToken);
                }

                // Check if item already exists in cart
                var existingItem = cart.CartItems.FirstOrDefault(ci => ci.CourseId == request.CourseId);
                if (existingItem != null)
                {
                    _logger.LogWarning("Course ID: {CourseId} already exists in cart for user ID: {UserId}", request.CourseId, userId);

                    throw new InvalidOperationException("الكورس موجود بالفعل في العربة.");
                }



                // Always add with quantity = 1 (courses can't be duplicated)
                await _cartRepository.AddItemToCartAsync(cart.Id, request.CourseId, 1, cancellationToken);

                // Refresh cart to get updated data
                if (string.IsNullOrEmpty(userId))
                {
                    var guestId = GetGuestId();
                    cart = await _cartRepository.GetCartByGuestIdAsync(guestId, cancellationToken);
                }
                else
                {
                    cart = await _cartRepository.GetCartByUserIdAsync(userId, cancellationToken);
                }

                _logger.LogInformation("Successfully added item to cart for user ID: {UserId}", userId);
                return MapToCartDto(cart);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex,
                    "Error adding item to cart for user ID: {UserId}, course ID: {CourseId}",
                    userId, request.CourseId);
                throw;
            }
        }

        /// <summary>
        /// Migrates a guest cart to a user cart
        /// </summary>
        /// <param name="userId">The user ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if migration was successful, false otherwise</returns>
        public async Task<bool> MigrateGuestCartToUserAsync(string userId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Migrating guest cart to user ID: {UserId}", userId);

                var guestId = GetGuestId();
                if (string.IsNullOrEmpty(guestId))
                {
                    _logger.LogWarning("No guest ID found for migration to user ID: {UserId}", userId);
                    return false;
                }

                return await _cartRepository.MigrateGuestCartToUserAsync(guestId, userId, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error migrating guest cart to user ID: {UserId}", userId);
                throw;
            }
        }

        /// <summary>
        /// Removes an item from the cart
        /// </summary>
        /// <param name="userId">The user ID</param>
        /// <param name="cartItemId">The cart item ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The updated cart DTO</returns>
        public async Task<CartDto> RemoveItemFromCartAsync(string userId, int cartItemId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Removing cart item ID: {CartItemId} for user ID: {UserId}",
                    cartItemId, userId);

                await _cartRepository.RemoveItemFromCartAsync(cartItemId, cancellationToken);

                var cart = await _cartRepository.GetCartByUserIdAsync(userId, cancellationToken);

                _logger.LogInformation("Successfully removed cart item ID: {CartItemId} for user ID: {UserId}",
                    cartItemId, userId);
                return MapToCartDto(cart);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error removing cart item ID: {CartItemId} for user ID: {UserId}",
                    cartItemId, userId);
                throw;
            }
        }

        /// <summary>
        /// Clears all items from the cart
        /// </summary>
        /// <param name="userId">The user ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if the cart was cleared successfully</returns>
        public async Task<bool> ClearCartAsync(string userId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Clearing cart for user ID: {UserId}", userId);

                var cart = await GetOrCreateUserCart(userId, cancellationToken);
                var result = await _cartRepository.ClearCartAsync(cart.Id, cancellationToken);

                _logger.LogInformation("Successfully cleared cart for user ID: {UserId}", userId);
                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error clearing cart for user ID: {UserId}", userId);
                throw;
            }
        }

        #endregion
    }
}