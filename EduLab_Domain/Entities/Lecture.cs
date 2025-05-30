using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    public class Lecture
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string VideoUrl { get; set; }
        public TimeSpan Duration { get; set; } // it is for the video time
        public int SectionId { get; set; } // it is to link the lectures ( the videos) to specific sections 
        [ForeignKey("SectionId")]
        public Section Section { get; set; }
    }
}
