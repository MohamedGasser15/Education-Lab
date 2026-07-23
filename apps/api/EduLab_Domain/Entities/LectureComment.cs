using System.ComponentModel.DataAnnotations.Schema;

namespace EduLab_Domain.Entities
{
    public class LectureComment
    {
        public int Id { get; set; }
        public int LectureId { get; set; }
        public string UserId { get; set; }
        public string Content { get; set; }
        public int? ParentCommentId { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? UpdatedAt { get; set; }

        [ForeignKey("LectureId")]
        public Lecture Lecture { get; set; }
        [ForeignKey("UserId")]
        public ApplicationUser User { get; set; }
        [ForeignKey("ParentCommentId")]
        public LectureComment ParentComment { get; set; }
        public ICollection<LectureComment> Replies { get; set; } = new List<LectureComment>();
    }
}
