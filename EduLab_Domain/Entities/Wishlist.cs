using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace EduLab_Domain.Entities
{
    public class Wishlist
    {
        public int Id { get; set; }

        public string UserId { get; set; }
        [ForeignKey("UserId")]
        public ApplicationUser User { get; set; }

        public int CourseId { get; set; }
        [ForeignKey("CourseId")]
        public Course Course { get; set; }

        public DateTime AddedAt { get; set; } = DateTime.UtcNow;
    }
}