using System.Collections.Generic;

namespace EduLab_MVC.Models.DTOs.Course
{
    public class PublishResultDTO
    {
        public bool Success { get; set; }
        public List<string> Errors { get; set; } = new();
    }
}
