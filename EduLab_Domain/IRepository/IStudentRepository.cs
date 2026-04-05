using EduLab_Domain.Entities;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.IRepository
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
        /// Retrieves students for notification purposes for a specific instructor (returns entities)
        /// </summary>
        /// <param name="instructorId">The unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of student entities</returns>
        Task<List<ApplicationUser>> GetStudentsForNotificationAsync(string instructorId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Validates that the specified students belong to the given instructor
        /// </summary>
        /// <param name="instructorId">The unique identifier of the instructor</param>
        /// <param name="studentIds">List of student IDs to validate</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if all students belong to the instructor, otherwise false</returns>
        Task<bool> ValidateStudentsBelongToInstructorAsync(string instructorId, List<string> studentIds, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets total number of students for an instructor
        /// </summary>
        /// <param name="instructorId">The unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Total count of distinct students</returns>
        Task<int> GetTotalStudentsByInstructorAsync(string instructorId, CancellationToken cancellationToken = default);
        #endregion

        #region Enrollment and Progress Methods
        /// <summary>
        /// Retrieves student enrollments with all necessary related data (Course, Sections, Lectures, Instructor)
        /// </summary>
        /// <param name="studentId">The unique identifier of the student</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of Enrollment entities with includes</returns>
        Task<List<Enrollment>> GetStudentEnrollmentsWithDetailsAsync(string studentId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves recent student enrollments to be used as activities
        /// </summary>
        /// <param name="studentId">The unique identifier of the student</param>
        /// <param name="count">Number of enrollments to retrieve</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of Enrollment entities with Course</returns>
        Task<List<Enrollment>> GetRecentStudentEnrollmentsAsync(string studentId, int count, CancellationToken cancellationToken = default);
        #endregion

        #region Summary and Progress Methods
        /// <summary>
        /// Retrieves summary statistics for an instructor
        /// </summary>
        /// <param name="instructorId">The unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Tuple containing (TotalStudents, ActiveStudents, CompletedCourses, AverageCompletion)</returns>
        Task<(int TotalStudents, int ActiveStudents, int CompletedCourses, decimal AverageCompletion)> GetStudentsSummaryStatsByInstructorAsync(string instructorId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves progress details for multiple students (returns enrollments with related data)
        /// </summary>
        /// <param name="studentIds">List of student IDs to retrieve progress for</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of Enrollment entities with Course, Sections, Lectures and CourseProgress</returns>
        Task<List<Enrollment>> GetStudentsProgressEnrollmentsAsync(List<string> studentIds, CancellationToken cancellationToken = default);
        #endregion
    }
    #endregion
}