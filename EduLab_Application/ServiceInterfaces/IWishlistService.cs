using EduLab_Shared.DTOs.Wishlist;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IWishlistService
    {
        Task<List<WishlistItemDto>> GetUserWishlistAsync(string userId);
        Task<WishlistResponse> AddToWishlistAsync(string userId, int courseId);
        Task<WishlistResponse> RemoveFromWishlistAsync(string userId, int courseId);
        Task<bool> IsCourseInWishlistAsync(string userId, int courseId);
        Task<int> GetWishlistCountAsync(string userId);
    }
}