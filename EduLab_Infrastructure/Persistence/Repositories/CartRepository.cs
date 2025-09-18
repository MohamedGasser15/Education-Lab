using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    /// <summary>
    /// Repository implementation for managing shopping cart operations
    /// </summary>
    public class CartRepository : ICartRepository
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<CartRepository> _logger;

        /// <summary>
        /// Initializes a new instance of the CartRepository class
        /// </summary>
        /// <param name="context">The database context</param>
        /// <param name="logger">The logger instance</param>
        public CartRepository(ApplicationDbContext context, ILogger<CartRepository> logger)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region Cart Retrieval Methods

        /// <summary>
        /// Retrieves a cart by user ID with all related data
        /// </summary>
        /// <param name="userId">The ID of the user</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The user's cart or null if not found</returns>
        public async Task<Cart> GetCartByUserIdAsync(string userId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving cart for user ID: {UserId}", userId);

                return await _context.Carts
                    .AsNoTracking()
                    .Include(c => c.CartItems)
                        .ThenInclude(ci => ci.Course)
                            .ThenInclude(c => c.Instructor)
                    .FirstOrDefaultAsync(c => c.UserId == userId, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving cart for user ID: {UserId}", userId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves a cart by guest ID with all related data
        /// </summary>
        /// <param name="guestId">The ID of the guest</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The guest's cart or null if not found</returns>
        public async Task<Cart> GetCartByGuestIdAsync(string guestId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Retrieving cart for guest ID: {GuestId}", guestId);

                return await _context.Carts
                    .AsNoTracking()
                    .Include(c => c.CartItems)
                        .ThenInclude(ci => ci.Course)
                            .ThenInclude(c => c.Instructor)
                    .FirstOrDefaultAsync(c => c.GuestId == guestId, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving cart for guest ID: {GuestId}", guestId);
                throw;
            }
        }

        #endregion

        #region Cart Creation Methods

        /// <summary>
        /// Creates a new cart for a registered user
        /// </summary>
        /// <param name="userId">The ID of the user</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The newly created cart</returns>
        public async Task<Cart> CreateUserCartAsync(string userId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Creating new cart for user ID: {UserId}", userId);

                var cart = new Cart { UserId = userId };
                _context.Carts.Add(cart);
                await _context.SaveChangesAsync(cancellationToken);

                _logger.LogInformation("Successfully created cart with ID: {CartId} for user ID: {UserId}", cart.Id, userId);
                return cart;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating cart for user ID: {UserId}", userId);
                throw;
            }
        }

        /// <summary>
        /// Creates a new cart for a guest user
        /// </summary>
        /// <param name="guestId">The ID of the guest</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The newly created cart</returns>
        public async Task<Cart> CreateGuestCartAsync(string guestId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Creating new cart for guest ID: {GuestId}", guestId);

                var cart = new Cart { GuestId = guestId };
                _context.Carts.Add(cart);
                await _context.SaveChangesAsync(cancellationToken);

                _logger.LogInformation("Successfully created cart with ID: {CartId} for guest ID: {GuestId}", cart.Id, guestId);
                return cart;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating cart for guest ID: {GuestId}", guestId);
                throw;
            }
        }

        #endregion

        #region Cart Migration Methods

        /// <summary>
        /// Migrates a guest cart to a user cart when a guest registers or logs in
        /// </summary>
        /// <param name="guestId">The ID of the guest</param>
        /// <param name="userId">The ID of the user</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if migration was successful, false otherwise</returns>
        public async Task<bool> MigrateGuestCartToUserAsync(string guestId, string userId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Migrating guest cart from guest ID: {GuestId} to user ID: {UserId}", guestId, userId);

                var guestCart = await GetCartByGuestIdAsync(guestId, cancellationToken);
                if (guestCart == null || !guestCart.CartItems.Any())
                {
                    _logger.LogWarning("Guest cart is empty or not found for guest ID: {GuestId}", guestId);
                    return false;
                }

                var userCart = await GetCartByUserIdAsync(userId, cancellationToken);
                if (userCart == null)
                {
                    userCart = await CreateUserCartAsync(userId, cancellationToken);
                }

                // Merge guest cart items with user cart
                foreach (var guestItem in guestCart.CartItems)
                {
                    var existingItem = userCart.CartItems.FirstOrDefault(ci => ci.CourseId == guestItem.CourseId);

                    if (existingItem == null)
                    {
                        userCart.CartItems.Add(new CartItem
                        {
                            CourseId = guestItem.CourseId,
                            AddedAt = DateTime.UtcNow
                        });
                    }
                }

                // Remove guest cart after migration
                _context.Carts.Remove(guestCart);
                await _context.SaveChangesAsync(cancellationToken);

                _logger.LogInformation("Successfully migrated cart from guest ID: {GuestId} to user ID: {UserId}", guestId, userId);
                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error migrating cart from guest ID: {GuestId} to user ID: {UserId}", guestId, userId);
                throw;
            }
        }


        #endregion

        #region Cart Item Management Methods

        /// <summary>
        /// Adds an item to the specified cart
        /// </summary>
        /// <param name="cartId">The ID of the cart</param>
        /// <param name="courseId">The ID of the course to add</param>
        /// <param name="quantity">The quantity to add</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The added cart item</returns>
        public async Task<CartItem> AddItemToCartAsync(int cartId, int courseId, int quantity, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Adding item to cart ID: {CartId}, course ID: {CourseId}, quantity: {Quantity}",
                    cartId, courseId, quantity);

                var cartItem = new CartItem
                {
                    CartId = cartId,
                    CourseId = courseId,
                    AddedAt = DateTime.UtcNow
                };

                _context.CartItems.Add(cartItem);
                await _context.SaveChangesAsync(cancellationToken);

                _logger.LogInformation("Successfully added item to cart ID: {CartId}, cart item ID: {CartItemId}",
                    cartId, cartItem.Id);
                return cartItem;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding item to cart ID: {CartId}, course ID: {CourseId}", cartId, courseId);
                throw;
            }
        }

        /// <summary>
        /// Removes an item from the cart
        /// </summary>
        /// <param name="cartItemId">The ID of the cart item to remove</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if the item was removed, false if not found</returns>
        public async Task<bool> RemoveItemFromCartAsync(int cartItemId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Removing cart item ID: {CartItemId}", cartItemId);

                var cartItem = await _context.CartItems.FindAsync(new object[] { cartItemId }, cancellationToken);
                if (cartItem != null)
                {
                    _context.CartItems.Remove(cartItem);
                    await _context.SaveChangesAsync(cancellationToken);

                    _logger.LogInformation("Successfully removed cart item ID: {CartItemId}", cartItemId);
                    return true;
                }

                _logger.LogWarning("Cart item not found with ID: {CartItemId}", cartItemId);
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error removing cart item ID: {CartItemId}", cartItemId);
                throw;
            }
        }

        /// <summary>
        /// Clears all items from the specified cart
        /// </summary>
        /// <param name="cartId">The ID of the cart to clear</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if the cart was cleared successfully</returns>
        public async Task<bool> ClearCartAsync(int cartId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Clearing cart ID: {CartId}", cartId);

                var cartItems = _context.CartItems.Where(ci => ci.CartId == cartId);
                _context.CartItems.RemoveRange(cartItems);
                await _context.SaveChangesAsync(cancellationToken);

                _logger.LogInformation("Successfully cleared cart ID: {CartId}", cartId);
                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error clearing cart ID: {CartId}", cartId);
                throw;
            }
        }

        #endregion
    }
}