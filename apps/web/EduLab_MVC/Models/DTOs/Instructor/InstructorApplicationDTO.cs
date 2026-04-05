using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Instructor
{
    public class InstructorApplicationDTO
    {
        [Required(ErrorMessage = "الاسم بالكامل مطلوب")]
        public string FullName { get; set; }

        public string? Email { get; set; }

        [Required(ErrorMessage = "رقم الهاتف مطلوب")]
        [Phone(ErrorMessage = "رقم الهاتف غير صحيح")]
        public string Phone { get; set; }

        [Required(ErrorMessage = "السيرة الذاتية مطلوبة")]
        [MaxLength(200, ErrorMessage = "السيرة الذاتية يجب ألا تتعدى 200 حرف")]
        public string Bio { get; set; }

        [Required(ErrorMessage = "مجال التخصص مطلوب")]
        public string Specialization { get; set; }

        [Required(ErrorMessage = "سنوات الخبرة مطلوبة")]
        public string Experience { get; set; }

        [Required(ErrorMessage = "المهارات مطلوبة")]
        public List<string> Skills { get; set; } = new List<string>();
        //public string? ProfileImageUrl { get; set; } = null;
        public IFormFile ProfileImage { get; set; }
        public IFormFile CvFile { get; set; }
    }
}
