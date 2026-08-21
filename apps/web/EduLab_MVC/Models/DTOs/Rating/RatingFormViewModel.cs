namespace EduLab_MVC.Models.DTOs.Rating
{
    /// <summary>
    /// View model that supplies data for the rating form view.
    /// </summary>
    public class RatingFormViewModel
    {
        public int CourseId { get; set; }
        public RatingDto ExistingRating { get; set; }
    }
}
