using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Student;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    #region Student Repository Interface
    /// <summary>
    /// Interface for student repository operations
    /// </summary>
    public interface IStudentRepository
    {
        #region Student Retrieval Methods
        /// <summary>
        /// Retrieves all students with basic information
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of application users representing students</returns>
        Task<List<ApplicationUser>> GetStudentsAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a student by their unique identifier
        /// </summary>
        /// <param name="studentId">The unique identifier of the student</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The student entity if found, otherwise null</returns>
        Task<ApplicationUser> GetStudentByIdAsync(string studentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves students by instructor ID
        /// </summary>
        /// <param name="instructorId">The unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of students associated with the instructor</returns>
        Task<List<ApplicationUser>> GetStudentsByInstructorAsync(string instructorId, CancellationToken cancellationToken = default);
        #endregion

        #region Notification Methods
        /// <summary>
        /// Retrieves students for notification purposes for a specific instructor
        /// </summary>
        /// <param name="instructorId">The unique identifier of the instructor</param>
        /// <param name="selectedStudentIds">Optional list of pre-selected student IDs</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of student notification DTOs</returns>
        Task<List<StudentNotificationDto>> GetStudentsForNotificationAsync(string instructorId, List<string> selectedStudentIds = null, CancellationToken cancellationToken = default);

        /// <summary>
        /// Validates that the specified students belong to the given instructor
        /// </summary>
        /// <param name="instructorId">The unique identifier of the instructor</param>
        /// <param name="studentIds">List of student IDs to validate</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if all students belong to the instructor, otherwise false</returns>
        Task<bool> ValidateStudentsBelongToInstructorAsync(string instructorId, List<string> studentIds, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves notification summary for an instructor
        /// </summary>
        /// <param name="instructorId">The unique identifier of the instructor</param>
        /// <param name="selectedStudentIds">Optional list of selected student IDs</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Instructor notification summary DTO</returns>
        Task<InstructorNotificationSummaryDto> GetNotificationSummaryAsync(string instructorId, List<string> selectedStudentIds = null, CancellationToken cancellationToken = default);
        #endregion

        #region Enrollment and Progress Methods
        /// <summary>
        /// Retrieves student enrollments with progress information
        /// </summary>
        /// <param name="studentId">The unique identifier of the student</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of student enrollment DTOs with progress details</returns>
        Task<List<StudentEnrollmentDto>> GetStudentEnrollmentsAsync(string studentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves student activities
        /// </summary>
        /// <param name="studentId">The unique identifier of the student</param>
        /// <param name="count">Number of activities to retrieve (default: 10)</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of student activity DTOs</returns>
        Task<List<StudentActivityDto>> GetStudentActivitiesAsync(string studentId, int count = 10, CancellationToken cancellationToken = default);
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
        /// Retrieves progress details for multiple students
        /// </summary>
        /// <param name="studentIds">List of student IDs to retrieve progress for</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of student progress DTOs</returns>
        Task<List<StudentProgressDto>> GetStudentsProgressAsync(List<string> studentIds, CancellationToken cancellationToken = default);
        #endregion
    }
    #endregion
}