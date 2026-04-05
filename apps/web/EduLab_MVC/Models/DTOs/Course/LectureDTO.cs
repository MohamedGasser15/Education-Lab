using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Course
{
    public class LectureDTO
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string? VideoUrl { get; set; }
        public IFormFile? Video { get; set; }
        public string? ArticleContent { get; set; }
        public int? QuizId { get; set; }
        public string ContentType { get; set; }
        public int Duration { get; set; }
        public int Order { get; set; }
        public bool IsFreePreview { get; set; }

        // الإضافات الجديدة
        public string? Description { get; set; }
        public List<LectureResourceDTO> Resources { get; set; } = new List<LectureResourceDTO>();
        public List<IFormFile>? ResourceFiles { get; set; }
    }
}
