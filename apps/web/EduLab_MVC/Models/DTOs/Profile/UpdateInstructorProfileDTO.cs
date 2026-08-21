using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Profile
{
    /// <summary>
    /// Represents an update instructor profile data transfer object.
    /// </summary>
    public class UpdateInstructorProfileDTO : UpdateProfileDTO
    {
        public List<string>? Subjects { get; set; }
    }
}
