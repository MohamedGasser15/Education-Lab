using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Cart;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Learner
{
    /// <summary>
    /// API controller for managing shopping cart operations
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    [Produces("application/json")]
    public class CartController : ControllerBase
    {
        private readonly ICartService _cartService;
        private readonly ILogger<CartController> _logger;

        /// <summary>
        /// Initializes a new instance of the CartController class
        /// </summary>
        /// <param name="cartService">The cart service</param>
        /// <param name="logger">The logger instance</param>
        public CartController(ICartService cartService, ILogger<CartController> logger)
        {
            _cartService = cartService ?? throw new ArgumentNullException(nameof(cartService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #region Private Helper Methods

        /// <summary>
        /// Retrieves the user ID from the current claims principal
        /// </summary>
        /// <returns>The user ID or null if not authenticated</returns>
        private string GetUserId()
        {
            return User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        }

        #endregion

        #region Cart Retrieval Endpoints

        /// <summary>
        /// Retrieves the current user's cart
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The user's cart</returns>
        /// <response code="200">Returns the user's cart</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpGet]
        [ProducesResponseType(typeof(CartDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<CartDto>> GetCart(CancellationToken cancellationToken = default)
        {
            try
            {
                var userId = GetUserId();
                CartDto cart;

                if (string.IsNullOrEmpty(userId))
                {
                    cart = await _cartService.GetGuestCartAsync(cancellationToken);
                }
                else
                {
                    cart = await _cartService.GetUserCartAsync(userId, cancellationToken);
                }

                return Ok(cart);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving cart");
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while retrieving the cart");
            }
        }

        #endregion

        #region Cart Modification Endpoints

        /// <summary>
        /// Adds an item to the cart
        /// </summary>
        /// <param name="request">The add to cart request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The updated cart</returns>
        /// <response code="200">Returns the updated cart</response>
        /// <response code="400">If the request is invalid</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPost("items")]
        [ProducesResponseType(typeof(CartDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<CartDto>> AddItemToCart([FromBody] AddToCartRequest request, CancellationToken cancellationToken = default)
        {
            try
            {
                if (request == null || request.CourseId <= 0 || request.Quantity <= 0)
                {
                    return BadRequest("Invalid request data");
                }

                var userId = GetUserId();
                var cart = await _cartService.AddItemToCartAsync(userId, request, cancellationToken);

                return Ok(cart);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding item to cart");
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while adding item to cart");
            }
        }

        /// <summary>
        /// Updates a cart item quantity
        /// </summary>
        /// <param name="cartItemId">The ID of the cart item to update</param>
        /// <param name="request">The update request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The updated cart</returns>
        /// <response code="200">Returns the updated cart</response>
        /// <response code="400">If the request is invalid</response>
        /// <response code="404">If the cart item is not found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPut("items/{cartItemId:int}")]
        [ProducesResponseType(typeof(CartDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<CartDto>> UpdateCartItem(int cartItemId, [FromBody] UpdateCartItemRequest request, CancellationToken cancellationToken = default)
        {
            try
            {
                if (request == null || request.Quantity <= 0)
                {
                    return BadRequest("Invalid request data");
                }

                var userId = GetUserId();
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized("User must be authenticated to update cart items");
                }

                var cart = await _cartService.UpdateCartItemAsync(userId, cartItemId, request, cancellationToken);

                return Ok(cart);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating cart item with ID: {CartItemId}", cartItemId);
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while updating the cart item");
            }
        }

        /// <summary>
        /// Removes an item from the cart
        /// </summary>
        /// <param name="cartItemId">The ID of the cart item to remove</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The updated cart</returns>
        /// <response code="200">Returns the updated cart</response>
        /// <response code="404">If the cart item is not found</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpDelete("items/{cartItemId:int}")]
        [ProducesResponseType(typeof(CartDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult<CartDto>> RemoveItemFromCart(int cartItemId, CancellationToken cancellationToken = default)
        {
            try
            {
                var userId = GetUserId();
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized("User must be authenticated to remove cart items");
                }

                var cart = await _cartService.RemoveItemFromCartAsync(userId, cartItemId, cancellationToken);

                return Ok(cart);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error removing cart item with ID: {CartItemId}", cartItemId);
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while removing the cart item");
            }
        }

        /// <summary>
        /// Clears all items from the cart
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>No content if successful</returns>
        /// <response code="204">If the cart was cleared successfully</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpDelete("clear")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult> ClearCart(CancellationToken cancellationToken = default)
        {
            try
            {
                var userId = GetUserId();
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized("User must be authenticated to clear cart");
                }

                await _cartService.ClearCartAsync(userId, cancellationToken);

                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error clearing cart");
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while clearing the cart");
            }
        }

        #endregion

        #region Cart Migration Endpoints

        /// <summary>
        /// Migrates a guest cart to a user cart
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Migration result</returns>
        /// <response code="200">Returns the migration result</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="500">If there was an internal server error</response>
        [HttpPost("migrate")]
        [Authorize]
        [ProducesResponseType(typeof(object), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult> MigrateGuestCart(CancellationToken cancellationToken = default)
        {
            try
            {
                var userId = GetUserId();
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized();
                }

                var success = await _cartService.MigrateGuestCartToUserAsync(userId, cancellationToken);
                return Ok(new { success });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error migrating guest cart for user ID: {UserId}", GetUserId());
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while migrating the cart");
            }
        }

        #endregion
    }
}