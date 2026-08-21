namespace EduLab_MVC.Models.DTOs.Rating
{
    /// <summary>
    /// Represents a can rate response data transfer object.
    /// </summary>
    public class CanRateResponseDto
    {
        public bool EligibleToRate { get; set; } 
        public bool HasRated { get; set; }
        public bool CanRate { get; set; }
    }
}
