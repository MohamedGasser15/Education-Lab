namespace EduLab_MVC.Models.DTOs.Rating
{
    public class UpdateRatingDto
    {
        public int CourseId { get; set; }
        public int Value { get; set; }
        public string Comment { get; set; }
    }
}
