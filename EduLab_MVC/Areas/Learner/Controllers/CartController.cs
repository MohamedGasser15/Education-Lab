using EduLab_MVC.Models.DTOs.Cart;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Controllers
{
    /// <summary>
    /// MVC Controller for managing shopping cart operations
    /// </summary>
    [Area("Learner")]
    public class CartController : Controller
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

        #region View Actions

        /// <summary>
        /// Displays the cart page
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>The cart view</returns>
        [HttpGet]
        public async Task<IActionResult> Index(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Loading cart page");

                var cart = await _cartService.GetUserCartAsync(cancellationToken);

                _logger.LogInformation("Successfully loaded cart page with {ItemCount} items", cart.Items.Count);
                return View(cart);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading cart page");
                return View(new CartDto());
            }
        }

        #endregion

        #region API Actions

        /// <summary>
        /// Adds an item to the cart
        /// </summary>
        /// <param name="request">The add to cart request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>JSON response indicating success or failure</returns>
        [HttpPost]
        public async Task<IActionResult> AddToCart([FromBody] AddToCartRequest request, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Adding item to cart via AJAX, course ID: {CourseId}", request.CourseId);

                if (request == null || request.CourseId <= 0)
                {
                    return Json(new { success = false, message = "طلب غير صالح" });
                }

                var cart = await _cartService.AddItemToCartAsync(request, cancellationToken);

                return Json(new
                {
                    success = true,
                    message = "تمت إضافة المنتج إلى السلة",
                    cartCount = cart.Items.Count
                });
            }
            catch (InvalidOperationException ex)
            {
                _logger.LogWarning(ex, "Duplicate course detected while adding to cart");
                return Json(new { success = false, message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding item to cart via AJAX, course ID: {CourseId}", request?.CourseId);
                return Json(new { success = false, message = "حدث خطأ أثناء إضافة المنتج إلى السلة" });
            }
        }

        /// <summary>
        /// Removes an item from the cart
        /// </summary>
        /// <param name="cartItemId">The cart item ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>JSON response with updated cart data</returns>
        [HttpPost]
        public async Task<JsonResult> RemoveItem(int cartItemId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Removing cart item via AJAX, cart item ID: {CartItemId}", cartItemId);

                var cart = await _cartService.RemoveItemFromCartAsync(cartItemId, cancellationToken);

                _logger.LogInformation("Successfully removed cart item via AJAX, cart item ID: {CartItemId}", cartItemId);
                return Json(new
                {
                    success = true,
                    totalItems = cart.TotalItems,
                    totalPrice = cart.TotalPrice,
                    items = cart.Items
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error removing item from cart via AJAX, cart item ID: {CartItemId}", cartItemId);
                return Json(new { success = false, message = "حدث خطأ أثناء إزالة المنتج من السلة" });
            }
        }

        /// <summary>
        /// Clears all items from the cart
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>JSON response indicating success or failure</returns>
        [HttpPost]
        public async Task<JsonResult> ClearCart(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Clearing cart via AJAX");

                var success = await _cartService.ClearCartAsync(cancellationToken);

                if (success)
                {
                    _logger.LogInformation("Successfully cleared cart via AJAX");
                    return Json(new { success = true });
                }
                else
                {
                    _logger.LogWarning("Failed to clear cart via AJAX");
                    return Json(new { success = false, message = "فشل في تفريغ السلة" });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error clearing cart via AJAX");
                return Json(new { success = false, message = "حدث خطأ أثناء تفريغ السلة" });
            }
        }

        /// <summary>
        /// Retrieves a summary of the cart
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>JSON response with cart summary</returns>
        [HttpGet]
        public async Task<JsonResult> GetCartSummary(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting cart summary via AJAX");

                var cart = await _cartService.GetUserCartAsync(cancellationToken);

                _logger.LogInformation("Successfully retrieved cart summary via AJAX with {TotalItems} items", cart.TotalItems);
                return Json(new
                {
                    totalItems = cart.TotalItems,
                    totalPrice = cart.TotalPrice
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting cart summary via AJAX");
                return Json(new { totalItems = 0, totalPrice = 0m });
            }
        }

        #endregion
    }
}