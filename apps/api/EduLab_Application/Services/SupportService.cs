using EduLab_Application.Common.Constants;
using EduLab_Application.DTOs.Support;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for the real-time support system
    /// </summary>
    public class SupportService : ISupportService
    {
        private readonly IRepository<SupportConversation> _conversationRepository;
        private readonly IRepository<SupportMessage> _messageRepository;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly ILogger<SupportService> _logger;

        public SupportService(
            IRepository<SupportConversation> conversationRepository,
            IRepository<SupportMessage> messageRepository,
            UserManager<ApplicationUser> userManager,
            ILogger<SupportService> logger)
        {
            _conversationRepository = conversationRepository;
            _messageRepository = messageRepository;
            _userManager = userManager;
            _logger = logger;
        }

        #region User Side

        /// <summary>
        /// Creates a new support conversation for a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="subject">Subject of the conversation</param>
        /// <param name="firstMessage">Initial message content</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The created conversation DTO</returns>
        public async Task<SupportConversationDto> CreateConversationAsync(string userId, string subject, string firstMessage, CancellationToken cancellationToken = default)
        {
            var conversation = new SupportConversation
            {
                UserId = userId,
                Subject = string.IsNullOrWhiteSpace(subject) ? "General support" : subject.Trim(),
                Status = SupportConversationStatus.Open,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            await _conversationRepository.CreateAsync(conversation, cancellationToken);

            var message = new SupportMessage
            {
                ConversationId = conversation.Id,
                SenderId = userId,
                SenderRole = SupportMessageSenderRole.User,
                Content = firstMessage?.Trim() ?? string.Empty,
                CreatedAt = DateTime.UtcNow,
                IsRead = false
            };

            await _messageRepository.CreateAsync(message, cancellationToken);

            return new SupportConversationDto
            {
                Id = conversation.Id,
                Subject = conversation.Subject,
                Status = conversation.Status.ToString(),
                CreatedAt = conversation.CreatedAt,
                UpdatedAt = conversation.UpdatedAt,
                UnreadCount = 0,
                LastMessage = message.Content,
                LastMessageAt = message.CreatedAt
            };
        }

        public async Task<List<SupportConversationDto>> GetUserConversationsAsync(string userId, CancellationToken cancellationToken = default)
        {
            var conversations = await _conversationRepository.GetAllAsync(
                filter: c => c.UserId == userId,
                includeProperties: "Messages",
                orderBy: q => q.OrderByDescending(c => c.UpdatedAt),
                cancellationToken: cancellationToken);

            return conversations.Select(c => new SupportConversationDto
            {
                Id = c.Id,
                Subject = c.Subject,
                Status = c.Status.ToString(),
                CreatedAt = c.CreatedAt,
                UpdatedAt = c.UpdatedAt,
                UnreadCount = c.Messages.Count(m => m.SenderRole == SupportMessageSenderRole.Agent && !m.IsRead),
                LastMessage = c.Messages.OrderByDescending(m => m.CreatedAt).FirstOrDefault()?.Content,
                LastMessageAt = c.Messages.OrderByDescending(m => m.CreatedAt).FirstOrDefault()?.CreatedAt
            }).ToList();
        }

        public async Task<List<SupportMessageDto>> GetConversationMessagesAsync(string userId, int conversationId, CancellationToken cancellationToken = default)
        {
            var conversation = await _conversationRepository.GetAsync(
                filter: c => c.Id == conversationId && c.UserId == userId,
                includeProperties: "Messages",
                isTracking: true,
                cancellationToken: cancellationToken);

            if (conversation == null)
                return new List<SupportMessageDto>();

            // Mark agent messages as read by the user
            var unread = conversation.Messages
                .Where(m => m.SenderRole == SupportMessageSenderRole.Agent && !m.IsRead)
                .ToList();

            if (unread.Any())
            {
                foreach (var message in unread)
                    message.IsRead = true;
                await _conversationRepository.SaveAsync(cancellationToken);
            }

            return conversation.Messages
                .OrderBy(m => m.CreatedAt)
                .Select(m => new SupportMessageDto
                {
                    Id = m.Id,
                    ConversationId = m.ConversationId,
                    SenderId = m.SenderId,
                    SenderRole = m.SenderRole.ToString(),
                    Content = m.Content,
                    CreatedAt = m.CreatedAt,
                    IsRead = m.IsRead
                }).ToList();
        }

        /// <summary>
        /// Sends a message from a user to a support conversation
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="conversationId">Unique identifier of the conversation</param>
        /// <param name="content">Message content</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The created message DTO</returns>
        public async Task<SupportMessageDto> SendUserMessageAsync(string userId, int conversationId, string content, CancellationToken cancellationToken = default)
        {
            var conversation = await _conversationRepository.GetAsync(
                filter: c => c.Id == conversationId && c.UserId == userId,
                isTracking: true,
                cancellationToken: cancellationToken);

            if (conversation == null)
                throw new KeyNotFoundException("Conversation not found");

            if (conversation.Status == SupportConversationStatus.Closed)
                throw new InvalidOperationException("Conversation is closed");

            var message = new SupportMessage
            {
                ConversationId = conversationId,
                SenderId = userId,
                SenderRole = SupportMessageSenderRole.User,
                Content = content?.Trim() ?? string.Empty,
                CreatedAt = DateTime.UtcNow,
                IsRead = false
            };

            await _messageRepository.CreateAsync(message, cancellationToken);

            conversation.UpdatedAt = DateTime.UtcNow;
            await _conversationRepository.SaveAsync(cancellationToken);

            return ToMessageDto(message);
        }

        /// <summary>
        /// Closes a support conversation owned by a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="conversationId">Unique identifier of the conversation</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the conversation was closed, otherwise false</returns>
        public async Task<bool> CloseConversationAsync(string userId, int conversationId, CancellationToken cancellationToken = default)
        {
            var conversation = await _conversationRepository.GetAsync(
                filter: c => c.Id == conversationId && c.UserId == userId,
                isTracking: true,
                cancellationToken: cancellationToken);

            if (conversation == null)
                return false;

            conversation.Status = SupportConversationStatus.Closed;
            conversation.UpdatedAt = DateTime.UtcNow;
            await _conversationRepository.SaveAsync(cancellationToken);

            return true;
        }

        /// <summary>
        /// Reopens a closed support conversation owned by a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="conversationId">Unique identifier of the conversation</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the conversation was reopened, otherwise false</returns>
        public async Task<bool> ReopenConversationAsync(string userId, int conversationId, CancellationToken cancellationToken = default)
        {
            var conversation = await _conversationRepository.GetAsync(
                filter: c => c.Id == conversationId && c.UserId == userId,
                isTracking: true,
                cancellationToken: cancellationToken);

            if (conversation == null)
                return false;

            conversation.Status = SupportConversationStatus.Open;
            conversation.UpdatedAt = DateTime.UtcNow;
            await _conversationRepository.SaveAsync(cancellationToken);

            return true;
        }

        /// <summary>
        /// Gets the number of unread agent messages across the conversations of a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The unread messages count</returns>
        public async Task<int> GetUserUnreadCountAsync(string userId, CancellationToken cancellationToken = default)
        {
            var conversations = await _conversationRepository.GetAllAsync(
                filter: c => c.UserId == userId,
                includeProperties: "Messages",
                cancellationToken: cancellationToken);

            return conversations
                .SelectMany(c => c.Messages)
                .Count(m => m.SenderRole == SupportMessageSenderRole.Agent && !m.IsRead);
        }

        #endregion

        #region Admin / Agent Side

        public async Task<List<AdminSupportConversationDto>> GetAllConversationsAsync(CancellationToken cancellationToken = default)
        {
            var conversations = await _conversationRepository.GetAllAsync(
                includeProperties: "Messages,User",
                orderBy: q => q.OrderByDescending(c => c.UpdatedAt),
                cancellationToken: cancellationToken);

            var result = new List<AdminSupportConversationDto>();

            foreach (var conversation in conversations)
            {
                var roles = await _userManager.GetRolesAsync(conversation.User);
                var lastMessage = conversation.Messages.OrderByDescending(m => m.CreatedAt).FirstOrDefault();

                result.Add(new AdminSupportConversationDto
                {
                    Id = conversation.Id,
                    Subject = conversation.Subject,
                    Status = conversation.Status.ToString(),
                    CreatedAt = conversation.CreatedAt,
                    UpdatedAt = conversation.UpdatedAt,
                    UserId = conversation.UserId,
                    UserName = conversation.User?.FullName ?? "Unknown",
                    UserImageUrl = conversation.User?.ProfileImageUrl,
                    UserRole = roles.FirstOrDefault() ?? SD.Student,
                    UnreadCount = conversation.Messages.Count(m => m.SenderRole == SupportMessageSenderRole.User && !m.IsRead),
                    LastMessage = lastMessage?.Content,
                    LastMessageAt = lastMessage?.CreatedAt,
                    LastSenderRole = lastMessage?.SenderRole.ToString()
                });
            }

            return result;
        }

        /// <summary>
        /// Retrieves the details of a support conversation for the agent panel
        /// </summary>
        /// <param name="conversationId">Unique identifier of the conversation</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Conversation details DTO</returns>
        public async Task<AdminSupportConversationDetailDto> GetConversationDetailAsync(int conversationId, CancellationToken cancellationToken = default)
        {
            var conversation = await _conversationRepository.GetAsync(
                filter: c => c.Id == conversationId,
                includeProperties: "Messages,User",
                isTracking: true,
                cancellationToken: cancellationToken);

            if (conversation == null)
                return null;

            // Mark user messages as read by the agent
            var unread = conversation.Messages
                .Where(m => m.SenderRole == SupportMessageSenderRole.User && !m.IsRead)
                .ToList();

            if (unread.Any())
            {
                foreach (var message in unread)
                    message.IsRead = true;
                await _conversationRepository.SaveAsync(cancellationToken);
            }

            var roles = await _userManager.GetRolesAsync(conversation.User);

            return new AdminSupportConversationDetailDto
            {
                Id = conversation.Id,
                Subject = conversation.Subject,
                Status = conversation.Status.ToString(),
                CreatedAt = conversation.CreatedAt,
                UserId = conversation.UserId,
                UserName = conversation.User?.FullName ?? "Unknown",
                UserImageUrl = conversation.User?.ProfileImageUrl,
                UserRole = roles.FirstOrDefault() ?? SD.Student,
                Messages = conversation.Messages
                    .OrderBy(m => m.CreatedAt)
                    .Select(ToMessageDto)
                    .ToList()
            };
        }

        /// <summary>
        /// Sends a message from a support agent to a conversation
        /// </summary>
        /// <param name="agentId">Unique identifier of the agent</param>
        /// <param name="conversationId">Unique identifier of the conversation</param>
        /// <param name="content">Message content</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The created message DTO</returns>
        public async Task<SupportMessageDto> SendAgentMessageAsync(string agentId, int conversationId, string content, CancellationToken cancellationToken = default)
        {
            var conversation = await _conversationRepository.GetAsync(
                filter: c => c.Id == conversationId,
                isTracking: true,
                cancellationToken: cancellationToken);

            if (conversation == null)
                throw new KeyNotFoundException("Conversation not found");

            if (conversation.Status == SupportConversationStatus.Closed)
                throw new InvalidOperationException("Conversation is closed");

            var message = new SupportMessage
            {
                ConversationId = conversationId,
                SenderId = agentId,
                SenderRole = SupportMessageSenderRole.Agent,
                Content = content?.Trim() ?? string.Empty,
                CreatedAt = DateTime.UtcNow,
                IsRead = false
            };

            await _messageRepository.CreateAsync(message, cancellationToken);

            conversation.UpdatedAt = DateTime.UtcNow;
            await _conversationRepository.SaveAsync(cancellationToken);

            return ToMessageDto(message);
        }

        /// <summary>
        /// Sets the open/closed status of a support conversation
        /// </summary>
        /// <param name="conversationId">Unique identifier of the conversation</param>
        /// <param name="open">True to open, false to close</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the status was updated, otherwise false</returns>
        public async Task<bool> SetConversationStatusAsync(int conversationId, bool open, CancellationToken cancellationToken = default)
        {
            var conversation = await _conversationRepository.GetAsync(
                filter: c => c.Id == conversationId,
                isTracking: true,
                cancellationToken: cancellationToken);

            if (conversation == null)
                return false;

            conversation.Status = open ? SupportConversationStatus.Open : SupportConversationStatus.Closed;
            conversation.UpdatedAt = DateTime.UtcNow;
            await _conversationRepository.SaveAsync(cancellationToken);

            return true;
        }

        /// <summary>
        /// Gets the number of unread user messages across all conversations
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The unread messages count</returns>
        public async Task<int> GetAgentUnreadCountAsync(CancellationToken cancellationToken = default)
        {
            var conversations = await _conversationRepository.GetAllAsync(
                includeProperties: "Messages",
                cancellationToken: cancellationToken);

            return conversations
                .SelectMany(c => c.Messages)
                .Count(m => m.SenderRole == SupportMessageSenderRole.User && !m.IsRead);
        }

        /// <summary>
        /// Marks all user messages across conversations as read
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The number of messages marked as read</returns>
        public async Task<int> MarkAllUserMessagesReadAsync(CancellationToken cancellationToken = default)
        {
            var conversations = await _conversationRepository.GetAllAsync(
                includeProperties: "Messages",
                isTracking: true,
                cancellationToken: cancellationToken);

            var unreadMessages = conversations
                .SelectMany(c => c.Messages)
                .Where(m => m.SenderRole == SupportMessageSenderRole.User && !m.IsRead)
                .ToList();

            if (!unreadMessages.Any())
                return 0;

            foreach (var message in unreadMessages)
                message.IsRead = true;

            await _conversationRepository.SaveAsync(cancellationToken);

            return unreadMessages.Count;
        }

        #endregion

        #region Helpers

        private static SupportMessageDto ToMessageDto(SupportMessage message)
        {
            return new SupportMessageDto
            {
                Id = message.Id,
                ConversationId = message.ConversationId,
                SenderId = message.SenderId,
                SenderRole = message.SenderRole.ToString(),
                Content = message.Content,
                CreatedAt = message.CreatedAt,
                IsRead = message.IsRead
            };
        }

        #endregion
    }
}
