// EduLab_Domain/RepoInterfaces/ICourseProgressRepository.cs
using EduLab_Domain.Entities;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    public interface ICourseProgressRepository
    {
        Task<CourseProgress> GetProgressAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default);
        Task<List<CourseProgress>> GetProgressByEnrollmentAsync(int enrollmentId, CancellationToken cancellationToken = default);
        Task<CourseProgress> CreateProgressAsync(CourseProgress progress, CancellationToken cancellationToken = default);
        Task<CourseProgress> UpdateProgressAsync(CourseProgress progress, CancellationToken cancellationToken = default);
        Task<bool> DeleteProgressAsync(int progressId, CancellationToken cancellationToken = default);
        Task<int> GetCompletedLecturesCountAsync(int enrollmentId, CancellationToken cancellationToken = default);
        Task<bool> IsLectureCompletedAsync(int enrollmentId, int lectureId, CancellationToken cancellationToken = default);
        Task<decimal> GetCourseProgressPercentageAsync(int enrollmentId, CancellationToken cancellationToken = default);
    }
}