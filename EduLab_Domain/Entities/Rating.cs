// EduLab_Domain/Entities/Rating.cs
using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace EduLab_Domain.Entities
{
    public class Rating
    {
        public int Id { get; set; }

        [ForeignKey("Course")]
        public int CourseId { get; set; }
        public Course Course { get; set; }

        [ForeignKey("User")]
        public string UserId { get; set; }
        public ApplicationUser User { get; set; }

        public int Value { get; set; } // من 1 إلى 5
        public string? Comment { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? UpdatedAt { get; set; }
    }
}