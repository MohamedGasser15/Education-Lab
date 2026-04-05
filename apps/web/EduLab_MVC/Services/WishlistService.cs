using EduLab_MVC.Models.DTOs.Wishlist;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Json;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services
{
    #region Wishlist MVC Service Implementation
    /// <summary>
    /// MVC service for handling wishlist operations by communicating with the API
    /// </summary>
    public class WishlistService : IWishlistService
    {
        #region Fields
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly ILogger<WishlistService> _logger;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the WishlistService class
        /// </summary>
        /// <param name="httpClientService">HTTP client service for API communication</param>
        /// <param name="logger">Logger instance for logging operations</param>
        /// <exception cref="ArgumentNullException">Thrown when any dependency is null</exception>
        public WishlistService(
            IAuthorizedHttpClientService httpClientService,
            ILogger<WishlistService> logger)
        {
            _httpClientService = httpClientService ?? throw new ArgumentNullException(nameof(httpClientService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }
        #endregion

        #region Private Helper Methods
        /// <summary>
        /// Updates the image URL for a wishlist item to include the full base URL
        /// </summary>
        /// <param name="course">The wishlist item to update</param>
        private void UpdateImageUrl(WishlistItemDto course)
        {
            if (course == null) return;

            if (!string.IsNullOrEmpty(course.ThumbnailUrl) && !course.ThumbnailUrl.StartsWith("https"))
            {
                course.ThumbnailUrl = "https://localhost:7292" + course.ThumbnailUrl;
            }
        }
        #endregion

        #region Public Methods
        /// <summary>
        /// Retrieves the complete wishlist for the authenticated user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of wishlist items for the user</returns>
        public async Task<List<WishlistItemDto>> GetUserWishlistAsync(CancellationToken cancellationToken = default)
        {
            const string operationName = "GetUserWishlistAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("wishlist", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    var wishlist = JsonConvert.DeserializeObject<List<WishlistItemDto>>(content) ?? new List<WishlistItemDto>();

                    // Update image URLs for all wishlist items
                    foreach (var item in wishlist)
                    {
                        UpdateImageUrl(item);
                    }

                    _logger.LogInformation("Successfully retrieved {Count} wishlist items in {OperationName}",
                        wishlist.Count, operationName);

                    return wishlist;
                }

                _logger.LogWarning("Failed to get wishlist in {OperationName}. Status: {StatusCode}",
                    operationName, response.StatusCode);
                return new List<WishlistItemDto>();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return new List<WishlistItemDto>();
            }
        }

        /// <summary>
        /// Adds a course to the authenticated user's wishlist
        /// </summary>
        /// <param name="courseId">Unique identifier of the course to add</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Wishlist operation response</returns>
        public async Task<WishlistResponse> AddToWishlistAsync(int courseId, CancellationToken cancellationToken = default)
        {
            const string operationName = "AddToWishlistAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for course {CourseId}", operationName, courseId);

                var client = _httpClientService.CreateClient();
                var response = await client.PostAsJsonAsync($"wishlist/{courseId}", new { }, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadFromJsonAsync<WishlistResponse>(cancellationToken: cancellationToken);
                    _logger.LogInformation("Successfully added course {CourseId} to wishlist in {OperationName}",
                        courseId, operationName);
                    return result;
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);
                    _logger.LogWarning("Add to wishlist failed in {OperationName}. Status: {StatusCode}, Response: {ErrorContent}",
                        operationName, response.StatusCode, errorContent);

                    return new WishlistResponse
                    {
                        Success = false,
                        Message = $"Failed to add to wishlist. Status: {response.StatusCode}"
                    };
                }
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for course {CourseId}", operationName, courseId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for course {CourseId}", operationName, courseId);
                return new WishlistResponse
                {
                    Success = false,
                    Message = $"An error occurred: {ex.Message}"
                };
            }
        }

        /// <summary>
        /// Removes a course from the authenticated user's wishlist
        /// </summary>
        /// <param name="courseId">Unique identifier of the course to remove</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Wishlist operation response</returns>
        public async Task<WishlistResponse> RemoveFromWishlistAsync(int courseId, CancellationToken cancellationToken = default)
        {
            const string operationName = "RemoveFromWishlistAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for course {CourseId}", operationName, courseId);

                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync($"wishlist/{courseId}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadFromJsonAsync<WishlistResponse>(cancellationToken: cancellationToken);
                    _logger.LogInformation("Successfully removed course {CourseId} from wishlist in {OperationName}",
                        courseId, operationName);
                    return result;
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);
                    _logger.LogWarning("Remove from wishlist failed in {OperationName}. Status: {StatusCode}, Response: {ErrorContent}",
                        operationName, response.StatusCode, errorContent);

                    return new WishlistResponse
                    {
                        Success = false,
                        Message = $"Failed to remove from wishlist. Status: {response.StatusCode}"
                    };
                }
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for course {CourseId}", operationName, courseId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for course {CourseId}", operationName, courseId);
                return new WishlistResponse
                {
                    Success = false,
                    Message = $"An error occurred: {ex.Message}"
                };
            }
        }

        /// <summary>
        /// Checks if a course exists in the authenticated user's wishlist
        /// </summary>
        /// <param name="courseId">Unique identifier of the course to check</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the course exists in the wishlist, otherwise false</returns>
        public async Task<bool> IsCourseInWishlistAsync(int courseId, CancellationToken cancellationToken = default)
        {
            const string operationName = "IsCourseInWishlistAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for course {CourseId}", operationName, courseId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"wishlist/check/{courseId}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadFromJsonAsync<WishlistCheckResponse>(cancellationToken: cancellationToken);
                    _logger.LogDebug("Completed {OperationName} for course {CourseId} with result: {Result}",
                        operationName, courseId, result?.IsInWishlist);
                    return result?.IsInWishlist ?? false;
                }

                _logger.LogWarning("Check wishlist failed in {OperationName}. Status: {StatusCode}",
                    operationName, response.StatusCode);
                return false;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for course {CourseId}", operationName, courseId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for course {CourseId}", operationName, courseId);
                return false;
            }
        }

        /// <summary>
        /// Gets the total count of items in the authenticated user's wishlist
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Number of items in the wishlist</returns>
        public async Task<int> GetWishlistCountAsync(CancellationToken cancellationToken = default)
        {
            const string operationName = "GetWishlistCountAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("wishlist/count", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadFromJsonAsync<dynamic>(cancellationToken: cancellationToken);
                    var count = (int)(result?.count ?? 0);

                    _logger.LogDebug("Completed {OperationName} with count: {Count}", operationName, count);
                    return count;
                }

                _logger.LogWarning("Get wishlist count failed in {OperationName}. Status: {StatusCode}",
                    operationName, response.StatusCode);
                return 0;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return 0;
            }
        }
        #endregion
    }
    #endregion
}