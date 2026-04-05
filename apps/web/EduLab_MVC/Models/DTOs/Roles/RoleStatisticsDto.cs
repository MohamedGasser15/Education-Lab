namespace EduLab_MVC.Models.DTOs.Roles
{
    public class RoleStatisticsDto
    {
        public int TotalRoles { get; set; }
        public int ActiveRoles { get; set; }
        public int SystemRoles { get; set; }
        public string LatestRoleDate { get; set; }
    }
}
