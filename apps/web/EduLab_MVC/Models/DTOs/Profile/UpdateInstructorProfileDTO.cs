using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Profile
{
    public class UpdateInstructorProfileDTO : UpdateProfileDTO
    {
        public List<string>? Subjects { get; set; }
    }
}
