using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Cart;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EduLab_API.Controllers.Learner
{
    [ApiController]
    [Route("api/[controller]")]
    public class CartController : ControllerBase
    {
        private readonly ICartService _cartService;

        public CartController(ICartService cartService)
        {
            _cartService = cartService;
        }

        private string GetUserId()
        {
            return User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        }

        [HttpGet]
        public async Task<ActionResult<CartDto>> GetCart()
        {
            var userId = GetUserId();
            CartDto cart;

            if (string.IsNullOrEmpty(userId))
            {
                cart = await _cartService.GetGuestCartAsync();
            }
            else
            {
                cart = await _cartService.GetUserCartAsync(userId);
            }

            return Ok(cart);
        }

        [HttpPost("items")]
        public async Task<ActionResult<CartDto>> AddItemToCart([FromBody] AddToCartRequest request)
        {
            var userId = GetUserId();
            var cart = await _cartService.AddItemToCartAsync(userId, request);
            return Ok(cart);
        }

        [HttpPost("migrate")]
        [Authorize]
        public async Task<ActionResult> MigrateGuestCart()
        {
            var userId = GetUserId();
            if (string.IsNullOrEmpty(userId))
                return Unauthorized();

            var success = await _cartService.MigrateGuestCartToUserAsync(userId);
            return Ok(new { success });
        }

        [HttpPut("items/{cartItemId}")]
        public async Task<ActionResult<CartDto>> UpdateCartItem(int cartItemId, [FromBody] UpdateCartItemRequest request)
        {
            var userId = GetUserId();
            var cart = await _cartService.UpdateCartItemAsync(userId, cartItemId, request);
            return Ok(cart);
        }

        [HttpDelete("items/{cartItemId}")]
        public async Task<ActionResult<CartDto>> RemoveItemFromCart(int cartItemId)
        {
            var userId = GetUserId();
            var cart = await _cartService.RemoveItemFromCartAsync(userId, cartItemId);
            return Ok(cart);
        }

        [HttpDelete("clear")]
        public async Task<ActionResult> ClearCart()
        {
            var userId = GetUserId();
            await _cartService.ClearCartAsync(userId);
            return NoContent();
        }
    }
}
