using EduLab_Shared.DTOs.Rating;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IRatingService
    {
        Task<RatingDto> AddRatingAsync(string userId, CreateRatingDto createRatingDto);
        Task<RatingDto> UpdateRatingAsync(string userId, int ratingId, UpdateRatingDto updateRatingDto);
        Task<bool> DeleteRatingAsync(string userId, int ratingId);
        Task<RatingDto?> GetUserRatingForCourseAsync(string userId, int courseId);
        Task<List<RatingDto>> GetCourseRatingsAsync(int courseId, int page = 1, int pageSize = 10);
        Task<CourseRatingSummaryDto> GetCourseRatingSummaryAsync(int courseId);
        Task<CanRateResponseDto> CanUserRateCourseAsync(string userId, int courseId);
    }
}
