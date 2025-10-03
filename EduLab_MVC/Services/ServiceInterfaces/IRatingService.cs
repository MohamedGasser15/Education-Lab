using EduLab_MVC.Models.DTOs.Rating;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    public interface IRatingService
    {
        Task<List<RatingDto>> GetCourseRatingsAsync(int courseId, int page = 1, int pageSize = 10, CancellationToken cancellationToken = default);
        Task<CourseRatingSummaryDto> GetCourseRatingSummaryAsync(int courseId, CancellationToken cancellationToken = default);
        Task<RatingDto> GetMyRatingForCourseAsync(int courseId, CancellationToken cancellationToken = default);
        Task<RatingDto> AddRatingAsync(CreateRatingDto createRatingDto, CancellationToken cancellationToken = default);
        Task<RatingDto> UpdateRatingAsync(int ratingId, UpdateRatingDto updateRatingDto, CancellationToken cancellationToken = default);
        Task<bool> DeleteRatingAsync(int ratingId, CancellationToken cancellationToken = default);
        Task<CanRateResponseDto> CanUserRateCourseAsync(int courseId, CancellationToken cancellationToken = default);
    }
}