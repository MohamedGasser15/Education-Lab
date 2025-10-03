namespace EduLab_MVC.Models.DTOs.Rating
{
    public class CourseRatingSummaryDto
    {
        public int CourseId { get; set; }
        public double AverageRating { get; set; }
        public int TotalRatings { get; set; }
        public System.Collections.Generic.Dictionary<int, int> RatingDistribution { get; set; }
    }
}
