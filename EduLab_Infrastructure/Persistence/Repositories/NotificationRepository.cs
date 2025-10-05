// EduLab_Infrastructure/Persistence/Repositories/NotificationRepository.cs
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    public class NotificationRepository : Repository<Notification>, INotificationRepository
    {
        private readonly ApplicationDbContext _db;
        private readonly ILogger<NotificationRepository> _logger;
        public NotificationRepository(ApplicationDbContext db, ILogger<NotificationRepository> logger)
            : base(db, logger)
        {
            _db = db;
            _logger = logger;
        }

        public async Task<List<Notification>> GetUserNotificationsAsync(
            string userId,
            NotificationType? type = null,
            NotificationStatus? status = null,
            int pageNumber = 1,
            int pageSize = 10,
            CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogDebug("Getting notifications for user {UserId}", userId);

                var query = dbSet.Where(n => n.UserId == userId);

                if (type.HasValue)
                    query = query.Where(n => n.Type == type.Value);

                if (status.HasValue)
                    query = query.Where(n => n.Status == status.Value);

                var skip = (pageNumber - 1) * pageSize;
                return await query
                    .OrderByDescending(n => n.CreatedAt)
                    .Skip(skip)
                    .Take(pageSize)
                    .ToListAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting notifications for user {UserId}", userId);
                throw;
            }
        }

        public async Task<int> GetUserUnreadCountAsync(string userId, CancellationToken cancellationToken = default)
        {
            try
            {
                return await dbSet
                    .Where(n => n.UserId == userId && n.Status == NotificationStatus.Unread)
                    .CountAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting unread count for user {UserId}", userId);
                throw;
            }
        }

        public async Task<NotificationSummary> GetUserNotificationSummaryAsync(string userId, CancellationToken cancellationToken = default)
        {
            try
            {
                var totalCount = await dbSet
                    .Where(n => n.UserId == userId)
                    .CountAsync(cancellationToken);

                var unreadCount = await dbSet
                    .Where(n => n.UserId == userId && n.Status == NotificationStatus.Unread)
                    .CountAsync(cancellationToken);

                var systemCount = await dbSet
                    .Where(n => n.UserId == userId && n.Type == NotificationType.System)
                    .CountAsync(cancellationToken);

                var promotionalCount = await dbSet
                    .Where(n => n.UserId == userId && n.Type == NotificationType.Promotional)
                    .CountAsync(cancellationToken);

                return new NotificationSummary
                {
                    TotalCount = totalCount,
                    UnreadCount = unreadCount,
                    SystemCount = systemCount,
                    PromotionalCount = promotionalCount
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting notification summary for user {UserId}", userId);
                throw;
            }
        }

        public async Task MarkAllAsReadAsync(string userId, CancellationToken cancellationToken = default)
        {
            try
            {
                var unreadNotifications = await dbSet
                    .Where(n => n.UserId == userId && n.Status == NotificationStatus.Unread)
                    .ToListAsync(cancellationToken);

                foreach (var notification in unreadNotifications)
                {
                    notification.Status = NotificationStatus.Read;
                    notification.ReadAt = DateTime.UtcNow;
                }

                await SaveAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking all notifications as read for user {UserId}", userId);
                throw;
            }
        }

        public async Task DeleteAllUserNotificationsAsync(string userId, CancellationToken cancellationToken = default)
        {
            try
            {
                var userNotifications = await dbSet
                    .Where(n => n.UserId == userId)
                    .ToListAsync(cancellationToken);

                await DeleteRangeAsync(userNotifications, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting all notifications for user {UserId}", userId);
                throw;
            }
        }

        public async Task MarkAsReadAsync(int notificationId, string userId, CancellationToken cancellationToken = default)
        {
            try
            {
                var notification = await dbSet
                    .FirstOrDefaultAsync(n => n.Id == notificationId && n.UserId == userId, cancellationToken);

                if (notification != null && notification.Status == NotificationStatus.Unread)
                {
                    notification.Status = NotificationStatus.Read;
                    notification.ReadAt = DateTime.UtcNow;
                    await SaveAsync(cancellationToken);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking notification {NotificationId} as read for user {UserId}",
                    notificationId, userId);
                throw;
            }
        }
    }
}