using EduLab_API.Hubs;
using EduLab_Application.Common.Constants;
using EduLab_Application.DTOs.Support;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Admin
{
    /// <summary>
    /// Support inbox API for admin/support agents
    /// </summary>
    [Route("api/admin/support")]
    [ApiController]
    [Authorize(Policy = "AdminArea")]
    public class SupportController : ControllerBase
    {
        private readonly ISupportService _supportService;
        private readonly IHubContext<SupportHub> _hubContext;
        private readonly ILogger<SupportController> _logger;

        public SupportController(
            ISupportService supportService,
            IHubContext<SupportHub> hubContext,
            ILogger<SupportController> logger)
        {
            _supportService = supportService;
            _hubContext = hubContext;
            _logger = logger;
        }

        /// <summary>
        /// Gets all support conversations for the agents inbox
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of support conversations</returns>
        /// <response code="200">Returns the list of conversations</response>
        /// <response code="403">If the user lacks the ViewSupport claim</response>
        [HttpGet("conversations")]
        public async Task<ActionResult<List<AdminSupportConversationDto>>> GetConversations(CancellationToken cancellationToken = default)
        {
            if (!User.HasClaim(c => c.Type == "ViewSupport"))
                return Forbid();

            var conversations = await _supportService.GetAllConversationsAsync(cancellationToken);
            return Ok(conversations);
        }

        /// <summary>
        /// Gets the details of a single support conversation
        /// </summary>
        /// <param name="conversationId">Conversation ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Conversation details including messages</returns>
        /// <response code="200">Returns the conversation details</response>
        /// <response code="403">If the user lacks the ViewSupport claim</response>
        /// <response code="404">If the conversation was not found</response>
        [HttpGet("conversations/{conversationId}")]
        public async Task<ActionResult<AdminSupportConversationDetailDto>> GetConversation(int conversationId, CancellationToken cancellationToken = default)
        {
            if (!User.HasClaim(c => c.Type == "ViewSupport"))
                return Forbid();

            var detail = await _supportService.GetConversationDetailAsync(conversationId, cancellationToken);
            if (detail == null) return NotFound(new { message = "Conversation not found" });

            // Notify the user that their unread count changed (agent read their messages)
            var userUnread = await _supportService.GetUserUnreadCountAsync(detail.UserId, cancellationToken);
            await _hubContext.Clients.Group($"user-{detail.UserId}").SendAsync("UnreadCountChanged", userUnread);

            return Ok(detail);
        }

        /// <summary>
        /// Sends an agent message in a support conversation
        /// </summary>
        /// <param name="conversationId">Conversation ID</param>
        /// <param name="request">Message content</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The created message</returns>
        /// <response code="200">Returns the created message</response>
        /// <response code="400">If the message content is invalid</response>
        /// <response code="401">If the agent could not be identified</response>
        /// <response code="403">If the user lacks the HandleSupport claim</response>
        /// <response code="404">If the conversation was not found</response>
        [HttpPost("conversations/{conversationId}/messages")]
        public async Task<ActionResult<SupportMessageDto>> SendMessage(int conversationId, [FromBody] SendSupportMessageRequest request, CancellationToken cancellationToken = default)
        {
            if (!User.HasClaim(c => c.Type == "HandleSupport"))
                return Forbid();

            var agentId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(agentId)) return Unauthorized();

            if (string.IsNullOrWhiteSpace(request?.Content))
                return BadRequest(new { message = "Message content is required" });

            try
            {
                var message = await _supportService.SendAgentMessageAsync(agentId, conversationId, request.Content, cancellationToken);

                // Determine the conversation owner to push their unread count
                var detail = await _supportService.GetConversationDetailAsync(conversationId, cancellationToken);
                if (detail != null)
                {
                    var userUnread = await _supportService.GetUserUnreadCountAsync(detail.UserId, cancellationToken);
                    await SupportHub.BroadcastNewMessageAsync(_hubContext, message, $"user-{detail.UserId}", userUnread);
                }

                return Ok(message);
            }
            catch (KeyNotFoundException)
            {
                return NotFound(new { message = "Conversation not found" });
            }
            catch (InvalidOperationException ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        /// <summary>
        /// Sets the open/closed status of a support conversation
        /// </summary>
        /// <param name="conversationId">Conversation ID</param>
        /// <param name="request">Status request with the Open flag</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation result</returns>
        /// <response code="200">If the status was updated successfully</response>
        /// <response code="403">If the user lacks the HandleSupport claim</response>
        /// <response code="404">If the conversation was not found</response>
        [HttpPost("conversations/{conversationId}/status")]
        public async Task<IActionResult> SetStatus(int conversationId, [FromBody] SetConversationStatusRequest request, CancellationToken cancellationToken = default)
        {
            if (!User.HasClaim(c => c.Type == "HandleSupport"))
                return Forbid();

            var success = await _supportService.SetConversationStatusAsync(conversationId, request?.Open == true, cancellationToken);
            if (!success) return NotFound(new { message = "Conversation not found" });

            var detail = await _supportService.GetConversationDetailAsync(conversationId, cancellationToken);
            if (detail != null)
            {
                await SupportHub.NotifyUserConversationsChangedAsync(_hubContext, detail.UserId);
            }
            await SupportHub.NotifyAgentsConversationsChangedAsync(_hubContext);

            return Ok(new { success = true });
        }

        /// <summary>
        /// Gets the unread message count for the current agent
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Number of unread messages</returns>
        /// <response code="200">Returns the unread count</response>
        /// <response code="403">If the user lacks the ViewSupport claim</response>
        [HttpGet("unread-count")]
        public async Task<ActionResult<int>> GetUnreadCount(CancellationToken cancellationToken = default)
        {
            if (!User.HasClaim(c => c.Type == "ViewSupport"))
                return Forbid();

            var count = await _supportService.GetAgentUnreadCountAsync(cancellationToken);
            return Ok(count);
        }

        /// <summary>
        /// Marks all user messages as read for the current agent
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Number of messages marked as read</returns>
        /// <response code="200">Returns the count of marked messages</response>
        /// <response code="403">If the user lacks the HandleSupport claim</response>
        [HttpPost("mark-all-read")]
        public async Task<ActionResult<int>> MarkAllRead(CancellationToken cancellationToken = default)
        {
            if (!User.HasClaim(c => c.Type == "HandleSupport"))
                return Forbid();

            var marked = await _supportService.MarkAllUserMessagesReadAsync(cancellationToken);

            await _hubContext.Clients.Group("agents").SendAsync("UnreadCountChanged", 0);

            return Ok(marked);
        }
    }

    /// <summary>
    /// Request body for setting the open/closed status of a conversation
    /// </summary>
    public class SetConversationStatusRequest
    {
        public bool Open { get; set; }
    }
}
