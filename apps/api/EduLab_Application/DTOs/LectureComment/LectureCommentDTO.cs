namespace EduLab_Application.DTOs.LectureComment
{
    public class LectureCommentDTO
    {
        public int Id { get; set; }
        public int LectureId { get; set; }
        public string UserId { get; set; }
        public string UserName { get; set; }
        public string? UserProfileImage { get; set; }
        public string Content { get; set; }
        public int? ParentCommentId { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
        public bool IsInstructorReply { get; set; }
        public List<LectureCommentDTO> Replies { get; set; } = new();
    }
}
