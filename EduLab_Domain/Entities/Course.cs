using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    public class Course
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public string ThumbnailUrl { get; set; } // it is the photo of the course that appear in the primary page or course details
        public DateTime CreatedAt { get; set; }
        public string InstructorId { get; set; }
        [ForeignKey("InstructorId")]
        public ApplicationUser Instructor { get; set; }
        public ICollection<Section> Sections { get; set; }
        public ICollection<Enrollment> Enrollments { get; set; }
        public ICollection<Review> Reviews { get; set; }
    }
}
