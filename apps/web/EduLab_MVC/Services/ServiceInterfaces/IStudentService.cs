using EduLab_MVC.Models.DTOs.Notifications;
using EduLab_MVC.Models.DTOs.Student;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    #region Student Service Interface
    /// <summary>
    /// Interface defining contract for student-related operations in the MVC application
    /// Provides methods for student management, notifications, and data retrieval
    /// </summary>
    public interface IStudentService
    {
        #region Student Retrieval Methods
        /// <summary>
        /// Retrieves students based on specified filter criteria
        /// </summary>
        /// <param name="filter">The filter criteria containing search parameters, pagination, and status filters</param>
        /// <returns>
        /// Task representing the asynchronous operation that returns a list of StudentDto objects
        /// </returns>
        /// <remarks>
        /// This method supports filtering by search text, course ID, status, and pagination
        /// </remarks>
        Task<List<StudentDto>> GetStudentsAsync(StudentFilterDto filter);

        /// <summary>
        /// Retrieves summary statistics for students
        /// </summary>
        /// <returns>
        /// Task representing the asynchronous operation that returns StudentsSummaryDto containing summary data
        /// </returns>
        /// <remarks>
        /// Summary includes total students, active students, completed courses, and average completion rates
        /// </remarks>
        Task<StudentsSummaryDto> GetStudentsSummaryAsync();

        /// <summary>
        /// Retrieves students associated with the currently authenticated instructor
        /// </summary>
        /// <returns>
        /// Task representing the asynchronous operation that returns a list of StudentDto objects
        /// </returns>
        /// <remarks>
        /// This method uses the current user's context to retrieve their associated students
        /// </remarks>
        Task<List<StudentDto>> GetMyStudentsAsync();

        /// <summary>
        /// Retrieves students associated with a specific instructor
        /// </summary>
        /// <param name="instructorId">The unique identifier of the instructor</param>
        /// <returns>
        /// Task representing the asynchronous operation that returns a list of StudentDto objects
        /// </returns>
        /// <remarks>
        /// This method is useful for administrative purposes or when managing multiple instructors
        /// </remarks>
        Task<List<StudentDto>> GetStudentsByInstructorAsync(string instructorId);

        /// <summary>
        /// Retrieves detailed information for a specific student
        /// </summary>
        /// <param name="studentId">The unique identifier of the student</param>
        /// <returns>
        /// Task representing the asynchronous operation that returns StudentDetailsDto with comprehensive student data
        /// </returns>
        /// <remarks>
        /// Returns detailed information including enrollments, statistics, and recent activities
        /// </remarks>
        Task<StudentDetailsDto> GetStudentDetailsAsync(string studentId);
        #endregion

        #region Notification Methods
        /// <summary>
        /// Sends notifications to students based on the provided request
        /// </summary>
        /// <param name="request">The notification request containing message details and delivery options</param>
        /// <returns>
        /// Task representing the asynchronous operation that returns BulkNotificationResultDto with operation results
        /// </returns>
        /// <remarks>
        /// The result includes success status and any errors that occurred during the notification process
        /// </remarks>
        Task<BulkNotificationResultDto> SendNotificationAsync(InstructorNotificationRequestDto request);

        /// <summary>
        /// Retrieves students specifically for notification purposes with selection status
        /// </summary>
        /// <param name="selectedStudentIds">Optional list of pre-selected student IDs to mark as selected</param>
        /// <returns>
        /// Task representing the asynchronous operation that returns a list of StudentNotificationDto objects
        /// </returns>
        /// <remarks>
        /// This method is optimized for notification interfaces and includes selection status for each student
        /// </remarks>
        Task<List<StudentNotificationDto>> GetStudentsForNotificationAsync(List<string> selectedStudentIds = null);

        /// <summary>
        /// Retrieves summary information for notification operations
        /// </summary>
        /// <param name="selectedStudentIds">Optional list of selected student IDs for summary calculation</param>
        /// <returns>
        /// Task representing the asynchronous operation that returns InstructorNotificationSummaryDto with summary data
        /// </returns>
        /// <remarks>
        /// Provides statistics including total students, selected students count, and send-to-all indication
        /// </remarks>
        Task<InstructorNotificationSummaryDto> GetNotificationSummaryAsync(List<string> selectedStudentIds = null);
        #endregion
    }
    #endregion
}