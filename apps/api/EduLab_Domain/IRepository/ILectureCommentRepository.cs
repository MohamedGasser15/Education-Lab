using EduLab_Domain.Entities;

namespace EduLab_Domain.IRepository
{
    public interface ILectureCommentRepository : IRepository<LectureComment>
    {
        Task<List<LectureComment>> GetLectureCommentsAsync(int lectureId, CancellationToken cancellationToken = default);
        Task<bool> HasUserCommentedOnLectureAsync(string userId, int lectureId, CancellationToken cancellationToken = default);
    }
}
