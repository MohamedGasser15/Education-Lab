using AutoMapper;
using EduLab_Application.DTOs.Settings;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using Microsoft.Extensions.Logging;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for managing site-wide settings
    /// </summary>
    public class SiteSettingsService : ISiteSettingsService
    {
        private readonly IRepository<SiteSettings> _repository;
        private readonly IMapper _mapper;
        private readonly ILogger<SiteSettingsService> _logger;

        public SiteSettingsService(
            IRepository<SiteSettings> repository,
            IMapper mapper,
            ILogger<SiteSettingsService> logger)
        {
            _repository = repository ?? throw new ArgumentNullException(nameof(repository));
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        /// <summary>
        /// Retrieves the site settings, creating defaults if none exist
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The site settings DTO</returns>
        public async Task<SiteSettingsDTO?> GetSettingsAsync(CancellationToken cancellationToken = default)
        {
            const string operationName = "GetSettingsAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var settings = await _repository.GetAsync(
                    filter: s => s.Id == 1,
                    isTracking: false,
                    cancellationToken: cancellationToken);

                if (settings == null)
                {
                    _logger.LogWarning("Site settings not found, creating defaults in {OperationName}", operationName);
                    settings = new SiteSettings();
                    await _repository.CreateAsync(settings, cancellationToken);
                    await _repository.SaveAsync(cancellationToken);
                }

                _logger.LogInformation("Successfully retrieved site settings in {OperationName}", operationName);
                return _mapper.Map<SiteSettingsDTO>(settings);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                throw;
            }
        }

        /// <summary>
        /// Updates the site settings
        /// </summary>
        /// <param name="dto">The new settings values</param>
        /// <param name="updatedBy">Unique identifier of the admin performing the update</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the settings were updated, otherwise false</returns>
        public async Task<bool> UpdateSettingsAsync(SiteSettingsDTO dto, string? updatedBy = null, CancellationToken cancellationToken = default)
        {
            const string operationName = "UpdateSettingsAsync";

            try
            {
                _logger.LogDebug("Starting {OperationName}", operationName);

                var settings = await _repository.GetAsync(
                    filter: s => s.Id == 1,
                    isTracking: true,
                    cancellationToken: cancellationToken);

                if (settings == null)
                {
                    _logger.LogWarning("Site settings not found, creating new in {OperationName}", operationName);
                    settings = new SiteSettings();
                }

                _mapper.Map(dto, settings);
                settings.UpdatedAt = DateTime.UtcNow;
                settings.UpdatedBy = updatedBy;

                if (settings.Id == 0)
                    await _repository.CreateAsync(settings, cancellationToken);
                else
                    await _repository.SaveAsync(cancellationToken);

                _logger.LogInformation("Successfully updated site settings in {OperationName}", operationName);
                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName}", operationName);
                throw;
            }
        }
    }
}
