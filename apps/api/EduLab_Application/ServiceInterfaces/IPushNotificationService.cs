using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for sending push notifications to mobile devices via Firebase Cloud Messaging (FCM)
    /// </summary>
    public interface IPushNotificationService
    {
        /// <summary>
        /// Sends a push notification to a single device
        /// </summary>
        /// <param name="deviceToken">FCM / APNs device token</param>
        /// <param name="title">Notification title</param>
        /// <param name="body">Notification body message</param>
        /// <param name="data">Optional custom key-value data payload</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if successfully sent, false otherwise</returns>
        Task<bool> SendPushNotificationAsync(
            string deviceToken,
            string title,
            string body,
            Dictionary<string, string>? data = null,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Sends a push notification to multiple devices (multicast)
        /// </summary>
        /// <param name="deviceTokens">List of device tokens</param>
        /// <param name="title">Notification title</param>
        /// <param name="body">Notification body message</param>
        /// <param name="data">Optional custom key-value data payload</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Count of successfully sent notifications</returns>
        Task<int> SendMulticastPushNotificationAsync(
            List<string> deviceTokens,
            string title,
            string body,
            Dictionary<string, string>? data = null,
            CancellationToken cancellationToken = default);
    }
}
