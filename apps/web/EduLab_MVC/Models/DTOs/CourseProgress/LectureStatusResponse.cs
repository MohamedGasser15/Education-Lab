using Newtonsoft.Json;

namespace EduLab_MVC.Models.DTOs.CourseProgress
{
    public class LectureStatusResponse
    {
        [JsonProperty("success")]
        public bool Success { get; set; }

        [JsonProperty("data")]
        public bool IsCompleted { get; set; }

        [JsonProperty("message")]
        public string Message { get; set; }
    }
}
