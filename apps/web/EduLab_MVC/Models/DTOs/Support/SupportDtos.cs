using System;
using System.Collections.Generic;

namespace EduLab_MVC.Models.DTOs.Support
{
    /// <summary>
    /// Represents a support message data transfer object.
    /// </summary>
    public class SupportMessageDto
    {
        public int Id { get; set; }
        public int ConversationId { get; set; }
        public string SenderId { get; set; }
        public string SenderRole { get; set; }
        public string Content { get; set; }
        public DateTime CreatedAt { get; set; }
        public bool IsRead { get; set; }
    }

    /// <summary>
    /// Represents a support conversation data transfer object.
    /// </summary>
    public class SupportConversationDto
    {
        public int Id { get; set; }
        public string Subject { get; set; }
        public string Status { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public int UnreadCount { get; set; }
        public string? LastMessage { get; set; }
        public DateTime? LastMessageAt { get; set; }
    }

    /// <summary>
    /// Represents a create conversation request.
    /// </summary>
    public class CreateConversationRequest
    {
        public string Subject { get; set; }
        public string Message { get; set; }
    }

    /// <summary>
    /// Represents a send support message request.
    /// </summary>
    public class SendSupportMessageRequest
    {
        public string Content { get; set; }
    }

    /// <summary>
    /// Represents an admin support conversation data transfer object.
    /// </summary>
    public class AdminSupportConversationDto
    {
        public int Id { get; set; }
        public string Subject { get; set; }
        public string Status { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string UserId { get; set; }
        public string UserName { get; set; }
        public string? UserImageUrl { get; set; }
        public string UserRole { get; set; }
        public int UnreadCount { get; set; }
        public string? LastMessage { get; set; }
        public DateTime? LastMessageAt { get; set; }
        public string? LastSenderRole { get; set; }
    }

    /// <summary>
    /// Represents an admin support conversation detail data transfer object.
    /// </summary>
    public class AdminSupportConversationDetailDto
    {
        public int Id { get; set; }
        public string Subject { get; set; }
        public string Status { get; set; }
        public DateTime CreatedAt { get; set; }
        public string UserId { get; set; }
        public string UserName { get; set; }
        public string? UserImageUrl { get; set; }
        public string UserRole { get; set; }
        public List<SupportMessageDto> Messages { get; set; } = new();
    }
}
