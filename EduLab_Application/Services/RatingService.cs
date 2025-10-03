// EduLab_Application/Services/RatingService.cs
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Rating;
using Microsoft.Extensions.Logging;

namespace EduLab_Application.Services
{
    public class RatingService : IRatingService
    {
        private readonly IRatingRepository _ratingRepository;
        private readonly IEnrollmentService _enrollmentService;
        private readonly ILogger<RatingService> _logger;

        public RatingService(
            IRatingRepository ratingRepository,
            IEnrollmentService enrollmentService,
            ILogger<RatingService> logger)
        {
            _ratingRepository = ratingRepository;
            _enrollmentService = enrollmentService;
            _logger = logger;
        }

        public async Task<RatingDto> AddRatingAsync(string userId, CreateRatingDto createRatingDto)
        {
            // التحقق من أن المستخدم مسجل في الكورس
            var isEnrolled = await _enrollmentService.IsUserEnrolledInCourseAsync(userId, createRatingDto.CourseId);
            if (!isEnrolled)
            {
                throw new InvalidOperationException("يجب أن تكون مسجلاً في هذا الكورس لتتمكن من تقييمه");
            }

            // التحقق من نسبة الإتمام (80% على الأقل)
            var enrollment = await _enrollmentService.GetUserCourseEnrollmentAsync(userId, createRatingDto.CourseId);
            if (enrollment?.ProgressPercentage < 80)
            {
                throw new InvalidOperationException("يجب إكمال 80% على الأقل من الكورس لتتمكن من تقييمه");
            }

            // التحقق من أن المستخدم لم يقم بالتقييم من قبل
            var existingRating = await _ratingRepository.GetUserRatingForCourseAsync(userId, createRatingDto.CourseId);
            if (existingRating != null)
            {
                throw new InvalidOperationException("لقد قمت بتقييم هذا الكورس من قبل");
            }

            // التحقق من صحة قيمة التقييم
            if (createRatingDto.Value < 1 || createRatingDto.Value > 5)
            {
                throw new ArgumentException("قيمة التقييم يجب أن تكون بين 1 و 5");
            }

            var rating = new Rating
            {
                CourseId = createRatingDto.CourseId,
                UserId = userId,
                Value = createRatingDto.Value,
                Comment = createRatingDto.Comment,
                CreatedAt = DateTime.UtcNow
            };

            await _ratingRepository.CreateAsync(rating);

            _logger.LogInformation("تم إضافة تقييم جديد للكورس {CourseId} من المستخدم {UserId}",
                createRatingDto.CourseId, userId);

            return MapToDto(rating);
        }

        public async Task<RatingDto> UpdateRatingAsync(string userId, int ratingId, UpdateRatingDto updateRatingDto)
        {
            // استخدام التتبع (tracking) للتأكد من أن التغييرات سيتم حفظها
            var rating = await _ratingRepository.GetAsync(
                r => r.Id == ratingId && r.UserId == userId,
                isTracking: true); // مهم: وضع التتبع على true

            if (rating == null)
            {
                throw new KeyNotFoundException("التقييم غير موجود أو لا يوجد لديك صلاحية لتعديله");
            }

            if (updateRatingDto.Value < 1 || updateRatingDto.Value > 5)
            {
                throw new ArgumentException("قيمة التقييم يجب أن تكون بين 1 و 5");
            }

            rating.Value = updateRatingDto.Value;
            rating.Comment = updateRatingDto.Comment;
            rating.UpdatedAt = DateTime.UtcNow;

            // حفظ التغييرات
            await _ratingRepository.SaveAsync();

            _logger.LogInformation("تم تحديث التقييم {RatingId} من المستخدم {UserId}", ratingId, userId);

            return MapToDto(rating);
        }

        public async Task<bool> DeleteRatingAsync(string userId, int ratingId)
        {
            var rating = await _ratingRepository.GetAsync(r => r.Id == ratingId && r.UserId == userId);
            if (rating == null)
            {
                throw new KeyNotFoundException("التقييم غير موجود أو لا يوجد لديك صلاحية لحذفه");
            }

            await _ratingRepository.DeleteAsync(rating);

            _logger.LogInformation("تم حذف التقييم {RatingId} من المستخدم {UserId}", ratingId, userId);

            return true;
        }

        public async Task<RatingDto?> GetUserRatingForCourseAsync(string userId, int courseId)
        {
            var rating = await _ratingRepository.GetUserRatingForCourseAsync(userId, courseId);
            return rating != null ? MapToDto(rating) : null;
        }

        public async Task<List<RatingDto>> GetCourseRatingsAsync(int courseId, int page = 1, int pageSize = 10)
        {
            var ratings = await _ratingRepository.GetCourseRatingsAsync(
                courseId,
                includeProperties: "User",
                orderBy: q => q.OrderByDescending(r => r.CreatedAt)
            );

            // Pagination logic
            var paginatedRatings = ratings
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            return paginatedRatings.Select(MapToDto).ToList();
        }

        public async Task<CourseRatingSummaryDto> GetCourseRatingSummaryAsync(int courseId)
        {
            return await _ratingRepository.GetCourseRatingSummaryAsync(courseId);
        }
        public async Task<CanRateResponseDto> CanUserRateCourseAsync(string userId, int courseId)
        {
            try
            {
                var isEnrolled = await _enrollmentService.IsUserEnrolledInCourseAsync(userId, courseId);
                if (!isEnrolled)
                {
                    return new CanRateResponseDto
                    {
                        EligibleToRate = false,
                        HasRated = false
                    };
                }

                var enrollment = await _enrollmentService.GetUserCourseEnrollmentAsync(userId, courseId);
                bool eligibleToRate = enrollment?.ProgressPercentage >= 80;

                var hasRated = await _ratingRepository.HasUserRatedCourseAsync(userId, courseId);

                return new CanRateResponseDto
                {
                    EligibleToRate = eligibleToRate,
                    HasRated = hasRated
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "خطأ في التحقق من إمكانية التقييم للمستخدم {UserId} للكورس {CourseId}", userId, courseId);
                return new CanRateResponseDto
                {
                    EligibleToRate = false,
                    HasRated = false
                };
            }
        }



        private RatingDto MapToDto(Rating rating)
        {
            return new RatingDto
            {
                Id = rating.Id,
                CourseId = rating.CourseId,
                UserId = rating.UserId,
                UserName = rating.User?.FullName ?? "مستخدم",
                UserProfileImage = rating.User?.ProfileImageUrl,
                Value = rating.Value,
                Comment = rating.Comment,
                CreatedAt = rating.CreatedAt,
                UpdatedAt = rating.UpdatedAt
            };
        }
    }
}