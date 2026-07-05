using System.Collections.Generic;

namespace EduLab_Application.DTOs.Lecture
{
    public class LectureReorderDTO
    {
        public int SectionId { get; set; }
        public List<int> LectureIds { get; set; }
    }
}
