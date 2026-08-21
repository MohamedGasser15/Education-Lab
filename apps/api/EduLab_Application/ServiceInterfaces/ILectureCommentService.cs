using EduLab_Application.DTOs.Instructor;
using EduLab_Application.DTOs.LectureComment;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for managing lecture comments
    /// </summary>
    public interface ILectureCommentService
    {
        /// <summary>
        /// Retrieves all comments of a lecture
        /// </summary>
        /// <param name="lectureId">Unique identifier of the lecture</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of lecture comment DTOs</returns>
        Task<List<LectureCommentDTO>> GetLectureCommentsAsync(int lectureId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Adds a new comment to a lecture
        /// </summary>
        /// <param name="userId">Unique identifier of the commenting user</param>
        /// <param name="dto">Comment creation data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The created comment DTO</returns>
        Task<LectureCommentDTO> AddCommentAsync(string userId, CreateLectureCommentDTO dto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Replies to an existing lecture comment
        /// </summary>
        /// <param name="userId">Unique identifier of the replying user</param>
        /// <param name="parentCommentId">Unique identifier of the parent comment</param>
        /// <param name="dto">Reply creation data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The created reply DTO</returns>
        Task<LectureCommentDTO> ReplyToCommentAsync(string userId, int parentCommentId, CreateLectureCommentDTO dto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a comment if the user owns it
        /// </summary>
        /// <param name="commentId">Unique identifier of the comment</param>
        /// <param name="userId">Unique identifier of the requesting user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the comment was deleted, otherwise false</returns>
        Task<bool> DeleteCommentAsync(int commentId, string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves comments grouped by lecture for an instructor
        /// </summary>
        /// <param name="instructorId">Unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of instructor comment groups</returns>
        Task<List<InstructorCommentsGroupDTO>> GetInstructorCommentsAsync(string instructorId, CancellationToken cancellationToken = default);
    }
}