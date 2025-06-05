using EduLab_Shared.Utitlites.Attributes;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Auth
{
    public class RegisterRequestDTO
    {
        [Required(ErrorMessage = "الاسم الكامل مطلوب")]
        [MinLength(6, ErrorMessage = "يجب أن يكون الاسم الكامل على الأقل 6 أحرف")]
        public string FullName { get; set; }
        [Required(ErrorMessage = "البريد الإلكتروني مطلوب")]
        public string Email { get; set; }
        [Required(ErrorMessage = "كلمة المرور مطلوبة")]
        [DataType(DataType.Password)]
        [Display(Name = "Password")]
        [CustomPassword] 
        public string Password { get; set; }
        [Required(ErrorMessage = "تأكيد كلمة المرور مطلوب")]
        [DataType(DataType.Password)]
        [Compare("Password", ErrorMessage = "كلمة المرور وتأكيدها غير متطابقين")]
        public string ConfirmPassword { get; set; }
    }
}
