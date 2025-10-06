using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Notification;

namespace EduLab_Domain.RepoInterfaces
{
    #region Notification Repository Interface
    /// <summary>
    /// Interface for Notification-specific data operations
    /// </summary>
    public interface INotificationRepository : IRepository<Notification>
    {
        #region Notification Specific Operations
        /// <summary>
        /// Retrieves paginated notifications for a specific user with optional filtering
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="type">Optional filter by notification type</param>
        /// <param name="status">Optional filter by notification status</param>
        /// <param name="pageNumber">Page number for pagination (default: 1)</param>
        /// <param name="pageSize">Number of items per page (default: 10)</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of user notifications</returns>
        Task<List<Notification>> GetUserNotificationsAsync(
            string userId,
            NotificationType? type = null,
            NotificationStatus? status = null,
            int pageNumber = 1,
            int pageSize = 10,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets the count of unread notifications for a user
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Count of unread notifications</returns>
        Task<int> GetUserUnreadCountAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets a summary of user notifications including counts by type
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Notification summary object</returns>
        Task<NotificationSummary> GetUserNotificationSummaryAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Marks all unread notifications as read for a user
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Task representing the asynchronous operation</returns>
        Task MarkAllAsReadAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes all notifications for a specific user
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Task representing the asynchronous operation</returns>
        Task DeleteAllUserNotificationsAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Marks a specific notification as read
        /// </summary>
        /// <param name="notificationId">The unique identifier of the notification</param>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Task representing the asynchronous operation</returns>
        Task MarkAsReadAsync(int notificationId, string userId, CancellationToken cancellationToken = default);
        #endregion
    }
    #endregion
}