namespace EduLab_MVC.Models.DTOs.Roles
{
    /// <summary>
    /// Represents a role claims data transfer object.
    /// </summary>
    public class RoleClaimsDto
    {
        public string RoleId { get; set; }
        public string RoleName { get; set; }
        public List<ClaimDto> Claims { get; set; } = new List<ClaimDto>();
    }
}
