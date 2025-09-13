using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Cart;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EduLab_API.Controllers.Learner
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
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
            var cart = await _cartService.GetUserCartAsync(userId);
            return Ok(cart);
        }

        [HttpPost("items")]
        public async Task<ActionResult<CartDto>> AddItemToCart([FromBody] AddToCartRequest request)
        {
            var userId = GetUserId();
            var cart = await _cartService.AddItemToCartAsync(userId, request);
            return Ok(cart);
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
