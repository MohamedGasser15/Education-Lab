using EduLab_Application.DTOs.Support;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Interface for the real-time support system operations
    /// </summary>
    public interface ISupportService
    {
        #region User Side

        Task<SupportConversationDto> CreateConversationAsync(string userId, string subject, string firstMessage, CancellationToken cancellationToken = default);

        Task<System.Collections.Generic.List<SupportConversationDto>> GetUserConversationsAsync(string userId, CancellationToken cancellationToken = default);

        Task<System.Collections.Generic.List<SupportMessageDto>> GetConversationMessagesAsync(string userId, int conversationId, CancellationToken cancellationToken = default);

        Task<SupportMessageDto> SendUserMessageAsync(string userId, int conversationId, string content, CancellationToken cancellationToken = default);

        Task<bool> CloseConversationAsync(string userId, int conversationId, CancellationToken cancellationToken = default);

        Task<bool> ReopenConversationAsync(string userId, int conversationId, CancellationToken cancellationToken = default);

        Task<int> GetUserUnreadCountAsync(string userId, CancellationToken cancellationToken = default);

        #endregion

        #region Admin / Agent Side

        Task<System.Collections.Generic.List<AdminSupportConversationDto>> GetAllConversationsAsync(CancellationToken cancellationToken = default);

        Task<AdminSupportConversationDetailDto> GetConversationDetailAsync(int conversationId, CancellationToken cancellationToken = default);

        Task<SupportMessageDto> SendAgentMessageAsync(string agentId, int conversationId, string content, CancellationToken cancellationToken = default);

        Task<bool> SetConversationStatusAsync(int conversationId, bool open, CancellationToken cancellationToken = default);

        Task<int> GetAgentUnreadCountAsync(CancellationToken cancellationToken = default);

        Task<int> MarkAllUserMessagesReadAsync(CancellationToken cancellationToken = default);

        #endregion
    }
}
