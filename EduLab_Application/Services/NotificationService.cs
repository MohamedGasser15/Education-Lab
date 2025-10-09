using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Notification;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
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
        private readonly IEmailSender _emailSender;
        private readonly IEmailTemplateService _emailTemplateService;
        private readonly UserManager<ApplicationUser> _userManager;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the NotificationService class
        /// </summary>
        /// <param name="notificationRepository">Notification repository instance</param>
        /// <param name="mapper">AutoMapper instance</param>
        /// <param name="logger">Logger instance</param>
        /// <param name="emailSender">Email sender service</param>
        /// <param name="emailTemplateService">Email template service</param>
        /// <param name="userManager">User manager instance</param>
        /// <exception cref="ArgumentNullException">Thrown when any dependency is null</exception>
        public NotificationService(
            INotificationRepository notificationRepository,
            IMapper mapper,
            ILogger<NotificationService> logger,
            IEmailSender emailSender,
            IEmailTemplateService emailTemplateService,
            UserManager<ApplicationUser> userManager)
        {
            _notificationRepository = notificationRepository ?? throw new ArgumentNullException(nameof(notificationRepository));
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _emailSender = emailSender ?? throw new ArgumentNullException(nameof(emailSender));
            _emailTemplateService = emailTemplateService ?? throw new ArgumentNullException(nameof(emailTemplateService));
            _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
        }
        #endregion

        #region Public Methods - User Notifications
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

        #region Public Methods - Admin Notifications
        /// <summary>
        /// Sends bulk notifications to targeted users
        /// </summary>
        public async Task<BulkNotificationResultDto> SendBulkNotificationAsync(AdminNotificationRequestDto request)
        {
            const string operationName = nameof(SendBulkNotificationAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            var result = new BulkNotificationResultDto();
            var errors = new List<string>();

            try
            {
                _logger.LogInformation("Starting bulk notification for target: {Target}", request.Target);

                // التحقق من صحة البيانات الأساسية
                if (string.IsNullOrWhiteSpace(request.Title))
                {
                    errors.Add("عنوان الإشعار مطلوب");
                }

                if (string.IsNullOrWhiteSpace(request.Message))
                {
                    errors.Add("محتوى الإشعار مطلوب");
                }

                if (errors.Any())
                {
                    result.Errors = errors;
                    return result;
                }

                // Get target users
                var userIds = await GetUsersByTargetAsync(request.Target);
                result.TotalUsers = userIds.Count;

                _logger.LogInformation("Found {Count} users for notification", result.TotalUsers);

                if (result.TotalUsers == 0)
                {
                    errors.Add("لم يتم العثور على مستخدمين مستهدفين");
                    result.Errors = errors;
                    return result;
                }

                // Send notifications
                if (request.SendNotification && userIds.Any())
                {
                    _logger.LogInformation("Sending {Count} notifications", userIds.Count);
                    var notificationResults = await SendNotificationsToUsers(userIds, request, errors);
                    result.NotificationsSent = notificationResults.SuccessCount;
                    result.FailedNotifications = notificationResults.FailedCount;
                }

                // Send emails
                if (request.SendEmail && userIds.Any())
                {
                    _logger.LogInformation("Sending {Count} emails", userIds.Count);
                    var emailResults = await SendEmailsToUsers(userIds, request, errors);
                    result.EmailsSent = emailResults.SuccessCount;
                    result.FailedEmails = emailResults.FailedCount;
                }

                result.Errors = errors;

                _logger.LogInformation("Bulk notification completed. Total: {Total}, Notifications: {Notifications}, Emails: {Emails}",
                    result.TotalUsers, result.NotificationsSent, result.EmailsSent);

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in bulk notification process");
                errors.Add($"خطأ في عملية الإرسال: {ex.Message}");
                result.Errors = errors;
                return result;
            }
        }

        /// <summary>
        /// Gets users by target criteria for admin notifications
        /// </summary>
        public async Task<List<string>> GetUsersByTargetAsync(NotificationTargetDto target)
        {
            const string operationName = nameof(GetUsersByTargetAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogInformation("Getting users for target: {Target}", target);

                List<string> userIds = new List<string>();

                switch (target)
                {
                    case NotificationTargetDto.StudentsOnly:
                        // الحصول على جميع المستخدمين في دور الطالب
                        var students = await _userManager.GetUsersInRoleAsync("Student");
                        userIds = students.Select(u => u.Id).ToList();
                        _logger.LogInformation("Found {Count} students", students.Count);
                        break;

                    case NotificationTargetDto.InstructorsOnly:
                        // الحصول على جميع المستخدمين في دور المدرب
                        var instructors = await _userManager.GetUsersInRoleAsync("Instructor");
                        userIds = instructors.Select(u => u.Id).ToList();
                        _logger.LogInformation("Found {Count} instructors", instructors.Count);
                        break;

                    case NotificationTargetDto.AllUsers:
                    default:
                        // جميع المستخدمين
                        var allUsers = await _userManager.Users.ToListAsync();
                        userIds = allUsers.Select(u => u.Id).ToList();
                        _logger.LogInformation("Found {Count} total users", allUsers.Count);
                        break;
                }

                return userIds;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting users by target {Target}", target);
                return new List<string>();
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

        /// <summary>
        /// Sends notifications to multiple users
        /// </summary>
        private async Task<(int SuccessCount, int FailedCount)> SendNotificationsToUsers(
            List<string> userIds, AdminNotificationRequestDto request, List<string> errors)
        {
            const string operationName = nameof(SendNotificationsToUsers);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            int successCount = 0;
            int failedCount = 0;

            _logger.LogInformation("Starting to send notifications to {Count} users", userIds.Count);

            foreach (var userId in userIds)
            {
                try
                {
                    var createNotificationDto = new CreateNotificationDto
                    {
                        Title = request.Title.Trim(),
                        Message = request.Message.Trim(),
                        Type = (NotificationTypeDto)request.Type,
                        UserId = userId,
                        RelatedEntityType = "AdminNotification",
                    };

                    await CreateNotificationAsync(createNotificationDto);
                    successCount++;

                    if (successCount % 10 == 0)
                    {
                        _logger.LogInformation("Sent {Count} notifications so far", successCount);
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Failed to send notification to user {UserId}", userId);
                    errors.Add($"فشل إرسال إشعار للمستخدم {userId}: {ex.Message}");
                    failedCount++;
                }
            }

            _logger.LogInformation("Completed sending notifications. Success: {Success}, Failed: {Failed}", successCount, failedCount);
            return (successCount, failedCount);
        }

        /// <summary>
        /// Sends emails to multiple users
        /// </summary>
        private async Task<(int SuccessCount, int FailedCount)> SendEmailsToUsers(
            List<string> userIds, AdminNotificationRequestDto request, List<string> errors)
        {
            const string operationName = nameof(SendEmailsToUsers);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            int successCount = 0;
            int failedCount = 0;

            _logger.LogInformation("Starting to send emails to {Count} users", userIds.Count);

            var users = await _userManager.Users
                .Where(u => userIds.Contains(u.Id) && !string.IsNullOrEmpty(u.Email))
                .ToListAsync();

            _logger.LogInformation("Found {Count} users with email addresses", users.Count);

            foreach (var user in users)
            {
                try
                {
                    var emailContent = _emailTemplateService.GenerateAdminNotificationEmail(user, request);
                    await _emailSender.SendEmailAsync(user.Email, request.Title.Trim(), emailContent);
                    successCount++;

                    if (successCount % 10 == 0)
                    {
                        _logger.LogInformation("Sent {Count} emails so far", successCount);
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Failed to send email to user {Email}", user.Email);
                    errors.Add($"فشل إرسال بريد إلكتروني لـ {user.Email}: {ex.Message}");
                    failedCount++;
                }
            }

            _logger.LogInformation("Completed sending emails. Success: {Success}, Failed: {Failed}", successCount, failedCount);
            return (successCount, failedCount);
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