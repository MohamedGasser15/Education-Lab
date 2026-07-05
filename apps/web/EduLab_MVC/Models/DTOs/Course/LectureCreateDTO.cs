using Microsoft.AspNetCore.Http;

namespace EduLab_MVC.Models.DTOs.Course
{
    public class LectureCreateDTO
    {
        public string Title { get; set; }
        public string? Description { get; set; }
        public string ContentType { get; set; } = "video";
        public IFormFile? Video { get; set; }
        public string? ArticleContent { get; set; }
        public bool IsFreePreview { get; set; }
        public int SectionId { get; set; }
        public int Duration { get; set; }
    }
}
