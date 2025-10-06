using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Notification;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    #region Notification Service Implementation
    /// <summary>
    /// Service implementation for notification business operations
    /// </summary>
    public class NotificationService : INotificationService
    {
        #region Fields
        private readonly INotificationRepository _notificationRepository;
        private readonly IMapper _mapper;
        private readonly ILogger<NotificationService> _logger;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the NotificationService class
        /// </summary>
        /// <param name="notificationRepository">Notification repository instance</param>
        /// <param name="mapper">AutoMapper instance</param>
        /// <param name="logger">Logger instance</param>
        /// <exception cref="ArgumentNullException">Thrown when any dependency is null</exception>
        public NotificationService(
            INotificationRepository notificationRepository,
            IMapper mapper,
            ILogger<NotificationService> logger)
        {
            _notificationRepository = notificationRepository ?? throw new ArgumentNullException(nameof(notificationRepository));
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }
        #endregion

        #region Public Methods
        /// <summary>
        /// Retrieves user notifications with filtering and pagination
        /// </summary>
        public async Task<List<NotificationDto>> GetUserNotificationsAsync(string userId, NotificationFilterDto filter, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetUserNotificationsAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user {UserId} with filter", operationName, userId);

                // Validate input parameters
                if (string.IsNullOrWhiteSpace(userId))
                    throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

                if (filter == null)
                    throw new ArgumentNullException(nameof(filter));

                // Map DTO enums to domain enums
                var domainType = filter.Type?.MapToDomain();
                var domainStatus = filter.Status?.MapToDomain();

                // Retrieve notifications from repository
                var notifications = await _notificationRepository.GetUserNotificationsAsync(
                    userId,
                    domainType,
                    domainStatus,
                    filter.PageNumber,
                    filter.PageSize,
                    cancellationToken);

                // Map to DTOs
                var notificationDtos = _mapper.Map<List<NotificationDto>>(notifications);

                // Enhance DTOs with UI-specific properties
                foreach (var notification in notificationDtos)
                {
                    var (iconClass, colorClass) = GetNotificationStyle(notification.Type);
                    notification.IconClass = iconClass;
                    notification.ColorClass = colorClass;
                }

                _logger.LogInformation("Successfully retrieved {Count} notifications for user {UserId} in {OperationName}",
                    notificationDtos.Count, userId, operationName);

                return notificationDtos;
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
        /// Gets a summary of user notifications
        /// </summary>
        public async Task<NotificationSummaryDto> GetUserNotificationSummaryAsync(string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetUserNotificationSummaryAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user {UserId}", operationName, userId);

                if (string.IsNullOrWhiteSpace(userId))
                    throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

                var summary = await _notificationRepository.GetUserNotificationSummaryAsync(userId, cancellationToken);
                var summaryDto = _mapper.Map<NotificationSummaryDto>(summary);

                _logger.LogInformation("Successfully retrieved notification summary for user {UserId} in {OperationName}",
                    userId, operationName);

                return summaryDto;
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
        /// Creates a new notification
        /// </summary>
        public async Task<NotificationDto> CreateNotificationAsync(CreateNotificationDto createDto, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(CreateNotificationAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user {UserId}", operationName, createDto.UserId);

                if (createDto == null)
                    throw new ArgumentNullException(nameof(createDto));

                if (string.IsNullOrWhiteSpace(createDto.UserId))
                    throw new ArgumentException("User ID cannot be null or empty", nameof(createDto.UserId));

                // Create notification entity
                var notification = new Notification
                {
                    Title = createDto.Title?.Trim() ?? throw new ArgumentException("Title is required", nameof(createDto.Title)),
                    Message = createDto.Message?.Trim() ?? throw new ArgumentException("Message is required", nameof(createDto.Message)),
                    Type = createDto.Type.MapToDomain(),
                    UserId = createDto.UserId,
                    RelatedEntityId = createDto.RelatedEntityId,
                    RelatedEntityType = createDto.RelatedEntityType,
                    CreatedAt = DateTime.UtcNow,
                    Status = NotificationStatus.Unread
                };

                // Save to repository
                await _notificationRepository.CreateAsync(notification, cancellationToken);

                // Map to DTO and enhance with UI properties
                var notificationDto = _mapper.Map<NotificationDto>(notification);
                var (iconClass, colorClass) = GetNotificationStyle(notificationDto.Type);
                notificationDto.IconClass = iconClass;
                notificationDto.ColorClass = colorClass;

                _logger.LogInformation("Successfully created notification {NotificationId} for user {UserId} in {OperationName}",
                    notification.Id, createDto.UserId, operationName);

                return notificationDto;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user {UserId}", operationName, createDto?.UserId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user {UserId}", operationName, createDto?.UserId);
                throw;
            }
        }

        /// <summary>
        /// Marks a specific notification as read
        /// </summary>
        public async Task MarkNotificationAsReadAsync(int notificationId, string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(MarkNotificationAsReadAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for notification {NotificationId} and user {UserId}",
                    operationName, notificationId, userId);

                if (string.IsNullOrWhiteSpace(userId))
                    throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

                await _notificationRepository.MarkAsReadAsync(notificationId, userId, cancellationToken);

                _logger.LogInformation("Successfully marked notification {NotificationId} as read for user {UserId} in {OperationName}",
                    notificationId, userId, operationName);
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

        /// <summary>
        /// Marks all user notifications as read
        /// </summary>
        public async Task MarkAllNotificationsAsReadAsync(string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(MarkAllNotificationsAsReadAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user {UserId}", operationName, userId);

                if (string.IsNullOrWhiteSpace(userId))
                    throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

                await _notificationRepository.MarkAllAsReadAsync(userId, cancellationToken);

                _logger.LogInformation("Successfully marked all notifications as read for user {UserId} in {OperationName}",
                    userId, operationName);
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
        /// Deletes a specific notification
        /// </summary>
        public async Task DeleteNotificationAsync(int notificationId, string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(DeleteNotificationAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for notification {NotificationId} and user {UserId}",
                    operationName, notificationId, userId);

                if (string.IsNullOrWhiteSpace(userId))
                    throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

                var notification = await _notificationRepository.GetAsync(
                    n => n.Id == notificationId && n.UserId == userId,
                    cancellationToken: cancellationToken);

                if (notification != null)
                {
                    await _notificationRepository.DeleteAsync(notification, cancellationToken);
                    _logger.LogInformation("Successfully deleted notification {NotificationId} for user {UserId} in {OperationName}",
                        notificationId, userId, operationName);
                }
                else
                {
                    _logger.LogWarning("Notification {NotificationId} not found for user {UserId} in {OperationName}",
                        notificationId, userId, operationName);
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

        /// <summary>
        /// Deletes all user notifications
        /// </summary>
        public async Task DeleteAllNotificationsAsync(string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(DeleteAllNotificationsAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user {UserId}", operationName, userId);

                if (string.IsNullOrWhiteSpace(userId))
                    throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

                await _notificationRepository.DeleteAllUserNotificationsAsync(userId, cancellationToken);

                _logger.LogInformation("Successfully deleted all notifications for user {UserId} in {OperationName}",
                    userId, operationName);
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
        public async Task<int> GetUnreadCountAsync(string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetUnreadCountAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user {UserId}", operationName, userId);

                if (string.IsNullOrWhiteSpace(userId))
                    throw new ArgumentException("User ID cannot be null or empty", nameof(userId));

                var count = await _notificationRepository.GetUserUnreadCountAsync(userId, cancellationToken);

                _logger.LogDebug("Retrieved unread count {Count} for user {UserId} in {OperationName}",
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
        #endregion

        #region Private Methods
        /// <summary>
        /// Gets the UI style properties for a notification type
        /// </summary>
        /// <param name="type">The notification type</param>
        /// <returns>Tuple containing icon class and color class</returns>
        private static (string iconClass, string colorClass) GetNotificationStyle(NotificationTypeDto type)
        {
            return type switch
            {
                NotificationTypeDto.System => ("fas fa-cog", "bg-purple-100 dark:bg-purple-900 text-purple-600 dark:text-purple-400"),
                NotificationTypeDto.Promotional => ("fas fa-percentage", "bg-yellow-100 dark:bg-yellow-900 text-yellow-600 dark:text-yellow-400"),
                NotificationTypeDto.Course => ("fas fa-book", "bg-blue-100 dark:bg-blue-900 text-blue-600 dark:text-blue-400"),
                NotificationTypeDto.Enrollment => ("fas fa-check-circle", "bg-green-100 dark:bg-green-900 text-green-600 dark:text-green-400"),
                NotificationTypeDto.Reminder => ("fas fa-bell", "bg-red-100 dark:bg-red-900 text-red-600 dark:text-red-400"),
                _ => ("fas fa-bell", "bg-gray-100 dark:bg-gray-900 text-gray-600 dark:text-gray-400")
            };
        }
        #endregion
    }
    #endregion

    #region Extension Methods
    /// <summary>
    /// Extension methods for enum mapping between DTO and domain models
    /// </summary>
    public static class NotificationExtensions
    {
        /// <summary>
        /// Maps NotificationTypeDto to NotificationType
        /// </summary>
        /// <param name="dtoType">The DTO notification type</param>
        /// <returns>Domain notification type</returns>
        public static NotificationType MapToDomain(this NotificationTypeDto dtoType)
        {
            return dtoType switch
            {
                NotificationTypeDto.System => NotificationType.System,
                NotificationTypeDto.Promotional => NotificationType.Promotional,
                NotificationTypeDto.Course => NotificationType.Course,
                NotificationTypeDto.Enrollment => NotificationType.Enrollment,
                NotificationTypeDto.Reminder => NotificationType.Reminder,
                _ => NotificationType.System
            };
        }

        /// <summary>
        /// Maps NotificationStatusDto to NotificationStatus
        /// </summary>
        /// <param name="dtoStatus">The DTO notification status</param>
        /// <returns>Domain notification status</returns>
        public static NotificationStatus MapToDomain(this NotificationStatusDto dtoStatus)
        {
            return dtoStatus switch
            {
                NotificationStatusDto.Read => NotificationStatus.Read,
                NotificationStatusDto.Unread => NotificationStatus.Unread,
                _ => NotificationStatus.Unread
            };
        }
    }
    #endregion
}
