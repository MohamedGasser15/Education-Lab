using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    public enum ContentType
    {
        Video,
        Article,
        Quiz
    }

    public class Lecture
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string? VideoUrl { get; set; }
        public string? ArticleContent { get; set; }
        public int? QuizId { get; set; }
        public ContentType ContentType { get; set; }
        public int Duration { get; set; }
        public int Order { get; set; }
        public bool IsFreePreview { get; set; }

        // الإضافات الجديدة
        public string? Description { get; set; } // nullable description
        public List<LectureResource> Resources { get; set; } = new List<LectureResource>(); // nullable resources

        public int SectionId { get; set; }
        [ForeignKey("SectionId")]
        public Section Section { get; set; }
    }
}
