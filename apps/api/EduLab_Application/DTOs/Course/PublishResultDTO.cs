using System.Collections.Generic;

namespace EduLab_Application.DTOs.Course
{
    public class PublishResultDTO
    {
        public bool Success { get; set; }
        public List<string> Errors { get; set; } = new();
    }
}
