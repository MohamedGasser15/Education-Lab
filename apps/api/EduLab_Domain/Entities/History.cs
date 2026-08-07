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
        public int Id { get; set; }

        public string UserId { get; set; }

        [ForeignKey("UserId")]
        public ApplicationUser User { get; set; }

        public string Operation { get; set; } = string.Empty;

        public string? MessageKey { get; set; }

        public string? Parameters { get; set; }

        public int? OperationKeyId { get; set; }

        [ForeignKey("OperationKeyId")]
        public OperationKey OperationKey { get; set; }

        public DateOnly Date { get; set; } = DateOnly.FromDateTime(DateTime.Now);

        public TimeOnly Time { get; set; } = TimeOnly.FromDateTime(DateTime.Now);
    }
}
