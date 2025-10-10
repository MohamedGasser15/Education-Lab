using EduLab_Shared.DTOs.Student;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    #region Student Service Interface
    /// <summary>
    /// Interface for student service operations
    /// </summary>
    public interface IStudentService
    {
        #region Student Retrieval Methods
        /// <summary>
        /// Retrieves all students
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of student DTOs</returns>
        Task<List<StudentDto>> GetStudentsAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves detailed information for a specific student
        /// </summary>
        /// <param name="studentId">The unique identifier of the student</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Student details DTO</returns>
        Task<StudentDetailsDto> GetStudentDetailsAsync(string studentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves students by instructor ID
        /// </summary>
        /// <param name="instructorId">The unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of student DTOs</returns>
        Task<List<StudentDto>> GetStudentsByInstructorAsync(string instructorId, CancellationToken cancellationToken = default);
        #endregion

        #region Summary and Progress Methods
        /// <summary>
        /// Retrieves students summary for an instructor
        /// </summary>
        /// <param name="instructorId">The unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Students summary DTO</returns>
        Task<StudentsSummaryDto> GetStudentsSummaryByInstructorAsync(string instructorId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves progress information for multiple students
        /// </summary>
        /// <param name="studentIds">List of student IDs</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of student progress DTOs</returns>
        Task<List<StudentProgressDto>> GetStudentsProgressAsync(List<string> studentIds, CancellationToken cancellationToken = default);
        #endregion

        #region Notification Methods
        /// <summary>
        /// Sends bulk messages to students
        /// </summary>
        /// <param name="messageDto">Bulk message DTO containing message details</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if message was sent successfully, otherwise false</returns>
        Task<bool> SendBulkMessageAsync(BulkMessageDto messageDto, CancellationToken cancellationToken = default);
        #endregion
    }
    #endregion
}