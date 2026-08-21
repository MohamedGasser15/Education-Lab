using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    /// <summary>
    /// Represents an attached resource file for a lecture
    /// </summary>
    public class LectureResource
    {
        public int Id { get; set; }
        public string FileName { get; set; }
        public string? FileUrl { get; set; }
        public string FileType { get; set; } 
        public long FileSize { get; set; }
        public int LectureId { get; set; }

        [ForeignKey("LectureId")]
        public Lecture Lecture { get; set; }
    }
}
