using EduLab_MVC.Models.DTOs.Wishlist;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    public interface IWishlistService
    {
        Task<List<WishlistItemDto>> GetUserWishlistAsync(CancellationToken cancellationToken = default);

        Task<WishlistResponse> AddToWishlistAsync(int courseId, CancellationToken cancellationToken = default);
        Task<WishlistResponse> RemoveFromWishlistAsync(int courseId, CancellationToken cancellationToken = default);
        Task<bool> IsCourseInWishlistAsync(int courseId, CancellationToken cancellationToken = default);
        Task<int> GetWishlistCountAsync(CancellationToken cancellationToken = default);
    }
}