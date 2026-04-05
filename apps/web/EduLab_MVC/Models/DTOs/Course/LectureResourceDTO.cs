using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Course
{
    public class LectureResourceDTO
    {
        public int Id { get; set; }
        public string FileName { get; set; }
        public string? FileUrl { get; set; }
        public string FileType { get; set; }
        public long FileSize { get; set; }
        public int LectureId { get; set; }

        public IFormFile? File { get; set; }
    }
}
