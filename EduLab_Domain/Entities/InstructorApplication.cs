using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    public class InstructorApplication
    {
        public int Id { get; set; }
        public string UserId { get; set; }
        public string Bio { get; set; }
        public string Experience { get; set; }
        public string Status { get; set; }
        public DateTime AppliedAt { get; set; }

        [ForeignKey("UserId")]
        public ApplicationUser User { get; set; }
    }
}
