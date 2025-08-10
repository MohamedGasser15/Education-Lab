using System.ComponentModel.DataAnnotations;

namespace EduLab_MVC.Models.DTOs.Auth
{
    public class ExternalLoginConfirmationDto
    {
        [Required(ErrorMessage = "الاسم مطلوب")]
        public string Name { get; set; }
        public string Email { get; set; }
    }
}
