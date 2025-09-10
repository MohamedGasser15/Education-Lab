using EduLab_MVC.Models.DTOs.Profile;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for managing user profiles in MVC application
    /// </summary>
    public interface IProfileService
    {
        #region User Profile Operations

        /// <summary>
        /// Retrieves the current user's profile
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The user profile if found, otherwise null</returns>
        Task<ProfileDTO?> GetProfileAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates the current user's profile
        /// </summary>
        /// <param name="updateProfileDto">The profile data to update</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if update was successful, otherwise false</returns>
        Task<bool> UpdateProfileAsync(UpdateProfileDTO updateProfileDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a public instructor profile
        /// </summary>
        /// <param name="instructorId">The instructor ID</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The public instructor profile if found, otherwise null</returns>
        Task<InstructorProfileDTO?> GetPublicInstructorProfileAsync(string instructorId, CancellationToken cancellationToken = default);

        /// <summary>
        /// Uploads a profile image for the current user
        /// </summary>
        /// <param name="imageFile">The image file to upload</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The URL of the uploaded image if successful, otherwise null</returns>
        Task<string?> UploadProfileImageAsync(IFormFile imageFile, CancellationToken cancellationToken = default);

        #endregion

        #region Instructor Profile Operations

        /// <summary>
        /// Retrieves the current instructor's profile
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The instructor profile if found, otherwise null</returns>
        Task<InstructorProfileDTO?> GetInstructorProfileAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Updates the current instructor's profile
        /// </summary>
        /// <param name="updateProfileDto">The instructor profile data to update</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if update was successful, otherwise false</returns>
        Task<bool> UpdateInstructorProfileAsync(UpdateInstructorProfileDTO updateProfileDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Uploads a profile image for the current instructor
        /// </summary>
        /// <param name="imageFile">The image file to upload</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The URL of the uploaded image if successful, otherwise null</returns>
        Task<string?> UploadInstructorProfileImageAsync(IFormFile imageFile, CancellationToken cancellationToken = default);

        #endregion

        #region Certificate Operations

        /// <summary>
        /// Adds a new certificate for the current instructor
        /// </summary>
        /// <param name="certificateDto">The certificate data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The added certificate if successful, otherwise null</returns>
        Task<CertificateDTO?> AddCertificateAsync(CertificateDTO certificateDto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Deletes a certificate for the current instructor
        /// </summary>
        /// <param name="certId">The certificate ID</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if deletion was successful, otherwise false</returns>
        Task<bool> DeleteCertificateAsync(int certId, CancellationToken cancellationToken = default);

        #endregion
    }
}
