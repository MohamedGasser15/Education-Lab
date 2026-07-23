using EduLab_Application.DTOs.LectureComment;

namespace EduLab_Application.ServiceInterfaces
{
    public interface ILectureCommentService
    {
        Task<List<LectureCommentDTO>> GetLectureCommentsAsync(int lectureId, CancellationToken cancellationToken = default);
        Task<LectureCommentDTO> AddCommentAsync(string userId, CreateLectureCommentDTO dto, CancellationToken cancellationToken = default);
        Task<LectureCommentDTO> ReplyToCommentAsync(string userId, int parentCommentId, CreateLectureCommentDTO dto, CancellationToken cancellationToken = default);
        Task<bool> DeleteCommentAsync(int commentId, string userId, CancellationToken cancellationToken = default);
    }
}
