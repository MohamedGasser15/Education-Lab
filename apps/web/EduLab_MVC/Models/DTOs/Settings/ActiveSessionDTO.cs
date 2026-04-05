namespace EduLab_MVC.Models.DTOs.Settings
{
    public class ActiveSessionDTO
    {
        public Guid Id { get; set; }
        public string DeviceInfo { get; set; }
        public string Location { get; set; }
        public DateTime LoginTime { get; set; }
        public bool IsCurrent { get; set; }
    }
}
