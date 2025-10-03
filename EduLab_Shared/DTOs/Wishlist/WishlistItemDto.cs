using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Wishlist
{
    public class WishlistItemDto
    {
        public int Id { get; set; }
        public int CourseId { get; set; }
        public string CourseTitle { get; set; }
        public string CourseShortDescription { get; set; }
        public decimal CoursePrice { get; set; }
        public decimal? CourseDiscount { get; set; }
        public string ThumbnailUrl { get; set; }
        public string InstructorName { get; set; }
        public DateTime AddedAt { get; set; }
        public decimal FinalPrice => CourseDiscount > 0 ?
            CoursePrice - (CoursePrice * (CourseDiscount.Value / 100)) : CoursePrice;
        public double AverageRating { get; set; }
        public int TotalRatings { get; set; }
        public Dictionary<int, int> RatingDistribution { get; set; } = new Dictionary<int, int>();
    }
}
