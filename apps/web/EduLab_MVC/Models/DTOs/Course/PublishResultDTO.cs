using System.Collections.Generic;

namespace EduLab_MVC.Models.DTOs.Course
{
    /// <summary>
    /// Represents a publish result data transfer object.
    /// </summary>
    public class PublishResultDTO
    {
        public bool Success { get; set; }
        public List<string> Errors { get; set; } = new();
    }
}
