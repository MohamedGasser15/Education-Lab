using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;

namespace EduLab_Domain.Entities
{
    /// <summary>
    /// Represents a shopping cart, which may belong to a registered user or a guest
    /// </summary>
    public class Cart
    {
        public int Id { get; set; }
        public string? UserId { get; set; }
        public string? GuestId { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? UpdatedAt { get; set; }

        [ForeignKey("UserId")]
        public ApplicationUser? User { get; set; }
        public ICollection<CartItem> CartItems { get; set; } = new List<CartItem>();

        public int? AppliedCouponId { get; set; }

        [ForeignKey("AppliedCouponId")]
        public virtual Coupon? AppliedCoupon { get; set; }

        [NotMapped]
        public decimal Subtotal => CartItems.Sum(item => item.TotalPrice);

        [NotMapped]
        public decimal DiscountAmount => AppliedCoupon != null && AppliedCoupon.IsValidNow()
            ? AppliedCoupon.CalculateDiscount(Subtotal)
            : 0;

        [NotMapped]
        public decimal TotalPrice => Math.Max(0, Subtotal - DiscountAmount);

        [NotMapped]
        public bool IsGuestCart => !string.IsNullOrEmpty(GuestId) && string.IsNullOrEmpty(UserId); // true when the cart belongs to a guest only
    }
}
