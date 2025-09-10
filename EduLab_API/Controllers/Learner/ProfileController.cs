using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Profile;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Learner
{
    /// <summary>
    /// API controller for managing user profiles
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    [Produces("application/json")]
    public class ProfileController : ControllerBase
    {
        #region Fields
        private readonly IProfileService _profileService;
        private readonly ICurrentUserService _currentUserService;
        private readonly ILogger<ProfileController> _logger;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the ProfileController class
        /// </summary>
        /// <param name="profileService">Profile service instance</param>
        /// <param name="currentUserService">Current user service instance</param>
        /// <param name="logger">Logger instance</param>
        public ProfileController(
            IProfileService profileService,
            ICurrentUserService currentUserService,
            ILogger<ProfileController> logger)
        {
            _profileService = profileService ?? throw new ArgumentNullException(nameof(profileService));
            _currentUserService = currentUserService ?? throw new ArgumentNullException(nameof(currentUserService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }
        #endregion

        #region User Profile Endpoints
        /// <summary>
        /// Retrieves the current user's profile
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The user profile if found</returns>
        /// <response code="200">Returns the user profile</response>
        /// <response code="401">If user is not authenticated</response>
        /// <response code="404">If profile is not found</response>
        [HttpGet]
        [ProducesResponseType(typeof(ProfileDTO), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> GetProfile(CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetProfile);

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var userId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("User ID is null or empty in {OperationName}", operationName);
                    return Unauthorized(new { message = "المستخدم غير مصرح به" });
                }

                var profile = await _profileService.GetUserProfileAsync(userId, cancellationToken);
                if (profile == null)
                {
                    _logger.LogWarning("Profile not found for user ID: {UserId} in {OperationName}", userId, operationName);
                    return NotFound(new { message = "لم يتم العثور على الملف الشخصي" });
                }

                _logger.LogInformation("Successfully retrieved profile for user ID: {UserId}", userId);
                return Ok(profile);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new { message = "تم إلغاء العملية" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "حدث خطأ داخلي في الخادم" });
            }
        }

        /// <summary>
        /// Updates the current user's profile
        /// </summary>
        /// <param name="updateProfileDto">The profile data to update</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Success message if update was successful</returns>
        /// <response code="200">If update was successful</response>
        /// <response code="400">If model state is invalid</response>
        /// <response code="401">If user is not authenticated or unauthorized</response>
        /// <response code="500">If update failed</response>
        [HttpPut]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> UpdateProfile(
            [FromBody] UpdateProfileDTO updateProfileDto,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(UpdateProfile);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, updateProfileDto.Id);

                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid model state in {OperationName}", operationName);
                    return BadRequest(new { message = "بيانات غير صالحة", errors = ModelState });
                }

                var userId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(userId) || userId != updateProfileDto.Id)
                {
                    _logger.LogWarning("Unauthorized access in {OperationName}. Current user ID: {CurrentUserId}, Target user ID: {TargetUserId}",
                        operationName, userId, updateProfileDto.Id);
                    return Unauthorized(new { message = "غير مصرح به" });
                }

                var success = await _profileService.UpdateUserProfileAsync(updateProfileDto, cancellationToken);
                if (!success)
                {
                    _logger.LogError("Failed to update profile for user ID: {UserId}", updateProfileDto.Id);
                    return StatusCode(StatusCodes.Status500InternalServerError, new { message = "فشل في تحديث البروفايل" });
                }

                _logger.LogInformation("Successfully updated profile for user ID: {UserId}", updateProfileDto.Id);
                return Ok(new { message = "تم تحديث البروفايل بنجاح" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, updateProfileDto.Id);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new { message = "تم إلغاء العملية" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, updateProfileDto.Id);
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "حدث خطأ داخلي في الخادم" });
            }
        }

        /// <summary>
        /// Uploads a profile image for the current user
        /// </summary>
        /// <param name="profileImageDto">The image file and user information</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The URL of the uploaded image</returns>
        /// <response code="200">Returns the image URL</response>
        /// <response code="400">If model state is invalid or no image provided</response>
        /// <response code="401">If user is not authenticated or unauthorized</response>
        /// <response code="500">If upload failed</response>
        [HttpPost("upload-image")]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> UploadProfileImage(
            [FromForm] ProfileImageDTO profileImageDto,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(UploadProfileImage);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, profileImageDto.UserId);

                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid model state in {OperationName}", operationName);
                    return BadRequest(new { message = "بيانات غير صالحة", errors = ModelState });
                }

                var userId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(userId) || userId != profileImageDto.UserId)
                {
                    _logger.LogWarning("Unauthorized access in {OperationName}. Current user ID: {CurrentUserId}, Target user ID: {TargetUserId}",
                        operationName, userId, profileImageDto.UserId);
                    return Unauthorized(new { message = "غير مصرح به" });
                }

                var imageUrl = await _profileService.UploadProfileImageAsync(profileImageDto, cancellationToken);

                _logger.LogInformation("Successfully uploaded profile image for user ID: {UserId}. Image URL: {ImageUrl}",
                    profileImageDto.UserId, imageUrl);

                return Ok(new { imageUrl });
            }
            catch (ArgumentException ex)
            {
                _logger.LogWarning(ex, "Invalid argument in {OperationName} for user ID: {UserId}", operationName, profileImageDto.UserId);
                return BadRequest(new { message = ex.Message });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, profileImageDto.UserId);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new { message = "تم إلغاء العملية" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, profileImageDto.UserId);
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = ex.Message });
            }
        }
        #endregion

        #region Instructor Profile Endpoints
        /// <summary>
        /// Retrieves the current instructor's profile
        /// </summary>
        /// <param name="latestCoursesCount">Number of latest courses to include (default: 2)</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The instructor profile if found</returns>
        /// <response code="200">Returns the instructor profile</response>
        /// <response code="401">If user is not authenticated or not an instructor</response>
        /// <response code="404">If profile is not found</response>
        [HttpGet("instructor")]
        [Authorize(Roles = SD.Instructor)]
        [ProducesResponseType(typeof(InstructorProfileDTO), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> GetInstructorProfile(
            [FromQuery] int latestCoursesCount = 2,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetInstructorProfile);

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var userId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("User ID is null or empty in {OperationName}", operationName);
                    return Unauthorized(new { message = "المستخدم غير مصرح به" });
                }

                var profile = await _profileService.GetInstructorProfileAsync(userId, latestCoursesCount, cancellationToken);
                if (profile == null)
                {
                    _logger.LogWarning("Instructor profile not found for user ID: {UserId} in {OperationName}", userId, operationName);
                    return NotFound(new { message = "لم يتم العثور على ملف المدرب" });
                }

                _logger.LogInformation("Successfully retrieved instructor profile for user ID: {UserId}", userId);
                return Ok(profile);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new { message = "تم إلغاء العملية" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "حدث خطأ داخلي في الخادم" });
            }
        }

        /// <summary>
        /// Retrieves a public instructor profile
        /// </summary>
        /// <param name="instructorId">The instructor ID</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The public instructor profile if found</returns>
        /// <response code="200">Returns the public instructor profile</response>
        /// <response code="400">If instructor ID is not provided</response>
        /// <response code="404">If profile is not found</response>
        [HttpGet("public/instructor/{instructorId}")]
        [AllowAnonymous]
        [ProducesResponseType(typeof(InstructorProfileDTO), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> GetPublicInstructorProfile(
            string instructorId,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetPublicInstructorProfile);

            try
            {
                _logger.LogDebug("Starting {OperationName} for instructor ID: {InstructorId}", operationName, instructorId);

                if (string.IsNullOrEmpty(instructorId))
                {
                    _logger.LogWarning("Instructor ID is null or empty in {OperationName}", operationName);
                    return BadRequest(new { message = "معرف المدرب مطلوب" });
                }

                var profile = await _profileService.GetPublishInstructorProfileAsync(instructorId, cancellationToken);
                if (profile == null)
                {
                    _logger.LogWarning("Public instructor profile not found for ID: {InstructorId} in {OperationName}", instructorId, operationName);
                    return NotFound(new { message = "لم يتم العثور على المدرب" });
                }

                _logger.LogInformation("Successfully retrieved public instructor profile for ID: {InstructorId}", instructorId);
                return Ok(profile);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for instructor ID: {InstructorId}", operationName, instructorId);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new { message = "تم إلغاء العملية" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for instructor ID: {InstructorId}", operationName, instructorId);
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "حدث خطأ داخلي في الخادم" });
            }
        }

        /// <summary>
        /// Updates the current instructor's profile
        /// </summary>
        /// <param name="updateProfileDto">The instructor profile data to update</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Success message if update was successful</returns>
        /// <response code="200">If update was successful</response>
        /// <response code="400">If model state is invalid</response>
        /// <response code="401">If user is not authenticated or unauthorized</response>
        /// <response code="500">If update failed</response>
        [HttpPut("instructor")]
        [Authorize(Roles = SD.Instructor)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> UpdateInstructorProfile(
            [FromBody] UpdateInstructorProfileDTO updateProfileDto,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(UpdateInstructorProfile);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, updateProfileDto.Id);

                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid model state in {OperationName}", operationName);
                    return BadRequest(new { message = "بيانات غير صالحة", errors = ModelState });
                }

                var userId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(userId) || userId != updateProfileDto.Id)
                {
                    _logger.LogWarning("Unauthorized access in {OperationName}. Current user ID: {CurrentUserId}, Target user ID: {TargetUserId}",
                        operationName, userId, updateProfileDto.Id);
                    return Unauthorized(new { message = "غير مصرح به" });
                }

                var success = await _profileService.UpdateInstructorProfileAsync(updateProfileDto, cancellationToken);
                if (!success)
                {
                    _logger.LogError("Failed to update instructor profile for user ID: {UserId}", updateProfileDto.Id);
                    return StatusCode(StatusCodes.Status500InternalServerError, new { message = "فشل في تحديث بروفايل المدرب" });
                }

                _logger.LogInformation("Successfully updated instructor profile for user ID: {UserId}", updateProfileDto.Id);
                return Ok(new { message = "تم تحديث بروفايل المدرب بنجاح" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, updateProfileDto.Id);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new { message = "تم إلغاء العملية" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, updateProfileDto.Id);
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "حدث خطأ داخلي في الخادم" });
            }
        }

        /// <summary>
        /// Uploads a profile image for the current instructor
        /// </summary>
        /// <param name="profileImageDto">The image file and user information</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The URL of the uploaded image</returns>
        /// <response code="200">Returns the image URL</response>
        /// <response code="400">If model state is invalid or no image provided</response>
        /// <response code="401">If user is not authenticated or unauthorized</response>
        /// <response code="500">If upload failed</response>
        [HttpPost("instructor/upload-image")]
        [Authorize(Roles = SD.Instructor)]
        [ProducesResponseType(typeof(string), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> UploadInstructorProfileImage(
            [FromForm] ProfileImageDTO profileImageDto,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(UploadInstructorProfileImage);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, profileImageDto.UserId);

                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid model state in {OperationName}", operationName);
                    return BadRequest(new { message = "بيانات غير صالحة", errors = ModelState });
                }

                var userId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(userId) || userId != profileImageDto.UserId)
                {
                    _logger.LogWarning("Unauthorized access in {OperationName}. Current user ID: {CurrentUserId}, Target user ID: {TargetUserId}",
                        operationName, userId, profileImageDto.UserId);
                    return Unauthorized(new { message = "غير مصرح به" });
                }

                var imageUrl = await _profileService.UploadInstructorProfileImageAsync(profileImageDto, cancellationToken);

                _logger.LogInformation("Successfully uploaded instructor profile image for user ID: {UserId}. Image URL: {ImageUrl}",
                    profileImageDto.UserId, imageUrl);

                return Ok(new { imageUrl });
            }
            catch (ArgumentException ex)
            {
                _logger.LogWarning(ex, "Invalid argument in {OperationName} for user ID: {UserId}", operationName, profileImageDto.UserId);
                return BadRequest(new { message = ex.Message });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, profileImageDto.UserId);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new { message = "تم إلغاء العملية" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, profileImageDto.UserId);
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = ex.Message });
            }
        }
        #endregion
            
        #region Certificate Endpoints
        /// <summary>
        /// Adds a new certificate for the current instructor
        /// </summary>
        /// <param name="certificateDto">The certificate data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The added certificate if successful</returns>
        /// <response code="200">Returns the added certificate</response>
        /// <response code="400">If model state is invalid</response>
        /// <response code="401">If user is not authenticated or not an instructor</response>
        /// <response code="500">If addition failed</response>
        [HttpPost("certificates")]
        [Authorize(Roles = SD.Instructor)]
        [ProducesResponseType(typeof(CertificateDTO), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> AddCertificate(
            [FromBody] CertificateDTO certificateDto,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(AddCertificate);

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid model state in {OperationName}", operationName);
                    return BadRequest(new { message = "بيانات غير صالحة", errors = ModelState });
                }

                var userId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("User ID is null or empty in {OperationName}", operationName);
                    return Unauthorized(new { message = "غير مصرح به" });
                }

                var addedCertificate = await _profileService.AddCertificateAsync(userId, certificateDto, cancellationToken);
                if (addedCertificate == null)
                {
                    _logger.LogError("Failed to add certificate for user ID: {UserId}", userId);
                    return StatusCode(StatusCodes.Status500InternalServerError, new { message = "فشل في إضافة الشهادة" });
                }

                _logger.LogInformation("Successfully added certificate for user ID: {UserId}. Certificate ID: {CertificateId}",
                    userId, addedCertificate.Id);
                return Ok(addedCertificate);
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled", operationName);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new { message = "تم إلغاء العملية" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "حدث خطأ داخلي في الخادم" });
            }
        }

        /// <summary>
        /// Deletes a certificate for the current instructor
        /// </summary>
        /// <param name="certId">The certificate ID</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Success message if deletion was successful</returns>
        /// <response code="200">If deletion was successful</response>
        /// <response code="401">If user is not authenticated or not an instructor</response>
        /// <response code="404">If certificate is not found</response>
        [HttpDelete("certificates/{certId}")]
        [Authorize(Roles = SD.Instructor)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> DeleteCertificate(
            int certId,
            CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(DeleteCertificate);

            try
            {
                _logger.LogDebug("Starting {OperationName} for certificate ID: {CertificateId}", operationName, certId);

                var userId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("User ID is null or empty in {OperationName}", operationName);
                    return Unauthorized(new { message = "غير مصرح به" });
                }

                var success = await _profileService.DeleteCertificateAsync(userId, certId, cancellationToken);
                if (!success)
                {
                    _logger.LogWarning("Certificate not found or deletion failed for certificate ID: {CertificateId}, user ID: {UserId}",
                        certId, userId);
                    return NotFound(new { message = "لم يتم العثور على الشهادة" });
                }

                _logger.LogInformation("Successfully deleted certificate ID: {CertificateId} for user ID: {UserId}", certId, userId);
                return Ok(new { message = "تم حذف الشهادة بنجاح" });
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for certificate ID: {CertificateId}", operationName, certId);
                return StatusCode(StatusCodes.Status499ClientClosedRequest, new { message = "تم إلغاء العملية" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for certificate ID: {CertificateId}", operationName, certId);
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "حدث خطأ داخلي في الخادم" });
            }
        }
        #endregion
    }
}