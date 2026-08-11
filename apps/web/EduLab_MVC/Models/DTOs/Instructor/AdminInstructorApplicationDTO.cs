using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Instructor
{
    public class AdminInstructorApplicationDto : InstructorApplicationResponseDto
    {
        public string UserId { get; set; }
        public string Skills { get; set; }
        public string? ReviewedBy { get; set; }
        public DateTime? ReviewedDate { get; set; }
        public string? ProfileImageUrl { get; set; } = null;
        public string? Bio { get; set; }
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
