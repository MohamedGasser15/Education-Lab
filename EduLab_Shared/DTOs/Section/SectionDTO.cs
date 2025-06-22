using EduLab_Shared.DTOs.Lecture;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Section
{
    public class SectionDTO
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public int Order { get; set; }
        public List<LectureDTO> Lectures { get; set; } = new();
    }
}