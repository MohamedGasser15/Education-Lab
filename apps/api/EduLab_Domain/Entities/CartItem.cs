using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    /// <summary>
    /// Represents a course added to a shopping cart
    /// </summary>
    public class CartItem
    {
        public int Id { get; set; }
        public int CartId { get; set; }
        public int CourseId { get; set; }
        public DateTime AddedAt { get; set; } = DateTime.UtcNow;

        [ForeignKey("CartId")]
        public Cart Cart { get; set; }

        [ForeignKey("CourseId")]
        public Course Course { get; set; }

        [NotMapped]
        public decimal TotalPrice => Math.Max(0, Course.Price - (Course.Price * (Course.Discount ?? 0) / 100)); // discounted price, clamped at zero
    }
}
