using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Instructor
{
    public class AdminInstructorApplicationDto : InstructorApplicationResponseDto
    {
        public string UserId { get; set; }
        public string Skills { get; set; }
        public string? ReviewedBy { get; set; }
        public DateTime? ReviewedDate { get; set; }
        public string? ProfileImageUrl { get; set; } = null;
        public List<string> SkillsList => !string.IsNullOrEmpty(Skills) ?
            Skills.Split(',').ToList() : new List<string>();
    }
}
