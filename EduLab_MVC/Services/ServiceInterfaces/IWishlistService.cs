using EduLab_MVC.Models.DTOs.Wishlist;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    public interface IWishlistService
    {
        Task<List<WishlistItemDto>> GetUserWishlistAsync();
        Task<WishlistResponse> AddToWishlistAsync(int courseId);
        Task<WishlistResponse> RemoveFromWishlistAsync(int courseId);
        Task<bool> IsCourseInWishlistAsync(int courseId);
        Task<int> GetWishlistCountAsync();
    }
}