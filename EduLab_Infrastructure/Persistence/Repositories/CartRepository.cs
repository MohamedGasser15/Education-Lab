using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    public class CartRepository : ICartRepository
    {
        private readonly ApplicationDbContext _context;

        public CartRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<Cart> GetCartByUserIdAsync(string userId)
        {
            return await _context.Carts
                .Include(c => c.CartItems)
                    .ThenInclude(ci => ci.Course)
                        .ThenInclude(c => c.Instructor)
                .FirstOrDefaultAsync(c => c.UserId == userId);
        }


        public async Task<Cart> CreateCartAsync(string userId)
        {
            var cart = new Cart { UserId = userId };
            _context.Carts.Add(cart);
            await _context.SaveChangesAsync();
            return cart;
        }

        public async Task<CartItem> AddItemToCartAsync(int cartId, int courseId, int quantity)
        {
            var cartItem = new CartItem
            {
                CartId = cartId,
                CourseId = courseId,
                Quantity = quantity
            };

            _context.CartItems.Add(cartItem);
            await _context.SaveChangesAsync();
            return cartItem;
        }

        public async Task<CartItem> UpdateCartItemQuantityAsync(int cartItemId, int quantity)
        {
            var cartItem = await _context.CartItems.FindAsync(cartItemId);
            if (cartItem != null)
            {
                cartItem.Quantity = quantity;
                cartItem.AddedAt = DateTime.UtcNow;
                await _context.SaveChangesAsync();
            }
            return cartItem;
        }

        public async Task<bool> RemoveItemFromCartAsync(int cartItemId)
        {
            var cartItem = await _context.CartItems.FindAsync(cartItemId);
            if (cartItem != null)
            {
                _context.CartItems.Remove(cartItem);
                await _context.SaveChangesAsync();
                return true;
            }
            return false;
        }

        public async Task<bool> ClearCartAsync(int cartId)
        {
            var cartItems = _context.CartItems.Where(ci => ci.CartId == cartId);
            _context.CartItems.RemoveRange(cartItems);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
