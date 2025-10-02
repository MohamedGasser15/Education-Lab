using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.CourseProgress
{
    public class CourseProgressSummaryDto
    {
        public int EnrollmentId { get; set; }
        public int CourseId { get; set; }
        public string CourseTitle { get; set; }
        public int TotalLectures { get; set; }
        public int CompletedLectures { get; set; }
        public decimal ProgressPercentage { get; set; }
        public int TotalDuration { get; set; }
        public int WatchedDuration { get; set; }
    }
}
