using EduLab_Domain.Entities;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    public interface IWishlistRepository : IRepository<Wishlist>
    {
        Task<List<Wishlist>> GetUserWishlistAsync(string userId, CancellationToken cancellationToken = default);
        Task<Wishlist> GetWishlistItemAsync(string userId, int courseId, CancellationToken cancellationToken = default);
        Task<bool> IsCourseInWishlistAsync(string userId, int courseId, CancellationToken cancellationToken = default);
        Task<int> GetWishlistCountAsync(string userId, CancellationToken cancellationToken = default);
    }
}