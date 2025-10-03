// EduLab_MVC/Services/RatingService.cs
using AutoMapper;
using EduLab_MVC.Models.DTOs.Rating;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Net.Http;
using System.Text;

namespace EduLab_MVC.Services
{
    #region MVC Rating Service Implementation
    /// <summary>
    /// MVC Service for handling rating operations in the presentation layer
    /// Communicates with the API backend for rating management
    /// </summary>
    public class RatingService : IRatingService
    {
        #region Fields
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly ILogger<RatingService> _logger;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the RatingService class
        /// </summary>
        /// <param name="httpClientService">HTTP client service for API communication</param>
        /// <param name="logger">Logger instance for logging operations</param>
        /// <param name="mapper">AutoMapper instance for object mapping</param>
        /// <exception cref="ArgumentNullException">Thrown when any dependency is null</exception>
        public RatingService(
            IAuthorizedHttpClientService httpClientService,
            ILogger<RatingService> logger)
        {
            _httpClientService = httpClientService ?? throw new ArgumentNullException(nameof(httpClientService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }
        #endregion

        #region Public Methods
        /// <summary>
        /// Retrieves all ratings for a specific course with pagination
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="page">Page number for pagination (default: 1)</param>
        /// <param name="pageSize">Number of items per page (default: 10)</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of ratings for the specified course</returns>
        public async Task<List<RatingDto>> GetCourseRatingsAsync(
            int courseId,
            int page = 1,
            int pageSize = 10,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "GetCourseRatingsAsync";

            try
            {
                _logger.LogInformation("Starting {OperationName} for Course ID: {CourseId}, Page: {Page}, PageSize: {PageSize}",
                    operationName, courseId, page, pageSize);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"ratings/course/{courseId}?page={page}&pageSize={pageSize}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    var ratings = JsonConvert.DeserializeObject<List<RatingDto>>(content);

                    // Process profile images
                    if (ratings != null)
                    {
                        foreach (var rating in ratings)
                        {
                            rating.UserProfileImage = ProcessProfileImageUrl(rating.UserProfileImage);
                        }
                    }

                    _logger.LogInformation("Successfully retrieved {Count} ratings for Course ID: {CourseId}",
                        ratings?.Count ?? 0, courseId);

                    return ratings ?? new List<RatingDto>();
                }

                _logger.LogWarning("Failed to get course ratings. Status code: {StatusCode}", response.StatusCode);
                return new List<RatingDto>();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for Course ID: {CourseId}", operationName, courseId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for Course ID: {CourseId}", operationName, courseId);
                return new List<RatingDto>();
            }
        }

        /// <summary>
        /// Retrieves rating summary for a specific course
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Course rating summary with statistics</returns>
        public async Task<CourseRatingSummaryDto> GetCourseRatingSummaryAsync(int courseId, CancellationToken cancellationToken = default)
        {
            const string operationName = "GetCourseRatingSummaryAsync";

            try
            {
                _logger.LogInformation("Starting {OperationName} for Course ID: {CourseId}", operationName, courseId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"ratings/course/{courseId}/summary", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    var summary = JsonConvert.DeserializeObject<CourseRatingSummaryDto>(content);

                    _logger.LogInformation("Successfully retrieved rating summary for Course ID: {CourseId}", courseId);
                    return summary;
                }

                _logger.LogWarning("Failed to get rating summary. Status code: {StatusCode}", response.StatusCode);
                return CreateDefaultRatingSummary(courseId);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for Course ID: {CourseId}", operationName, courseId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for Course ID: {CourseId}", operationName, courseId);
                return CreateDefaultRatingSummary(courseId);
            }
        }

        /// <summary>
        /// Retrieves the current user's rating for a specific course
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>User's rating for the course or null if not found</returns>
        public async Task<RatingDto> GetMyRatingForCourseAsync(int courseId, CancellationToken cancellationToken = default)
        {
            const string operationName = "GetMyRatingForCourseAsync";

            try
            {
                _logger.LogInformation("Starting {OperationName} for Course ID: {CourseId}", operationName, courseId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"ratings/course/{courseId}/my-rating", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    var rating = JsonConvert.DeserializeObject<RatingDto>(content);

                    if (rating != null)
                    {
                        rating.UserProfileImage = ProcessProfileImageUrl(rating.UserProfileImage);
                    }

                    _logger.LogInformation("Successfully retrieved user rating for Course ID: {CourseId}", courseId);
                    return rating;
                }

                _logger.LogWarning("Failed to get user rating. Status code: {StatusCode}", response.StatusCode);
                return null;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for Course ID: {CourseId}", operationName, courseId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for Course ID: {CourseId}", operationName, courseId);
                return null;
            }
        }

        /// <summary>
        /// Adds a new rating for a course
        /// </summary>
        /// <param name="createRatingDto">Rating data to create</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Created rating DTO</returns>
        public async Task<RatingDto> AddRatingAsync(CreateRatingDto createRatingDto, CancellationToken cancellationToken = default)
        {
            const string operationName = "AddRatingAsync";

            try
            {
                _logger.LogInformation("Starting {OperationName} for Course ID: {CourseId}",
                    operationName, createRatingDto.CourseId);

                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(createRatingDto);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync("ratings", content, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync(cancellationToken);
                    var rating = JsonConvert.DeserializeObject<RatingDto>(responseContent);

                    _logger.LogInformation("Successfully added rating for Course ID: {CourseId}", createRatingDto.CourseId);
                    return rating;
                }

                var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);
                _logger.LogWarning("Failed to add rating. Status code: {StatusCode}, Error: {Error}",
                    response.StatusCode, errorContent);

                return null;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for Course ID: {CourseId}",
                    operationName, createRatingDto.CourseId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for Course ID: {CourseId}",
                    operationName, createRatingDto.CourseId);
                return null;
            }
        }

        /// <summary>
        /// Updates an existing rating
        /// </summary>
        /// <param name="ratingId">Rating identifier to update</param>
        /// <param name="updateRatingDto">Updated rating data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Updated rating DTO</returns>
        public async Task<RatingDto> UpdateRatingAsync(
            int ratingId,
            UpdateRatingDto updateRatingDto,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "UpdateRatingAsync";

            try
            {
                _logger.LogInformation("Starting {OperationName} for Rating ID: {RatingId}", operationName, ratingId);

                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(updateRatingDto);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PutAsync($"ratings/{ratingId}", content, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync(cancellationToken);
                    var rating = JsonConvert.DeserializeObject<RatingDto>(responseContent);

                    _logger.LogInformation("Successfully updated Rating ID: {RatingId}", ratingId);
                    return rating;
                }

                var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);
                _logger.LogWarning("Failed to update rating. Status code: {StatusCode}, Error: {Error}",
                    response.StatusCode, errorContent);

                return null;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for Rating ID: {RatingId}", operationName, ratingId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for Rating ID: {RatingId}", operationName, ratingId);
                return null;
            }
        }

        /// <summary>
        /// Deletes a user's rating
        /// </summary>
        /// <param name="ratingId">Rating identifier to delete</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if deletion was successful</returns>
        public async Task<bool> DeleteRatingAsync(int ratingId, CancellationToken cancellationToken = default)
        {
            const string operationName = "DeleteRatingAsync";

            try
            {
                _logger.LogInformation("Starting {OperationName} for Rating ID: {RatingId}", operationName, ratingId);

                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync($"ratings/{ratingId}", cancellationToken);

                var success = response.IsSuccessStatusCode;

                if (success)
                {
                    _logger.LogInformation("Successfully deleted Rating ID: {RatingId}", ratingId);
                }
                else
                {
                    _logger.LogWarning("Failed to delete rating. Status code: {StatusCode}", response.StatusCode);
                }

                return success;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for Rating ID: {RatingId}", operationName, ratingId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for Rating ID: {RatingId}", operationName, ratingId);
                return false;
            }
        }

        /// <summary>
        /// Checks if a user can rate a specific course
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Rating eligibility information</returns>
        public async Task<CanRateResponseDto> CanUserRateCourseAsync(int courseId, CancellationToken cancellationToken = default)
        {
            const string operationName = "CanUserRateCourseAsync";

            try
            {
                _logger.LogInformation("Starting {OperationName} for Course ID: {CourseId}", operationName, courseId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"ratings/can-rate/{courseId}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    var canRateResponse = JsonConvert.DeserializeObject<CanRateResponseDto>(content);

                    _logger.LogInformation("Successfully checked rating eligibility for Course ID: {CourseId}", courseId);
                    return canRateResponse;
                }

                _logger.LogWarning("Failed to check rating permission. Status code: {StatusCode}", response.StatusCode);
                return CreateDefaultCanRateResponse();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for Course ID: {CourseId}", operationName, courseId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in {OperationName} for Course ID: {CourseId}", operationName, courseId);
                return CreateDefaultCanRateResponse();
            }
        }
        #endregion

        #region Private Methods
        /// <summary>
        /// Processes profile image URL to ensure proper formatting
        /// </summary>
        /// <param name="profileImageUrl">Original profile image URL</param>
        /// <returns>Processed profile image URL</returns>
        private string ProcessProfileImageUrl(string profileImageUrl)
        {
            if (string.IsNullOrEmpty(profileImageUrl))
            {
                return "https://randomuser.me/api/portraits/women/44.jpg";
            }

            if (!profileImageUrl.StartsWith("http", StringComparison.OrdinalIgnoreCase))
            {
                return "https://localhost:7292" + profileImageUrl;
            }

            return profileImageUrl;
        }

        /// <summary>
        /// Creates a default rating summary for error cases
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <returns>Default rating summary</returns>
        private CourseRatingSummaryDto CreateDefaultRatingSummary(int courseId)
        {
            return new CourseRatingSummaryDto
            {
                CourseId = courseId,
                AverageRating = 0,
                TotalRatings = 0,
                RatingDistribution = new Dictionary<int, int>
                {
                    {1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}
                }
            };
        }

        /// <summary>
        /// Creates a default can-rate response for error cases
        /// </summary>
        /// <returns>Default can-rate response</returns>
        private CanRateResponseDto CreateDefaultCanRateResponse()
        {
            return new CanRateResponseDto
            {
                EligibleToRate = false,
                HasRated = false,
                CanRate = false
            };
        }
        #endregion
    }
    #endregion
}