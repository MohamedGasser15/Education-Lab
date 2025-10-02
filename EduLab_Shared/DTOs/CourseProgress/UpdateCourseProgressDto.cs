using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.CourseProgress
{
    public class UpdateCourseProgressDto
    {
        public int EnrollmentId { get; set; }
        public int LectureId { get; set; }
        public bool IsCompleted { get; set; }
    }
}
