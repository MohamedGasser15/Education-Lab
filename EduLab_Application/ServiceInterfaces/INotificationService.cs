using EduLab_Shared.DTOs.Notification;
using EduLab_Shared.DTOs.Student;

namespace EduLab_Application.ServiceInterfaces
{
    #region Notification Service Interface
    /// <summary>
    /// Service interface for notification business operations
    /// </summary>
    public interface INotificationService
    {
        #region Notification Operations
        /// <summary>
        /// Retrieves user notifications with filtering and pagination
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="filter">Filter criteria for notifications</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of notification DTOs</returns>
        Task<List<NotificationDto>> GetUserNotificationsAsync(string userId, NotificationFilterDto filter, CancellationToken cancellationToken = default);
        Task<BulkNotificationResultDto> SendInstructorNotificationAsync(InstructorNotificationRequestDto request, string instructorId);
        Task<List<StudentNotificationDto>> GetInstructorStudentsForNotificationAsync(string instructorId, List<string> selectedStudentIds = null);
        Task<InstructorNotificationSummaryDto> GetInstructorNotificationSummaryAsync(string instructorId, List<string> selectedStudentIds = null);
        Task<BulkNotificationResultDto> SendBulkNotificationAsync(AdminNotificationRequestDto request);
        Task<List<string>> GetUsersByTargetAsync(NotificationTargetDto target);

        /// <summary>
        /// Gets a summary of user notifications
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Notification summary DTO</returns>
        Task<NotificationSummaryDto> GetUserNotificationSummaryAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Creates a new notification
        /// </summary>
        /// <param name="createDto">Data for creating the notification</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Created notification DTO</returns>
        Task<NotificationDto> CreateNotificationAsync(CreateNotificationDto createDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Marks a specific notification as read
        /// </summary>
        /// <param name="notificationId">The unique identifier of the notification</param>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Task representing the asynchronous operation</returns>
        Task MarkNotificationAsReadAsync(int notificationId, string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Marks all user notifications as read
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Task representing the asynchronous operation</returns>
        Task MarkAllNotificationsAsReadAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a specific notification
        /// </summary>
        /// <param name="notificationId">The unique identifier of the notification</param>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Task representing the asynchronous operation</returns>
        Task DeleteNotificationAsync(int notificationId, string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes all user notifications
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Task representing the asynchronous operation</returns>
        Task DeleteAllNotificationsAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets the count of unread notifications for a user
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Count of unread notifications</returns>
        Task<int> GetUnreadCountAsync(string userId, CancellationToken cancellationToken = default);
        #endregion
    }
    #endregion
}
