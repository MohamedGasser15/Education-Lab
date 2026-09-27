using System;
using System.Collections.Generic;
using System.Linq;

namespace EduLab_MVC.Models.DTOs.Cart
{
    /// <summary>
    /// Represents a cart data transfer object.
    /// </summary>
    public class CartDto
    {
        public int Id { get; set; }
        public string? UserId { get; set; }
        public List<CartItemDto> Items { get; set; } = new List<CartItemDto>();
        public decimal Subtotal { get; set; }
        public decimal DiscountAmount { get; set; }
        public decimal TotalPrice { get; set; }
        public string? AppliedCouponCode { get; set; }
        public int? AppliedCouponId { get; set; }
        public int TotalItems => Items?.Sum(item => item.Quantity) ?? 0;
        public bool HasCoupon => !string.IsNullOrEmpty(AppliedCouponCode) && DiscountAmount > 0;
    }
}
