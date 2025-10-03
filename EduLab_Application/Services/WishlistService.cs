using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Wishlist;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    #region Wishlist Service Implementation
    /// <summary>
    /// Service implementation for managing wishlist operations
    /// </summary>
    public class WishlistService : IWishlistService
    {
        #region Fields
        private readonly IWishlistRepository _wishlistRepo;
        private readonly IRepository<Course> _courseRepo;
        private readonly ILogger<WishlistService> _logger;
        private readonly IRatingRepository _ratingRepo;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the WishlistService class
        /// </summary>
        /// <param name="wishlistRepo">Wishlist repository for data access</param>
        /// <param name="courseRepo">Course repository for course validation</param>
        /// <param name="logger">Logger instance for logging operations</param>
        /// <exception cref="ArgumentNullException">Thrown when any dependency is null</exception>
        public WishlistService(
            IWishlistRepository wishlistRepo,
            IRepository<Course> courseRepo,
            ILogger<WishlistService> logger,
            IRatingRepository ratingRepo)
        {
            _wishlistRepo = wishlistRepo ?? throw new ArgumentNullException(nameof(wishlistRepo));
            _courseRepo = courseRepo ?? throw new ArgumentNullException(nameof(courseRepo));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _ratingRepo = ratingRepo;
        }
        #endregion

        #region Public Methods
        /// <summary>
        /// Retrieves the complete wishlist for a specific user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of wishlist items as DTOs</returns>
        /// <exception cref="ArgumentException">Thrown when userId is null or empty</exception>
        public async Task<List<WishlistItemDto>> GetUserWishlistAsync(string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = "GetUserWishlistAsync";

            if (string.IsNullOrWhiteSpace(userId))
                throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

            try
            {
                _logger.LogDebug("Starting {OperationName} for user {UserId}", operationName, userId);

                var wishlistItems = await _wishlistRepo.GetUserWishlistAsync(userId, cancellationToken);

                var result = new List<WishlistItemDto>();

                foreach (var item in wishlistItems)
                {
                    var dto = new WishlistItemDto
                    {
                        Id = item.Id,
                        CourseId = item.Course.Id,
                        CourseTitle = item.Course.Title,
                        CourseShortDescription = item.Course.ShortDescription,
                        CoursePrice = item.Course.Price,
                        CourseDiscount = item.Course.Discount,
                        ThumbnailUrl = item.Course.ThumbnailUrl,
                        InstructorName = item.Course.Instructor.FullName,
                        AddedAt = item.AddedAt
                    };

                    var ratingSummary = await _ratingRepo.GetCourseRatingSummaryAsync(item.Course.Id, cancellationToken);
                    if (ratingSummary != null)
                    {
                        dto.AverageRating = ratingSummary.AverageRating;
                        dto.TotalRatings = ratingSummary.TotalRatings;
                        dto.RatingDistribution = ratingSummary.RatingDistribution;
                    }

                    result.Add(dto);
                }

                _logger.LogInformation(
                    "Successfully retrieved {Count} wishlist items for user {UserId} in {OperationName}",
                    result.Count, userId, operationName);

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex,
                    "Error occurred while getting user wishlist for user {UserId} in {OperationName}",
                    userId, operationName);
                throw;
            }
        }

        /// <summary>
        /// Adds a course to the user's wishlist
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="courseId">Unique identifier of the course to add</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Wishlist operation response indicating success or failure</returns>
        /// <exception cref="ArgumentException">Thrown when userId is null or empty</exception>
        public async Task<WishlistResponse> AddToWishlistAsync(string userId, int courseId, CancellationToken cancellationToken = default)
        {
            const string operationName = "AddToWishlistAsync";

            if (string.IsNullOrWhiteSpace(userId))
                throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

            try
            {
                _logger.LogDebug("Starting {OperationName} for user {UserId} and course {CourseId}",
                    operationName, userId, courseId);

                // Check if course exists
                var course = await _courseRepo.GetAsync(c => c.Id == courseId, cancellationToken: cancellationToken);
                if (course == null)
                {
                    _logger.LogWarning("Course {CourseId} not found for user {UserId} in {OperationName}",
                        courseId, userId, operationName);

                    return new WishlistResponse
                    {
                        Success = false,
                        Message = "Course not found"
                    };
                }

                // Check if already in wishlist
                var existingItem = await _wishlistRepo.GetWishlistItemAsync(userId, courseId, cancellationToken);
                if (existingItem != null)
                {
                    _logger.LogWarning("Course {CourseId} is already in wishlist for user {UserId} in {OperationName}",
                        courseId, userId, operationName);

                    return new WishlistResponse
                    {
                        Success = false,
                        Message = "Course is already in wishlist"
                    };
                }

                // Add to wishlist
                var wishlistItem = new Wishlist
                {
                    UserId = userId,
                    CourseId = courseId,
                    AddedAt = DateTime.UtcNow
                };

                await _wishlistRepo.CreateAsync(wishlistItem, cancellationToken);
                var wishlistCount = await _wishlistRepo.GetWishlistCountAsync(userId, cancellationToken);

                _logger.LogInformation("Successfully added course {CourseId} to wishlist for user {UserId} in {OperationName}",
                    courseId, userId, operationName);

                return new WishlistResponse
                {
                    Success = true,
                    Message = "Course added to wishlist successfully",
                    WishlistCount = wishlistCount
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while adding course {CourseId} to wishlist for user {UserId} in {OperationName}",
                    courseId, userId, operationName);

                return new WishlistResponse
                {
                    Success = false,
                    Message = "An error occurred while adding to wishlist"
                };
            }
        }

        /// <summary>
        /// Removes a course from the user's wishlist
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="courseId">Unique identifier of the course to remove</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Wishlist operation response indicating success or failure</returns>
        /// <exception cref="ArgumentException">Thrown when userId is null or empty</exception>
        public async Task<WishlistResponse> RemoveFromWishlistAsync(string userId, int courseId, CancellationToken cancellationToken = default)
        {
            const string operationName = "RemoveFromWishlistAsync";

            if (string.IsNullOrWhiteSpace(userId))
                throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

            try
            {
                _logger.LogDebug("Starting {OperationName} for user {UserId} and course {CourseId}",
                    operationName, userId, courseId);

                var wishlistItem = await _wishlistRepo.GetWishlistItemAsync(userId, courseId, cancellationToken);
                if (wishlistItem == null)
                {
                    _logger.LogWarning("Course {CourseId} not found in wishlist for user {UserId} in {OperationName}",
                        courseId, userId, operationName);

                    return new WishlistResponse
                    {
                        Success = false,
                        Message = "Course not found in wishlist"
                    };
                }

                await _wishlistRepo.DeleteAsync(wishlistItem, cancellationToken);
                var wishlistCount = await _wishlistRepo.GetWishlistCountAsync(userId, cancellationToken);

                _logger.LogInformation("Successfully removed course {CourseId} from wishlist for user {UserId} in {OperationName}",
                    courseId, userId, operationName);

                return new WishlistResponse
                {
                    Success = true,
                    Message = "Course removed from wishlist successfully",
                    WishlistCount = wishlistCount
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while removing course {CourseId} from wishlist for user {UserId} in {OperationName}",
                    courseId, userId, operationName);

                return new WishlistResponse
                {
                    Success = false,
                    Message = "An error occurred while removing from wishlist"
                };
            }
        }

        /// <summary>
        /// Checks if a course exists in the user's wishlist
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

                var result = await _wishlistRepo.IsCourseInWishlistAsync(userId, courseId, cancellationToken);

                _logger.LogDebug("Completed {OperationName} for user {UserId} and course {CourseId} with result: {Result}",
                    operationName, userId, courseId, result);

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while checking if course {CourseId} is in wishlist for user {UserId} in {OperationName}",
                    courseId, userId, operationName);
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

                var count = await _wishlistRepo.GetWishlistCountAsync(userId, cancellationToken);

                _logger.LogDebug("Completed {OperationName} for user {UserId} with count: {Count}",
                    operationName, userId, count);

                return count;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting wishlist count for user {UserId} in {OperationName}",
                    userId, operationName);
                throw;
            }
        }
        #endregion
    }
    #endregion
}