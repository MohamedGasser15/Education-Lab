using EduLab_Shared.DTOs.Section;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Course
{
    public class CourseDTO
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string ShortDescription { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public decimal? Discount { get; set; }
        public string? ThumbnailUrl { get; set; }
        public DateTime CreatedAt { get; set; }
        public string InstructorId { get; set; }
        public string InstructorName { get; set; }
        public int CategoryId { get; set; }
        public string CategoryName { get; set; }
        public string Level { get; set; }
        public string Language { get; set; }
        public int Duration { get; set; }
        public int TotalLectures { get; set; }
        public bool HasCertificate { get; set; }
        public List<string> Requirements { get; set; } = new();
        public List<string> Learnings { get; set; } = new();
        public string TargetAudience { get; set; }
        public List<SectionDTO> Sections { get; set; } = new();
    }
}
