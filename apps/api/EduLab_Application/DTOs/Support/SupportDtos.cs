using System;

namespace EduLab_Application.DTOs.Support
{
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

    public class CreateConversationRequest
    {
        public string Subject { get; set; }
        public string Message { get; set; }
    }

    public class SendSupportMessageRequest
    {
        public string Content { get; set; }
    }

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
        public System.Collections.Generic.List<SupportMessageDto> Messages { get; set; } = new();
    }
}
