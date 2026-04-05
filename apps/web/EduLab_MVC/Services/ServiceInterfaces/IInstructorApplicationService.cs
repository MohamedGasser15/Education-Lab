using EduLab_MVC.Models.DTOs.Instructor;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for handling instructor application operations in MVC
    /// </summary>
    public interface IInstructorApplicationService
    {
        #region User Endpoints

        /// <summary>
        /// Submits a new instructor application
        /// </summary>
        /// <param name="dto">Application data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation result message</returns>
        Task<string> ApplyAsync(InstructorApplicationDTO dto, CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets all applications for the current user
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of user applications or null if failed</returns>
        Task<List<InstructorApplicationResponseDto>?> GetMyApplicationsAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets application details by ID for the current user
        /// </summary>
        /// <param name="id">Application identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Application details or null if failed</returns>
        Task<InstructorApplicationResponseDto?> GetApplicationDetailsAsync(string id, CancellationToken cancellationToken = default);

        #endregion

        #region Admin Endpoints

        /// <summary>
        /// Gets all applications for admin review
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of all applications or null if failed</returns>
        Task<List<AdminInstructorApplicationDto>?> GetAllApplicationsAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Gets application details by ID for admin
        /// </summary>
        /// <param name="id">Application identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Application details or null if failed</returns>
        Task<AdminInstructorApplicationDto?> GetApplicationDetailsAdminAsync(string id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Approves an instructor application
        /// </summary>
        /// <param name="id">Application identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation result message</returns>
        Task<string> ApproveApplicationAsync(string id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Rejects an instructor application
        /// </summary>
        /// <param name="id">Application identifier</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Operation result message</returns>
        Task<string> RejectApplicationAsync(string id, CancellationToken cancellationToken = default);

        #endregion
    }
}
