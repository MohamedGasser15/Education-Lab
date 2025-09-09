using EduLab_Shared.Utitlites.Attributes;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Settings
{
    /// <summary>
    /// Data Transfer Object for changing user password
    /// </summary>
    public class ChangePasswordDTO
    {
        /// <summary>
        /// Gets or sets the current password
        /// </summary>
        [Required(ErrorMessage = "كلمة المرور الحالية مطلوبة")]
        [DataType(DataType.Password)]
        public string CurrentPassword { get; set; }

        /// <summary>
        /// Gets or sets the new password
        /// </summary>
        [Required(ErrorMessage = "كلمة المرور الجديدة مطلوبة")]
        [DataType(DataType.Password)]
        [CustomPassword] // Assuming this is a custom validation attribute
        public string NewPassword { get; set; }

        /// <summary>
        /// Gets or sets the confirmation of the new password
        /// </summary>
        [Required(ErrorMessage = "تأكيد كلمة المرور مطلوب")]
        [DataType(DataType.Password)]
        [Compare("NewPassword", ErrorMessage = "كلمة المرور وتأكيدها غير متطابقين")]
        public string ConfirmPassword { get; set; }
    }
}
