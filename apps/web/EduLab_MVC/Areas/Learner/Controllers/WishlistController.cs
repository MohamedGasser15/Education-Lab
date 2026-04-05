using EduLab_MVC.Models.DTOs.Wishlist;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Controllers
{
    #region Wishlist MVC Controller
    /// <summary>
    /// MVC controller for handling wishlist views and operations
    /// </summary>
    [Area("Learner")]
    [Authorize]
    public class WishlistController : Controller
    {
        #region Fields
        private readonly IWishlistService _wishlistService;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the WishlistController class
        /// </summary>
        /// <param name="wishlistService">Wishlist service for business logic operations</param>
        /// <exception cref="ArgumentNullException">Thrown when wishlistService is null</exception>
        public WishlistController(IWishlistService wishlistService)
        {
            _wishlistService = wishlistService ?? throw new ArgumentNullException(nameof(wishlistService));
        }
        #endregion

        #region Public Actions
        /// <summary>
        /// Displays the wishlist page for the authenticated user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Wishlist view with user's wishlist items</returns>
        [HttpGet]
        public async Task<IActionResult> Index(CancellationToken cancellationToken = default)
        {
            var wishlist = await _wishlistService.GetUserWishlistAsync(cancellationToken);
            return View(wishlist);
        }

        /// <summary>
        /// Adds a course to the authenticated user's wishlist via AJAX request
        /// </summary>
        /// <param name="request">Request containing course ID to add</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>JSON response indicating success or failure</returns>
        [HttpPost]
        public async Task<IActionResult> AddToWishlist(
            [FromBody] AddToWishlistRequest request,
            CancellationToken cancellationToken = default)
        {
            if (request == null)
            {
                return Json(new WishlistResponse
                {
                    Success = false,
                    Message = "Invalid request"
                });
            }

            var result = await _wishlistService.AddToWishlistAsync(request.CourseId, cancellationToken);
            return Json(result);
        }

        /// <summary>
        /// Removes a course from the authenticated user's wishlist via AJAX request
        /// </summary>
        /// <param name="request">Request containing course ID to remove</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>JSON response indicating success or failure</returns>
        [HttpPost]
        public async Task<IActionResult> RemoveFromWishlist(
            [FromBody] RemoveFromWishlistRequest request,
            CancellationToken cancellationToken = default)
        {
            if (request == null)
            {
                return Json(new WishlistResponse
                {
                    Success = false,
                    Message = "Invalid request"
                });
            }

            var result = await _wishlistService.RemoveFromWishlistAsync(request.CourseId, cancellationToken);
            return Json(result);
        }

        /// <summary>
        /// Checks if a course exists in the authenticated user's wishlist via AJAX request
        /// </summary>
        /// <param name="courseId">Unique identifier of the course to check</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>JSON response indicating if course is in wishlist</returns>
        [HttpGet]
        public async Task<IActionResult> IsCourseInWishlist(
            [Required] int courseId,
            CancellationToken cancellationToken = default)
        {
            var isInWishlist = await _wishlistService.IsCourseInWishlistAsync(courseId, cancellationToken);
            return Json(new { isInWishlist });
        }
        #endregion
    }
    #endregion
}