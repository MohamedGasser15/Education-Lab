using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Notification
{
    public class NotificationFilterDto
    {
        public NotificationTypeDto? Type { get; set; }
        public NotificationStatusDto? Status { get; set; }
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 10;
    }
}
