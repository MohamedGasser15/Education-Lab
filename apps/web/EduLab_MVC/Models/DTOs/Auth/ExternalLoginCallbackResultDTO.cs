namespace EduLab_MVC.Models.DTOs.Auth
{
    /// <summary>
    /// Represents an external login callback result data transfer object.
    /// </summary>
    public class ExternalLoginCallbackResultDTO
    {
        public bool IsNewUser { get; set; }
        public string Email { get; set; }
        public string ReturnUrl { get; set; }
        public string Message { get; set; }
    }
}
