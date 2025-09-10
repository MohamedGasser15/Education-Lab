using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using EduLab_Infrastructure.Persistence.Repositories;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    /// <summary>
    /// Repository implementation for profile-related data operations
    /// </summary>
    public class ProfileRepository : Repository<ApplicationUser>, IProfileRepository
    {
        #region Fields
        private readonly ApplicationDbContext _db;
        private readonly ILogger<ProfileRepository> _logger;
        #endregion

        #region Constructor
        /// <summary>
        /// Initializes a new instance of the ProfileRepository class
        /// </summary>
        /// <param name="db">Application database context</param>
        /// <param name="logger">Logger instance for logging operations</param>
        public ProfileRepository(ApplicationDbContext db, ILogger<ProfileRepository> logger)
            : base(db, logger)
        {
            _db = db ?? throw new ArgumentNullException(nameof(db));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }
        #endregion

        #region User Profile Operations
        /// <inheritdoc/>
        public async Task<ApplicationUser?> GetUserProfileAsync(string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetUserProfileAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("User ID is null or empty in {OperationName}", operationName);
                    return null;
                }

                var user = await _db.Users
                    .AsNoTracking()
                    .FirstOrDefaultAsync(u => u.Id == userId, cancellationToken);

                if (user == null)
                {
                    _logger.LogWarning("User not found with ID: {UserId} in {OperationName}", userId, operationName);
                }
                else
                {
                    _logger.LogDebug("Successfully retrieved user profile for ID: {UserId}", userId);
                }

                return user;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, userId);
                throw;
            }
        }

        /// <inheritdoc/>
        public async Task<bool> UpdateUserProfileAsync(ApplicationUser user, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(UpdateUserProfileAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, user.Id);

                if (user == null)
                {
                    _logger.LogWarning("User entity is null in {OperationName}", operationName);
                    return false;
                }

                // التحقق مما إذا كان الكيان مُتتبعًا بالفعل
                var existingUser = await _db.Users.FindAsync(new object[] { user.Id }, cancellationToken);
                if (existingUser == null)
                {
                    _logger.LogWarning("User not found with ID: {UserId} in {OperationName}", user.Id, operationName);
                    return false;
                }

                // تحديث الخصائص فقط دون إرفاق الكيان
                _db.Entry(existingUser).CurrentValues.SetValues(user);

                var changes = await _db.SaveChangesAsync(cancellationToken);

                var success = changes > 0;
                _logger.LogInformation("User profile update {Status} for user ID: {UserId}. Changes: {Changes}",
                    success ? "succeeded" : "failed", user.Id, changes);

                return success;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, user.Id);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, user.Id);
                throw;
            }
        }

        /// <inheritdoc/>
        public async Task<bool> UpdateProfileImageAsync(string userId, string imageUrl, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(UpdateProfileImageAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("User ID is null or empty in {OperationName}", operationName);
                    return false;
                }

                var user = await _db.Users.FindAsync(new object[] { userId }, cancellationToken);
                if (user == null)
                {
                    _logger.LogWarning("User not found with ID: {UserId} in {OperationName}", userId, operationName);
                    return false;
                }

                user.ProfileImageUrl = imageUrl;
                _db.Users.Update(user);
                var changes = await _db.SaveChangesAsync(cancellationToken);

                var success = changes > 0;
                _logger.LogInformation("Profile image update {Status} for user ID: {UserId}. Changes: {Changes}",
                    success ? "succeeded" : "failed", userId, changes);

                return success;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, userId);
                throw;
            }
        }
        #endregion

        #region Instructor Profile Operations
        /// <inheritdoc/>
        public async Task<ApplicationUser?> GetInstructorProfileAsync(string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(GetInstructorProfileAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, userId);

                if (string.IsNullOrEmpty(userId))
                {
                    _logger.LogWarning("User ID is null or empty in {OperationName}", operationName);
                    return null;
                }

                var user = await _db.Users
                    .AsNoTracking()
                    .Include(u => u.Certificates)
                    .FirstOrDefaultAsync(u => u.Id == userId, cancellationToken);

                if (user == null)
                {
                    _logger.LogWarning("Instructor not found with ID: {UserId} in {OperationName}", userId, operationName);
                    return null;
                }

                _logger.LogDebug("Successfully retrieved instructor profile for ID: {UserId}", userId);
                return user;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, userId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, userId);
                throw;
            }
        }

        /// <inheritdoc/>
        public async Task<bool> UpdateInstructorProfileAsync(ApplicationUser user, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(UpdateInstructorProfileAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, user.Id);

                if (user == null)
                {
                    _logger.LogWarning("User entity is null in {OperationName}", operationName);
                    return false;
                }

                // التحقق مما إذا كان الكيان مُتتبعًا بالفعل
                var existingUser = await _db.Users
                    .Include(u => u.Certificates)
                    .FirstOrDefaultAsync(u => u.Id == user.Id, cancellationToken);

                if (existingUser == null)
                {
                    _logger.LogWarning("Instructor not found with ID: {UserId} in {OperationName}", user.Id, operationName);
                    return false;
                }

                // تحديث الخصائص الأساسية
                existingUser.FullName = user.FullName;
                existingUser.Title = user.Title;
                existingUser.Location = user.Location;
                existingUser.PhoneNumber = user.PhoneNumber;
                existingUser.About = user.About;
                existingUser.GitHubUrl = user.GitHubUrl;
                existingUser.LinkedInUrl = user.LinkedInUrl;
                existingUser.TwitterUrl = user.TwitterUrl;
                existingUser.FacebookUrl = user.FacebookUrl;
                existingUser.Subjects = user.Subjects;

                var changes = await _db.SaveChangesAsync(cancellationToken);

                var success = changes > 0;
                _logger.LogInformation("Instructor profile update {Status} for user ID: {UserId}. Changes: {Changes}",
                    success ? "succeeded" : "failed", user.Id, changes);

                return success;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, user.Id);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, user.Id);
                throw;
            }
        }

        /// <inheritdoc/>
        public async Task<bool> UpdateInstructorProfileImageAsync(string userId, string imageUrl, CancellationToken cancellationToken = default)
        {
            return await UpdateProfileImageAsync(userId, imageUrl, cancellationToken);
        }
        #endregion

        #region Certificate Operations
        /// <inheritdoc/>
        public async Task<Certificate?> AddCertificateAsync(Certificate certificate, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(AddCertificateAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName} for user ID: {UserId}", operationName, certificate.UserId);

                if (certificate == null)
                {
                    _logger.LogWarning("Certificate entity is null in {OperationName}", operationName);
                    return null;
                }

                await _db.Certificates.AddAsync(certificate, cancellationToken);
                var changes = await _db.SaveChangesAsync(cancellationToken);

                if (changes > 0)
                {
                    _logger.LogInformation("Successfully added certificate for user ID: {UserId}. Certificate ID: {CertificateId}",
                        certificate.UserId, certificate.Id);
                    return certificate;
                }

                _logger.LogWarning("Failed to add certificate for user ID: {UserId}", certificate.UserId);
                return null;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for user ID: {UserId}", operationName, certificate.UserId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for user ID: {UserId}", operationName, certificate.UserId);
                throw;
            }
        }

        /// <inheritdoc/>
        public async Task<bool> DeleteCertificateAsync(int certId, string userId, CancellationToken cancellationToken = default)
        {
            const string operationName = nameof(DeleteCertificateAsync);

            try
            {
                _logger.LogDebug("Starting {OperationName} for certificate ID: {CertificateId}, user ID: {UserId}",
                    operationName, certId, userId);

                var certificate = await _db.Certificates
                    .FirstOrDefaultAsync(c => c.Id == certId && c.UserId == userId, cancellationToken);

                if (certificate == null)
                {
                    _logger.LogWarning("Certificate not found with ID: {CertificateId} for user ID: {UserId}", certId, userId);
                    return false;
                }

                _db.Certificates.Remove(certificate);
                var changes = await _db.SaveChangesAsync(cancellationToken);

                var success = changes > 0;
                _logger.LogInformation("Certificate deletion {Status} for certificate ID: {CertificateId}, user ID: {UserId}",
                    success ? "succeeded" : "failed", certId, userId);

                return success;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {OperationName} was cancelled for certificate ID: {CertificateId}", operationName, certId);
                throw;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {OperationName} for certificate ID: {CertificateId}", operationName, certId);
                throw;
            }
        }
        #endregion
    }
}