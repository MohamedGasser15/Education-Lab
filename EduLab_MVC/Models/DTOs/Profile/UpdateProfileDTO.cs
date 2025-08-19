using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Profile
{
    public class UpdateProfileDTO
    {
        [Required]
        public string Id { get; set; }

        [StringLength(100, ErrorMessage = "الاسم يجب ألا يتجاوز 100 حرف")]
        public string? FullName { get; set; }

        [StringLength(100, ErrorMessage = "المسمى الوظيفي يجب ألا يتجاوز 100 حرف")]
        public string? Title { get; set; }

        [StringLength(100, ErrorMessage = "الموقع يجب ألا يتجاوز 100 حرف")]
        public string? Location { get; set; }

        [Phone(ErrorMessage = "رقم الهاتف غير صحيح")]
        public string? PhoneNumber { get; set; }

        [StringLength(500, ErrorMessage = "النبذة يجب ألا تتجاوز 500 حرف")]
        public string? About { get; set; }

        public SocialLinksDTO? SocialLinks { get; set; }
    }
}
