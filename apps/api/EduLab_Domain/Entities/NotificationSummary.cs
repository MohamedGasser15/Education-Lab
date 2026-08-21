namespace EduLab_Domain.Entities
{
    /// <summary>
    /// Aggregated counts of a user's notifications
    /// </summary>
    public class NotificationSummary
    {
        public int TotalCount { get; set; }
        public int UnreadCount { get; set; }
        public int SystemCount { get; set; }
        public int PromotionalCount { get; set; }
    }
}
