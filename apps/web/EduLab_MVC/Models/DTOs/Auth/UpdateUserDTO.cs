namespace EduLab_MVC.Models.DTOs.Auth
{
    /// <summary>
    /// Represents an update user data transfer object.
    /// </summary>
    public class UpdateUserDTO
    {
        public string Id { get; set; }
        public string FullName { get; set; }
        public string Role { get; set; }
    }
}
