using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    public enum Coursestatus
    {
        Pending,
        Rejected,   
        Approved   
    }
    public class Course
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string ShortDescription { get; set; }
        public decimal Price { get; set; }
        public Coursestatus Status { get; set; } = Coursestatus.Pending;
        public decimal? Discount { get; set; }
        public string? ThumbnailUrl { get; set; }
        public DateTime CreatedAt { get; set; }
        public string InstructorId { get; set; }
        [ForeignKey("InstructorId")]
        public ApplicationUser Instructor { get; set; }
        public ICollection<Section> Sections { get; set; }
        public int CategoryId { get; set; }
        [ForeignKey("CategoryId")]
        public Category Category { get; set; }
        public string Level { get; set; }
        public string Language { get; set; }
        public int Duration { get; set; }
        public bool HasCertificate { get; set; }
        public List<string> Requirements { get; set; }
        public List<string> Learnings { get; set; }
        public string TargetAudience { get; set; }
        public ICollection<Rating> Ratings { get; set; } = new List<Rating>();

        [NotMapped]
        public double AverageRating { get; set; }

        [NotMapped]
        public int RatingsCount { get; set; }
    }
}
