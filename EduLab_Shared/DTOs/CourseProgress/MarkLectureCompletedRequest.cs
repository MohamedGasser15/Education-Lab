using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.CourseProgress
{
    public class MarkLectureCompletedRequest
    {
        public int CourseId { get; set; }
        public int LectureId { get; set; }
        public double WatchedDuration { get; set; }
        public double TotalDuration { get; set; }
    }
}
