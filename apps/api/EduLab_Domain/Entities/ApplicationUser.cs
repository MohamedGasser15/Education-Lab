using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Http;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Collections.Generic;

namespace EduLab_Domain.Entities
{
    /// <summary>
    /// Represents an application user in the system
    /// </summary>
    public class ApplicationUser : IdentityUser
    {
        /// <summary>
        /// Gets or sets the full name of the user
        /// </summary>
        public string FullName { get; set; }

        /// <summary>
        /// Gets or sets the title of the user
        /// </summary>
        public string? Title { get; set; }

        /// <summary>
        /// Gets or sets the location of the user
        /// </summary>
        public string? Location { get; set; }

        /// <summary>
        /// Gets or sets the about/bio of the user
        /// </summary>
        public string? About { get; set; }

        /// <summary>
        /// Gets or sets the Postal Code of the user
        /// </summary>
        public string? PostalCode { get; set; } 

        /// <summary>
        /// Gets or sets the profile image URL of the user
        /// </summary>
        public string? ProfileImageUrl { get; set; }

        /// <summary>
        /// Gets or sets the GitHub URL of the user
        /// </summary>
        public string? GitHubUrl { get; set; }

        /// <summary>
        /// Gets or sets the LinkedIn URL of the user
        /// </summary>
        public string? LinkedInUrl { get; set; }

        /// <summary>
        /// Gets or sets the Twitter URL of the user
        /// </summary>
        public string? TwitterUrl { get; set; }

        /// <summary>
        /// Gets or sets the Facebook URL of the user
        /// </summary>
        public string? FacebookUrl { get; set; }

        /// <summary>
        /// Gets or sets the list of subjects/tags for the user
        /// </summary>
        public List<string> Subjects { get; set; } = new List<string>();

        /// <summary>
        /// Gets or sets the role of the user (not mapped to database)
        /// </summary>
        [NotMapped]
        public string Role { get; set; }

        /// <summary>
        /// Gets a value indicating whether the user is locked out
        /// </summary>
        [NotMapped]
        public bool IsLocked => LockoutEnd.HasValue && LockoutEnd.Value > DateTimeOffset.UtcNow;

        /// <summary>
        /// Gets or sets the creation date of the user
        /// </summary>
        public DateTime CreatedAt { get; set; }

        /// <summary>
        /// Gets or sets the courses created by the user
        /// </summary>
        public ICollection<Course> CoursesCreated { get; set; }

        /// <summary>
        /// Gets or sets the enrollments of the user
        /// </summary>
        public ICollection<Enrollment> Enrollments { get; set; }

        /// <summary>
        /// Gets or sets the certificates of the user
        /// </summary>
        public ICollection<Certificate> Certificates { get; set; }
    }
}