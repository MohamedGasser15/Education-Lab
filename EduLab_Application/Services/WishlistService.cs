using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Wishlist;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class WishlistService : IWishlistService
    {
        private readonly IWishlistRepository _wishlistRepo;
        private readonly IRepository<Course> _courseRepo;
        private readonly ILogger<WishlistService> _logger;

        public WishlistService(
            IWishlistRepository wishlistRepo,
            IRepository<Course> courseRepo,
            ILogger<WishlistService> logger)
        {
            _wishlistRepo = wishlistRepo;
            _courseRepo = courseRepo;
            _logger = logger;
        }

        public async Task<List<WishlistItemDto>> GetUserWishlistAsync(string userId)
        {
            try
            {
                var wishlistItems = await _wishlistRepo.GetUserWishlistAsync(userId);

                return wishlistItems.Select(item => new WishlistItemDto
                {
                    Id = item.Id,
                    CourseId = item.Course.Id,
                    CourseTitle = item.Course.Title,
                    CourseShortDescription = item.Course.ShortDescription,
                    CoursePrice = item.Course.Price,
                    CourseDiscount = item.Course.Discount,
                    ThumbnailUrl = item.Course.ThumbnailUrl,
                    InstructorName = item.Course.Instructor.FullName,
                    AddedAt = item.AddedAt
                }).ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting user wishlist for user {UserId}", userId);
                throw;
            }
        }

        public async Task<WishlistResponse> AddToWishlistAsync(string userId, int courseId)
        {
            try
            {
                // Check if course exists
                var course = await _courseRepo.GetAsync(c => c.Id == courseId);
                if (course == null)
                {
                    return new WishlistResponse
                    {
                        Success = false,
                        Message = "Course not found"
                    };
                }

                // Check if already in wishlist
                var existingItem = await _wishlistRepo.GetWishlistItemAsync(userId, courseId);
                if (existingItem != null)
                {
                    return new WishlistResponse
                    {
                        Success = false,
                        Message = "Course is already in wishlist"
                    };
                }

                // Add to wishlist
                var wishlistItem = new Wishlist
                {
                    UserId = userId,
                    CourseId = courseId,
                    AddedAt = DateTime.UtcNow
                };

                await _wishlistRepo.CreateAsync(wishlistItem);
                var wishlistCount = await _wishlistRepo.GetWishlistCountAsync(userId);

                return new WishlistResponse
                {
                    Success = true,
                    Message = "Course added to wishlist successfully",
                    WishlistCount = wishlistCount
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while adding course {CourseId} to wishlist for user {UserId}", courseId, userId);
                return new WishlistResponse
                {
                    Success = false,
                    Message = "An error occurred while adding to wishlist"
                };
            }
        }

        public async Task<WishlistResponse> RemoveFromWishlistAsync(string userId, int courseId)
        {
            try
            {
                var wishlistItem = await _wishlistRepo.GetWishlistItemAsync(userId, courseId);
                if (wishlistItem == null)
                {
                    return new WishlistResponse
                    {
                        Success = false,
                        Message = "Course not found in wishlist"
                    };
                }

                await _wishlistRepo.DeleteAsync(wishlistItem);
                var wishlistCount = await _wishlistRepo.GetWishlistCountAsync(userId);

                return new WishlistResponse
                {
                    Success = true,
                    Message = "Course removed from wishlist successfully",
                    WishlistCount = wishlistCount
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while removing course {CourseId} from wishlist for user {UserId}", courseId, userId);
                return new WishlistResponse
                {
                    Success = false,
                    Message = "An error occurred while removing from wishlist"
                };
            }
        }

        public async Task<bool> IsCourseInWishlistAsync(string userId, int courseId)
        {
            return await _wishlistRepo.IsCourseInWishlistAsync(userId, courseId);
        }

        public async Task<int> GetWishlistCountAsync(string userId)
        {
            return await _wishlistRepo.GetWishlistCountAsync(userId);
        }
    }
}