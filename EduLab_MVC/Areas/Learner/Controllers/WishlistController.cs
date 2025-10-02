using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace EduLab_MVC.Controllers
{
    [Area("Learner")] // ✅ تأكد من وجود الـ Area
    [Authorize]
    public class WishlistController : Controller
    {
        private readonly IWishlistService _wishlistService;

        public WishlistController(IWishlistService wishlistService)
        {
            _wishlistService = wishlistService;
        }

        public async Task<IActionResult> Index()
        {
            var wishlist = await _wishlistService.GetUserWishlistAsync();
            return View(wishlist);
        }

        [HttpPost]
        public async Task<IActionResult> AddToWishlist([FromBody] AddToWishlistRequest request) // ✅ استخدم model binding
        {
            var result = await _wishlistService.AddToWishlistAsync(request.CourseId);
            return Json(result);
        }

        [HttpPost]
        public async Task<IActionResult> RemoveFromWishlist([FromBody] RemoveFromWishlistRequest request) // ✅ استخدم model binding
        {
            var result = await _wishlistService.RemoveFromWishlistAsync(request.CourseId);
            return Json(result);
        }

        [HttpGet]
        public async Task<IActionResult> IsCourseInWishlist(int courseId)
        {
            var isInWishlist = await _wishlistService.IsCourseInWishlistAsync(courseId);
            return Json(new { isInWishlist });
        }
    }

    // ✅ إضافة الـ DTOs للـ Request
    public class AddToWishlistRequest
    {
        public int CourseId { get; set; }
    }

    public class RemoveFromWishlistRequest
    {
        public int CourseId { get; set; }
    }
}