using Microsoft.AspNetCore.Http;

namespace EduLab_MVC.Models.DTOs.Course
{
    public class CourseDraftDTO
    {
        public string Title { get; set; }
        public string ShortDescription { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public decimal? Discount { get; set; }
        public int CategoryId { get; set; }
        public string Level { get; set; } = "beginner";
        public string Language { get; set; } = "ar";
        public bool HasCertificate { get; set; }
        public string TargetAudience { get; set; }
        public List<string> Requirements { get; set; } = new();
        public List<string> Learnings { get; set; } = new();
        public IFormFile? Image { get; set; }
    }
}
