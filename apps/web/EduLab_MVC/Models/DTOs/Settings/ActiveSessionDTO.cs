namespace EduLab_MVC.Models.DTOs.Settings
{
    /// <summary>
    /// Represents an active session data transfer object.
    /// </summary>
    public class ActiveSessionDTO
    {
        public Guid Id { get; set; }
        public string DeviceInfo { get; set; }
        public string Location { get; set; }
        public DateTime LoginTime { get; set; }
        public bool IsCurrent { get; set; }
    }
}
