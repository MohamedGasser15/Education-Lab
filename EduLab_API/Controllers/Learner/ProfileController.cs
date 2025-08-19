using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Profile;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EduLab_API.Controllers.Learner
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProfileController : ControllerBase
    {
        private readonly IProfileService _profileService;
        private readonly ICurrentUserService _currentUserService;

        public ProfileController(IProfileService profileService, ICurrentUserService currentUserService)
        {
            _profileService = profileService;
            _currentUserService = currentUserService;
        }

        [HttpGet]
        public async Task<IActionResult> GetProfile()
        {
            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId))
                return Unauthorized();

            var profile = await _profileService.GetUserProfileAsync(userId);
            if (profile == null)
                return NotFound();

            return Ok(profile);
        }

        [HttpPut]
        public async Task<IActionResult> UpdateProfile([FromBody] UpdateProfileDTO updateProfileDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId) || userId != updateProfileDto.Id)
                return Unauthorized();

            var success = await _profileService.UpdateUserProfileAsync(updateProfileDto);
            if (!success)
                return StatusCode(500, "فشل في تحديث البروفايل");

            return Ok(new { message = "تم تحديث البروفايل بنجاح" });
        }

        [HttpPost("upload-image")]
        public async Task<IActionResult> UploadProfileImage([FromForm] ProfileImageDTO profileImageDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId) || userId != profileImageDto.UserId)
                return Unauthorized();

            try
            {
                var imageUrl = await _profileService.UploadProfileImageAsync(profileImageDto);
                return Ok(new { imageUrl });
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }
    }
}
