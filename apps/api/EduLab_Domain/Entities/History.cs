using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    public class History
    {
        // Unique identifier for the history record
        public int Id { get; set; }

        // Foreign key to the user who performed the operation
        public string UserId { get; set; }

        [ForeignKey("UserId")]
        public ApplicationUser User { get; set; }

        // operation performed by the user
        public string Operation { get; set; } = string.Empty;

        // date when the operation was performed
        public DateOnly Date { get; set; } = DateOnly.FromDateTime(DateTime.Now);

        // time when the operation was performed
        public TimeOnly Time { get; set; } = TimeOnly.FromDateTime(DateTime.Now);
    }
}
