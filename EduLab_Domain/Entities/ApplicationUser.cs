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

        public string? Title { get; set; }
        public string? Location { get; set; }
        public string? About { get; set; }
        public string? ProfileImageUrl { get; set; }

        public string? GitHubUrl { get; set; }
        public string? LinkedInUrl { get; set; }
        public string? TwitterUrl { get; set; }
        public string? FacebookUrl { get; set; }

        [NotMapped]
        public string Role { get; set; }
        [NotMapped]
        public bool IsLocked => LockoutEnd.HasValue && LockoutEnd.Value > DateTimeOffset.UtcNow;
        public DateTime CreatedAt { get; set; }
        public ICollection<Course> CoursesCreated { get; set; }
        public ICollection<Enrollment> Enrollments { get; set; }
    }
}
