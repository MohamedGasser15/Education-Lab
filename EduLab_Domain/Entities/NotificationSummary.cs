namespace EduLab_Domain.Entities
{
    public class NotificationSummary
    {
        public int TotalCount { get; set; }
        public int UnreadCount { get; set; }
        public int SystemCount { get; set; }
        public int PromotionalCount { get; set; }
    }
}
