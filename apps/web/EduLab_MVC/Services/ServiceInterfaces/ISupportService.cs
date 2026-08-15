using EduLab_MVC.Models.DTOs.Support;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for support chat operations in the MVC application
    /// </summary>
    public interface ISupportService
    {
        Task<System.Collections.Generic.List<SupportConversationDto>> GetUserConversationsAsync(CancellationToken cancellationToken = default);

        Task<SupportConversationDto> CreateConversationAsync(string subject, string message, CancellationToken cancellationToken = default);

        Task<System.Collections.Generic.List<SupportMessageDto>> GetConversationMessagesAsync(int conversationId, CancellationToken cancellationToken = default);

        Task<SupportMessageDto> SendUserMessageAsync(int conversationId, string content, CancellationToken cancellationToken = default);

        Task<bool> CloseConversationAsync(int conversationId, CancellationToken cancellationToken = default);

        Task<bool> ReopenConversationAsync(int conversationId, CancellationToken cancellationToken = default);

        Task<int> GetUserUnreadCountAsync(CancellationToken cancellationToken = default);

        Task<System.Collections.Generic.List<AdminSupportConversationDto>> GetAllConversationsAsync(CancellationToken cancellationToken = default);

        Task<AdminSupportConversationDetailDto> GetConversationDetailAsync(int conversationId, CancellationToken cancellationToken = default);

        Task<SupportMessageDto> SendAgentMessageAsync(int conversationId, string content, CancellationToken cancellationToken = default);

        Task<bool> SetConversationStatusAsync(int conversationId, bool open, CancellationToken cancellationToken = default);

        Task<int> GetAgentUnreadCountAsync(CancellationToken cancellationToken = default);

        Task<int> MarkAllReadAsync(CancellationToken cancellationToken = default);
    }
}
