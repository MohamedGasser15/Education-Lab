using EduLab_MVC.Models.DTOs.Cart;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    public interface ICartService
    {
        Task<CartDto> GetUserCartAsync();
        Task<CartDto> AddItemToCartAsync(AddToCartRequest request);
        Task<CartDto> UpdateCartItemAsync(int cartItemId, UpdateCartItemRequest request);
        Task<CartDto> RemoveItemFromCartAsync(int cartItemId);
        Task<bool> ClearCartAsync();
    }
}
