// EduLab_Application/Services/RatingService.cs
using AutoMapper;
using EduLab.Shared.DTOs.Notification;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Rating;
using Microsoft.Extensions.Logging;

namespace EduLab_Application.Services
{
    #region Rating Service Implementation
    /// <summary>
    /// Service implementation for handling rating business logic
    /// Provides methods for rating operations and validation
    /// </summary>
    public class RatingService : IRatingService
    {
        #region Fields
        private readonly IRatingRepository _ratingRepository;
        private readonly IEnrollmentService _enrollmentService;
        private readonly ILogger<RatingService> _logger;
        private readonly IMapper _mapper;
        private readonly INotificationService _notificationService;
        private readonly ICourseRepository _courseRepository;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the RatingService class
        /// </summary>
        /// <param name="ratingRepository">Rating repository for data access</param>
        /// <param name="enrollmentService">Enrollment service for validation</param>
        /// <param name="logger">Logger instance for logging operations</param>
        /// <param name="mapper">AutoMapper instance for object mapping</param>
        /// <exception cref="ArgumentNullException">Thrown when any dependency is null</exception>
        public RatingService(
            IRatingRepository ratingRepository,
            IEnrollmentService enrollmentService,
            ILogger<RatingService> logger,
            IMapper mapper,
            INotificationService notificationService,
            ICourseRepository courseRepository)
        {
            _ratingRepository = ratingRepository ?? throw new ArgumentNullException(nameof(ratingRepository));
            _enrollmentService = enrollmentService ?? throw new ArgumentNullException(nameof(enrollmentService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
            _notificationService = notificationService ?? throw new ArgumentNullException(nameof(notificationService));
            _courseRepository = courseRepository ?? throw new ArgumentNullException(nameof(courseRepository));
        }
        #endregion

        #region Public Methods
        /// <summary>
        /// Adds a new rating for a course with validation
        /// </summary>
        /// <param name="userId">User identifier adding the rating</param>
        /// <param name="createRatingDto">Rating data to create</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Created rating DTO</returns>
        /// <exception cref="InvalidOperationException">Thrown when user is not eligible to rate</exception>
        /// <exception cref="ArgumentException">Thrown when rating value is invalid</exception>
        public async Task<RatingDto> AddRatingAsync(string userId, CreateRatingDto createRatingDto, CancellationToken cancellationToken = default)
        {
            const string operationName = "AddRatingAsync";

            try
            {
                _logger.LogInformation("Starting {OperationName} for User: {UserId}, Course: {CourseId}",
                    operationName, userId, createRatingDto.CourseId);

                // Validate user enrollment
                var isEnrolled = await _enrollmentService.IsUserEnrolledInCourseAsync(userId, createRatingDto.CourseId, cancellationToken);
                if (!isEnrolled)
                {
                    _logger.LogWarning("User {UserId} is not enrolled in Course {CourseId}", userId, createRatingDto.CourseId);
                    throw new InvalidOperationException("يجب أن تكون مسجلاً في هذا الكورس لتتمكن من تقييمه");
                }

                // Validate completion percentage (80% minimum)
                var enrollment = await _enrollmentService.GetUserCourseEnrollmentAsync(userId, createRatingDto.CourseId, cancellationToken);
                if (enrollment?.ProgressPercentage < 80)
                {
                    _logger.LogWarning("User {UserId} has insufficient progress ({Progress}%) for Course {CourseId}",
                        userId, enrollment.ProgressPercentage, createRatingDto.CourseId);
                    throw new InvalidOperationException("يجب إكمال 80% على الأقل من الكورس لتتمكن من تقييمه");
                }

                // Check for existing rating
                var existingRating = await _ratingRepository.GetUserRatingForCourseAsync(userId, createRatingDto.CourseId, cancellationToken);
                if (existingRating != null)
                {
                    _logger.LogWarning("User {UserId} has already rated Course {CourseId}", userId, createRatingDto.CourseId);
                    throw new InvalidOperationException("لقد قمت بتقييم هذا الكورس من قبل");
                }

                // Validate rating value
                if (createRatingDto.Value < 1 || createRatingDto.Value > 5)
                {
                    _logger.LogWarning("Invalid rating value {RatingValue} provided by User {UserId}",
                        createRatingDto.Value, userId);
                    throw new ArgumentException("قيمة التقييم يجب أن تكون بين 1 و 5");
                }

                // Create new rating
                var rating = new Rating
                {
                    CourseId = createRatingDto.CourseId,
                    UserId = userId,
                    Value = createRatingDto.Value,
                    Comment = createRatingDto.Comment,
                    CreatedAt = DateTime.UtcNow
                };

                await _ratingRepository.CreateAsync(rating, cancellationToken);

                var course = await _courseRepository.GetCourseByIdAsync(createRatingDto.CourseId, false, cancellationToken);

                if (course != null && !string.IsNullOrEmpty(course.InstructorId) && course.InstructorId != userId)
                {
                    var notificationDto = new CreateNotificationDto
                    {
                        Title = "تقييم جديد على كورسك ⭐",
                        Message = $"قام أحد الطلاب بتقييم كورسك \"{course.Title}\" بتقييم {createRatingDto.Value}/5.",
                        Type = NotificationTypeDto.Course,
                        UserId = course.InstructorId,
                        RelatedEntityId = course.Id.ToString(),
                        RelatedEntityType = "Course"
                    };

                    await _notificationService.CreateNotificationAsync(notificationDto);
                }

                _logger.LogInformation("Successfully added rating for Course: {CourseId} by User: {UserId} with Rating ID: {RatingId}",
                    createRatingDto.CourseId, userId, rating.Id);

                return _mapper.Map<RatingDto>(rating);
            }
            catch (Exception ex) when (ex is not (InvalidOperationException or ArgumentException))
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for User: {UserId}, Course: {CourseId}",
                    operationName, userId, createRatingDto.CourseId);
                throw;
            }
        }

        /// <summary>
        /// Updates an existing rating
        /// </summary>
        /// <param name="userId">User identifier updating the rating</param>
        /// <param name="ratingId">Rating identifier to update</param>
        /// <param name="updateRatingDto">Updated rating data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Updated rating DTO</returns>
        /// <exception cref="KeyNotFoundException">Thrown when rating is not found or user doesn't have permission</exception>
        /// <exception cref="ArgumentException">Thrown when rating value is invalid</exception>
        public async Task<RatingDto> UpdateRatingAsync(string userId, int ratingId, UpdateRatingDto updateRatingDto, CancellationToken cancellationToken = default)
        {
            const string operationName = "UpdateRatingAsync";

            try
            {
                _logger.LogInformation("Starting {OperationName} for Rating ID: {RatingId} by User: {UserId}",
                    operationName, ratingId, userId);

                // Get rating with tracking enabled for updates
                var rating = await _ratingRepository.GetAsync(
                    r => r.Id == ratingId && r.UserId == userId,
                    isTracking: true,
                    cancellationToken: cancellationToken);

                if (rating == null)
                {
                    _logger.LogWarning("Rating not found or access denied - Rating ID: {RatingId}, User: {UserId}",
                        ratingId, userId);
                    throw new KeyNotFoundException("التقييم غير موجود أو لا يوجد لديك صلاحية لتعديله");
                }

                // Validate rating value
                if (updateRatingDto.Value < 1 || updateRatingDto.Value > 5)
                {
                    _logger.LogWarning("Invalid rating value {RatingValue} provided for update", updateRatingDto.Value);
                    throw new ArgumentException("قيمة التقييم يجب أن تكون بين 1 و 5");
                }

                // Update rating properties
                rating.Value = updateRatingDto.Value;
                rating.Comment = updateRatingDto.Comment;
                rating.UpdatedAt = DateTime.UtcNow;

                await _ratingRepository.SaveAsync(cancellationToken);

                _logger.LogInformation("Successfully updated Rating ID: {RatingId} by User: {UserId}", ratingId, userId);

                return _mapper.Map<RatingDto>(rating);
            }
            catch (Exception ex) when (ex is not (KeyNotFoundException or ArgumentException))
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for Rating ID: {RatingId} by User: {UserId}",
                    operationName, ratingId, userId);
                throw;
            }
        }

        /// <summary>
        /// Deletes a user's rating
        /// </summary>
        /// <param name="userId">User identifier deleting the rating</param>
        /// <param name="ratingId">Rating identifier to delete</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if deletion was successful</returns>
        /// <exception cref="KeyNotFoundException">Thrown when rating is not found or user doesn't have permission</exception>
        public async Task<bool> DeleteRatingAsync(string userId, int ratingId, CancellationToken cancellationToken = default)
        {
            const string operationName = "DeleteRatingAsync";

            try
            {
                _logger.LogInformation("Starting {OperationName} for Rating ID: {RatingId} by User: {UserId}",
                    operationName, ratingId, userId);

                var rating = await _ratingRepository.GetAsync(
                    r => r.Id == ratingId && r.UserId == userId,
                    cancellationToken: cancellationToken);

                if (rating == null)
                {
                    _logger.LogWarning("Rating not found or access denied - Rating ID: {RatingId}, User: {UserId}",
                        ratingId, userId);
                    throw new KeyNotFoundException("التقييم غير موجود أو لا يوجد لديك صلاحية لحذفه");
                }

                await _ratingRepository.DeleteAsync(rating, cancellationToken);

                _logger.LogInformation("Successfully deleted Rating ID: {RatingId} by User: {UserId}", ratingId, userId);

                return true;
            }
            catch (Exception ex) when (ex is not KeyNotFoundException)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for Rating ID: {RatingId} by User: {UserId}",
                    operationName, ratingId, userId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves a user's rating for a specific course
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>User's rating DTO or null if not found</returns>
        public async Task<RatingDto?> GetUserRatingForCourseAsync(string userId, int courseId, CancellationToken cancellationToken = default)
        {
            const string operationName = "GetUserRatingForCourseAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for User: {UserId}, Course: {CourseId}",
                    operationName, userId, courseId);

                var rating = await _ratingRepository.GetUserRatingForCourseAsync(userId, courseId, cancellationToken);

                if (rating == null)
                {
                    _logger.LogDebug("No rating found for User: {UserId}, Course: {CourseId}", userId, courseId);
                    return null;
                }

                _logger.LogDebug("Found rating for User: {UserId}, Course: {CourseId}", userId, courseId);
                return _mapper.Map<RatingDto>(rating);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for User: {UserId}, Course: {CourseId}",
                    operationName, userId, courseId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves all ratings for a specific course with pagination
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="page">Page number for pagination (default: 1)</param>
        /// <param name="pageSize">Number of items per page (default: 10)</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of rating DTOs for the specified course</returns>
        public async Task<List<RatingDto>> GetCourseRatingsAsync(
            int courseId,
            int page = 1,
            int pageSize = 10,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "GetCourseRatingsAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for Course: {CourseId}, Page: {Page}, PageSize: {PageSize}",
                    operationName, courseId, page, pageSize);

                var ratings = await _ratingRepository.GetCourseRatingsAsync(
                    courseId,
                    includeProperties: "User",
                    orderBy: q => q.OrderByDescending(r => r.CreatedAt),
                    cancellationToken: cancellationToken);

                // Apply pagination
                var paginatedRatings = ratings
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToList();

                _logger.LogDebug("Retrieved {Count} ratings for Course: {CourseId}", paginatedRatings.Count, courseId);

                return _mapper.Map<List<RatingDto>>(paginatedRatings);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for Course: {CourseId}", operationName, courseId);
                throw;
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
                _logger.LogDebug("Starting {OperationName} for Course: {CourseId}", operationName, courseId);

                var summary = await _ratingRepository.GetCourseRatingSummaryAsync(courseId, cancellationToken);

                _logger.LogDebug("Retrieved rating summary for Course: {CourseId}", courseId);

                return summary;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for Course: {CourseId}", operationName, courseId);
                throw;
            }
        }

        /// <summary>
        /// Checks if a user can rate a specific course
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="courseId">Course identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Response indicating rating eligibility and status</returns>
        public async Task<CanRateResponseDto> CanUserRateCourseAsync(string userId, int courseId, CancellationToken cancellationToken = default)
        {
            const string operationName = "CanUserRateCourseAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName} for User: {UserId}, Course: {CourseId}",
                    operationName, userId, courseId);

                var isEnrolled = await _enrollmentService.IsUserEnrolledInCourseAsync(userId, courseId, cancellationToken);
                if (!isEnrolled)
                {
                    _logger.LogDebug("User {UserId} is not enrolled in Course {CourseId}", userId, courseId);
                    return new CanRateResponseDto
                    {
                        EligibleToRate = false,
                        HasRated = false
                    };
                }

                var enrollment = await _enrollmentService.GetUserCourseEnrollmentAsync(userId, courseId, cancellationToken);
                bool eligibleToRate = enrollment?.ProgressPercentage >= 80;

                var hasRated = await _ratingRepository.HasUserRatedCourseAsync(userId, courseId, cancellationToken);

                var response = new CanRateResponseDto
                {
                    EligibleToRate = eligibleToRate,
                    HasRated = hasRated
                };

                _logger.LogDebug("Rating eligibility for User {UserId}, Course {CourseId}: Eligible={Eligible}, HasRated={HasRated}",
                    userId, courseId, eligibleToRate, hasRated);

                return response;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for User: {UserId}, Course: {CourseId}",
                    operationName, userId, courseId);

                // Return safe default response in case of error
                return new CanRateResponseDto
                {
                    EligibleToRate = false,
                    HasRated = false
                };
            }
        }
        #endregion
    }
    #endregion
}