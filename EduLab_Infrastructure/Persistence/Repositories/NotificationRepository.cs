using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using EduLab_Shared.DTOs.Notification;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Diagnostics;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    #region Notification Repository Implementation
    /// <summary>
    /// Repository implementation for Notification entity with specific business operations
    /// </summary>
    public class NotificationRepository : Repository<Notification>, INotificationRepository
    {
        #region Fields
        private readonly ApplicationDbContext _dbContext;
        private readonly ILogger<NotificationRepository> _logger;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the NotificationRepository class
        /// </summary>
        /// <param name="dbContext">Application database context</param>
        /// <param name="logger">Logger instance for logging operations</param>
        /// <exception cref="ArgumentNullException">Thrown when dbContext or logger is null</exception>
        public NotificationRepository(ApplicationDbContext dbContext, ILogger<NotificationRepository> logger)
            : base(dbContext, logger)
        {
            _dbContext = dbContext ?? throw new ArgumentNullException(nameof(dbContext));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }
        #endregion

        #region Notification Specific Operations
        /// <summary>
        /// Retrieves paginated notifications for a specific user with optional filtering
        /// </summary>
        public async Task<List<Notification>> GetUserNotificationsAsync(
            string userId,
            NotificationType? type = null,
            NotificationStatus? status = null,
            int pageNumber = 1,
            int pageSize = 10,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetUserNotificationsAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user {UserId} with filters - Type: {Type}, Status: {Status}, Page: {Page}, Size: {Size}",
                    operationName, userId, type, status, pageNumber, pageSize);

                // Validate input parameters
                if (string.IsNullOrWhiteSpace(userId))
                    throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

                if (pageNumber < 1)
                    throw new ArgumentException("Page number must be greater than 0", nameof(pageNumber));

                if (pageSize < 1 || pageSize > 100)
                    throw new ArgumentException("Page size must be between 1 and 100", nameof(pageSize));

                var query = dbSet.Where(n => n.UserId == userId);

                // Apply filters if provided
                if (type.HasValue)
                {
                    query = query.Where(n => n.Type == type.Value);
                    _logger.LogDebug("Applied type filter: {NotificationType}", type.Value);
                }

                if (status.HasValue)
                {
                    query = query.Where(n => n.Status == status.Value);
                    _logger.LogDebug("Applied status filter: {NotificationStatus}", status.Value);
                }

                // Calculate pagination
                var skipAmount = (pageNumber - 1) * pageSize;
                var result = await query
                    .OrderByDescending(n => n.CreatedAt)
                    .Skip(skipAmount)
                    .Take(pageSize)
                    .ToListAsync(cancellationToken);

                _logger.LogInformation("Successfully retrieved {Count} notifications for user {UserId} in {OperationName}",
                    result.Count, userId, operationName);

                return result;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user {UserId}", operationName, userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user {UserId}", operationName, userId);
                throw;
            }
        }

        /// <summary>
        /// Gets the count of unread notifications for a user
        /// </summary>
        public async Task<int> GetUserUnreadCountAsync(string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetUserUnreadCountAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user {UserId}", operationName, userId);

                if (string.IsNullOrWhiteSpace(userId))
                    throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

                var count = await dbSet
                    .AsNoTracking()
                    .Where(n => n.UserId == userId && n.Status == NotificationStatus.Unread)
                    .CountAsync(cancellationToken);

                _logger.LogInformation("Successfully retrieved unread count {Count} for user {UserId} in {OperationName}",
                    count, userId, operationName);

                return count;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user {UserId}", operationName, userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user {UserId}", operationName, userId);
                throw;
            }
        }

        /// <summary>
        /// Gets a summary of user notifications including counts by type
        /// </summary>
        public async Task<NotificationSummary> GetUserNotificationSummaryAsync(string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetUserNotificationSummaryAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user {UserId}", operationName, userId);

                if (string.IsNullOrWhiteSpace(userId))
                    throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

                // Use a single query to get all counts for better performance
                var query = dbSet.AsNoTracking().Where(n => n.UserId == userId);

                var totalCount = await query.CountAsync(cancellationToken);
                var unreadCount = await query.CountAsync(n => n.Status == NotificationStatus.Unread, cancellationToken);
                var systemCount = await query.CountAsync(n => n.Type == NotificationType.System, cancellationToken);
                var promotionalCount = await query.CountAsync(n => n.Type == NotificationType.Promotional, cancellationToken);

                var summary = new NotificationSummary
                {
                    TotalCount = totalCount,
                    UnreadCount = unreadCount,
                    SystemCount = systemCount,
                    PromotionalCount = promotionalCount
                };

                _logger.LogInformation("Successfully retrieved notification summary for user {UserId} in {OperationName} - Total: {Total}, Unread: {Unread}",
                    userId, operationName, totalCount, unreadCount);

                return summary;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user {UserId}", operationName, userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user {UserId}", operationName, userId);
                throw;
            }
        }

        /// <summary>
        /// Marks all unread notifications as read for a user
        /// </summary>
        public async Task MarkAllAsReadAsync(string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(MarkAllAsReadAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user {UserId}", operationName, userId);

                if (string.IsNullOrWhiteSpace(userId))
                    throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

                var unreadNotifications = await dbSet
                    .Where(n => n.UserId == userId && n.Status == NotificationStatus.Unread)
                    .ToListAsync(cancellationToken);

                if (!unreadNotifications.Any())
                {
                    _logger.LogInformation("No unread notifications found for user {UserId} in {OperationName}", userId, operationName);
                    return;
                }

                var now = DateTime.UtcNow;
                foreach (var notification in unreadNotifications)
                {
                    notification.Status = NotificationStatus.Read;
                    notification.ReadAt = now;
                }

                await SaveAsync(cancellationToken);

                _logger.LogInformation("Successfully marked {Count} notifications as read for user {UserId} in {OperationName}",
                    unreadNotifications.Count, userId, operationName);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user {UserId}", operationName, userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user {UserId}", operationName, userId);
                throw;
            }
        }

        /// <summary>
        /// Deletes all notifications for a specific user
        /// </summary>
        public async Task DeleteAllUserNotificationsAsync(string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(DeleteAllUserNotificationsAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user {UserId}", operationName, userId);

                if (string.IsNullOrWhiteSpace(userId))
                    throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

                var userNotifications = await dbSet
                    .Where(n => n.UserId == userId)
                    .ToListAsync(cancellationToken);

                if (!userNotifications.Any())
                {
                    _logger.LogInformation("No notifications found for user {UserId} in {OperationName}", userId, operationName);
                    return;
                }

                await DeleteRangeAsync(userNotifications, cancellationToken);

                _logger.LogInformation("Successfully deleted {Count} notifications for user {UserId} in {OperationName}",
                    userNotifications.Count, userId, operationName);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user {UserId}", operationName, userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user {UserId}", operationName, userId);
                throw;
            }
        }

        /// <summary>
        /// Marks a specific notification as read
        /// </summary>
        public async Task MarkAsReadAsync(int notificationId, string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(MarkAsReadAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for notification {NotificationId} and user {UserId}",
                    operationName, notificationId, userId);

                if (string.IsNullOrWhiteSpace(userId))
                    throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

                var notification = await dbSet
                    .FirstOrDefaultAsync(n => n.Id == notificationId && n.UserId == userId, cancellationToken);

                if (notification == null)
                {
                    _logger.LogWarning("Notification {NotificationId} not found for user {UserId} in {OperationName}",
                        notificationId, userId, operationName);
                    return;
                }

                if (notification.Status == NotificationStatus.Unread)
                {
                    notification.Status = NotificationStatus.Read;
                    notification.ReadAt = DateTime.UtcNow;
                    await SaveAsync(cancellationToken);

                    _logger.LogInformation("Successfully marked notification {NotificationId} as read for user {UserId} in {OperationName}",
                        notificationId, userId, operationName);
                }
                else
                {
                    _logger.LogDebug("Notification {NotificationId} is already marked as read for user {UserId}",
                        notificationId, userId);
                }
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for notification {NotificationId} and user {UserId}",
                    operationName, notificationId, userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for notification {NotificationId} and user {UserId}",
                    operationName, notificationId, userId);
                throw;
            }
        }
        #endregion
    }
    #endregion
}