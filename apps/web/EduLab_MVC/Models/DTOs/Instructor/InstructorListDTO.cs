using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Instructor
{
    public class InstructorListDTO
    {
        public List<InstructorDTO> Instructors { get; set; }
        public int TotalCount { get; set; }
    }
}
