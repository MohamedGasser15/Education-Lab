using System;
using System.Collections.Generic;
using System.Linq;

namespace EduLab_Application.DTOs.Cart
{
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
        public int TotalItems => Items?.Count ?? 0;
    }
}
