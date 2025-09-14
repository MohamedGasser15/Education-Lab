using EduLab_Domain.Entities;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    /// <summary>
    /// Repository interface for managing shopping cart operations
    /// </summary>
    public interface ICartRepository
    {
        #region Cart Retrieval Methods

        /// <summary>
        /// Retrieves a cart by user ID with all related data
        /// </summary>
        /// <param name="userId">The ID of the user</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The user's cart or null if not found</returns>
        Task<Cart> GetCartByUserIdAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a cart by guest ID with all related data
        /// </summary>
        /// <param name="guestId">The ID of the guest</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The guest's cart or null if not found</returns>
        Task<Cart> GetCartByGuestIdAsync(string guestId, CancellationToken cancellationToken = default);

        #endregion

        #region Cart Creation Methods

        /// <summary>
        /// Creates a new cart for a registered user
        /// </summary>
        /// <param name="userId">The ID of the user</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The newly created cart</returns>
        Task<Cart> CreateUserCartAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Creates a new cart for a guest user
        /// </summary>
        /// <param name="guestId">The ID of the guest</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The newly created cart</returns>
        Task<Cart> CreateGuestCartAsync(string guestId, CancellationToken cancellationToken = default);

        #endregion

        #region Cart Migration Methods

        /// <summary>
        /// Migrates a guest cart to a user cart when a guest registers or logs in
        /// </summary>
        /// <param name="guestId">The ID of the guest</param>
        /// <param name="userId">The ID of the user</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if migration was successful, false otherwise</returns>
        Task<bool> MigrateGuestCartToUserAsync(string guestId, string userId, CancellationToken cancellationToken = default);

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
        Task<CartItem> AddItemToCartAsync(int cartId, int courseId, int quantity, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates the quantity of a cart item
        /// </summary>
        /// <param name="cartItemId">The ID of the cart item</param>
        /// <param name="quantity">The new quantity</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The updated cart item or null if not found</returns>
        Task<CartItem> UpdateCartItemQuantityAsync(int cartItemId, int quantity, CancellationToken cancellationToken = default);

        /// <summary>
        /// Removes an item from the cart
        /// </summary>
        /// <param name="cartItemId">The ID of the cart item to remove</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if the item was removed, false if not found</returns>
        Task<bool> RemoveItemFromCartAsync(int cartItemId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Clears all items from the specified cart
        /// </summary>
        /// <param name="cartId">The ID of the cart to clear</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if the cart was cleared successfully</returns>
        Task<bool> ClearCartAsync(int cartId, CancellationToken cancellationToken = default);

        #endregion
    }
}