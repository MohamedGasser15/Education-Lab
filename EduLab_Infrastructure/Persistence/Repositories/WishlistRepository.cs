using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    #region Wishlist Repository Implementation
    /// <summary>
    /// Repository implementation for managing wishlist operations in the database
    /// </summary>
    public class WishlistRepository : Repository<Wishlist>, IWishlistRepository
    {
        #region Fields
        private readonly ApplicationDbContext _db;
        private readonly ILogger<WishlistRepository> _logger;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the WishlistRepository class
        /// </summary>
        /// <param name="db">Application database context</param>
        /// <param name="logger">Logger instance for logging operations</param>
        /// <exception cref="ArgumentNullException">Thrown when db or logger is null</exception>
        public WishlistRepository(ApplicationDbContext db, ILogger<WishlistRepository> logger)
            : base(db, logger)
        {
            _db = db ?? throw new ArgumentNullException(nameof(db));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }
        #endregion

        #region Public Methods
        /// <summary>
        /// Retrieves the complete wishlist for a specific user with related course data
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of wishlist items for the user ordered by addition date (descending)</returns>
        /// <exception cref="ArgumentException">Thrown when userId is null or empty</exception>
        public async Task<List<Wishlist>> GetUserWishlistAsync(string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = "GetUserWishlistAsync";

            if (string.IsNullOrWhiteSpace(userId))
                throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

            try
            {
                _logger.LogDebug("Starting {OperationName} for user {UserId}", operationName, userId);

                var wishlist = await _db.WishlistItems
                    .Where(x => x.UserId == userId)
                    .Include(x => x.Course)
                        .ThenInclude(c => c.Instructor)
                    .Include(x => x.Course)
                        .ThenInclude(c => c.Category)
                    .OrderByDescending(x => x.AddedAt)
                    .ToListAsync(cancellationToken);

                _logger.LogInformation("Successfully retrieved {Count} wishlist items for user {UserId} in {OperationName}",
                    wishlist.Count, userId, operationName);

                return wishlist;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user {UserId}",
                    operationName, userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user {UserId}",
                    operationName, userId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves a specific wishlist item for a user and course combination
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="courseId">Unique identifier of the course</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Wishlist item if found, otherwise null</returns>
        /// <exception cref="ArgumentException">Thrown when userId is null or empty</exception>
        public async Task<Wishlist> GetWishlistItemAsync(string userId, int courseId, CancellationToken cancellationToken = default)
        {
            const string operationName = "GetWishlistItemAsync";

            if (string.IsNullOrWhiteSpace(userId))
                throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

            try
            {
                _logger.LogDebug("Starting {OperationName} for user {UserId} and course {CourseId}",
                    operationName, userId, courseId);

                var wishlistItem = await _db.WishlistItems
                    .FirstOrDefaultAsync(x => x.UserId == userId && x.CourseId == courseId, cancellationToken);

                if (wishlistItem == null)
                {
                    _logger.LogDebug("No wishlist item found for user {UserId} and course {CourseId} in {OperationName}",
                        userId, courseId, operationName);
                }
                else
                {
                    _logger.LogDebug("Successfully retrieved wishlist item for user {UserId} and course {CourseId} in {OperationName}",
                        userId, courseId, operationName);
                }

                return wishlistItem;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user {UserId} and course {CourseId}",
                    operationName, userId, courseId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user {UserId} and course {CourseId}",
                    operationName, userId, courseId);
                throw;
            }
        }

        /// <summary>
        /// Checks if a specific course exists in the user's wishlist
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="courseId">Unique identifier of the course</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the course exists in the wishlist, otherwise false</returns>
        /// <exception cref="ArgumentException">Thrown when userId is null or empty</exception>
        public async Task<bool> IsCourseInWishlistAsync(string userId, int courseId, CancellationToken cancellationToken = default)
        {
            const string operationName = "IsCourseInWishlistAsync";

            if (string.IsNullOrWhiteSpace(userId))
                throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

            try
            {
                _logger.LogDebug("Starting {OperationName} for user {UserId} and course {CourseId}",
                    operationName, userId, courseId);

                var exists = await _db.WishlistItems
                    .AnyAsync(x => x.UserId == userId && x.CourseId == courseId, cancellationToken);

                _logger.LogDebug("Completed {OperationName} for user {UserId} and course {CourseId} with result: {Result}",
                    operationName, userId, courseId, exists);

                return exists;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user {UserId} and course {CourseId}",
                    operationName, userId, courseId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user {UserId} and course {CourseId}",
                    operationName, userId, courseId);
                throw;
            }
        }

        /// <summary>
        /// Gets the total count of items in the user's wishlist
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Number of items in the wishlist</returns>
        /// <exception cref="ArgumentException">Thrown when userId is null or empty</exception>
        public async Task<int> GetWishlistCountAsync(string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = "GetWishlistCountAsync";

            if (string.IsNullOrWhiteSpace(userId))
                throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

            try
            {
                _logger.LogDebug("Starting {OperationName} for user {UserId}", operationName, userId);

                var count = await _db.WishlistItems
                    .Where(x => x.UserId == userId)
                    .CountAsync(cancellationToken);

                _logger.LogDebug("Completed {OperationName} for user {UserId} with count: {Count}",
                    operationName, userId, count);

                return count;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user {UserId}",
                    operationName, userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user {UserId}",
                    operationName, userId);
                throw;
            }
        }
        #endregion
    }
    #endregion
}