using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    public class CartItem
    {
        public int Id { get; set; }
        public int CartId { get; set; }
        public int CourseId { get; set; }
        public int Quantity { get; set; } = 1;
        public DateTime AddedAt { get; set; } = DateTime.UtcNow;

        [ForeignKey("CartId")]
        public Cart Cart { get; set; }

        [ForeignKey("CourseId")]
        public Course Course { get; set; }

        [NotMapped]
        public decimal TotalPrice => Course.Price * Quantity;
    }
}
