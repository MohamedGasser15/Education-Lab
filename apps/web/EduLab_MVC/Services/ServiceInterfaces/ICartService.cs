using EduLab_MVC.Models.DTOs.Cart;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for cart operations in the MVC application.
    /// </summary>
    public interface ICartService
    {
        #region Public Methods
            /// <summary>
            /// Retrieves the current user's cart.
            /// </summary>
            Task<CartDto> GetUserCartAsync(CancellationToken cancellationToken = default);

            /// <summary>
            /// Migrates the guest cart items to the authenticated user's cart.
            /// </summary>
            Task<bool> MigrateGuestCartAsync(CancellationToken cancellationToken = default);

            /// <summary>
            /// Adds an item to the user's cart.
            /// </summary>
            Task<CartDto> AddItemToCartAsync(AddToCartRequest request, CancellationToken cancellationToken = default);

            /// <summary>
            /// Removes an item from the user's cart.
            /// </summary>
            Task<CartDto> RemoveItemFromCartAsync(int cartItemId, CancellationToken cancellationToken = default);

            /// <summary>
            /// Clears all items from the user's cart.
            /// </summary>
            Task<bool> ClearCartAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks whether a course is already in the user's cart.
        /// </summary>
        Task<bool> IsCourseInCartAsync(int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a summary of the user's cart.
        /// </summary>
        Task<CartSummaryDto> GetCartSummaryAsync(CancellationToken cancellationToken = default);
        #endregion
    }
}
