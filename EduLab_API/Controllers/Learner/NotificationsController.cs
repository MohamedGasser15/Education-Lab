using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Notification;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using System.Security.Claims;

namespace EduLab_API.Controllers.Learner
{
    #region Notifications Controller
    /// <summary>
    /// API Controller for managing user notifications
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class NotificationsController : ControllerBase
    {
        #region Fields
        private readonly INotificationService _notificationService;
        private readonly ILogger<NotificationsController> _logger;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the NotificationsController class
        /// </summary>
        /// <param name="notificationService">Notification service instance</param>
        /// <param name="logger">Logger instance</param>
        /// <exception cref="ArgumentNullException">Thrown when any dependency is null</exception>
        public NotificationsController(
            INotificationService notificationService,
            ILogger<NotificationsController> logger)
        {
            _notificationService = notificationService ?? throw new ArgumentNullException(nameof(notificationService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }
        #endregion

        #region Private Methods
        /// <summary>
        /// Extracts the user ID from the current claims principal
        /// </summary>
        /// <returns>The user ID as string</returns>
        /// <exception cref="UnauthorizedAccessException">Thrown when user ID is not found</exception>
        private string GetUserId()
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrWhiteSpace(userId))
            {
                _logger.LogWarning("User ID not found in claims for authenticated user");
                throw new UnauthorizedAccessException("User identification failed");
            }
            return userId;
        }
        #endregion

        #region GET Operations
        /// <summary>
        /// Retrieves user notifications with optional filtering
        /// </summary>
        /// <param name="filter">Filter criteria for notifications</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of user notifications</returns>
        [HttpGet]
        [ProducesResponseType(typeof(List<NotificationDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<List<NotificationDto>>> GetNotifications(
            [FromQuery] NotificationFilterDto filter,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "GetNotifications";
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user", operationName);

                var userId = GetUserId();
                var notifications = await _notificationService.GetUserNotificationsAsync(userId, filter, cancellationToken);

                _logger.LogInformation("Successfully retrieved {Count} notifications for user in {OperationName}",
                    notifications.Count, operationName);

                return Ok(notifications);
            }
            catch (UnauthorizedAccessException ex)
            {
                _logger.LogWarning("Authorization failed in {OperationName}: {Message}", operationName, ex.Message);
                return Unauthorized(new ProblemDetails
                {
                    Title = "Authorization failed",
                    Detail = ex.Message,
                    Status = StatusCodes.Status401Unauthorized
                });
            }
            catch (ArgumentException ex)
            {
                _logger.LogWarning("Invalid argument in {OperationName}: {Message}", operationName, ex.Message);
                return BadRequest(new ProblemDetails
                {
                    Title = "Invalid request",
                    Detail = ex.Message,
                    Status = StatusCodes.Status400BadRequest
                });
            }
            catch (OperationCanceledException)
            {
                _logger.LogInformation("Operation {OperationName} was cancelled by the client", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new ProblemDetails
                {
                    Title = "Request cancelled",
                    Detail = "The operation was cancelled by the client",
                    Status = StatusCodes.Status499ClientClosedRequest
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, new ProblemDetails
                {
                    Title = "Internal server error",
                    Detail = "An unexpected error occurred while retrieving notifications",
                    Status = StatusCodes.Status500InternalServerError
                });
            }
        }

        /// <summary>
        /// Gets a summary of user notifications
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Notification summary</returns>
        [HttpGet("summary")]
        [ProducesResponseType(typeof(NotificationSummaryDto), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<NotificationSummaryDto>> GetNotificationSummary(CancellationToken cancellationToken = default)
        {
            const string operationName = "GetNotificationSummary";
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user", operationName);

                var userId = GetUserId();
                var summary = await _notificationService.GetUserNotificationSummaryAsync(userId, cancellationToken);

                _logger.LogInformation("Successfully retrieved notification summary for user in {OperationName}", operationName);

                return Ok(summary);
            }
            catch (UnauthorizedAccessException ex)
            {
                _logger.LogWarning("Authorization failed in {OperationName}: {Message}", operationName, ex.Message);
                return Unauthorized(new ProblemDetails
                {
                    Title = "Authorization failed",
                    Detail = ex.Message,
                    Status = StatusCodes.Status401Unauthorized
                });
            }
            catch (OperationCanceledException)
            {
                _logger.LogInformation("Operation {OperationName} was cancelled by the client", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new ProblemDetails
                {
                    Title = "Request cancelled",
                    Detail = "The operation was cancelled by the client",
                    Status = StatusCodes.Status499ClientClosedRequest
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, new ProblemDetails
                {
                    Title = "Internal server error",
                    Detail = "An unexpected error occurred while retrieving notification summary",
                    Status = StatusCodes.Status500InternalServerError
                });
            }
        }

        /// <summary>
        /// Gets the count of unread notifications for the user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Count of unread notifications</returns>
        [HttpGet("unread-count")]
        [ProducesResponseType(typeof(int), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<int>> GetUnreadCount(CancellationToken cancellationToken = default)
        {
            const string operationName = "GetUnreadCount";
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user", operationName);

                var userId = GetUserId();
                var count = await _notificationService.GetUnreadCountAsync(userId, cancellationToken);

                _logger.LogDebug("Retrieved unread count {Count} for user in {OperationName}", count, operationName);

                return Ok(count);
            }
            catch (UnauthorizedAccessException ex)
            {
                _logger.LogWarning("Authorization failed in {OperationName}: {Message}", operationName, ex.Message);
                return Unauthorized(new ProblemDetails
                {
                    Title = "Authorization failed",
                    Detail = ex.Message,
                    Status = StatusCodes.Status401Unauthorized
                });
            }
            catch (OperationCanceledException)
            {
                _logger.LogInformation("Operation {OperationName} was cancelled by the client", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new ProblemDetails
                {
                    Title = "Request cancelled",
                    Detail = "The operation was cancelled by the client",
                    Status = StatusCodes.Status499ClientClosedRequest
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, new ProblemDetails
                {
                    Title = "Internal server error",
                    Detail = "An unexpected error occurred while retrieving unread count",
                    Status = StatusCodes.Status500InternalServerError
                });
            }
        }
        #endregion

        #region POST Operations
        /// <summary>
        /// Marks all user notifications as read
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Success message</returns>
        [HttpPost("mark-all-read")]
        [ProducesResponseType(typeof(object), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> MarkAllAsRead(CancellationToken cancellationToken = default)
        {
            const string operationName = "MarkAllAsRead";
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user", operationName);

                var userId = GetUserId();
                await _notificationService.MarkAllNotificationsAsReadAsync(userId, cancellationToken);

                _logger.LogInformation("Successfully marked all notifications as read for user in {OperationName}", operationName);

                return Ok(new { message = "All notifications marked as read successfully" });
            }
            catch (UnauthorizedAccessException ex)
            {
                _logger.LogWarning("Authorization failed in {OperationName}: {Message}", operationName, ex.Message);
                return Unauthorized(new ProblemDetails
                {
                    Title = "Authorization failed",
                    Detail = ex.Message,
                    Status = StatusCodes.Status401Unauthorized
                });
            }
            catch (OperationCanceledException)
            {
                _logger.LogInformation("Operation {OperationName} was cancelled by the client", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new ProblemDetails
                {
                    Title = "Request cancelled",
                    Detail = "The operation was cancelled by the client",
                    Status = StatusCodes.Status499ClientClosedRequest
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, new ProblemDetails
                {
                    Title = "Internal server error",
                    Detail = "An unexpected error occurred while marking notifications as read",
                    Status = StatusCodes.Status500InternalServerError
                });
            }
        }
        #endregion

        #region PUT Operations
        /// <summary>
        /// Marks a specific notification as read
        /// </summary>
        /// <param name="id">The notification ID</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Success message</returns>
        [HttpPut("{id}/read")]
        [ProducesResponseType(typeof(object), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> MarkAsRead(
            [FromRoute] int id,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "MarkAsRead";
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for notification {NotificationId}", operationName, id);

                if (id <= 0)
                {
                    _logger.LogWarning("Invalid notification ID {NotificationId} in {OperationName}", id, operationName);
                    return BadRequest(new ProblemDetails
                    {
                        Title = "Invalid notification ID",
                        Detail = "Notification ID must be greater than 0",
                        Status = StatusCodes.Status400BadRequest
                    });
                }

                var userId = GetUserId();
                await _notificationService.MarkNotificationAsReadAsync(id, userId, cancellationToken);

                _logger.LogInformation("Successfully marked notification {NotificationId} as read in {OperationName}",
                    id, operationName);

                return Ok(new { message = "Notification marked as read successfully" });
            }
            catch (UnauthorizedAccessException ex)
            {
                _logger.LogWarning("Authorization failed in {OperationName}: {Message}", operationName, ex.Message);
                return Unauthorized(new ProblemDetails
                {
                    Title = "Authorization failed",
                    Detail = ex.Message,
                    Status = StatusCodes.Status401Unauthorized
                });
            }
            catch (OperationCanceledException)
            {
                _logger.LogInformation("Operation {OperationName} was cancelled by the client", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new ProblemDetails
                {
                    Title = "Request cancelled",
                    Detail = "The operation was cancelled by the client",
                    Status = StatusCodes.Status499ClientClosedRequest
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error in {OperationName} for notification {NotificationId}",
                    operationName, id);
                return StatusCode(StatusCodes.Status500InternalServerError, new ProblemDetails
                {
                    Title = "Internal server error",
                    Detail = "An unexpected error occurred while marking notification as read",
                    Status = StatusCodes.Status500InternalServerError
                });
            }
        }
        #endregion

        #region Admin Operations

        [Authorize(Roles = "Admin")]
        [HttpPost("send-bulk")]
        [ProducesResponseType(typeof(BulkNotificationResultDto), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<BulkNotificationResultDto>> SendBulkNotification(
    [FromBody] AdminNotificationRequestDto request)
        {
            const string operationName = "SendBulkNotification";
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogInformation("Starting bulk notification send operation");

                if (request == null)
                {
                    return BadRequest(new ProblemDetails
                    {
                        Title = "طلب غير صالح",
                        Detail = "بيانات الطلب غير مكتملة",
                        Status = StatusCodes.Status400BadRequest
                    });
                }

                // التحقق من صحة البيانات
                if (!ModelState.IsValid)
                {
                    var errors = ModelState.Values
                        .SelectMany(v => v.Errors)
                        .Select(e => e.ErrorMessage)
                        .ToList();

                    return BadRequest(new ProblemDetails
                    {
                        Title = "بيانات غير صالحة",
                        Detail = string.Join("; ", errors),
                        Status = StatusCodes.Status400BadRequest
                    });
                }

                if (!request.SendEmail && !request.SendNotification)
                {
                    return BadRequest(new ProblemDetails
                    {
                        Title = "طلب غير صالح",
                        Detail = "يجب اختيار نوع الإرسال على الأقل (بريد إلكتروني أو إشعار)",
                        Status = StatusCodes.Status400BadRequest
                    });
                }

                var result = await _notificationService.SendBulkNotificationAsync(request);

                _logger.LogInformation("Bulk notification completed. Total: {Total}, Notifications: {Notifications}, Emails: {Emails}",
                    result.TotalUsers, result.NotificationsSent, result.EmailsSent);

                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, new ProblemDetails
                {
                    Title = "خطأ داخلي",
                    Detail = "حدث خطأ غير متوقع أثناء إرسال الإشعارات",
                    Status = StatusCodes.Status500InternalServerError
                });
            }
        }
        #endregion

        #region DELETE Operations
        /// <summary>
        /// Deletes a specific notification
        /// </summary>
        /// <param name="id">The notification ID</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Success message</returns>
        [HttpDelete("{id}")]
        [ProducesResponseType(typeof(object), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> DeleteNotification(
            [FromRoute] int id,
            CancellationToken cancellationToken = default)
        {
            const string operationName = "DeleteNotification";
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for notification {NotificationId}", operationName, id);

                if (id <= 0)
                {
                    _logger.LogWarning("Invalid notification ID {NotificationId} in {OperationName}", id, operationName);
                    return BadRequest(new ProblemDetails
                    {
                        Title = "Invalid notification ID",
                        Detail = "Notification ID must be greater than 0",
                        Status = StatusCodes.Status400BadRequest
                    });
                }

                var userId = GetUserId();
                await _notificationService.DeleteNotificationAsync(id, userId, cancellationToken);

                _logger.LogInformation("Successfully deleted notification {NotificationId} in {OperationName}",
                    id, operationName);

                return Ok(new { message = "Notification deleted successfully" });
            }
            catch (UnauthorizedAccessException ex)
            {
                _logger.LogWarning("Authorization failed in {OperationName}: {Message}", operationName, ex.Message);
                return Unauthorized(new ProblemDetails
                {
                    Title = "Authorization failed",
                    Detail = ex.Message,
                    Status = StatusCodes.Status401Unauthorized
                });
            }
            catch (OperationCanceledException)
            {
                _logger.LogInformation("Operation {OperationName} was cancelled by the client", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new ProblemDetails
                {
                    Title = "Request cancelled",
                    Detail = "The operation was cancelled by the client",
                    Status = StatusCodes.Status499ClientClosedRequest
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error in {OperationName} for notification {NotificationId}",
                    operationName, id);
                return StatusCode(StatusCodes.Status500InternalServerError, new ProblemDetails
                {
                    Title = "Internal server error",
                    Detail = "An unexpected error occurred while deleting notification",
                    Status = StatusCodes.Status500InternalServerError
                });
            }
        }

        /// <summary>
        /// Deletes all user notifications
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Success message</returns>
        [HttpDelete("delete-all")]
        [ProducesResponseType(typeof(object), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> DeleteAllNotifications(CancellationToken cancellationToken = default)
        {
            const string operationName = "DeleteAllNotifications";
            using var activity = Activity.Current?.Source.StartActivity(operationName);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user", operationName);

                var userId = GetUserId();
                await _notificationService.DeleteAllNotificationsAsync(userId, cancellationToken);

                _logger.LogInformation("Successfully deleted all notifications for user in {OperationName}", operationName);

                return Ok(new { message = "All notifications deleted successfully" });
            }
            catch (UnauthorizedAccessException ex)
            {
                _logger.LogWarning("Authorization failed in {OperationName}: {Message}", operationName, ex.Message);
                return Unauthorized(new ProblemDetails
                {
                    Title = "Authorization failed",
                    Detail = ex.Message,
                    Status = StatusCodes.Status401Unauthorized
                });
            }
            catch (OperationCanceledException)
            {
                _logger.LogInformation("Operation {OperationName} was cancelled by the client", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new ProblemDetails
                {
                    Title = "Request cancelled",
                    Detail = "The operation was cancelled by the client",
                    Status = StatusCodes.Status499ClientClosedRequest
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, new ProblemDetails
                {
                    Title = "Internal server error",
                    Detail = "An unexpected error occurred while deleting all notifications",
                    Status = StatusCodes.Status500InternalServerError
                });
            }
        }
        #endregion
    }
    #endregion
}