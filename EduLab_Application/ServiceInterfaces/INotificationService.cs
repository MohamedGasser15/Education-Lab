using EduLab.Shared.DTOs.Notification;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface INotificationService
    {
        Task<List<NotificationDto>> GetUserNotificationsAsync(string userId, NotificationFilterDto filter);
        Task<NotificationSummaryDto> GetUserNotificationSummaryAsync(string userId);
        Task<NotificationDto> CreateNotificationAsync(CreateNotificationDto createDto);
        Task MarkNotificationAsReadAsync(int notificationId, string userId);
        Task MarkAllNotificationsAsReadAsync(string userId);
        Task DeleteNotificationAsync(int notificationId, string userId);
        Task DeleteAllNotificationsAsync(string userId);
        Task<int> GetUnreadCountAsync(string userId);
    }
}
 