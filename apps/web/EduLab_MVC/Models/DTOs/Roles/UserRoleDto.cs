namespace EduLab_MVC.Models.DTOs.Roles
{
    public class UserRoleDto
    {
        public string UserId { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public string FullName { get; set; }
        public DateTime CreatedAt { get; set; }
        public string ProfileImage { get; set; }
    }
}
