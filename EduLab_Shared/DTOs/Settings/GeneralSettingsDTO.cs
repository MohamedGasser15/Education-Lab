using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Settings
{
    /// <summary>
    /// Data Transfer Object for general user settings
    /// </summary>
    public class GeneralSettingsDTO
    {
        /// <summary>
        /// Gets or sets the email address
        /// </summary>
        [Required(ErrorMessage = "البريد الإلكتروني مطلوب")]
        [EmailAddress(ErrorMessage = "صيغة البريد الإلكتروني غير صحيحة")]
        public string Email { get; set; }

        /// <summary>
        /// Gets or sets the full name
        /// </summary>
        [Required(ErrorMessage = "الاسم الكامل مطلوب")]
        [StringLength(100, ErrorMessage = "الاسم الكامل يجب أن يكون بين 2 و 100 حرف", MinimumLength = 2)]
        public string FullName { get; set; }

        /// <summary>
        /// Gets or sets the phone number
        /// </summary>
        [Phone(ErrorMessage = "صيغة رقم الهاتف غير صحيحة")]
        public string PhoneNumber { get; set; }
    }
}
