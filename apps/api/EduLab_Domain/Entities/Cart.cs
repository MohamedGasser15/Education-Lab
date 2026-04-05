using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    public class Cart
    {
        public int Id { get; set; }
        public string? UserId { get; set; }
        public string? GuestId { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? UpdatedAt { get; set; }

        [ForeignKey("UserId")]
        public ApplicationUser User { get; set; }
        public ICollection<CartItem> CartItems { get; set; } = new List<CartItem>();

        public decimal TotalPrice => CartItems.Sum(item => item.TotalPrice);
        [NotMapped]
        public bool IsGuestCart => !string.IsNullOrEmpty(GuestId) && string.IsNullOrEmpty(UserId);
    }
}
