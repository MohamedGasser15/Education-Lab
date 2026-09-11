using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab_Application.Common;
using EduLab_Application.DTOs.Notification;
using EduLab_Application.DTOs.Student;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Text.Json;
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
        private readonly IStudentRepository _studentRepository;
        private readonly IPushNotificationService _pushNotificationService;
        private readonly IEnrollmentRepository? _enrollmentRepository;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the NotificationService class
        /// </summary>
        public NotificationService(
            INotificationRepository notificationRepository,
            IMapper mapper,
            ILogger<NotificationService> logger,
            IEmailSender emailSender,
            IEmailTemplateService emailTemplateService,
            UserManager<ApplicationUser> userManager,
            IStudentRepository studentRepository,
            IPushNotificationService pushNotificationService,
            IEnrollmentRepository? enrollmentRepository = null)
        {
            _notificationRepository = notificationRepository ?? throw new ArgumentNullException(nameof(notificationRepository));
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _emailSender = emailSender ?? throw new ArgumentNullException(nameof(emailSender));
            _emailTemplateService = emailTemplateService ?? throw new ArgumentNullException(nameof(emailTemplateService));
            _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
            _studentRepository = studentRepository;
            _pushNotificationService = pushNotificationService ?? throw new ArgumentNullException(nameof(pushNotificationService));
            _enrollmentRepository = enrollmentRepository;
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

                if (string.IsNullOrWhiteSpace(createDto.Title) && string.IsNullOrWhiteSpace(createDto.TitleKey))
                    throw new ArgumentException("Title is required", nameof(createDto.Title));

                if (string.IsNullOrWhiteSpace(createDto.Message) && string.IsNullOrWhiteSpace(createDto.MessageKey))
                    throw new ArgumentException("Message is required", nameof(createDto.Message));

                // Fetch target user to determine preferred language and device token
                var targetUser = await _userManager.FindByIdAsync(createDto.UserId);
                var userLang = string.IsNullOrWhiteSpace(targetUser?.PreferredLanguage) ? "en" : targetUser.PreferredLanguage.ToLower();

                var (resolvedTitle, resolvedMessage) = ResolveLocalizedNotification(
                    createDto.TitleKey,
                    createDto.MessageKey,
                    createDto.Title ?? "",
                    createDto.Message ?? "",
                    createDto.Parameters,
                    userLang);

                if (string.IsNullOrWhiteSpace(resolvedTitle))
                    throw new ArgumentException("Title is required", nameof(createDto.Title));

                if (string.IsNullOrWhiteSpace(resolvedMessage))
                    throw new ArgumentException("Message is required", nameof(createDto.Message));

                // Create notification entity
                var notification = new Notification
                {
                    Title = resolvedTitle.Trim(),
                    Message = resolvedMessage.Trim(),
                    Type = createDto.Type.MapToDomain(),
                    UserId = createDto.UserId,
                    RelatedEntityId = createDto.RelatedEntityId,
                    RelatedEntityType = createDto.RelatedEntityType,
                    TitleKey = createDto.TitleKey,
                    MessageKey = createDto.MessageKey,
                    Parameters = createDto.Parameters,
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

                // Send real-time Push Notification to user's mobile device if token exists
                try
                {
                    if (targetUser != null && !string.IsNullOrWhiteSpace(targetUser.DeviceToken))
                    {
                        var pushData = new Dictionary<string, string>
                        {
                            { "notificationId", notification.Id.ToString() },
                            { "type", createDto.Type.ToString() },
                            { "relatedEntityId", createDto.RelatedEntityId?.ToString() ?? "" },
                            { "relatedEntityType", createDto.RelatedEntityType ?? "" }
                        };

                        await _pushNotificationService.SendPushNotificationAsync(
                            targetUser.DeviceToken,
                            resolvedTitle,
                            resolvedMessage,
                            pushData,
                            cancellationToken);
                    }
                }
                catch (Exception pushEx)
                {
                    _logger.LogWarning(pushEx, "Failed to send push notification to user {UserId}", createDto.UserId);
                }

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

        /// <summary>
        /// Updates the device token for push notifications
        /// </summary>
        public async Task<bool> UpdateDeviceTokenAsync(string userId, string deviceToken, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(UpdateDeviceTokenAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogInformation("Updating device token for user {UserId}", userId);

                var user = await _userManager.FindByIdAsync(userId);
                if (user == null)
                {
                    _logger.LogWarning("User {UserId} not found when updating device token", userId);
                    return false;
                }

                user.DeviceToken = deviceToken?.Trim();
                var result = await _userManager.UpdateAsync(user);

                if (result.Succeeded)
                {
                    _logger.LogInformation("Successfully updated device token for user {UserId}", userId);
                    return true;
                }

                _logger.LogWarning("Failed to update device token for user {UserId}: {Errors}",
                    userId, string.Join(", ", result.Errors.Select(e => e.Description)));
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating device token for user {UserId}", userId);
                return false;
            }
        }

        /// <summary>
        /// Sends a test push notification to the user's device
        /// </summary>
        public async Task<bool> SendTestPushNotificationAsync(string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(SendTestPushNotificationAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                var user = await _userManager.FindByIdAsync(userId);
                if (user == null || string.IsNullOrWhiteSpace(user.DeviceToken))
                {
                    _logger.LogWarning("User {UserId} has no registered device token for test push", userId);
                    return false;
                }

                var userLang = user.PreferredLanguage?.ToLower() == "ar" ? "ar" : "en";
                var title = userLang == "ar" ? "إشعار تجريبي" : "Test Notification";
                var body = userLang == "ar"
                    ? "تم استلام الإشعار بنجاح على جهازك."
                    : "Notification received successfully on your device.";

                return await _pushNotificationService.SendPushNotificationAsync(
                    user.DeviceToken,
                    title,
                    body,
                    new Dictionary<string, string> { { "type", "TestPush" }, { "timestamp", DateTime.UtcNow.ToString("o") } },
                    cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending test push notification to user {UserId}", userId);
                return false;
            }
        }

        /// <summary>
        /// Sends an automated study/learning reminder to a specific learner
        /// </summary>
        public async Task<bool> SendStudyReminderAsync(string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(SendStudyReminderAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                var user = await _userManager.FindByIdAsync(userId);
                if (user == null || string.IsNullOrWhiteSpace(user.DeviceToken))
                {
                    _logger.LogWarning("User {UserId} has no registered device token for study reminder", userId);
                    return false;
                }

                var userLang = string.IsNullOrWhiteSpace(user.PreferredLanguage) ? "en" : user.PreferredLanguage.ToLower();
                string defaultCourse = _emailTemplateService.GetLocalizedText(NotificationMessages.DefaultCourse, userLang);
                string courseTitle = defaultCourse;

                if (_enrollmentRepository != null)
                {
                    var enrollments = await _enrollmentRepository.GetUserEnrollmentsAsync(userId, cancellationToken);
                    var activeEnrollment = enrollments.FirstOrDefault(e => e.Course != null);
                    if (activeEnrollment?.Course != null)
                    {
                        courseTitle = activeEnrollment.Course.Title;
                    }
                }

                var studentName = !string.IsNullOrWhiteSpace(user.FullName)
                    ? user.FullName
                    : _emailTemplateService.GetLocalizedText(NotificationMessages.DefaultLearner, userLang);

                var title = _emailTemplateService.GetLocalizedText(NotificationMessages.StudyReminder_Title, userLang);
                var message = _emailTemplateService.GetFormattedText(NotificationMessages.StudyReminder_Msg, userLang, studentName, courseTitle);

                var notificationDto = await CreateNotificationAsync(new CreateNotificationDto
                {
                    Title = title,
                    Message = message,
                    TitleKey = NotificationMessages.StudyReminder_Title,
                    MessageKey = NotificationMessages.StudyReminder_Msg,
                    Parameters = System.Text.Json.JsonSerializer.Serialize(new { studentName, courseTitle }),
                    Type = NotificationTypeDto.Reminder,
                    UserId = userId,
                    RelatedEntityType = "StudyReminder"
                }, cancellationToken);

                _logger.LogInformation("Successfully sent study reminder to user {UserId}", userId);
                return notificationDto != null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending study reminder to user {UserId}", userId);
                return false;
            }
        }

        /// <summary>
        /// Sends automated study/learning reminders to all active learners with in-progress courses
        /// </summary>
        public async Task<int> SendAllStudyRemindersAsync(CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(SendAllStudyRemindersAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            int sentCount = 0;
            try
            {
                var learnersWithTokens = await _userManager.Users
                    .Where(u => !string.IsNullOrEmpty(u.DeviceToken))
                    .ToListAsync(cancellationToken);

                _logger.LogInformation("Found {Count} users with registered device tokens for study reminders", learnersWithTokens.Count);

                foreach (var learner in learnersWithTokens)
                {
                    try
                    {
                        var sent = await SendStudyReminderAsync(learner.Id, cancellationToken);
                        if (sent) sentCount++;
                    }
                    catch (Exception ex)
                    {
                        _logger.LogWarning(ex, "Failed to send study reminder to user {UserId}", learner.Id);
                    }
                }

                _logger.LogInformation("Successfully dispatched {SentCount} study reminders out of {TotalCount}",
                    sentCount, learnersWithTokens.Count);

                return sentCount;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in bulk study reminders process");
                return sentCount;
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

                // Validate the basic data
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
                        // Get all users in the Student role
                        var students = await _userManager.GetUsersInRoleAsync("Student");
                        userIds = students.Select(u => u.Id).ToList();
                        _logger.LogInformation("Found {Count} students", students.Count);
                        break;

                    case NotificationTargetDto.InstructorsOnly:
                        // Get all users in the Instructor role
                        var instructors = await _userManager.GetUsersInRoleAsync("Instructor");
                        userIds = instructors.Select(u => u.Id).ToList();
                        _logger.LogInformation("Found {Count} instructors", instructors.Count);
                        break;

                    case NotificationTargetDto.AllUsers:
                    default:
                        // All users
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

        #region Instructor Notification Methods

        /// <summary>
        /// Sends notifications and/or emails from an instructor to their students
        /// </summary>
        /// <param name="request">The notification request details</param>
        /// <param name="instructorId">Unique identifier of the instructor</param>
        /// <returns>Result with sent and failed counts</returns>
        public async Task<BulkNotificationResultDto> SendInstructorNotificationAsync(InstructorNotificationRequestDto request, string instructorId)
        {
            const string operationName = nameof(SendInstructorNotificationAsync);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            var result = new BulkNotificationResultDto();
            var errors = new List<string>();

            try
            {
                _logger.LogInformation("Starting instructor notification for instructor: {InstructorId}", instructorId);

                // Validate the basic data
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

                // Verify that the students belong to the instructor
                if (request.StudentIds != null && request.StudentIds.Any())
                {
                    var isValid = await _studentRepository.ValidateStudentsBelongToInstructorAsync(instructorId, request.StudentIds);
                    if (!isValid)
                    {
                        errors.Add("بعض الطلاب المحددين لا ينتمون لدوراتك");
                        result.Errors = errors;
                        return result;
                    }
                }

                // Get the targeted students
                List<string> studentIds;
                if (request.StudentIds != null && request.StudentIds.Any())
                {
                    studentIds = request.StudentIds;
                }
                else
                {
                    // Send to all students
                    var allStudents = await _studentRepository.GetStudentsByInstructorAsync(instructorId);
                    studentIds = allStudents.Select(s => s.Id).ToList();
                }

                result.TotalUsers = studentIds.Count;

                _logger.LogInformation("Found {Count} students for notification", result.TotalUsers);

                if (result.TotalUsers == 0)
                {
                    errors.Add("لم يتم العثور على طلاب مستهدفين");
                    result.Errors = errors;
                    return result;
                }

                // Send the notifications
                if (request.SendNotification && studentIds.Any())
                {
                    _logger.LogInformation("Sending {Count} notifications", studentIds.Count);
                    var notificationResults = await SendNotificationsToStudents(studentIds, request, instructorId, errors);
                    result.NotificationsSent = notificationResults.SuccessCount;
                    result.FailedNotifications = notificationResults.FailedCount;
                }

                // Send the emails
                if (request.SendEmail && studentIds.Any())
                {
                    _logger.LogInformation("Sending {Count} emails", studentIds.Count);
                    var emailResults = await SendEmailsToStudents(studentIds, request, instructorId, errors);
                    result.EmailsSent = emailResults.SuccessCount;
                    result.FailedEmails = emailResults.FailedCount;
                }

                result.Errors = errors;

                _logger.LogInformation("Instructor notification completed. Total: {Total}, Notifications: {Notifications}, Emails: {Emails}",
                    result.TotalUsers, result.NotificationsSent, result.EmailsSent);

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in instructor notification process for instructor {InstructorId}", instructorId);
                errors.Add($"خطأ في عملية الإرسال: {ex.Message}");
                result.Errors = errors;
                return result;
            }
        }

        /// <summary>
        /// Retrieves students for notification with selection flag
        /// </summary>
        public async Task<List<StudentNotificationDto>> GetInstructorStudentsForNotificationAsync(
            string instructorId,
            List<string> selectedStudentIds = null)
        {
            const string operationName = nameof(GetInstructorStudentsForNotificationAsync);

            try
            {
                _logger.LogInformation("Getting students for notification for instructor: {InstructorId}", instructorId);

                // 1. Fetch the students as entities from the repository
                var students = await _studentRepository.GetStudentsForNotificationAsync(instructorId);

                // 2. Map them to DTOs, setting IsSelected based on selectedStudentIds
                var studentDtos = students.Select(s => new StudentNotificationDto
                {
                    StudentId = s.Id,
                    FullName = s.FullName,
                    Email = s.Email,
                    ProfileImageUrl = s.ProfileImageUrl,
                    IsSelected = selectedStudentIds != null && selectedStudentIds.Contains(s.Id)
                }).ToList();

                _logger.LogInformation("Successfully retrieved {Count} students for notification", studentDtos.Count);
                return studentDtos;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting students for notification for instructor: {InstructorId}", instructorId);
                throw;
            }
        }

        /// <summary>
        /// Retrieves notification summary for instructor
        /// </summary>
        public async Task<InstructorNotificationSummaryDto> GetInstructorNotificationSummaryAsync(
            string instructorId,
            List<string> selectedStudentIds = null)
        {
            const string operationName = nameof(GetInstructorNotificationSummaryAsync);

            try
            {
                _logger.LogInformation("Getting notification summary for instructor: {InstructorId}", instructorId);

                // 1. Get the total number of students from the repository (without DTOs)
                var totalStudents = await _studentRepository.GetTotalStudentsByInstructorAsync(instructorId);

                // 2. Build the required DTO
                var summary = new InstructorNotificationSummaryDto
                {
                    TotalStudents = totalStudents,
                    SelectedStudents = selectedStudentIds?.Count ?? 0,
                    SendToAll = selectedStudentIds == null || !selectedStudentIds.Any()
                };

                _logger.LogInformation("Successfully retrieved notification summary for instructor: {InstructorId}", instructorId);
                return summary;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting notification summary for instructor: {InstructorId}", instructorId);
                throw;
            }
        }

        private async Task<(int SuccessCount, int FailedCount)> SendNotificationsToStudents(
            List<string> studentIds, InstructorNotificationRequestDto request, string instructorId, List<string> errors)
        {
            const string operationName = nameof(SendNotificationsToStudents);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            int successCount = 0;
            int failedCount = 0;

            _logger.LogInformation("Starting to send notifications to {Count} students", studentIds.Count);

            foreach (var studentId in studentIds)
            {
                try
                {
                    var createNotificationDto = new CreateNotificationDto
                    {
                        Title = request.Title.Trim(),
                        Message = request.Message.Trim(),
                        Type = request.Type,
                        UserId = studentId,
                        RelatedEntityType = "InstructorNotification",
                        RelatedEntityId = instructorId
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
                    _logger.LogError(ex, "Failed to send notification to student {StudentId}", studentId);
                    errors.Add($"فشل إرسال إشعار للطالب {studentId}: {ex.Message}");
                    failedCount++;
                }
            }

            _logger.LogInformation("Completed sending notifications. Success: {Success}, Failed: {Failed}", successCount, failedCount);
            return (successCount, failedCount);
        }

        private async Task<(int SuccessCount, int FailedCount)> SendEmailsToStudents(
            List<string> studentIds, InstructorNotificationRequestDto request, string instructorId, List<string> errors)
        {
            const string operationName = nameof(SendEmailsToStudents);
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            int successCount = 0;
            int failedCount = 0;

            _logger.LogInformation("Starting to send emails to {Count} students", studentIds.Count);

            var users = await _userManager.Users
                .Where(u => studentIds.Contains(u.Id) && !string.IsNullOrEmpty(u.Email))
                .ToListAsync();

            _logger.LogInformation("Found {Count} students with email addresses", users.Count);

            var instructor = await _userManager.FindByIdAsync(instructorId);

            foreach (var user in users)
            {
                try
                {
                    var emailContent = _emailTemplateService.GenerateInstructorNotificationEmail(user, request, instructor, user.PreferredLanguage ?? "en");
                    await _emailSender.SendEmailAsync(user.Email, request.Title.Trim(), emailContent);
                    successCount++;

                    if (successCount % 10 == 0)
                    {
                        _logger.LogInformation("Sent {Count} emails so far", successCount);
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Failed to send email to student {Email}", user.Email);
                    errors.Add($"فشل إرسال بريد إلكتروني لـ {user.Email}: {ex.Message}");
                    failedCount++;
                }
            }

            _logger.LogInformation("Completed sending emails. Success: {Success}, Failed: {Failed}", successCount, failedCount);
            return (successCount, failedCount);
        }

        #endregion

        #region Private Methods
        /// <summary>
        /// Resolves localized notification title and message using resource keys and parameters
        /// </summary>
        private (string Title, string Message) ResolveLocalizedNotification(
            string? titleKey,
            string? messageKey,
            string fallbackTitle,
            string fallbackMessage,
            string? parametersJson,
            string language)
        {
            var title = fallbackTitle;
            var message = fallbackMessage;

            if (!string.IsNullOrWhiteSpace(titleKey))
            {
                var locTitle = _emailTemplateService.GetLocalizedText(titleKey, language);
                if (!string.IsNullOrWhiteSpace(locTitle) && locTitle != titleKey)
                {
                    title = locTitle;
                }
            }

            if (!string.IsNullOrWhiteSpace(messageKey))
            {
                var rawTemplate = _emailTemplateService.GetLocalizedText(messageKey, language);
                if (!string.IsNullOrWhiteSpace(rawTemplate) && rawTemplate != messageKey)
                {
                    if (!string.IsNullOrWhiteSpace(parametersJson))
                    {
                        try
                        {
                            using var doc = JsonDocument.Parse(parametersJson);
                            if (doc.RootElement.ValueKind == JsonValueKind.Object)
                            {
                                var values = doc.RootElement.EnumerateObject()
                                    .Select(p => p.Value.ValueKind == JsonValueKind.String ? p.Value.GetString() : p.Value.ToString())
                                    .ToArray();
                                message = string.Format(rawTemplate, values);
                            }
                            else if (doc.RootElement.ValueKind == JsonValueKind.Array)
                            {
                                var values = doc.RootElement.EnumerateArray()
                                    .Select(e => e.ValueKind == JsonValueKind.String ? e.GetString() : e.ToString())
                                    .ToArray();
                                message = string.Format(rawTemplate, values);
                            }
                            else
                            {
                                message = rawTemplate;
                            }
                        }
                        catch
                        {
                            message = rawTemplate;
                        }
                    }
                    else
                    {
                        message = rawTemplate;
                    }
                }
            }

            return (title, message);
        }

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
                    var emailContent = _emailTemplateService.GenerateAdminNotificationEmail(user, request, user.PreferredLanguage ?? "en");
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