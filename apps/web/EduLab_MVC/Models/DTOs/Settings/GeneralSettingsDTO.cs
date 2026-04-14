using System.ComponentModel.DataAnnotations;

namespace EduLab_MVC.Models.DTOs.Settings
{
    public class GeneralSettingsDTO
    {
        [EmailAddress(ErrorMessage = "البريد الإلكتروني غير صحيح")]
        public string Email { get; set; }

        [Required(ErrorMessage = "الاسم بالكامل مطلوب")]
        public string FullName { get; set; }

        [Phone(ErrorMessage = "رقم الهاتف غير صحيح")]
        public string PhoneNumber { get; set; }
    }
}
