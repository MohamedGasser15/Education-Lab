using EduLab_MVC.Models.DTOs.LectureComment;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    public interface ICommentsService
    {
        Task<List<LectureCommentDTO>> GetLectureCommentsAsync(int lectureId, CancellationToken cancellationToken = default);
        Task<LectureCommentDTO> AddCommentAsync(CreateLectureCommentDTO dto, CancellationToken cancellationToken = default);
        Task<LectureCommentDTO> ReplyToCommentAsync(int commentId, string content, CancellationToken cancellationToken = default);
        Task<bool> DeleteCommentAsync(int commentId, CancellationToken cancellationToken = default);
        Task<List<Models.DTOs.Instructor.QuestionGroupDTO>> GetInstructorQuestionsAsync(CancellationToken cancellationToken = default);
    }
}
