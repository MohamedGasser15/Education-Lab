using System.ComponentModel.DataAnnotations;

namespace EduLab_Application.DTOs.LectureComment
{
    public class CreateLectureCommentDTO
    {
        public int LectureId { get; set; }

        [Required(ErrorMessage = "محتوى التعليق مطلوب")]
        [StringLength(1000, MinimumLength = 1, ErrorMessage = "التعليق يجب أن يكون بين 1 و 1000 حرف")]
        public string Content { get; set; }

        public int? ParentCommentId { get; set; }
    }
}
