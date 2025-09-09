using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Settings
{
    /// <summary>
    /// Data Transfer Object for two-factor authentication
    /// </summary>
    public class TwoFactorDTO
    {
        /// <summary>
        /// Gets or sets a value indicating whether to enable two-factor authentication
        /// </summary>
        public bool Enable { get; set; }

        /// <summary>
        /// Gets or sets the verification code
        /// </summary>
        [Required(ErrorMessage = "رمز التحقق مطلوب")]
        [StringLength(6, ErrorMessage = "رمز التحقق يجب أن يكون 6 أرقام", MinimumLength = 6)]
        public string Code { get; set; }
    }
}
