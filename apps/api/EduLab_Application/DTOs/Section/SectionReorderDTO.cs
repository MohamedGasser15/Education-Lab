using System.Collections.Generic;

namespace EduLab_Application.DTOs.Section
{
    public class SectionReorderDTO
    {
        public int CourseId { get; set; }
        public List<int> SectionIds { get; set; }
    }
}
