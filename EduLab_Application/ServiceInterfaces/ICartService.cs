using EduLab_Shared.DTOs.Cart;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for shopping cart operations
    /// </summary>
    public interface ICartService
    {
        #region Cart Retrieval Methods

        /// <summary>
        /// Retrieves the cart for a registered user
        /// </summary>
        /// <param name="userId">The user ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The user's cart DTO</returns>
        Task<CartDto> GetUserCartAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the cart for a guest user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The guest's cart DTO</returns>
        Task<CartDto> GetGuestCartAsync(CancellationToken cancellationToken = default);

        #endregion

        #region Cart Modification Methods

        /// <summary>
        /// Adds an item to the cart
        /// </summary>
        /// <param name="userId">The user ID (null for guest)</param>
        /// <param name="request">The add to cart request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The updated cart DTO</returns>
        Task<CartDto> AddItemToCartAsync(string userId, AddToCartRequest request, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates a cart item quantity
        /// </summary>
        /// <param name="userId">The user ID</param>
        /// <param name="cartItemId">The cart item ID</param>
        /// <param name="request">The update request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The updated cart DTO</returns>
        Task<CartDto> UpdateCartItemAsync(string userId, int cartItemId, UpdateCartItemRequest request, CancellationToken cancellationToken = default);

        /// <summary>
        /// Removes an item from the cart
        /// </summary>
        /// <param name="userId">The user ID</param>
        /// <param name="cartItemId">The cart item ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The updated cart DTO</returns>
        Task<CartDto> RemoveItemFromCartAsync(string userId, int cartItemId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Clears all items from the cart
        /// </summary>
        /// <param name="userId">The user ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if the cart was cleared successfully</returns>
        Task<bool> ClearCartAsync(string userId, CancellationToken cancellationToken = default);

        #endregion

        #region Cart Migration Methods

        /// <summary>
        /// Migrates a guest cart to a user cart
        /// </summary>
        /// <param name="userId">The user ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if migration was successful, false otherwise</returns>
        Task<bool> MigrateGuestCartToUserAsync(string userId, CancellationToken cancellationToken = default);

        #endregion
    }
}