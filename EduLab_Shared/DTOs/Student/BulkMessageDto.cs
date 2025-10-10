using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Student
{
    public class BulkMessageDto
    {
        public List<string> StudentIds { get; set; }
        public string Subject { get; set; }
        public string Message { get; set; }
        public bool SendEmail { get; set; } = true;
        public bool SendNotification { get; set; } = true;
    }
}
