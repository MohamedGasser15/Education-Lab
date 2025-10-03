// EduLab_MVC/Services/RatingService.cs
using EduLab_MVC.Models.DTOs.Rating;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services
{
    public class RatingService : IRatingService
    {
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly ILogger<RatingService> _logger;

        public RatingService(
            IAuthorizedHttpClientService httpClientService,
            ILogger<RatingService> logger)
        {
            _httpClientService = httpClientService ?? throw new ArgumentNullException(nameof(httpClientService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public async Task<List<RatingDto>> GetCourseRatingsAsync(int courseId, int page = 1, int pageSize = 10, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting ratings for course ID: {CourseId}", courseId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"ratings/course/{courseId}?page={page}&pageSize={pageSize}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    var ratings = JsonConvert.DeserializeObject<List<RatingDto>>(content);

                    if (ratings != null)
                    {
                        foreach (var rating in ratings)
                        {
                            if (!string.IsNullOrEmpty(rating.UserProfileImage) &&
                                !rating.UserProfileImage.StartsWith("http", StringComparison.OrdinalIgnoreCase))
                            {
                                rating.UserProfileImage = "https://localhost:7292" + rating.UserProfileImage;
                            }

                            if (string.IsNullOrEmpty(rating.UserProfileImage))
                            {
                                rating.UserProfileImage = "https://randomuser.me/api/portraits/women/44.jpg";
                            }
                        }
                    }

                    return ratings ?? new List<RatingDto>();
                }

                _logger.LogWarning("Failed to get course ratings. Status code: {StatusCode}", response.StatusCode);
                return new List<RatingDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting ratings for course ID: {CourseId}", courseId);
                return new List<RatingDto>();
            }
        }

        public async Task<CourseRatingSummaryDto> GetCourseRatingSummaryAsync(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting rating summary for course ID: {CourseId}", courseId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"ratings/course/{courseId}/summary", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    return JsonConvert.DeserializeObject<CourseRatingSummaryDto>(content);
                }

                _logger.LogWarning("Failed to get rating summary. Status code: {StatusCode}", response.StatusCode);
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
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting rating summary for course ID: {CourseId}", courseId);
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
        }

        public async Task<RatingDto> GetMyRatingForCourseAsync(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting user rating for course ID: {CourseId}", courseId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"ratings/course/{courseId}/my-rating", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    return JsonConvert.DeserializeObject<RatingDto>(content);
                }

                _logger.LogWarning("Failed to get user rating. Status code: {StatusCode}", response.StatusCode);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting user rating for course ID: {CourseId}", courseId);
                return null;
            }
        }

        public async Task<RatingDto> AddRatingAsync(CreateRatingDto createRatingDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Adding rating for course ID: {CourseId}", createRatingDto.CourseId);

                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(createRatingDto);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PostAsync("ratings", content, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync(cancellationToken);
                    return JsonConvert.DeserializeObject<RatingDto>(responseContent);
                }

                var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);
                _logger.LogWarning("Failed to add rating. Status code: {StatusCode}, Error: {Error}",
                    response.StatusCode, errorContent);

                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding rating for course ID: {CourseId}", createRatingDto.CourseId);
                return null;
            }
        }

        public async Task<RatingDto> UpdateRatingAsync(int ratingId, UpdateRatingDto updateRatingDto, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Updating rating ID: {RatingId}", ratingId);

                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(updateRatingDto);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await client.PutAsync($"ratings/{ratingId}", content, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync(cancellationToken);
                    return JsonConvert.DeserializeObject<RatingDto>(responseContent);
                }

                var errorContent = await response.Content.ReadAsStringAsync(cancellationToken);
                _logger.LogWarning("Failed to update rating. Status code: {StatusCode}, Error: {Error}",
                    response.StatusCode, errorContent);

                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating rating ID: {RatingId}", ratingId);
                return null;
            }
        }

        public async Task<bool> DeleteRatingAsync(int ratingId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting rating ID: {RatingId}", ratingId);

                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync($"ratings/{ratingId}", cancellationToken);

                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting rating ID: {RatingId}", ratingId);
                return false;
            }
        }

        public async Task<CanRateResponseDto> CanUserRateCourseAsync(int courseId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Checking if user can rate course ID: {CourseId}", courseId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"ratings/can-rate/{courseId}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync(cancellationToken);
                    return JsonConvert.DeserializeObject<CanRateResponseDto>(content);
                }

                _logger.LogWarning("Failed to check rating permission. Status code: {StatusCode}", response.StatusCode);
                return new CanRateResponseDto
                {
                    EligibleToRate = false,
                    HasRated = false,
                    CanRate = false
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error checking rating permission for course ID: {CourseId}", courseId);
                return new CanRateResponseDto
                {
                    EligibleToRate = false,
                    HasRated = false,
                    CanRate = false
                };
            }
        }

    }
}