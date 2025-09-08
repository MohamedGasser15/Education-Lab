using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.InstructorApplication
{
    /// <summary>
    /// Data transfer object for instructor application submission
    /// </summary>
    public class InstructorApplicationDTO
    {
        /// <summary>
        /// Gets or sets the full name of the applicant
        /// </summary>
        [Required(ErrorMessage = "الاسم بالكامل مطلوب")]
        public string FullName { get; set; }

        /// <summary>
        /// Gets or sets the email of the applicant
        /// </summary>
        public string? Email { get; set; }

        /// <summary>
        /// Gets or sets the phone number of the applicant
        /// </summary>
        [Required(ErrorMessage = "رقم الهاتف مطلوب")]
        [Phone(ErrorMessage = "رقم الهاتف غير صحيح")]
        public string Phone { get; set; }

        /// <summary>
        /// Gets or sets the bio of the applicant
        /// </summary>
        [Required(ErrorMessage = "السيرة الذاتية مطلوبة")]
        [MaxLength(200, ErrorMessage = "السيرة الذاتية يجب ألا تتعدى 200 حرف")]
        public string Bio { get; set; }

        /// <summary>
        /// Gets or sets the specialization of the applicant
        /// </summary>
        [Required(ErrorMessage = "مجال التخصص مطلوب")]
        public string Specialization { get; set; }

        /// <summary>
        /// Gets or sets the experience of the applicant
        /// </summary>
        [Required(ErrorMessage = "سنوات الخبرة مطلوبة")]
        public string Experience { get; set; }

        /// <summary>
        /// Gets or sets the skills of the applicant
        /// </summary>
        [Required(ErrorMessage = "المهارات مطلوبة")]
        public List<string> Skills { get; set; } = new List<string>();

        /// <summary>
        /// Gets or sets the profile image file
        /// </summary>
        public IFormFile ProfileImage { get; set; }

        /// <summary>
        /// Gets or sets the CV file
        /// </summary>
        public IFormFile CvFile { get; set; }
    }
}
