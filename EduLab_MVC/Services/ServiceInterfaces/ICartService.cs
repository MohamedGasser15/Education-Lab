using EduLab_MVC.Models.DTOs.Cart;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    public interface ICartService
    {
        #region Public Methods
            Task<CartDto> GetUserCartAsync(CancellationToken cancellationToken = default);
            Task<bool> MigrateGuestCartAsync(CancellationToken cancellationToken = default);
            Task<CartDto> AddItemToCartAsync(AddToCartRequest request, CancellationToken cancellationToken = default);
            Task<CartDto> UpdateCartItemAsync(int cartItemId, UpdateCartItemRequest request, CancellationToken cancellationToken = default);
            Task<CartDto> RemoveItemFromCartAsync(int cartItemId, CancellationToken cancellationToken = default);
            Task<bool> ClearCartAsync(CancellationToken cancellationToken = default);
            Task<CartSummaryDto> GetCartSummaryAsync(CancellationToken cancellationToken = default);
        #endregion
    }
}
