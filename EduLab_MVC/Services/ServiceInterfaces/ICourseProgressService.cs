using EduLab_MVC.Models.DTOsCourseProgress;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    public interface ICourseProgressService
    {
        Task<bool> MarkLectureAsCompletedAsync(int courseId, int lectureId, CancellationToken cancellationToken = default);
        Task<bool> MarkLectureAsIncompleteAsync(int courseId, int lectureId, CancellationToken cancellationToken = default);
        Task<CourseProgressSummaryDto> GetCourseProgressAsync(int courseId, CancellationToken cancellationToken = default);
        Task<bool> GetLectureStatusAsync(int courseId, int lectureId, CancellationToken cancellationToken = default);
        Task<List<LectureProgressDto>> GetCourseProgressDetailsAsync(int courseId, CancellationToken cancellationToken = default);
        Task<Dictionary<int, bool>> GetLecturesStatusAsync(int courseId, List<int> lectureIds, CancellationToken cancellationToken = default);
    }
}