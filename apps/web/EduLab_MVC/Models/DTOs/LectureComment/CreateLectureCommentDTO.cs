using System.ComponentModel.DataAnnotations;

namespace EduLab_MVC.Models.DTOs.LectureComment
{
    /// <summary>
    /// Represents a create lecture comment data transfer object.
    /// </summary>
    public class CreateLectureCommentDTO
    {
        [Required]
        public int LectureId { get; set; }

        [Required(ErrorMessage = "محتوى التعليق مطلوب")]
        [StringLength(1000, MinimumLength = 1, ErrorMessage = "التعليق يجب أن يكون بين 1 و 1000 حرف")]
        public string Content { get; set; }

        public int? ParentCommentId { get; set; }
    }
}
