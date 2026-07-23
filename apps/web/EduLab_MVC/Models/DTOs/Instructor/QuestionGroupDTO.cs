using Newtonsoft.Json;

namespace EduLab_MVC.Models.DTOs.Instructor
{
    public class QuestionGroupDTO
    {
        [JsonProperty("courseId")]
        public int CourseId { get; set; }

        [JsonProperty("courseName")]
        public string CourseName { get; set; }

        [JsonProperty("courseIcon")]
        public string CourseIcon { get; set; }

        [JsonProperty("courseColor")]
        public string CourseColor { get; set; }

        [JsonProperty("unansweredCount")]
        public int UnansweredCount { get; set; }

        [JsonProperty("totalCount")]
        public int TotalCount { get; set; }

        [JsonProperty("questions")]
        public List<QuestionItemDTO> Questions { get; set; } = new();
    }

    public class QuestionItemDTO
    {
        [JsonProperty("id")]
        public int Id { get; set; }

        [JsonProperty("courseId")]
        public int CourseId { get; set; }

        [JsonProperty("studentName")]
        public string StudentName { get; set; }

        [JsonProperty("studentAvatar")]
        public string? StudentAvatar { get; set; }

        [JsonProperty("content")]
        public string Content { get; set; }

        [JsonProperty("createdAt")]
        public DateTime CreatedAt { get; set; }

        [JsonProperty("timeAgo")]
        public string TimeAgo { get; set; }

        [JsonProperty("lectureName")]
        public string LectureName { get; set; }

        [JsonProperty("isAnswered")]
        public bool IsAnswered { get; set; }

        [JsonProperty("repliesCount")]
        public int RepliesCount { get; set; }

        [JsonProperty("replies")]
        public List<ReplyItemDTO> Replies { get; set; } = new();
    }

    public class ReplyItemDTO
    {
        [JsonProperty("id")]
        public int Id { get; set; }

        [JsonProperty("studentName")]
        public string StudentName { get; set; }

        [JsonProperty("studentAvatar")]
        public string? StudentAvatar { get; set; }

        [JsonProperty("content")]
        public string Content { get; set; }

        [JsonProperty("createdAt")]
        public DateTime CreatedAt { get; set; }

        [JsonProperty("timeAgo")]
        public string TimeAgo { get; set; }

        [JsonProperty("isInstructorReply")]
        public bool IsInstructorReply { get; set; }
    }
}
