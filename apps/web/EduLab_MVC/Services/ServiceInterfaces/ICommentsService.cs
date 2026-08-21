using EduLab_MVC.Models.DTOs.LectureComment;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for lecture comment operations in the MVC application.
    /// </summary>
    public interface ICommentsService
    {
        /// <summary>
        /// Retrieves the comments for a lecture.
        /// </summary>
        Task<List<LectureCommentDTO>> GetLectureCommentsAsync(int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Adds a comment to a lecture.
        /// </summary>
        Task<LectureCommentDTO> AddCommentAsync(CreateLectureCommentDTO dto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Adds a reply to an existing comment.
        /// </summary>
        Task<LectureCommentDTO> ReplyToCommentAsync(int commentId, string content, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a comment.
        /// </summary>
        Task<bool> DeleteCommentAsync(int commentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the question groups used by instructors.
        /// </summary>
        Task<List<Models.DTOs.Instructor.QuestionGroupDTO>> GetInstructorQuestionsAsync(CancellationToken cancellationToken = default);
    }
}
