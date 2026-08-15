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

        [HttpGet("conversations")]
        public async Task<ActionResult<List<AdminSupportConversationDto>>> GetConversations(CancellationToken cancellationToken = default)
        {
            if (!User.HasClaim(c => c.Type == "ViewSupport"))
                return Forbid();

            var conversations = await _supportService.GetAllConversationsAsync(cancellationToken);
            return Ok(conversations);
        }

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

        [HttpGet("unread-count")]
        public async Task<ActionResult<int>> GetUnreadCount(CancellationToken cancellationToken = default)
        {
            if (!User.HasClaim(c => c.Type == "ViewSupport"))
                return Forbid();

            var count = await _supportService.GetAgentUnreadCountAsync(cancellationToken);
            return Ok(count);
        }

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

    public class SetConversationStatusRequest
    {
        public bool Open { get; set; }
    }
}
