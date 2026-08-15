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
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Learner
{
    /// <summary>
    /// Support chat API for learners and instructors (authenticated users)
    /// </summary>
    [Route("api/support")]
    [ApiController]
    [Authorize]
    public class SupportController : ControllerBase
    {
        private readonly ISupportService _supportService;
        private readonly ICurrentUserService _currentUserService;
        private readonly IHubContext<SupportHub> _hubContext;
        private readonly ILogger<SupportController> _logger;

        public SupportController(
            ISupportService supportService,
            ICurrentUserService currentUserService,
            IHubContext<SupportHub> hubContext,
            ILogger<SupportController> logger)
        {
            _supportService = supportService;
            _currentUserService = currentUserService;
            _hubContext = hubContext;
            _logger = logger;
        }

        [HttpGet("conversations")]
        public async Task<ActionResult<List<SupportConversationDto>>> GetConversations(CancellationToken cancellationToken = default)
        {
            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            var conversations = await _supportService.GetUserConversationsAsync(userId, cancellationToken);
            return Ok(conversations);
        }

        [HttpPost("conversations")]
        public async Task<ActionResult<SupportConversationDto>> CreateConversation([FromBody] CreateConversationRequest request, CancellationToken cancellationToken = default)
        {
            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            if (string.IsNullOrWhiteSpace(request?.Message))
                return BadRequest(new { message = "Message is required" });

            var conversation = await _supportService.CreateConversationAsync(userId, request?.Subject, request.Message, cancellationToken);

            await SupportHub.NotifyAgentsConversationsChangedAsync(_hubContext);

            return Ok(conversation);
        }

        [HttpGet("conversations/{conversationId}/messages")]
        public async Task<ActionResult<List<SupportMessageDto>>> GetMessages(int conversationId, CancellationToken cancellationToken = default)
        {
            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            var messages = await _supportService.GetConversationMessagesAsync(userId, conversationId, cancellationToken);

            // Notify agents that unread changed (user read the messages)
            var agentUnread = await _supportService.GetAgentUnreadCountAsync(cancellationToken);
            await _hubContext.Clients.Group("agents").SendAsync("UnreadCountChanged", agentUnread);

            return Ok(messages);
        }

        [HttpPost("conversations/{conversationId}/messages")]
        public async Task<ActionResult<SupportMessageDto>> SendMessage(int conversationId, [FromBody] SendSupportMessageRequest request, CancellationToken cancellationToken = default)
        {
            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            if (string.IsNullOrWhiteSpace(request?.Content))
                return BadRequest(new { message = "Message content is required" });

            try
            {
                var message = await _supportService.SendUserMessageAsync(userId, conversationId, request.Content, cancellationToken);

                var agentUnread = await _supportService.GetAgentUnreadCountAsync(cancellationToken);
                await SupportHub.BroadcastNewMessageAsync(_hubContext, message, "agents", agentUnread);
                await SupportHub.NotifyAgentsConversationsChangedAsync(_hubContext);

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

        [HttpPost("conversations/{conversationId}/close")]
        public async Task<IActionResult> CloseConversation(int conversationId, CancellationToken cancellationToken = default)
        {
            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            var closed = await _supportService.CloseConversationAsync(userId, conversationId, cancellationToken);
            if (!closed) return NotFound(new { message = "Conversation not found" });

            await SupportHub.NotifyAgentsConversationsChangedAsync(_hubContext);

            return Ok(new { success = true });
        }

        [HttpPost("conversations/{conversationId}/reopen")]
        public async Task<IActionResult> ReopenConversation(int conversationId, CancellationToken cancellationToken = default)
        {
            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            var reopened = await _supportService.ReopenConversationAsync(userId, conversationId, cancellationToken);
            if (!reopened) return NotFound(new { message = "Conversation not found" });

            await SupportHub.NotifyAgentsConversationsChangedAsync(_hubContext);

            return Ok(new { success = true });
        }

        [HttpGet("unread-count")]
        public async Task<ActionResult<int>> GetUnreadCount(CancellationToken cancellationToken = default)
        {
            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            var count = await _supportService.GetUserUnreadCountAsync(userId, cancellationToken);
            return Ok(count);
        }
    }
}
