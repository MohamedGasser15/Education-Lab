using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Cart
{
    public class CartItemDto
    {
        public int Id { get; set; }
        public int CourseId { get; set; }
        public string CourseTitle { get; set; }
        public decimal CoursePrice { get; set; }
        public string ThumbnailUrl { get; set; }
        public string InstructorName { get; set; }
        public decimal TotalPrice { get; set; }
    }
}
