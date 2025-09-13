using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Cart;
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

        public CartService(ICartRepository cartRepository, IMapper mapper)
        {
            _cartRepository = cartRepository;
            _mapper = mapper;
        }

        public async Task<CartDto> GetUserCartAsync(string userId)
        {
            var cart = await _cartRepository.GetCartByUserIdAsync(userId);
            if (cart == null)
            {
                cart = await _cartRepository.CreateCartAsync(userId);
            }

            return MapToCartDto(cart);
        }

        public async Task<CartDto> AddItemToCartAsync(string userId, AddToCartRequest request)
        {
            var cart = await GetOrCreateCart(userId);

            // Check if item already exists in cart
            var existingItem = cart.CartItems.FirstOrDefault(ci => ci.CourseId == request.CourseId);
            if (existingItem != null)
            {
                // بدل ما ترمي exception، زود الكمية
                existingItem.Quantity += request.Quantity;
                existingItem.AddedAt = DateTime.UtcNow;
                await _cartRepository.UpdateCartItemQuantityAsync(existingItem.Id, existingItem.Quantity);
            }
            else
            {
                await _cartRepository.AddItemToCartAsync(cart.Id, request.CourseId, request.Quantity);
            }

            // Refresh cart to get updated data
            cart = await _cartRepository.GetCartByUserIdAsync(userId);
            return MapToCartDto(cart);
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
            return cart ?? await _cartRepository.CreateCartAsync(userId);
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
