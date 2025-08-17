namespace EduLab_MVC.Models.DTOs.Roles
{
    public class UpdateRoleClaimsModel
    {
        public string RoleId { get; set; }
        public List<ClaimDto> Claims { get; set; }
    }
}
