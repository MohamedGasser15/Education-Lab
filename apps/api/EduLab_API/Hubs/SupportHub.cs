using EduLab_Application.Common.Constants;
using EduLab_Application.DTOs.Support;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;

namespace EduLab_API.Hubs
{
    /// <summary>
    /// Real-time support chat hub. Clients connect with the JWT and are grouped:
    /// - Every user joins "user-{id}"
    /// - Admins/Support agents join "agents"
    /// - Active chat windows join "conv-{conversationId}"
    /// </summary>
    [Authorize]
    public class SupportHub : Hub
    {
        public override async Task OnConnectedAsync()
        {
            var userId = Context.UserIdentifier;
            if (!string.IsNullOrEmpty(userId))
                await Groups.AddToGroupAsync(Context.ConnectionId, $"user-{userId}");

            var isAgent = Context.User?.IsInRole(SD.Admin) == true || Context.User?.IsInRole(SD.Support) == true;
            if (isAgent)
                await Groups.AddToGroupAsync(Context.ConnectionId, "agents");

            await base.OnConnectedAsync();
        }

        /// <summary>
        /// Joins the live group of a conversation (called when a chat window is opened)
        /// </summary>
        public Task JoinConversation(int conversationId)
            => Groups.AddToGroupAsync(Context.ConnectionId, $"conv-{conversationId}");

        /// <summary>
        /// Leaves the live group of a conversation
        /// </summary>
        public Task LeaveConversation(int conversationId)
            => Groups.RemoveFromGroupAsync(Context.ConnectionId, $"conv-{conversationId}");

        #region Broadcast Helpers

        /// <summary>
        /// Broadcasts a new message to the conversation group and pushes the unread count to the other party
        /// </summary>
        public static async Task BroadcastNewMessageAsync(IHubContext<SupportHub> hub, SupportMessageDto message, string recipientGroup, int recipientUnreadCount)
        {
            await hub.Clients.Group($"conv-{message.ConversationId}").SendAsync("ReceiveMessage", message);

            if (!string.IsNullOrEmpty(recipientGroup))
                await hub.Clients.Group(recipientGroup).SendAsync("UnreadCountChanged", recipientUnreadCount);
        }

        /// <summary>
        /// Tells the agents group that the conversation list changed (new conversation, status change)
        /// </summary>
        public static Task NotifyAgentsConversationsChangedAsync(IHubContext<SupportHub> hub)
            => hub.Clients.Group("agents").SendAsync("ConversationsChanged");

        /// <summary>
        /// Tells a specific user their conversation list changed (status change, etc.)
        /// </summary>
        public static Task NotifyUserConversationsChangedAsync(IHubContext<SupportHub> hub, string userId)
            => hub.Clients.Group($"user-{userId}").SendAsync("ConversationsChanged");

        #endregion
    }
}
