using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Settings
{
    public class ActiveSessionDTO
    {
        public Guid Id { get; set; }
        public string DeviceInfo { get; set; }
        public string Location { get; set; }
        public DateTime LoginTime { get; set; }
        public bool IsCurrent { get; set; } // To mark the current session
    }
}
