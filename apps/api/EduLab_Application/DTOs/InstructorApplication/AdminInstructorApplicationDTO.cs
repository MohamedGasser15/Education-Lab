using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.DTOs.InstructorApplication
{
    /// <summary>
    /// Data transfer object for admin view of instructor applications
    /// </summary>
    public class AdminInstructorApplicationDto : InstructorApplicationResponseDto
    {
        /// <summary>
        /// Gets or sets the user identifier
        /// </summary>
        public string UserId { get; set; }

        /// <summary>
        /// Gets or sets the skills of the applicant
        /// </summary>
        public string Skills { get; set; }

        /// <summary>
        /// Gets or sets the profile image URL of the applicant
        /// </summary>
        public string? ProfileImageUrl { get; set; } = null;

        /// <summary>
        /// Gets or sets the bio of the applicant (from the user profile)
        /// </summary>
        public string? Bio { get; set; }

        /// <summary>
        /// Gets or sets the user who reviewed the application
        /// </summary>
        public string? ReviewedBy { get; set; }

        /// <summary>
        /// Gets or sets the review date
        /// </summary>
        public DateTime? ReviewedDate { get; set; }

        /// <summary>
        /// Gets the list of skills
        /// </summary>
        public List<string> SkillsList => ParseSkills(Skills);

        private static List<string> ParseSkills(string raw)
        {
            if (string.IsNullOrEmpty(raw)) return new List<string>();

            var trimmed = raw.Trim();
            if (trimmed.StartsWith("["))
            {
                try
                {
                    var list = System.Text.Json.JsonSerializer.Deserialize<List<string>>(trimmed);
                    if (list != null)
                        return list.Select(s => s.Trim()).Where(s => s.Length > 0).ToList();
                }
                catch { }
            }

            return trimmed.Split(',')
                .Select(s => s.Trim().Trim('"', '[', ']'))
                .Where(s => s.Length > 0)
                .ToList();
        }
    }
}
