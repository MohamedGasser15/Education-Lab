using EduLab_Application.DTOs.Legal;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Learner
{
    /// <summary>
    /// Controller providing platform info, privacy policy, and terms of service for web and mobile clients
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [AllowAnonymous]
    public class LegalController : ControllerBase
    {
        private readonly ILegalService _legalService;
        private readonly ILogger<LegalController> _logger;

        public LegalController(ILegalService legalService, ILogger<LegalController> logger)
        {
            _legalService = legalService ?? throw new ArgumentNullException(nameof(legalService));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        /// <summary>
        /// Gets "About Us / About EduLab" information
        /// </summary>
        /// <param name="language">Language code ('ar' or 'en'). Defaults to client Accept-Language or 'en'</param>
        /// <param name="cancellationToken">Cancellation token</param>
        [HttpGet("about")]
        [ProducesResponseType(typeof(LegalContentDto), 200)]
        public async Task<ActionResult<LegalContentDto>> GetAbout([FromQuery] string? language = null, CancellationToken cancellationToken = default)
        {
            var effectiveLang = language ?? Request.Headers["Accept-Language"].ToString();
            var result = await _legalService.GetAboutInfoAsync(effectiveLang, cancellationToken);
            return Ok(result);
        }

        /// <summary>
        /// Gets the Privacy Policy document
        /// </summary>
        /// <param name="language">Language code ('ar' or 'en')</param>
        /// <param name="cancellationToken">Cancellation token</param>
        [HttpGet("privacy-policy")]
        [ProducesResponseType(typeof(LegalContentDto), 200)]
        public async Task<ActionResult<LegalContentDto>> GetPrivacyPolicy([FromQuery] string? language = null, CancellationToken cancellationToken = default)
        {
            var effectiveLang = language ?? Request.Headers["Accept-Language"].ToString();
            var result = await _legalService.GetPrivacyPolicyAsync(effectiveLang, cancellationToken);
            return Ok(result);
        }

        /// <summary>
        /// Gets the Terms of Service document
        /// </summary>
        /// <param name="language">Language code ('ar' or 'en')</param>
        /// <param name="cancellationToken">Cancellation token</param>
        [HttpGet("terms")]
        [ProducesResponseType(typeof(LegalContentDto), 200)]
        public async Task<ActionResult<LegalContentDto>> GetTerms([FromQuery] string? language = null, CancellationToken cancellationToken = default)
        {
            var effectiveLang = language ?? Request.Headers["Accept-Language"].ToString();
            var result = await _legalService.GetTermsOfServiceAsync(effectiveLang, cancellationToken);
            return Ok(result);
        }

        /// <summary>
        /// Gets all legal & platform documents at once (About, Privacy, Terms)
        /// </summary>
        /// <param name="language">Language code ('ar' or 'en')</param>
        /// <param name="cancellationToken">Cancellation token</param>
        [HttpGet("all")]
        [ProducesResponseType(typeof(Dictionary<string, LegalContentDto>), 200)]
        public async Task<ActionResult<Dictionary<string, LegalContentDto>>> GetAll([FromQuery] string? language = null, CancellationToken cancellationToken = default)
        {
            var effectiveLang = language ?? Request.Headers["Accept-Language"].ToString();
            var result = await _legalService.GetAllLegalInfoAsync(effectiveLang, cancellationToken);
            return Ok(result);
        }
    }
}
