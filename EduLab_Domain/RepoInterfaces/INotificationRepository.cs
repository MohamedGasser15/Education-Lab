// EduLab_Domain/RepoInterfaces/INotificationRepository.cs
using EduLab_Domain.Entities;

namespace EduLab_Domain.RepoInterfaces
{
    public interface INotificationRepository : IRepository<Notification>
    {
        Task<List<Notification>> GetUserNotificationsAsync(
            string userId,
            NotificationType? type = null,
            NotificationStatus? status = null,
            int pageNumber = 1,
            int pageSize = 10,
            CancellationToken cancellationToken = default);

        Task<int> GetUserUnreadCountAsync(string userId, CancellationToken cancellationToken = default);
        Task<NotificationSummary> GetUserNotificationSummaryAsync(string userId, CancellationToken cancellationToken = default);
        Task MarkAllAsReadAsync(string userId, CancellationToken cancellationToken = default);
        Task DeleteAllUserNotificationsAsync(string userId, CancellationToken cancellationToken = default);
        Task MarkAsReadAsync(int notificationId, string userId, CancellationToken cancellationToken = default);
    }

    public class NotificationSummary
    {
        public int TotalCount { get; set; }
        public int UnreadCount { get; set; }
        public int SystemCount { get; set; }
        public int PromotionalCount { get; set; }
    }
}