using System;
using System.Collections.Generic;

namespace EduLab_Application.DTOs.Instructor
{
    public class InstructorCommentsGroupDTO
    {
        public int CourseId { get; set; }
        public string CourseName { get; set; }
        public string CourseIcon { get; set; }
        public string CourseColor { get; set; }
        public int TotalCount { get; set; }
        public int UnansweredCount { get; set; }
        public List<InstructorCommentDTO> Questions { get; set; } = new();
    }

    public class InstructorCommentDTO
    {
        public int CourseId { get; set; }
        public int Id { get; set; }
        public string StudentName { get; set; }
        public string? StudentAvatar { get; set; }
        public string Content { get; set; }
        public DateTime CreatedAt { get; set; }
        public string TimeAgo { get; set; }
        public string LectureName { get; set; }
        public bool IsAnswered { get; set; }
        public int RepliesCount { get; set; }
        public List<InstructorCommentReplyDTO> Replies { get; set; } = new();
    }

    public class InstructorCommentReplyDTO
    {
        public int Id { get; set; }
        public string StudentName { get; set; }
        public string? StudentAvatar { get; set; }
        public string Content { get; set; }
        public DateTime CreatedAt { get; set; }
        public string TimeAgo { get; set; }
        public bool IsInstructorReply { get; set; }
    }
}
