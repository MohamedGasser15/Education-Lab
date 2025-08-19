using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Profile
{
    public class ProfileImageDTO
    {
        [Required]
        public string UserId { get; set; }

        [Required]
        public IFormFile ImageFile { get; set; }
    }
}
