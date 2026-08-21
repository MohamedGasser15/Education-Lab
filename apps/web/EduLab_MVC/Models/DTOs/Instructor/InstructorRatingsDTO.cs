using Newtonsoft.Json;

namespace EduLab_MVC.Models.DTOs.Instructor
{
    /// <summary>
    /// Represents an instructor ratings data transfer object.
    /// </summary>
    public class InstructorRatingsDTO
    {
        [JsonProperty("stats")]
        public InstructorRatingsStatsDTO Stats { get; set; } = new();

        [JsonProperty("courses")]
        public List<InstructorRatingCourseDTO> Courses { get; set; } = new();

        [JsonProperty("reviews")]
        public List<InstructorRatingItemDTO> Reviews { get; set; } = new();
    }

    /// <summary>
    /// Represents an instructor ratings stats data transfer object.
    /// </summary>
    public class InstructorRatingsStatsDTO
    {
        [JsonProperty("totalReviews")]
        public int TotalReviews { get; set; }

        [JsonProperty("averageRating")]
        public double AverageRating { get; set; }

        [JsonProperty("thisMonthReviews")]
        public int ThisMonthReviews { get; set; }

        [JsonProperty("reviewedCourses")]
        public int ReviewedCourses { get; set; }

        [JsonProperty("distribution")]
        public Dictionary<int, int> Distribution { get; set; } = new()
        {
            { 1, 0 }, { 2, 0 }, { 3, 0 }, { 4, 0 }, { 5, 0 }
        };
    }

    /// <summary>
    /// Represents an instructor rating course data transfer object.
    /// </summary>
    public class InstructorRatingCourseDTO
    {
        [JsonProperty("courseId")]
        public int CourseId { get; set; }

        [JsonProperty("courseName")]
        public string CourseName { get; set; }
    }

    /// <summary>
    /// Represents an instructor rating item data transfer object.
    /// </summary>
    public class InstructorRatingItemDTO
    {
        [JsonProperty("id")]
        public int Id { get; set; }

        [JsonProperty("courseId")]
        public int CourseId { get; set; }

        [JsonProperty("courseName")]
        public string CourseName { get; set; }

        [JsonProperty("studentName")]
        public string StudentName { get; set; }

        [JsonProperty("studentAvatar")]
        public string? StudentAvatar { get; set; }

        [JsonProperty("rating")]
        public int Rating { get; set; }

        [JsonProperty("comment")]
        public string Comment { get; set; }

        [JsonProperty("createdAt")]
        public DateTime CreatedAt { get; set; }

        [JsonProperty("timeAgo")]
        public string TimeAgo { get; set; }
    }
}
