using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Notifications
{
    public class BulkNotificationResultDto
    {
        public int TotalUsers { get; set; }
        public int NotificationsSent { get; set; }
        public int EmailsSent { get; set; }
        public int FailedNotifications { get; set; }
        public int FailedEmails { get; set; }
        public List<string> Errors { get; set; } = new List<string>();
        public bool IsSuccess => !Errors.Any();
    }
}
