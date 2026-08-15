namespace EduLab_Application.DTOs.Dashboard
{
    /// <summary>
    /// Public site statistics shown on the marketing pages
    /// </summary>
    public class SiteStatsDto
    {
        public int StudentsCount { get; set; }
        public int CoursesCount { get; set; }
        public int InstructorsCount { get; set; }
        public double SatisfactionPercent { get; set; }
    }
}
