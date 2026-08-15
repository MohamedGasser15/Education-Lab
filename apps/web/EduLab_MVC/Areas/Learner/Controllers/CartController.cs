using EduLab_MVC.Models.DTOs.Cart;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using EduLab_MVC.Resources;
using Microsoft.Extensions.Localization;
using System;
using System.Linq;
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
        private readonly IStringLocalizer<SharedResources> _localizer;

        /// <summary>
        /// Initializes a new instance of the CartController class
        /// </summary>
        /// <param name="cartService">The cart service</param>
        /// <param name="logger">The logger instance</param>
        public CartController(ICartService cartService, ILogger<CartController> logger, IStringLocalizer<SharedResources> localizer)
        {
            _cartService = cartService ?? throw new ArgumentNullException(nameof(cartService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _localizer = localizer ?? throw new ArgumentNullException(nameof(localizer));
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
                    return Json(new { success = false, message = _localizer["InvalidRequest"].Value });
                }

                var cart = await _cartService.AddItemToCartAsync(request, cancellationToken);

                return Json(new
                {
                    success = true,
                    message = _localizer["ItemAddedToCart"].Value,
                    cartCount = cart.Items.Count
                });
            }
            catch (InvalidOperationException ex)
            {
                _logger.LogWarning(ex, "Duplicate course detected while adding to cart");
                var message = ex.Message.Contains("مسجل بالفعل") ? _localizer["AlreadyEnrolled"].Value : _localizer["CourseAlreadyInCart"].Value;
                return Json(new { success = false, message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding item to cart via AJAX, course ID: {CourseId}", request?.CourseId);
                return Json(new { success = false, message = _localizer["ErrorAddingItemToCart"].Value });
            }
        }

        /// <summary>
        /// Toggles a course in the cart (adds if not present, removes if present)
        /// </summary>
        /// <param name="request">The toggle cart request</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>JSON response indicating the new cart state</returns>
        [HttpPost]
        public async Task<IActionResult> ToggleCart([FromBody] AddToCartRequest request, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Toggling course in cart via AJAX, course ID: {CourseId}", request?.CourseId);

                if (request == null || request.CourseId <= 0)
                {
                    return Json(new { success = false, message = _localizer["InvalidRequest"].Value });
                }

                var cart = await _cartService.GetUserCartAsync(cancellationToken);
                var existingItem = cart.Items?.FirstOrDefault(i => i.CourseId == request.CourseId);

                bool inCart;
                if (existingItem != null)
                {
                    cart = await _cartService.RemoveItemFromCartAsync(existingItem.Id, cancellationToken);
                    inCart = false;
                    _logger.LogInformation("Removed course {CourseId} from cart via toggle", request.CourseId);
                }
                else
                {
                    cart = await _cartService.AddItemToCartAsync(request, cancellationToken);
                    inCart = true;
                    _logger.LogInformation("Added course {CourseId} to cart via toggle", request.CourseId);
                }

                return Json(new
                {
                    success = true,
                    inCart = inCart,
                    cartCount = cart?.TotalItems ?? 0,
                    message = inCart ? _localizer["ItemAddedToCart"].Value : _localizer["ItemRemovedSuccess"].Value
                });
            }
            catch (InvalidOperationException ex)
            {
                _logger.LogWarning(ex, "Duplicate course detected while toggling cart");
                var message = ex.Message.Contains("مسجل بالفعل") ? _localizer["AlreadyEnrolled"].Value : _localizer["CourseAlreadyInCart"].Value;
                return Json(new { success = false, message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error toggling item in cart via AJAX, course ID: {CourseId}", request?.CourseId);
                return Json(new { success = false, message = _localizer["ErrorAddingToCart"].Value });
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
                return Json(new { success = false, message = _localizer["ErrorRemovingItemFromCart"].Value });
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
                    return Json(new { success = false, message = _localizer["FailedToClearCart"].Value });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error clearing cart via AJAX");
                return Json(new { success = false, message = _localizer["ErrorClearingCart"].Value });
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

        /// <summary>
        /// Returns the re-rendered cart dropdown HTML (keeps the navbar dropdown in sync with the cart)
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> GetDropdown()
        {
            try
            {
                var cart = await _cartService.GetUserCartAsync();
                return PartialView("~/Areas/Learner/Views/Shared/Components/CartDropdown/_CartDropdown.cshtml", cart);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error rendering cart dropdown");
                return Content(string.Empty, "text/html");
            }
        }

        #endregion
    }
}
