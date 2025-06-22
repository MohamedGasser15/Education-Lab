using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Lecture
{
    public class LectureDTO
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string? VideoUrl { get; set; }
        public IFormFile Video { get; set; }
        public string ArticleContent { get; set; }
        public int? QuizId { get; set; }
        public string ContentType { get; set; }
        public int Duration { get; set; }
        public int Order { get; set; }
        public bool IsFreePreview { get; set; }
    }
}
