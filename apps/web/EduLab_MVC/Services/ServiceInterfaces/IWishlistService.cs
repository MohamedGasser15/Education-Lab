using EduLab_MVC.Models.DTOs.Wishlist;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for wishlist operations in the MVC application.
    /// </summary>
    public interface IWishlistService
    {
        /// <summary>
        /// Retrieves the current user's wishlist.
        /// </summary>
        Task<List<WishlistItemDto>> GetUserWishlistAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Adds a course to the current user's wishlist.
        /// </summary>
        Task<WishlistResponse> AddToWishlistAsync(int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Removes a course from the current user's wishlist.
        /// </summary>
        Task<WishlistResponse> RemoveFromWishlistAsync(int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks whether a course is in the current user's wishlist.
        /// </summary>
        Task<bool> IsCourseInWishlistAsync(int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the current user's wishlist item count.
        /// </summary>
        Task<int> GetWishlistCountAsync(CancellationToken cancellationToken = default);
    }
}
