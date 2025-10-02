using EduLab_Shared.DTOs.Wishlist;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    #region Wishlist Service Interface
    /// <summary>
    /// Service interface for managing wishlist operations
    /// </summary>
    public interface IWishlistService
    {
        /// <summary>
        /// Retrieves the complete wishlist for a specific user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of wishlist items as DTOs</returns>
        Task<List<WishlistItemDto>> GetUserWishlistAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Adds a course to the user's wishlist
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="courseId">Unique identifier of the course to add</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Wishlist operation response indicating success or failure</returns>
        Task<WishlistResponse> AddToWishlistAsync(string userId, int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Removes a course from the user's wishlist
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="courseId">Unique identifier of the course to remove</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Wishlist operation response indicating success or failure</returns>
        Task<WishlistResponse> RemoveFromWishlistAsync(string userId, int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks if a course exists in the user's wishlist
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="courseId">Unique identifier of the course</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the course exists in the wishlist, otherwise false</returns>
        Task<bool> IsCourseInWishlistAsync(string userId, int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets the total count of items in the user's wishlist
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Number of items in the wishlist</returns>
        Task<int> GetWishlistCountAsync(string userId, CancellationToken cancellationToken = default);
    }
    #endregion
}