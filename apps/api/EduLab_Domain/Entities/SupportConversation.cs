using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

namespace EduLab_Domain.Entities
{
    /// <summary>
    /// Represents the state of a support conversation
    /// </summary>
    public enum SupportConversationStatus
    {
        Open,
        Closed
    }

    /// <summary>
    /// Represents a support conversation between a user and support agents
    /// </summary>
    public class SupportConversation
    {
        public int Id { get; set; }
        public string UserId { get; set; }
        public string Subject { get; set; }
        public SupportConversationStatus Status { get; set; } = SupportConversationStatus.Open;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;

        [ForeignKey("UserId")]
        public ApplicationUser User { get; set; }

        public ICollection<SupportMessage> Messages { get; set; } = new List<SupportMessage>();
    }
}
