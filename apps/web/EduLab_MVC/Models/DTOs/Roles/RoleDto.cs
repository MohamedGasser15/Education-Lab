namespace EduLab_MVC.Models.DTOs.Roles
{
    /// <summary>
    /// Represents a role data transfer object.
    /// </summary>
    public class RoleDto
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public int UserCount { get; set; }
    }
}
