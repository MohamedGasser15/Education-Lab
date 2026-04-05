using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    public class UserSession
    {
        [Key]
        public Guid Id { get; set; } = Guid.NewGuid();
        public string UserId { get; set; }
        public ApplicationUser User { get; set; } // Navigation property
        public string DeviceInfo { get; set; } // e.g., "Chrome on Windows"
        public string Location { get; set; } // e.g., "Cairo, Egypt"
        public string IPAddress { get; set; }
        public DateTime LoginTime { get; set; } = DateTime.UtcNow;
        public DateTime? LastActivity { get; set; }
        public DateTime? LogoutTime { get; set; }
        public bool IsActive { get; set; } = true;
        public string SessionToken { get; set; } // Optional: for JWT or session ID
    }
}
