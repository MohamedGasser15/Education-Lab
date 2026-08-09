using EduLab_Application.DTOs.Certificates;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Learner
{
    /// <summary>
    /// API Controller for course certificates
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Produces("application/json")]
    public class CertificatesController : ControllerBase
    {
        private readonly ICertificateService _certificateService;
        private readonly ICurrentUserService _currentUserService;
        private readonly ILogger<CertificatesController> _logger;

        public CertificatesController(
            ICertificateService certificateService,
            ICurrentUserService currentUserService,
            ILogger<CertificatesController> logger)
        {
            _certificateService = certificateService;
            _currentUserService = currentUserService;
            _logger = logger;
        }

        /// <summary>
        /// Retrieves all certificates earned by the current user
        /// </summary>
        [HttpGet("my")]
        [Authorize]
        public async Task<ActionResult> GetMyCertificates(CancellationToken cancellationToken = default)
        {
            try
            {
                var userId = await _currentUserService.GetUserIdAsync();
                if (string.IsNullOrEmpty(userId))
                {
                    return Unauthorized(new { Message = "User not identified." });
                }

                var certificates = await _certificateService.GetMyCertificatesAsync(userId, cancellationToken);
                return Ok(certificates);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving certificates for current user");
                return StatusCode(500, new { Message = "An unexpected error occurred while retrieving certificates." });
            }
        }

        /// <summary>
        /// Public certificate verification by code
        /// </summary>
        [HttpGet("verify/{code}")]
        [AllowAnonymous]
        public async Task<ActionResult> Verify(string code, CancellationToken cancellationToken = default)
        {
            try
            {
                var certificate = await _certificateService.GetByCodeAsync(code, cancellationToken);
                if (certificate == null)
                {
                    return NotFound(new { Message = "Certificate not found or code is invalid." });
                }

                return Ok(new
                {
                    Valid = true,
                    certificate.StudentName,
                    certificate.CourseTitle,
                    certificate.IssuedDate,
                    certificate.CertificateCode
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error verifying certificate {Code}", code);
                return StatusCode(500, new { Message = "An unexpected error occurred while verifying the certificate." });
            }
        }

        /// <summary>
        /// Downloads the certificate PDF by code
        /// </summary>
        [HttpGet("download/{code}")]
        [AllowAnonymous]
        public async Task<ActionResult> Download(string code, CancellationToken cancellationToken = default)
        {
            try
            {
                var certificate = await _certificateService.GetByCodeAsync(code, cancellationToken);
                if (certificate == null)
                {
                    return NotFound(new { Message = "Certificate not found or code is invalid." });
                }

                var filePath = _certificateService.GetCertificateFilePath(code);
                if (!System.IO.File.Exists(filePath))
                {
                    return NotFound(new { Message = "Certificate file not found." });
                }

                var bytes = await System.IO.File.ReadAllBytesAsync(filePath, cancellationToken);
                return File(bytes, "image/png", $"EduLab_Certificate_{code}.png");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error downloading certificate {Code}", code);
                return StatusCode(500, new { Message = "An unexpected error occurred while downloading the certificate." });
            }
        }
    }
}
