using EduLab_Shared.DTOs.Cart;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface ICartService
    {
        Task<CartDto> GetUserCartAsync(string userId);
        Task<CartDto> GetGuestCartAsync();
        Task<CartDto> AddItemToCartAsync(string userId, AddToCartRequest request);
        Task<CartDto> UpdateCartItemAsync(string userId, int cartItemId, UpdateCartItemRequest request);
        Task<CartDto> RemoveItemFromCartAsync(string userId, int cartItemId);
        Task<bool> ClearCartAsync(string userId);
        Task<bool> MigrateGuestCartToUserAsync(string userId);
    }
}
