using AutoMapper;
using EduLab.Shared.DTOs.Notification;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class NotificationService : INotificationService
    {
        private readonly INotificationRepository _notificationRepository;
        private readonly IMapper _mapper;
        private readonly ILogger<NotificationService> _logger;

        public NotificationService(
            INotificationRepository notificationRepository,
            IMapper mapper,
            ILogger<NotificationService> logger)
        {
            _notificationRepository = notificationRepository;
            _mapper = mapper;
            _logger = logger;
        }

        public async Task<List<NotificationDto>> GetUserNotificationsAsync(string userId, NotificationFilterDto filter)
        {
            try
            {
                _logger.LogInformation("Getting notifications for user {UserId} with filter", userId);

                var notifications = await _notificationRepository.GetUserNotificationsAsync(
                    userId,
                    filter.Type?.MapToDomain(),
                    filter.Status?.MapToDomain(),
                    filter.PageNumber,
                    filter.PageSize);

                var notificationDtos = _mapper.Map<List<NotificationDto>>(notifications);

                // إضافة معلومات التنسيق للواجهة
                foreach (var notification in notificationDtos)
                {
                    var (iconClass, colorClass) = GetNotificationStyle(notification.Type);
                    notification.IconClass = iconClass;
                    notification.ColorClass = colorClass;
                }

                return notificationDtos;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting notifications for user {UserId}", userId);
                throw;
            }
        }

        public async Task<NotificationSummaryDto> GetUserNotificationSummaryAsync(string userId)
        {
            try
            {
                var summary = await _notificationRepository.GetUserNotificationSummaryAsync(userId);
                return _mapper.Map<NotificationSummaryDto>(summary);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting notification summary for user {UserId}", userId);
                throw;
            }
        }

        public async Task<NotificationDto> CreateNotificationAsync(CreateNotificationDto createDto)
        {
            try
            {
                var notification = new Notification
                {
                    Title = createDto.Title,
                    Message = createDto.Message,
                    Type = createDto.Type.MapToDomain(),
                    UserId = createDto.UserId,
                    RelatedEntityId = createDto.RelatedEntityId,
                    RelatedEntityType = createDto.RelatedEntityType,
                    CreatedAt = DateTime.UtcNow,
                    Status = NotificationStatus.Unread
                };

                await _notificationRepository.CreateAsync(notification);

                var notificationDto = _mapper.Map<NotificationDto>(notification);
                var (iconClass, colorClass) = GetNotificationStyle(notificationDto.Type);
                notificationDto.IconClass = iconClass;
                notificationDto.ColorClass = colorClass;

                return notificationDto;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating notification for user {UserId}", createDto.UserId);
                throw;
            }
        }

        public async Task MarkNotificationAsReadAsync(int notificationId, string userId)
        {
            try
            {
                await _notificationRepository.MarkAsReadAsync(notificationId, userId);
                _logger.LogInformation("Notification {NotificationId} marked as read by user {UserId}",
                    notificationId, userId);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking notification {NotificationId} as read for user {UserId}",
                    notificationId, userId);
                throw;
            }
        }

        public async Task MarkAllNotificationsAsReadAsync(string userId)
        {
            try
            {
                await _notificationRepository.MarkAllAsReadAsync(userId);
                _logger.LogInformation("All notifications marked as read by user {UserId}", userId);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error marking all notifications as read for user {UserId}", userId);
                throw;
            }
        }

        public async Task DeleteNotificationAsync(int notificationId, string userId)
        {
            try
            {
                var notification = await _notificationRepository.GetAsync(
                    n => n.Id == notificationId && n.UserId == userId);

                if (notification != null)
                {
                    await _notificationRepository.DeleteAsync(notification);
                    _logger.LogInformation("Notification {NotificationId} deleted by user {UserId}",
                        notificationId, userId);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting notification {NotificationId} for user {UserId}",
                    notificationId, userId);
                throw;
            }
        }

        public async Task DeleteAllNotificationsAsync(string userId)
        {
            try
            {
                await _notificationRepository.DeleteAllUserNotificationsAsync(userId);
                _logger.LogInformation("All notifications deleted by user {UserId}", userId);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting all notifications for user {UserId}", userId);
                throw;
            }
        }

        public async Task<int> GetUnreadCountAsync(string userId)
        {
            try
            {
                return await _notificationRepository.GetUserUnreadCountAsync(userId);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting unread count for user {UserId}", userId);
                throw;
            }
        }

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
    }

    // Extension methods for enum mapping
    public static class NotificationExtensions
    {
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
}
