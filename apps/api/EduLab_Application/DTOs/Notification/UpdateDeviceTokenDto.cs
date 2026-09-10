using System.ComponentModel.DataAnnotations;

namespace EduLab_Application.DTOs.Notification
{
    /// <summary>
    /// Data transfer object for updating a user's mobile device token
    /// </summary>
    public class UpdateDeviceTokenDto
    {
        /// <summary>
        /// The device token provided by FCM or APNs
        /// </summary>
        [Required(ErrorMessage = "Device token is required")]
        public string DeviceToken { get; set; } = string.Empty;
    }
}
