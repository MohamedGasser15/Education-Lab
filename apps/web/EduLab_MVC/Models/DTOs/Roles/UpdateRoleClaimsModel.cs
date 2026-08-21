namespace EduLab_MVC.Models.DTOs.Roles
{
    /// <summary>
    /// Represents the update role claims model.
    /// </summary>
    public class UpdateRoleClaimsModel
    {
        public string RoleId { get; set; }
        public List<ClaimDto> Claims { get; set; }
    }
}
