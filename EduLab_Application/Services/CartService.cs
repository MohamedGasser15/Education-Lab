using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Cart;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class CartService : ICartService
    {
        private readonly ICartRepository _cartRepository;
        private readonly IMapper _mapper;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public CartService(ICartRepository cartRepository, IMapper mapper, IHttpContextAccessor httpContextAccessor)
        {
            _cartRepository = cartRepository;
            _mapper = mapper;
            _httpContextAccessor = httpContextAccessor;
        }
        private string GetGuestId()
        {
            var httpContext = _httpContextAccessor.HttpContext;
            if (httpContext.Request.Cookies.TryGetValue("GuestId", out var guestId))
            {
                return guestId;
            }

            // إنشاء معرف ضيف جديد إذا لم يكن موجوداً
            var newGuestId = Guid.NewGuid().ToString();
            httpContext.Response.Cookies.Append("GuestId", newGuestId, new CookieOptions
            {
                Expires = DateTime.Now.AddDays(30),
                HttpOnly = true,
                IsEssential = true
            });

            return newGuestId;
        }
        public async Task<CartDto> GetUserCartAsync(string userId)
        {
            var cart = await _cartRepository.GetCartByUserIdAsync(userId);
            if (cart == null)
            {
                cart = await _cartRepository.CreateUserCartAsync(userId);
            }

            return MapToCartDto(cart);
        }

        public async Task<CartDto> GetGuestCartAsync()
        {
            var guestId = GetGuestId();
            var cart = await _cartRepository.GetCartByGuestIdAsync(guestId);
            if (cart == null)
            {
                cart = await _cartRepository.CreateGuestCartAsync(guestId);
            }

            return MapToCartDto(cart);
        }

        public async Task<CartDto> AddItemToCartAsync(string userId, AddToCartRequest request)
        {
            Cart cart;
            if (string.IsNullOrEmpty(userId))
            {
                // مستخدم غير مسجل الدخول
                var guestId = GetGuestId();
                cart = await GetOrCreateGuestCart(guestId);
            }
            else
            {
                // مستخدم مسجل الدخول
                cart = await GetOrCreateUserCart(userId);
            }

            // Check if item already exists in cart
            var existingItem = cart.CartItems.FirstOrDefault(ci => ci.CourseId == request.CourseId);
            if (existingItem != null)
            {
                existingItem.Quantity += request.Quantity;
                existingItem.AddedAt = DateTime.UtcNow;
                await _cartRepository.UpdateCartItemQuantityAsync(existingItem.Id, existingItem.Quantity);
            }
            else
            {
                await _cartRepository.AddItemToCartAsync(cart.Id, request.CourseId, request.Quantity);
            }

            // Refresh cart to get updated data
            if (string.IsNullOrEmpty(userId))
            {
                var guestId = GetGuestId();
                cart = await _cartRepository.GetCartByGuestIdAsync(guestId);
            }
            else
            {
                cart = await _cartRepository.GetCartByUserIdAsync(userId);
            }

            return MapToCartDto(cart);
        }

        public async Task<bool> MigrateGuestCartToUserAsync(string userId)
        {
            var guestId = GetGuestId();
            if (string.IsNullOrEmpty(guestId))
                return false;

            return await _cartRepository.MigrateGuestCartToUserAsync(guestId, userId);
        }

        private async Task<Cart> GetOrCreateUserCart(string userId)
        {
            var cart = await _cartRepository.GetCartByUserIdAsync(userId);
            return cart ?? await _cartRepository.CreateUserCartAsync(userId);
        }

        private async Task<Cart> GetOrCreateGuestCart(string guestId)
        {
            var cart = await _cartRepository.GetCartByGuestIdAsync(guestId);
            return cart ?? await _cartRepository.CreateGuestCartAsync(guestId);
        }


        public async Task<CartDto> UpdateCartItemAsync(string userId, int cartItemId, UpdateCartItemRequest request)
        {
            var cart = await GetOrCreateCart(userId);
            await _cartRepository.UpdateCartItemQuantityAsync(cartItemId, request.Quantity);

            // Refresh cart
            cart = await _cartRepository.GetCartByUserIdAsync(userId);
            return MapToCartDto(cart);
        }

        public async Task<CartDto> RemoveItemFromCartAsync(string userId, int cartItemId)
        {
            await _cartRepository.RemoveItemFromCartAsync(cartItemId);

            var cart = await _cartRepository.GetCartByUserIdAsync(userId);
            return MapToCartDto(cart);
        }

        public async Task<bool> ClearCartAsync(string userId)
        {
            var cart = await GetOrCreateCart(userId);
            return await _cartRepository.ClearCartAsync(cart.Id);
        }

        private async Task<Cart> GetOrCreateCart(string userId)
        {
            var cart = await _cartRepository.GetCartByUserIdAsync(userId);
            return cart ?? await _cartRepository.CreateUserCartAsync(userId);
        }

        private CartDto MapToCartDto(Cart cart)
        {
            var cartDto = new CartDto
            {
                Id = cart.Id,
                UserId = cart.UserId,
                TotalPrice = cart.TotalPrice
            };

            foreach (var item in cart.CartItems)
            {
                cartDto.Items.Add(new CartItemDto
                {
                    Id = item.Id,
                    CourseId = item.CourseId,
                    CourseTitle = item.Course.Title,
                    CoursePrice = item.Course.Price,
                    ThumbnailUrl = item.Course.ThumbnailUrl,
                    InstructorName = item.Course.Instructor?.FullName,
                    Quantity = item.Quantity,
                    TotalPrice = item.TotalPrice
                });
            }

            return cartDto;
        }
    }
}
