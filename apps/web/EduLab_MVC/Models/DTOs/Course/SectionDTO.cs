using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Course
{
    /// <summary>
    /// Represents a section data transfer object.
    /// </summary>
    public class SectionDTO
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public int Order { get; set; }
        public int CourseId { get; set; }
        public bool IsFreePreview { get; set; }
        public List<LectureDTO> Lectures { get; set; } = new();
    }
}
