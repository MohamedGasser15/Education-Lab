namespace EduLab_MVC.Models.DTOs.Rating
{
    /// <summary>
    /// Represents an update rating data transfer object.
    /// </summary>
    public class UpdateRatingDto
    {
        public int CourseId { get; set; }
        public int Value { get; set; }
        public string Comment { get; set; }
    }
}
