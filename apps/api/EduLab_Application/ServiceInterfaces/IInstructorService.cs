using EduLab_Application.DTOs.Instructor;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    /// <summary>
    /// Service interface for retrieving instructor information
    /// </summary>
    public interface IInstructorService
    {
        /// <summary>
        /// Retrieves all instructors
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of instructors with summary data</returns>
        Task<InstructorListDTO> GetAllInstructorsAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves an instructor by their user ID
        /// </summary>
        /// <param name="id">Unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Instructor DTO or null if not found</returns>
        Task<InstructorDTO?> GetInstructorByIdAsync(string id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves the top-rated instructors
        /// </summary>
        /// <param name="count">Maximum number of instructors to return</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of top-rated instructor DTOs</returns>
        Task<List<InstructorDTO>> GetTopRatedInstructorsAsync(int count, CancellationToken cancellationToken = default);
    }
}