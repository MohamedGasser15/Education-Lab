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

        /// <summary>
        /// Initializes a new instance of the SupportController class
        /// </summary>
        /// <param name="supportService">Support service</param>
        /// <param name="currentUserService">Current user service</param>
        /// <param name="hubContext">SignalR hub context for real-time notifications</param>
        /// <param name="logger">Logger instance</param>
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

        /// <summary>
        /// Gets all support conversations for the current user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of the user's conversations</returns>
        /// <response code="200">Returns the list of conversations</response>
        /// <response code="401">If the user is not authenticated</response>
        [HttpGet("conversations")]
        public async Task<ActionResult<List<SupportConversationDto>>> GetConversations(CancellationToken cancellationToken = default)
        {
            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            var conversations = await _supportService.GetUserConversationsAsync(userId, cancellationToken);
            return Ok(conversations);
        }

        /// <summary>
        /// Creates a new support conversation with an initial message
        /// </summary>
        /// <param name="request">Conversation subject and initial message</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The created conversation</returns>
        /// <response code="200">Returns the created conversation</response>
        /// <response code="400">If the message is missing</response>
        /// <response code="401">If the user is not authenticated</response>
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

        /// <summary>
        /// Gets the messages of a support conversation
        /// </summary>
        /// <param name="conversationId">Conversation ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of messages in the conversation</returns>
        /// <response code="200">Returns the list of messages</response>
        /// <response code="401">If the user is not authenticated</response>
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

        /// <summary>
        /// Sends a message in a support conversation
        /// </summary>
        /// <param name="conversationId">Conversation ID</param>
        /// <param name="request">Message content</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The created message</returns>
        /// <response code="200">Returns the created message</response>
        /// <response code="400">If the message content is invalid</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="404">If the conversation was not found</response>
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

        /// <summary>
        /// Closes a support conversation
        /// </summary>
        /// <param name="conversationId">Conversation ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation result</returns>
        /// <response code="200">If the conversation was closed successfully</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="404">If the conversation was not found</response>
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

        /// <summary>
        /// Reopens a closed support conversation
        /// </summary>
        /// <param name="conversationId">Conversation ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation result</returns>
        /// <response code="200">If the conversation was reopened successfully</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="404">If the conversation was not found</response>
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

        /// <summary>
        /// Gets the unread message count for the current user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Number of unread messages</returns>
        /// <response code="200">Returns the unread count</response>
        /// <response code="401">If the user is not authenticated</response>
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
