// CartController.cs في مشروع MVC
using EduLab_MVC.Models.DTOs.Cart;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Controllers
{
    [Authorize]
    [Area("Learner")]
    public class CartController : Controller
    {
        private readonly ICartService _cartService;
        private readonly ILogger<CartController> _logger;

        public CartController(ICartService cartService, ILogger<CartController> logger)
        {
            _cartService = cartService;
            _logger = logger;
        }

        public async Task<IActionResult> Index()
        {
            try
            {
                var cart = await _cartService.GetUserCartAsync();
                return View(cart);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading cart page");
                return View(new CartDto());
            }
        }

        [HttpPost]
        public async Task<IActionResult> AddToCart([FromBody] AddToCartRequest request)
        {
            try
            {
                var cart = await _cartService.AddItemToCartAsync(request);

                return Json(new
                {
                    success = true,
                    message = "تمت إضافة المنتج إلى السلة",
                    cartCount = cart.Items.Count // تقدر تبعت أي بيانات إضافية
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding item to cart");

                return Json(new
                {
                    success = false,
                    message = "حدث خطأ أثناء إضافة المنتج إلى السلة"
                });
            }
        }


        [HttpPost]
        public async Task<JsonResult> RemoveItem(int cartItemId)
        {
            try
            {
                var cart = await _cartService.RemoveItemFromCartAsync(cartItemId);
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
                _logger.LogError(ex, "Error removing item from cart");
                return Json(new { success = false, message = "حدث خطأ أثناء إزالة المنتج من السلة" });
            }
        }

        [HttpPost]
        public async Task<JsonResult> UpdateItem(int cartItemId, int quantity)
        {
            try
            {
                var request = new UpdateCartItemRequest { Quantity = quantity };
                var cart = await _cartService.UpdateCartItemAsync(cartItemId, request);
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
                _logger.LogError(ex, "Error updating cart item");
                return Json(new { success = false, message = "حدث خطأ أثناء تحديث الكمية" });
            }
        }

        [HttpPost]
        public async Task<JsonResult> ClearCart()
        {
            try
            {
                var success = await _cartService.ClearCartAsync();
                return Json(new { success = success });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error clearing cart");
                return Json(new { success = false, message = "حدث خطأ أثناء تفريغ السلة" });
            }
        }
        [HttpGet]
        public async Task<JsonResult> GetCartSummary()
        {
            try
            {
                var cart = await _cartService.GetUserCartAsync();
                return Json(new
                {
                    totalItems = cart.TotalItems,
                    totalPrice = cart.TotalPrice
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting cart summary");
                return Json(new { totalItems = 0, totalPrice = 0m });
            }
        }
    }
}