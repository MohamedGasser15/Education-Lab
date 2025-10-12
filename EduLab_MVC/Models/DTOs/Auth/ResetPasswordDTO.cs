using System.ComponentModel.DataAnnotations;

namespace EduLab_MVC.Models.DTOs.Auth
{
    /// <summary>
    /// Data transfer object for reset password request
    /// </summary>
    public class ResetPasswordDTO
    {
        [Required(ErrorMessage = "البريد الإلكتروني مطلوب")]
        public string Email { get; set; }

        [Required(ErrorMessage = "كود التحقق مطلوب")]
        public string Code { get; set; }

        [Required(ErrorMessage = "كلمة المرور الجديدة مطلوبة")]
        [MinLength(6, ErrorMessage = "كلمة المرور يجب أن تكون 6 أحرف على الأقل")]
        public string NewPassword { get; set; }

        [Required(ErrorMessage = "تأكيد كلمة المرور مطلوب")]
        [Compare("NewPassword", ErrorMessage = "كلمتا المرور غير متطابقتين")]
        public string ConfirmPassword { get; set; }
    }
}