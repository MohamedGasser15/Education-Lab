using EduLab_Shared.DTOs.Role;

namespace EduLab_MVC.Models.DTOs.Roles
{
    public class RoleClaimsDto
    {
        public string RoleId { get; set; }
        public string RoleName { get; set; }
        public List<ClaimDto> Claims { get; set; } = new List<ClaimDto>();
    }
}
