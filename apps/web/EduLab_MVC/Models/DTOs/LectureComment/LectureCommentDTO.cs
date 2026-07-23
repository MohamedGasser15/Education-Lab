using Newtonsoft.Json;

namespace EduLab_MVC.Models.DTOs.LectureComment
{
    public class LectureCommentDTO
    {
        [JsonProperty("id")]
        public int Id { get; set; }

        [JsonProperty("lectureId")]
        public int LectureId { get; set; }

        [JsonProperty("userId")]
        public string UserId { get; set; }

        [JsonProperty("userName")]
        public string UserName { get; set; }

        [JsonProperty("userProfileImage")]
        public string? UserProfileImage { get; set; }

        [JsonProperty("content")]
        public string Content { get; set; }

        [JsonProperty("parentCommentId")]
        public int? ParentCommentId { get; set; }

        [JsonProperty("createdAt")]
        public DateTime CreatedAt { get; set; }

        [JsonProperty("updatedAt")]
        public DateTime? UpdatedAt { get; set; }

        [JsonProperty("timeAgo")]
        public string? TimeAgo { get; set; }

        [JsonProperty("isInstructorReply")]
        public bool IsInstructorReply { get; set; }

        [JsonProperty("replies")]
        public List<LectureCommentDTO> Replies { get; set; } = new();
    }
}
