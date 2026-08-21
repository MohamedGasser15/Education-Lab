namespace EduLab_MVC.Models.DTOs.Roles
{
    /// <summary>
    /// Represents a role statistics data transfer object.
    /// </summary>
    public class RoleStatisticsDto
    {
        public int TotalRoles { get; set; }
        public int ActiveRoles { get; set; }
        public int SystemRoles { get; set; }
        public string LatestRoleDate { get; set; }
    }
}
