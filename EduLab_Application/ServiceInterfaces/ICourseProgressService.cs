using EduLab_Shared.DTOs.CourseProgress;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface ICourseProgressService
    {
        Task<CourseProgressDto> GetProgressAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default);
        Task<List<CourseProgressDto>> GetProgressByEnrollmentAsync(int enrollmentId, CancellationToken cancellationToken = default);
        Task<CourseProgressDto> MarkLectureAsCompletedAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default);
        Task<CourseProgressDto> MarkLectureAsIncompleteAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default);
        Task<CourseProgressDto> UpdateProgressAsync(UpdateCourseProgressDto progressDto, CancellationToken cancellationToken = default);
        Task<bool> DeleteProgressAsync(int progressId, CancellationToken cancellationToken = default);
        Task<int> GetCompletedLecturesCountAsync(int enrollmentId, CancellationToken cancellationToken = default);
        Task<bool> IsLectureCompletedAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default);
        Task<CourseProgressSummaryDto> GetCourseProgressSummaryAsync(int enrollmentId, CancellationToken cancellationToken = default);
        Task<decimal> GetCourseProgressPercentageAsync(int enrollmentId, CancellationToken cancellationToken = default);
    }
}