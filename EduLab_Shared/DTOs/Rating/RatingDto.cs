using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Rating
{
    public class RatingDto
    {
        public int Id { get; set; }
        public int CourseId { get; set; }
        public string UserId { get; set; }
        public string UserName { get; set; }
        public string? UserProfileImage { get; set; }
        public int Value { get; set; }
        public string? Comment { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
    }
}
