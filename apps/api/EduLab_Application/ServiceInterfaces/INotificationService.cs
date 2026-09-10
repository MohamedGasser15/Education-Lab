using EduLab_Application.DTOs.Notification;
using EduLab_Application.DTOs.Student;

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

        /// <summary>
        /// Sends notifications and/or emails from an instructor to their students
        /// </summary>
        /// <param name="request">The notification request details</param>
        /// <param name="instructorId">Unique identifier of the instructor</param>
        /// <returns>Result with sent and failed counts</returns>
        Task<BulkNotificationResultDto> SendInstructorNotificationAsync(InstructorNotificationRequestDto request, string instructorId);

        /// <summary>
        /// Retrieves the students of an instructor with a selection flag
        /// </summary>
        /// <param name="instructorId">Unique identifier of the instructor</param>
        /// <param name="selectedStudentIds">Optional list of already selected student IDs</param>
        /// <returns>List of student notification DTOs</returns>
        Task<List<StudentNotificationDto>> GetInstructorStudentsForNotificationAsync(string instructorId, List<string> selectedStudentIds = null);

        /// <summary>
        /// Retrieves a summary for the instructor notification form
        /// </summary>
        /// <param name="instructorId">Unique identifier of the instructor</param>
        /// <param name="selectedStudentIds">Optional list of already selected student IDs</param>
        /// <returns>Instructor notification summary DTO</returns>
        Task<InstructorNotificationSummaryDto> GetInstructorNotificationSummaryAsync(string instructorId, List<string> selectedStudentIds = null);

        /// <summary>
        /// Sends notifications and/or emails to users matching a target audience
        /// </summary>
        /// <param name="request">The admin notification request details</param>
        /// <returns>Result with sent and failed counts</returns>
        Task<BulkNotificationResultDto> SendBulkNotificationAsync(AdminNotificationRequestDto request);

        /// <summary>
        /// Resolves the user IDs matching a notification target audience
        /// </summary>
        /// <param name="target">The target audience</param>
        /// <returns>List of user IDs</returns>
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

        /// <summary>
        /// Updates the device token for push notifications for a user
        /// </summary>
        /// <param name="userId">User ID</param>
        /// <param name="deviceToken">Device token (FCM / APNs)</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if updated, false otherwise</returns>
        Task<bool> UpdateDeviceTokenAsync(string userId, string deviceToken, CancellationToken cancellationToken = default);

        /// <summary>
        /// Sends a test push notification to the user's registered device
        /// </summary>
        /// <param name="userId">User ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if sent successfully, false otherwise</returns>
        Task<bool> SendTestPushNotificationAsync(string userId, CancellationToken cancellationToken = default);
        #endregion
    }
    #endregion
}
