using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Profile
{
    public class CertificateDTO
    {
        /// <summary>
        /// Gets or sets the certificate ID
        /// </summary>
        public int? Id { get; set; }

        /// <summary>
        /// Gets or sets the certificate name
        /// </summary>
        [Required(ErrorMessage = "اسم الشهادة مطلوب")]
        [StringLength(100, ErrorMessage = "اسم الشهادة يجب ألا يتجاوز 100 حرف")]
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the certificate issuer
        /// </summary>
        [Required(ErrorMessage = "جهة إصدار الشهادة مطلوبة")]
        [StringLength(100, ErrorMessage = "جهة الإصدار يجب ألا تتجاوز 100 حرف")]
        public string Issuer { get; set; }

        /// <summary>
        /// Gets or sets the year of issuance
        /// </summary>
        [Required(ErrorMessage = "سنة الإصدار مطلوبة")]
        [Range(1900, 2100, ErrorMessage = "سنة الإصدار يجب أن تكون بين 1900 و 2100")]
        public int Year { get; set; }
    }
}
