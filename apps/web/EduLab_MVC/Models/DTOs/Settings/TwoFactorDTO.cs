using System.ComponentModel.DataAnnotations;

namespace EduLab_MVC.Models.DTOs.Settings
{
    /// <summary>
    /// Represents a two factor data transfer object.
    /// </summary>
    public class TwoFactorDTO
    {
        [Required]
        [RegularExpression(@"^\d{6}$", ErrorMessage = "يجب أن يكون رمز التحقق 6 أرقام")]
        public string Code { get; set; }
    }
}
