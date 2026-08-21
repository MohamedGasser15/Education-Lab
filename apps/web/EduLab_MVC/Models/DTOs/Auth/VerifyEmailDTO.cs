namespace EduLab_MVC.Models.DTOs.Auth
{
    /// <summary>
    /// Represents a verify email data transfer object.
    /// </summary>
    public class VerifyEmailDTO
    {
        public string Email { get; set; }
        public string Code { get; set; }
    }
}
