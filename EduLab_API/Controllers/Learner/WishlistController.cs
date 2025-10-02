using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using System.Threading.Tasks;

namespace EduLab_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class WishlistController : ControllerBase
    {
        private readonly IWishlistService _wishlistService;

        public WishlistController(IWishlistService wishlistService)
        {
            _wishlistService = wishlistService;
        }

        [HttpGet]
        public async Task<IActionResult> GetUserWishlist()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var wishlist = await _wishlistService.GetUserWishlistAsync(userId);
            return Ok(wishlist);
        }

        [HttpPost("{courseId}")]
        public async Task<IActionResult> AddToWishlist(int courseId)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var result = await _wishlistService.AddToWishlistAsync(userId, courseId);

            if (result.Success)
                return Ok(result);

            return BadRequest(result);
        }

        [HttpDelete("{courseId}")]
        public async Task<IActionResult> RemoveFromWishlist(int courseId)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var result = await _wishlistService.RemoveFromWishlistAsync(userId, courseId);

            if (result.Success)
                return Ok(result);

            return BadRequest(result);
        }

        [HttpGet("check/{courseId}")]
        public async Task<IActionResult> IsCourseInWishlist(int courseId)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var isInWishlist = await _wishlistService.IsCourseInWishlistAsync(userId, courseId);
            return Ok(new { isInWishlist });
        }

        [HttpGet("count")]
        public async Task<IActionResult> GetWishlistCount()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var count = await _wishlistService.GetWishlistCountAsync(userId);
            return Ok(new { count });
        }
    }
}