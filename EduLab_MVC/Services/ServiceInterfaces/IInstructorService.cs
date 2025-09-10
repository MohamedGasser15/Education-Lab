using EduLab_MVC.Models.DTOs.Instructor;

namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for handling instructor-related operations in MVC application
    /// </summary>
    public interface IInstructorService
    {
        /// <summary>
        /// Retrieves all instructors from the API asynchronously
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of all instructors</returns>
        Task<List<InstructorDTO>> GetAllInstructorsAsync(CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves a specific instructor by their ID from the API asynchronously
        /// </summary>
        /// <param name="id">The unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Instructor details if found, null otherwise</returns>
        Task<InstructorDTO?> GetInstructorByIdAsync(string id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Retrieves top instructors from the API asynchronously
        /// </summary>
        /// <param name="count">Number of top instructors to retrieve</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of top instructors</returns>
        Task<List<InstructorDTO>> GetTopInstructorsAsync(int count = 4, CancellationToken cancellationToken = default);
    }
}
