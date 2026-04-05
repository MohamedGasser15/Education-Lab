using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Instructor
{
    public class InstructorDTO
    {
        public string Id { get; set; }
        public string FullName { get; set; }
        public string Title { get; set; }
        public string ProfileImageUrl { get; set; }
        public double Rating { get; set; }
        public int TotalStudents { get; set; }
        public int TotalCourses { get; set; }
        public string Location { get; set; }
        public string About { get; set; }
        public List<string> InstructorSubjects { get; set; } = new List<string>();
        public string? GitHubUrl { get; set; }
        public string? LinkedInUrl { get; set; }
        public string? TwitterUrl { get; set; }
        public string? FacebookUrl { get; set; }
    }
}
