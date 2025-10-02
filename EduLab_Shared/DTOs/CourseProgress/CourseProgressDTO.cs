using EduLab_Shared.DTOs.Enrollment;
using System;

namespace EduLab_Shared.DTOs.CourseProgress
{
    public class CourseProgressDto
    {
        public int Id { get; set; }
        public int EnrollmentId { get; set; }
        public int LectureId { get; set; }
        public bool IsCompleted { get; set; }
        public string LectureTitle { get; set; }
        public int LectureDuration { get; set; }
        public int LectureOrder { get; set; }
        public string SectionTitle { get; set; }
    }
}