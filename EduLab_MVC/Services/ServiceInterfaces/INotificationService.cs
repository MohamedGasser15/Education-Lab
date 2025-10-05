using EduLab_MVC.Models.DTOs.Notifications;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    public interface INotificationService
    {
        Task<List<NotificationDto>> GetUserNotificationsAsync(NotificationFilterDto filter);
        Task<NotificationSummaryDto> GetUserNotificationSummaryAsync();
        Task<int> GetUnreadCountAsync();
        Task MarkAllNotificationsAsReadAsync();
        Task MarkNotificationAsReadAsync(int id);
        Task DeleteNotificationAsync(int id);
        Task DeleteAllNotificationsAsync();
    }
}
