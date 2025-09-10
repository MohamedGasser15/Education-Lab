using EduLab_Domain.Entities;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    /// <summary>
    /// Interface defining operations for user profile data access
    /// </summary>
    public interface IProfileRepository : IRepository<ApplicationUser>
    {
        #region User Profile Operations
        /// <summary>
        /// Retrieves a user profile by user ID
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The user profile if found, otherwise null</returns>
        Task<ApplicationUser?> GetUserProfileAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates a user profile
        /// </summary>
        /// <param name="user">The user entity with updated information</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if update was successful, otherwise false</returns>
        Task<bool> UpdateUserProfileAsync(ApplicationUser user, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates the profile image URL for a user
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="imageUrl">The new profile image URL</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if update was successful, otherwise false</returns>
        Task<bool> UpdateProfileImageAsync(string userId, string imageUrl, CancellationToken cancellationToken = default);
        #endregion

        #region Instructor Profile Operations
        /// <summary>
        /// Retrieves an instructor profile by user ID with included certificates
        /// </summary>
        /// <param name="userId">The unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The instructor profile if found and user is an instructor, otherwise null</returns>
        Task<ApplicationUser?> GetInstructorProfileAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an instructor profile
        /// </summary>
        /// <param name="user">The instructor entity with updated information</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if update was successful and user is an instructor, otherwise false</returns>
        Task<bool> UpdateInstructorProfileAsync(ApplicationUser user, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates the profile image URL for an instructor
        /// </summary>
        /// <param name="userId">The unique identifier of the instructor</param>
        /// <param name="imageUrl">The new profile image URL</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if update was successful, otherwise false</returns>
        Task<bool> UpdateInstructorProfileImageAsync(string userId, string imageUrl, CancellationToken cancellationToken = default);
        #endregion

        #region Certificate Operations
        /// <summary>
        /// Adds a new certificate for an instructor
        /// </summary>
        /// <param name="certificate">The certificate entity to add</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The added certificate if successful, otherwise null</returns>
        Task<Certificate?> AddCertificateAsync(Certificate certificate, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a certificate by ID for a specific user
        /// </summary>
        /// <param name="certId">The unique identifier of the certificate</param>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if deletion was successful, otherwise false</returns>
        Task<bool> DeleteCertificateAsync(int certId, string userId, CancellationToken cancellationToken = default);
        #endregion
    }
}