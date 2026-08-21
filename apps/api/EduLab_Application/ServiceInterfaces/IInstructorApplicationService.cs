using EduLab_Application.DTOs.InstructorApplication;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for managing instructor applications
    /// </summary>
    public interface IInstructorApplicationService
    {
        /// <summary>
        /// Submits a new instructor application for a user
        /// </summary>
        /// <param name="applicationDto">The application details</param>
        /// <param name="userId">Unique identifier of the applicant</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Success flag with a result message</returns>
        Task<(bool Success, string Message)> SubmitApplication(
            InstructorApplicationDTO applicationDto,
            string userId,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves all applications submitted by a user
        /// </summary>
        /// <param name="userId">Unique identifier of the user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of the user's applications</returns>
        Task<List<InstructorApplicationResponseDto>> GetUserApplications(
            string userId,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the details of a specific application
        /// </summary>
        /// <param name="userId">Unique identifier of the owner</param>
        /// <param name="applicationId">Unique identifier of the application</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The application details</returns>
        Task<InstructorApplicationResponseDto> GetApplicationDetails(
            string userId,
            string applicationId,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves all applications for the admin review
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of all applications with admin view data</returns>
        Task<List<AdminInstructorApplicationDto>> GetAllApplicationsForAdmin(
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Approves an instructor application
        /// </summary>
        /// <param name="applicationId">Unique identifier of the application</param>
        /// <param name="reviewedByUserId">Unique identifier of the reviewing admin</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Success flag with a result message</returns>
        Task<(bool Success, string Message)> ApproveApplication(
            string applicationId,
            string reviewedByUserId,
            CancellationToken cancellationToken = default);

        /// <summary>
        /// Rejects an instructor application
        /// </summary>
        /// <param name="applicationId">Unique identifier of the application</param>
        /// <param name="reviewedByUserId">Unique identifier of the reviewing admin</param>
        /// <param name="rejectionReason">Reason for the rejection</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Success flag with a result message</returns>
        Task<(bool Success, string Message)> RejectApplication(
            string applicationId,
            string reviewedByUserId,
            string? rejectionReason = null,
            CancellationToken cancellationToken = default);
    }
}