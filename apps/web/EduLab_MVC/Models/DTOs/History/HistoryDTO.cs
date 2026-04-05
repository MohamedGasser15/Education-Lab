using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.History
{
    public class HistoryDTO
    {
        public int Id { get; set; }

        public string UserName { get; set; } = string.Empty;
        public string? ProfileImageUrl { get; set; }
        public string Operation { get; set; } = string.Empty;

        public DateOnly Date { get; set; }

        public TimeOnly Time { get; set; }
    }
}
