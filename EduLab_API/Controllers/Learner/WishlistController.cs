using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers
{
    #region Wishlist API Controller
    /// <summary>
    /// API controller for managing user wishlist operations
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    [Produces("application/json")]
    public class WishlistController : ControllerBase
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

        #region Public Endpoints
        /// <summary>
        /// Retrieves the complete wishlist for the authenticated user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of wishlist items for the user</returns>
        /// <response code="200">Returns the user's wishlist</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult> GetUserWishlist(CancellationToken cancellationToken = default)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var wishlist = await _wishlistService.GetUserWishlistAsync(userId, cancellationToken);
            return Ok(wishlist);
        }

        /// <summary>
        /// Adds a course to the authenticated user's wishlist
        /// </summary>
        /// <param name="courseId">Unique identifier of the course to add</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Wishlist operation response</returns>
        /// <response code="200">If course was successfully added to wishlist</response>
        /// <response code="400">If course is already in wishlist or not found</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPost("{courseId}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult> AddToWishlist(
            [Required] int courseId,
            CancellationToken cancellationToken = default)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var result = await _wishlistService.AddToWishlistAsync(userId, courseId, cancellationToken);

            if (result.Success)
                return Ok(result);

            return BadRequest(result);
        }

        /// <summary>
        /// Removes a course from the authenticated user's wishlist
        /// </summary>
        /// <param name="courseId">Unique identifier of the course to remove</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Wishlist operation response</returns>
        /// <response code="200">If course was successfully removed from wishlist</response>
        /// <response code="400">If course was not found in wishlist</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpDelete("{courseId}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult> RemoveFromWishlist(
            [Required] int courseId,
            CancellationToken cancellationToken = default)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var result = await _wishlistService.RemoveFromWishlistAsync(userId, courseId, cancellationToken);

            if (result.Success)
                return Ok(result);

            return BadRequest(result);
        }

        /// <summary>
        /// Checks if a course exists in the authenticated user's wishlist
        /// </summary>
        /// <param name="courseId">Unique identifier of the course to check</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Boolean indicating if course is in wishlist</returns>
        /// <response code="200">Returns check result</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("check/{courseId}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult> IsCourseInWishlist(
            [Required] int courseId,
            CancellationToken cancellationToken = default)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var isInWishlist = await _wishlistService.IsCourseInWishlistAsync(userId, courseId, cancellationToken);
            return Ok(new { isInWishlist });
        }

        /// <summary>
        /// Gets the total count of items in the authenticated user's wishlist
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Wishlist item count</returns>
        /// <response code="200">Returns wishlist count</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet("count")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult> GetWishlistCount(CancellationToken cancellationToken = default)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var count = await _wishlistService.GetWishlistCountAsync(userId, cancellationToken);
            return Ok(new { count });
        }
        #endregion
    }
    #endregion
}