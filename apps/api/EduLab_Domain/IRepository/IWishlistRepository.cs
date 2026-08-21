using EduLab_Domain.Entities;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.IRepository
{
    /// <summary>
    /// Repository interface for wishlist data operations
    /// </summary>
    public interface IWishlistRepository : IRepository<Wishlist>
    {
        /// <summary>
        /// Retrieves the wishlist of a user
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of wishlist items</returns>
        Task<List<Wishlist>> GetUserWishlistAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a specific wishlist item for a user and course
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The wishlist item or null</returns>
        Task<Wishlist> GetWishlistItemAsync(string userId, int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks whether a course is in a user's wishlist
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if present, otherwise false</returns>
        Task<bool> IsCourseInWishlistAsync(string userId, int courseId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets the number of items in a user's wishlist
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Wishlist item count</returns>
        Task<int> GetWishlistCountAsync(string userId, CancellationToken cancellationToken = default);
    }
}