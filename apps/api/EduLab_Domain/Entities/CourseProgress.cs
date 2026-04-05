using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    public class CourseProgress
    {
        public int Id { get; set; }
        public int EnrollmentId { get; set; }
        public int LectureId { get; set; }
        public bool IsCompleted { get; set; }

        [ForeignKey("EnrollmentId")]
        public Enrollment Enrollment { get; set; }
        [ForeignKey("LectureId")]
        public Lecture Lecture { get; set; }
    }
}
