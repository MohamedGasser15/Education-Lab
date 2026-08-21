using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace EduLab_Domain.Entities
{
    /// <summary>
    /// Represents the sender type of a support message
    /// </summary>
    public enum SupportMessageSenderRole
    {
        User,
        Agent
    }

    /// <summary>
    /// Represents a single message within a support conversation
    /// </summary>
    public class SupportMessage
    {
        public int Id { get; set; }
        public int ConversationId { get; set; }

        [ForeignKey("ConversationId")]
        public SupportConversation Conversation { get; set; }

        public string SenderId { get; set; }
        public SupportMessageSenderRole SenderRole { get; set; }
        public string Content { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public bool IsRead { get; set; }
    }
}
