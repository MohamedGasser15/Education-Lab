using EduLab_MVC.Models.DTOs.Notifications;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for notification operations in the MVC application.
    /// </summary>
    public interface INotificationService
    {
        /// <summary>
        /// Retrieves the current user's notifications based on the provided filter.
        /// </summary>
        Task<List<NotificationDto>> GetUserNotificationsAsync(NotificationFilterDto filter);

        /// <summary>
        /// Retrieves a summary of the current user's notifications.
        /// </summary>
        Task<NotificationSummaryDto> GetUserNotificationSummaryAsync();

        /// <summary>
        /// Retrieves the current user's unread notification count.
        /// </summary>
        Task<int> GetUnreadCountAsync();

        /// <summary>
        /// Sends a bulk notification to the target users.
        /// </summary>
        Task<BulkNotificationResultDto> SendBulkNotificationAsync(AdminNotificationRequestDto request);

        /// <summary>
        /// Marks all of the current user's notifications as read.
        /// </summary>
        Task MarkAllNotificationsAsReadAsync();

        /// <summary>
        /// Marks a single notification as read.
        /// </summary>
        Task MarkNotificationAsReadAsync(int id);

        /// <summary>
        /// Deletes a notification.
        /// </summary>
        Task DeleteNotificationAsync(int id);

        /// <summary>
        /// Deletes all of the current user's notifications.
        /// </summary>
        Task DeleteAllNotificationsAsync();
    }
}
