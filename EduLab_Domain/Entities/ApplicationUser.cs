using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    public class ApplicationUser : IdentityUser
    {
        public string FullName { get; set; }
        [NotMapped]
        public string Role { get; set; }
        [NotMapped]
        public bool IsLocked => LockoutEnd.HasValue && LockoutEnd.Value > DateTimeOffset.UtcNow;
        public DateTime CreatedAt { get; set; }
        public ICollection<Course> CoursesCreated { get; set; }
        public ICollection<Enrollment> Enrollments { get; set; }
    }
}
