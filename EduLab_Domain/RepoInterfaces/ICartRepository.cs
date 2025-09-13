using EduLab_Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    public interface ICartRepository
    {
        Task<Cart> GetCartByUserIdAsync(string userId);
        Task<Cart> CreateCartAsync(string userId);
        Task<CartItem> AddItemToCartAsync(int cartId, int courseId, int quantity);
        Task<CartItem> UpdateCartItemQuantityAsync(int cartItemId, int quantity);
        Task<bool> RemoveItemFromCartAsync(int cartItemId);
        Task<bool> ClearCartAsync(int cartId);
    }
}
