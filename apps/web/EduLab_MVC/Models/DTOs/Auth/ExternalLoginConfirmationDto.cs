using System.ComponentModel.DataAnnotations;

namespace EduLab_MVC.Models.DTOs.Auth
{
    /// <summary>
    /// Represents an external login confirmation data transfer object.
    /// </summary>
    public class ExternalLoginConfirmationDto
    {
        [Required(ErrorMessage = "الاسم مطلوب")]
        public string Name { get; set; }
        public string Email { get; set; }
    }
}
