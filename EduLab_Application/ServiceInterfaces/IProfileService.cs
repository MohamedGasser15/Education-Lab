using EduLab_Shared.DTOs.Profile;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Interface defining operations for profile management services
    /// </summary>
    public interface IProfileService
    {
        #region User Profile Operations
        /// <summary>
        /// Retrieves a user profile by user ID
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The user profile DTO if found, otherwise null</returns>
        Task<ProfileDTO?> GetUserProfileAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates a user profile
        /// </summary>
        /// <param name="updateProfileDto">The DTO containing updated profile information</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if update was successful, otherwise false</returns>
        Task<bool> UpdateUserProfileAsync(UpdateProfileDTO updateProfileDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Uploads and updates a user's profile image
        /// </summary>
        /// <param name="profileImageDto">The DTO containing image file and user information</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The URL of the uploaded image if successful, otherwise null</returns>
        Task<string?> UploadProfileImageAsync(ProfileImageDTO profileImageDto, CancellationToken cancellationToken = default);
        #endregion

        #region Instructor Profile Operations
        /// <summary>
        /// Retrieves an instructor profile by user ID
        /// </summary>
        /// <param name="userId">The unique identifier of the instructor</param>
        /// <param name="latestCoursesCount">Number of latest courses to include (default: 2)</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The instructor profile DTO if found, otherwise null</returns>
        Task<InstructorProfileDTO?> GetInstructorProfileAsync(string userId, int latestCoursesCount = 2, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a public instructor profile for display
        /// </summary>
        /// <param name="userId">The unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The public instructor profile DTO if found, otherwise null</returns>
        Task<InstructorProfileDTO?> GetPublishInstructorProfileAsync(string userId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates an instructor profile
        /// </summary>
        /// <param name="updateProfileDto">The DTO containing updated instructor profile information</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if update was successful, otherwise false</returns>
        Task<bool> UpdateInstructorProfileAsync(UpdateInstructorProfileDTO updateProfileDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Uploads and updates an instructor's profile image
        /// </summary>
        /// <param name="profileImageDto">The DTO containing image file and user information</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The URL of the uploaded image if successful, otherwise null</returns>
        Task<string?> UploadInstructorProfileImageAsync(ProfileImageDTO profileImageDto, CancellationToken cancellationToken = default);
        #endregion

        #region Certificate Operations
        /// <summary>
        /// Adds a new certificate for an instructor
        /// </summary>
        /// <param name="userId">The unique identifier of the instructor</param>
        /// <param name="certificateDto">The DTO containing certificate information</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The added certificate DTO if successful, otherwise null</returns>
        Task<CertificateDTO?> AddCertificateAsync(string userId, CertificateDTO certificateDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a certificate by ID for a specific user
        /// </summary>
        /// <param name="userId">The unique identifier of the user</param>
        /// <param name="certId">The unique identifier of the certificate</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if deletion was successful, otherwise false</returns>
        Task<bool> DeleteCertificateAsync(string userId, int certId, CancellationToken cancellationToken = default);
        #endregion
    }
}