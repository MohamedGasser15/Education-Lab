using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Auth;
using EduLab_Shared.DTOs.Instructor;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for instructor-related operations
    /// </summary>
    public class InstructorService : IInstructorService
    {
        #region Private Fields

        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IMapper _mapper;
        private readonly ILogger<InstructorService> _logger;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the <see cref="InstructorService"/> class
        /// </summary>
        /// <param name="userManager">User manager for user operations</param>
        /// <param name="mapper">AutoMapper instance for object mapping</param>
        /// <param name="logger">Logger for logging operations</param>
        public InstructorService(
            UserManager<ApplicationUser> userManager,
            IMapper mapper,
            ILogger<InstructorService> logger)
        {
            _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// Retrieves all instructors from the system asynchronously
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>A list of all instructors wrapped in InstructorListDTO</returns>
        public async Task<InstructorListDTO> GetAllInstructorsAsync(CancellationToken cancellationToken = default)
        {
            const string methodName = nameof(GetAllInstructorsAsync);
            _logger.LogInformation("Starting {MethodName}", methodName);

            try
            {
                var instructors = await _userManager.Users
                    .Include(u => u.CoursesCreated)
                    .AsNoTracking()
                    .ToListAsync(cancellationToken);

                var instructorList = new List<ApplicationUser>();

                foreach (var user in instructors)
                {
                    var roles = await _userManager.GetRolesAsync(user);
                    if (roles.Contains(SD.Instructor))
                    {
                        user.Role = string.Join(", ", roles);
                        instructorList.Add(user);
                    }
                }

                var instructorDTOs = instructorList.Select(instructor => new InstructorDTO
                {
                    Id = instructor.Id,
                    FullName = instructor.FullName,
                    Title = instructor.Title,
                    ProfileImageUrl = instructor.ProfileImageUrl ?? "https://randomuser.me/api/portraits/men/32.jpg",
                    Rating = 4.7, // TODO: Replace with actual rating from Reviews table
                    TotalStudents = 1200, // TODO: Replace with actual count from Enrollments
                    TotalCourses = instructor.CoursesCreated?.Count ?? 0,
                    Location = instructor.Location,
                    About = instructor.About,
                    InstructorSubjects = instructor.Subjects,
                    GitHubUrl = instructor.GitHubUrl,
                    LinkedInUrl = instructor.LinkedInUrl,
                    TwitterUrl = instructor.TwitterUrl,
                    FacebookUrl = instructor.FacebookUrl
                }).ToList();

                _logger.LogInformation("Successfully retrieved {Count} instructors", instructorDTOs.Count);

                return new InstructorListDTO
                {
                    Instructors = instructorDTOs,
                    TotalCount = instructorDTOs.Count
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {MethodName}", methodName);
                throw;
            }
        }

        /// <summary>
        /// Retrieves a specific instructor by their unique identifier asynchronously
        /// </summary>
        /// <param name="id">The unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>InstructorDTO if found, null otherwise</returns>
        public async Task<InstructorDTO?> GetInstructorByIdAsync(string id, CancellationToken cancellationToken = default)
        {
            const string methodName = nameof(GetInstructorByIdAsync);
            _logger.LogInformation("Starting {MethodName} for instructor ID: {InstructorId}", methodName, id);

            if (string.IsNullOrWhiteSpace(id))
            {
                _logger.LogWarning("Invalid instructor ID provided in {MethodName}", methodName);
                return null;
            }

            try
            {
                var instructor = await _userManager.Users
                    .Include(u => u.CoursesCreated)
                    .AsNoTracking()
                    .FirstOrDefaultAsync(u => u.Id == id, cancellationToken);

                if (instructor == null)
                {
                    _logger.LogWarning("Instructor with ID {InstructorId} not found", id);
                    return null;
                }

                var roles = await _userManager.GetRolesAsync(instructor);
                if (!roles.Contains(SD.Instructor))
                {
                    _logger.LogWarning("User with ID {UserId} is not an instructor", id);
                    return null;
                }

                var instructorDTO = new InstructorDTO
                {
                    Id = instructor.Id,
                    FullName = instructor.FullName,
                    Title = instructor.Title,
                    ProfileImageUrl = instructor.ProfileImageUrl ?? "https://randomuser.me/api/portraits/men/32.jpg",
                    Rating = 4.7,
                    TotalStudents = 1200,
                    TotalCourses = instructor.CoursesCreated?.Count ?? 0,
                    Location = instructor.Location,
                    About = instructor.About,
                    InstructorSubjects = instructor.Subjects,
                    GitHubUrl = instructor.GitHubUrl,
                    LinkedInUrl = instructor.LinkedInUrl,
                    TwitterUrl = instructor.TwitterUrl,
                    FacebookUrl = instructor.FacebookUrl
                };

                _logger.LogInformation("Successfully retrieved instructor with ID: {InstructorId}", id);
                return instructorDTO;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {MethodName} for instructor ID: {InstructorId}", methodName, id);
                throw;
            }
        }

        /// <summary>
        /// Retrieves top-rated instructors asynchronously
        /// </summary>
        /// <param name="count">Number of top instructors to retrieve</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of top-rated instructors</returns>
        public async Task<List<InstructorDTO>> GetTopRatedInstructorsAsync(int count, CancellationToken cancellationToken = default)
        {
            const string methodName = nameof(GetTopRatedInstructorsAsync);
            _logger.LogInformation("Starting {MethodName} for {Count} instructors", methodName, count);

            if (count <= 0)
            {
                _logger.LogWarning("Invalid count value {Count} provided in {MethodName}", count, methodName);
                return new List<InstructorDTO>();
            }

            try
            {
                var users = await _userManager.Users
                    .AsNoTracking()
                    .ToListAsync(cancellationToken);

                var instructors = new List<ApplicationUser>();

                foreach (var user in users)
                {
                    var roles = await _userManager.GetRolesAsync(user);
                    if (roles.Contains(SD.Instructor))
                    {
                        user.Role = string.Join(", ", roles);
                        instructors.Add(user);
                    }
                }

                var topInstructors = instructors.Take(count)
                    .Select(instructor => new InstructorDTO
                    {
                        Id = instructor.Id,
                        FullName = instructor.FullName,
                        Title = instructor.Title,
                        ProfileImageUrl = instructor.ProfileImageUrl ?? "https://randomuser.me/api/portraits/men/32.jpg",
                        Rating = 4.7,
                        TotalStudents = 1200,
                        TotalCourses = instructor.CoursesCreated?.Count ?? 0,
                        Location = instructor.Location,
                        About = instructor.About,
                        InstructorSubjects = instructor.Subjects,
                        GitHubUrl = instructor.GitHubUrl,
                        LinkedInUrl = instructor.LinkedInUrl,
                        TwitterUrl = instructor.TwitterUrl,
                        FacebookUrl = instructor.FacebookUrl
                    }).ToList();

                _logger.LogInformation("Successfully retrieved {Count} top instructors", topInstructors.Count);
                return topInstructors;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {MethodName}", methodName);
                throw;
            }
        }

        #endregion
    }
}