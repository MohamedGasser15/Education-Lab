using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Profile;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_API.Controllers.Learner
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class ProfileController : ControllerBase
    {
        private readonly IProfileService _profileService;
        private readonly ICurrentUserService _currentUserService;

        public ProfileController(IProfileService profileService, ICurrentUserService currentUserService)
        {
            _profileService = profileService;
            _currentUserService = currentUserService;
        }

        // ================= User =================
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
            if (!ModelState.IsValid) return BadRequest(ModelState);

            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId) || userId != updateProfileDto.Id) return Unauthorized();

            var success = await _profileService.UpdateUserProfileAsync(updateProfileDto);
            if (!success) return StatusCode(500, "فشل في تحديث البروفايل");

            return Ok(new { message = "تم تحديث البروفايل بنجاح" });
        }

        [HttpPost("upload-image")]
        public async Task<IActionResult> UploadProfileImage([FromForm] ProfileImageDTO profileImageDto)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);

            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId) || userId != profileImageDto.UserId) return Unauthorized();

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

        // ================= Instructor =================
        [HttpGet("instructor")]
        [Authorize(Roles = SD.Instructor)]
        public async Task<IActionResult> GetInstructorProfile([FromQuery] int latestCoursesCount = 2)
        {
            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId))
                return Unauthorized();

            var profile = await _profileService.GetInstructorProfileAsync(userId, latestCoursesCount);
            if (profile == null)
                return NotFound();

            return Ok(profile);
        }

        [HttpGet("public/instructor/{instructorId}")]
        [AllowAnonymous]
        public async Task<IActionResult> GetPublicInstructorProfile(string instructorId)
        {
            if (string.IsNullOrEmpty(instructorId))
                return BadRequest("معرف المدرب مطلوب");

            var profile = await _profileService.GetPublishInstructorProfileAsync(instructorId);
            if (profile == null)
                return NotFound("لم يتم العثور على المدرب");

            return Ok(profile);
        }

        [HttpPut("instructor")]
        [Authorize(Roles = SD.Instructor)]
        public async Task<IActionResult> UpdateInstructorProfile([FromBody] UpdateInstructorProfileDTO updateProfileDto)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);

            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId) || userId != updateProfileDto.Id) return Unauthorized();

            var success = await _profileService.UpdateInstructorProfileAsync(updateProfileDto);
            if (!success) return StatusCode(500, "فشل في تحديث البروفايل");

            return Ok(new { message = "تم تحديث البروفايل بنجاح" });
        }

        [HttpPost("instructor/upload-image")]
        [Authorize(Roles = SD.Instructor)]
        public async Task<IActionResult> UploadInstructorProfileImage([FromForm] ProfileImageDTO profileImageDto)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);

            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId) || userId != profileImageDto.UserId) return Unauthorized();

            try
            {
                var imageUrl = await _profileService.UploadInstructorProfileImageAsync(profileImageDto);
                return Ok(new { imageUrl });
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

        // ================= Certificates =================
        [HttpPost("certificates")]
        [Authorize(Roles = SD.Instructor)]
        public async Task<IActionResult> AddCertificate([FromBody] CertificateDTO dto)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);

            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            var addedCert = await _profileService.AddCertificateAsync(userId, dto);
            if (addedCert == null) return StatusCode(500, "فشل في إضافة الشهادة");

            return Ok(addedCert);
        }

        [HttpDelete("certificates/{certId}")]
        [Authorize(Roles = SD.Instructor)]
        public async Task<IActionResult> DeleteCertificate(int certId)
        {
            var userId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(userId)) return Unauthorized();

            var success = await _profileService.DeleteCertificateAsync(userId, certId);
            if (!success) return NotFound();

            return Ok(new { message = "تم حذف الشهادة بنجاح" });
        }
    }
}
