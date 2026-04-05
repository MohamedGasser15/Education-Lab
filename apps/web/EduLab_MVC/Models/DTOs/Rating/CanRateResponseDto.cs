namespace EduLab_MVC.Models.DTOs.Rating
{
    public class CanRateResponseDto
    {
        public bool EligibleToRate { get; set; } 
        public bool HasRated { get; set; }
        public bool CanRate { get; set; }
    }
}
