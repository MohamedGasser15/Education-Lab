using EduLab_Shared.DTOs.Enrollment;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.CourseProgress
{
    public class EnrollmentProgressDto
    {
        public EnrollmentDto Enrollment { get; set; }
        public CourseProgressSummaryDto ProgressSummary { get; set; }
        public List<CourseProgressDto> ProgressDetails { get; set; }
    }
}
