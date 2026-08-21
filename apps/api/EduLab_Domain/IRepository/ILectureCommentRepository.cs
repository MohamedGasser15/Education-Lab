using EduLab_Domain.Entities;

namespace EduLab_Domain.IRepository
{
    /// <summary>
    /// Repository interface for lecture comment data operations
    /// </summary>
    public interface ILectureCommentRepository : IRepository<LectureComment>
    {
        /// <summary>
        /// Retrieves all comments for a lecture
        /// </summary>
        /// <param name="lectureId">Lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of lecture comments</returns>
        Task<List<LectureComment>> GetLectureCommentsAsync(int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Checks whether a user has commented on a lecture
        /// </summary>
        /// <param name="userId">User identifier</param>
        /// <param name="lectureId">Lecture identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if the user has commented, otherwise false</returns>
        Task<bool> HasUserCommentedOnLectureAsync(string userId, int lectureId, CancellationToken cancellationToken = default);
    }
}
