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

        /// <summary>
        /// Creates a new support conversation for a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="subject">Subject of the conversation</param>
        /// <param name="firstMessage">Initial message content</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The created conversation DTO</returns>
        Task<SupportConversationDto> CreateConversationAsync(string userId, string subject, string firstMessage, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves all support conversations of a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of conversation DTOs</returns>
        Task<System.Collections.Generic.List<SupportConversationDto>> GetUserConversationsAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the messages of a conversation owned by a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="conversationId">Unique identifier of the conversation</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of message DTOs</returns>
        Task<System.Collections.Generic.List<SupportMessageDto>> GetConversationMessagesAsync(string userId, int conversationId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Sends a message from a user to a support conversation
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="conversationId">Unique identifier of the conversation</param>
        /// <param name="content">Message content</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The created message DTO</returns>
        Task<SupportMessageDto> SendUserMessageAsync(string userId, int conversationId, string content, CancellationToken cancellationToken = default);

        /// <summary>
        /// Closes a support conversation owned by a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="conversationId">Unique identifier of the conversation</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the conversation was closed, otherwise false</returns>
        Task<bool> CloseConversationAsync(string userId, int conversationId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Reopens a closed support conversation owned by a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="conversationId">Unique identifier of the conversation</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the conversation was reopened, otherwise false</returns>
        Task<bool> ReopenConversationAsync(string userId, int conversationId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets the number of unread agent messages across the conversations of a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The unread messages count</returns>
        Task<int> GetUserUnreadCountAsync(string userId, CancellationToken cancellationToken = default);

        #endregion

        #region Admin / Agent Side

        /// <summary>
        /// Retrieves all support conversations for the agent panel
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of admin conversation DTOs</returns>
        Task<System.Collections.Generic.List<AdminSupportConversationDto>> GetAllConversationsAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the details of a support conversation for the agent panel
        /// </summary>
        /// <param name="conversationId">Unique identifier of the conversation</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Conversation details DTO</returns>
        Task<AdminSupportConversationDetailDto> GetConversationDetailAsync(int conversationId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Sends a message from a support agent to a conversation
        /// </summary>
        /// <param name="agentId">Unique identifier of the agent</param>
        /// <param name="conversationId">Unique identifier of the conversation</param>
        /// <param name="content">Message content</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The created message DTO</returns>
        Task<SupportMessageDto> SendAgentMessageAsync(string agentId, int conversationId, string content, CancellationToken cancellationToken = default);

        /// <summary>
        /// Sets the open/closed status of a support conversation
        /// </summary>
        /// <param name="conversationId">Unique identifier of the conversation</param>
        /// <param name="open">True to open, false to close</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the status was updated, otherwise false</returns>
        Task<bool> SetConversationStatusAsync(int conversationId, bool open, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets the number of unread user messages across all conversations
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The unread messages count</returns>
        Task<int> GetAgentUnreadCountAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Marks all user messages across conversations as read
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The number of messages marked as read</returns>
        Task<int> MarkAllUserMessagesReadAsync(CancellationToken cancellationToken = default);

        #endregion
    }
}