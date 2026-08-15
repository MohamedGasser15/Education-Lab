using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace EduLab_Domain.Entities
{
    public enum SupportMessageSenderRole
    {
        User,
        Agent
    }

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
