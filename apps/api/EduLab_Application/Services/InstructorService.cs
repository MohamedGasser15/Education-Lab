using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab_Application.DTOs.Auth;
using EduLab_Application.DTOs.Instructor;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using EduLab_Application.Common.Constants;

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
        private readonly IRatingRepository _ratingRepository;
        private readonly IMemoryCache? _cache;
        private const string AllInstructorsCacheKey = "Api_All_Instructors";
        private static readonly TimeSpan CacheDuration = TimeSpan.FromMinutes(10);

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the <see cref="InstructorService"/> class
        /// </summary>
        /// <param name="userManager">User manager for user operations</param>
        /// <param name="mapper">AutoMapper instance for object mapping</param>
        /// <param name="logger">Logger for logging operations</param>
        /// <param name="ratingRepository">Rating repository for instructor ratings</param>
        /// <param name="cache">Optional memory cache instance</param>
        public InstructorService(
            UserManager<ApplicationUser> userManager,
            IMapper mapper,
            ILogger<InstructorService> logger,
            IRatingRepository ratingRepository,
            IMemoryCache? cache = null)
        {
            _userManager = userManager ?? throw new ArgumentNullException(nameof(userManager));
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _ratingRepository = ratingRepository ?? throw new ArgumentNullException(nameof(ratingRepository));
            _cache = cache;
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// Computes the average rating of all courses belonging to an instructor
        /// </summary>
        private async Task<double> GetInstructorRatingAsync(string instructorId, CancellationToken cancellationToken = default)
        {
            var ratings = await _ratingRepository.GetAllAsync(
                r => r.Course.InstructorId == instructorId,
                isTracking: false,
                cancellationToken: cancellationToken);

            return ratings.Count == 0 ? 0 : Math.Round(ratings.Average(r => r.Value), 1);
        }

        /// <summary>
        /// Computes average ratings for a batch of instructors in a single database query
        /// </summary>
        private async Task<Dictionary<string, double>> GetInstructorRatingsBatchAsync(List<string> instructorIds, CancellationToken cancellationToken = default)
        {
            if (instructorIds == null || !instructorIds.Any())
                return new Dictionary<string, double>();

            var ratings = await _ratingRepository.GetAllAsync(
                r => instructorIds.Contains(r.Course.InstructorId),
                includeProperties: "Course",
                isTracking: false,
                cancellationToken: cancellationToken);

            return ratings
                .Where(r => r.Course != null && !string.IsNullOrEmpty(r.Course.InstructorId))
                .GroupBy(r => r.Course.InstructorId)
                .ToDictionary(g => g.Key, g => Math.Round(g.Average(r => r.Value), 1));
        }

        /// <summary>
        /// Resolves all instructor users with their created courses using a single role query when available
        /// </summary>
        private async Task<List<ApplicationUser>> GetInstructorUsersWithCoursesAsync(CancellationToken cancellationToken = default)
        {
            var roleUsers = await _userManager.GetUsersInRoleAsync(SD.Instructor);
            if (roleUsers != null && roleUsers.Count > 0)
            {
                var instructorIds = roleUsers.Select(u => u.Id).ToList();
                var instructorsWithCourses = await _userManager.Users
                    .Where(u => instructorIds.Contains(u.Id))
                    .Include(u => u.CoursesCreated)
                    .AsNoTracking()
                    .ToListAsync(cancellationToken);

                foreach (var user in instructorsWithCourses)
                {
                    user.Role = SD.Instructor;
                }

                return instructorsWithCourses;
            }

            var users = await _userManager.Users
                .Include(u => u.CoursesCreated)
                .AsNoTracking()
                .ToListAsync(cancellationToken);

            var instructorList = new List<ApplicationUser>();
            foreach (var user in users)
            {
                var roles = await _userManager.GetRolesAsync(user);
                if (roles.Contains(SD.Instructor))
                {
                    user.Role = string.Join(", ", roles);
                    instructorList.Add(user);
                }
            }

            return instructorList;
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

            if (_cache != null && _cache.TryGetValue(AllInstructorsCacheKey, out InstructorListDTO? cached) && cached != null)
            {
                return cached;
            }

            try
            {
                var instructorList = await GetInstructorUsersWithCoursesAsync(cancellationToken);
                var instructorIds = instructorList.Select(i => i.Id).ToList();

                var studentsPerInstructor = await GetStudentsPerInstructorAsync(cancellationToken);
                var ratingsPerInstructor = await GetInstructorRatingsBatchAsync(instructorIds, cancellationToken);

                var instructorDTOs = new List<InstructorDTO>(instructorList.Count);

                foreach (var instructor in instructorList)
                {
                    instructorDTOs.Add(new InstructorDTO
                    {
                        Id = instructor.Id,
                        FullName = instructor.FullName,
                        Title = instructor.Title,
                        ProfileImageUrl = instructor.ProfileImageUrl,
                        Rating = ratingsPerInstructor.GetValueOrDefault(instructor.Id),
                        TotalStudents = studentsPerInstructor.GetValueOrDefault(instructor.Id),
                        TotalCourses = instructor.CoursesCreated?.Count(c => c.Status == Coursestatus.Approved) 
                            ?? instructor.CoursesCreated?.Count 
                            ?? 0,
                        Location = instructor.Location,
                        About = instructor.About,
                        InstructorSubjects = instructor.Subjects,
                        GitHubUrl = instructor.GitHubUrl,
                        LinkedInUrl = instructor.LinkedInUrl,
                        TwitterUrl = instructor.TwitterUrl,
                        FacebookUrl = instructor.FacebookUrl
                    });
                }

                _logger.LogInformation("Successfully retrieved {Count} instructors", instructorDTOs.Count);

                var result = new InstructorListDTO
                {
                    Instructors = instructorDTOs,
                    TotalCount = instructorDTOs.Count
                };

                _cache?.Set(AllInstructorsCacheKey, result, CacheDuration);
                return result;
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
                    ProfileImageUrl = instructor.ProfileImageUrl,
                    Rating = await GetInstructorRatingAsync(instructor.Id, cancellationToken),
                    TotalStudents = (await GetStudentsPerInstructorAsync(cancellationToken)).GetValueOrDefault(instructor.Id),
                    TotalCourses = instructor.CoursesCreated?.Count(c => c.Status == Coursestatus.Approved) 
                        ?? instructor.CoursesCreated?.Count 
                        ?? 0,
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

            var topCacheKey = $"Api_Top_Instructors_{count}";
            if (_cache != null && _cache.TryGetValue(topCacheKey, out List<InstructorDTO>? cachedTop) && cachedTop != null)
            {
                return cachedTop;
            }

            try
            {
                var instructors = await GetInstructorUsersWithCoursesAsync(cancellationToken);
                var instructorIds = instructors.Select(i => i.Id).ToList();

                var studentsPerInstructor = await GetStudentsPerInstructorAsync(cancellationToken);
                var ratingsPerInstructor = await GetInstructorRatingsBatchAsync(instructorIds, cancellationToken);

                var instructorDTOs = new List<InstructorDTO>(instructors.Count);
                foreach (var instructor in instructors)
                {
                    var rating = ratingsPerInstructor.GetValueOrDefault(instructor.Id);
                    var totalCourses = instructor.CoursesCreated?.Count(c => c.Status == Coursestatus.Approved) 
                        ?? instructor.CoursesCreated?.Count 
                        ?? 0;

                    instructorDTOs.Add(new InstructorDTO
                    {
                        Id = instructor.Id,
                        FullName = instructor.FullName,
                        Title = instructor.Title,
                        ProfileImageUrl = instructor.ProfileImageUrl,
                        Rating = rating,
                        TotalStudents = studentsPerInstructor.GetValueOrDefault(instructor.Id),
                        TotalCourses = totalCourses,
                        Location = instructor.Location,
                        About = instructor.About,
                        InstructorSubjects = instructor.Subjects,
                        GitHubUrl = instructor.GitHubUrl,
                        LinkedInUrl = instructor.LinkedInUrl,
                        TwitterUrl = instructor.TwitterUrl,
                        FacebookUrl = instructor.FacebookUrl
                    });
                }

                // Rank the instructors by Rating descending, then TotalCourses descending, then TotalStudents
                var topInstructors = instructorDTOs
                    .OrderByDescending(i => i.Rating)
                    .ThenByDescending(i => i.TotalCourses)
                    .ThenByDescending(i => i.TotalStudents)
                    .Take(count)
                    .ToList();

                _cache?.Set(topCacheKey, topInstructors, CacheDuration);
                _logger.LogInformation("Successfully retrieved {Count} top instructors", topInstructors.Count);
                return topInstructors;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred in {MethodName}", methodName);
                throw;
            }
        }

        /// <summary>
        /// Counts DISTINCT students enrolled in each instructor's courses (one batched query).
        /// </summary>
        private async Task<Dictionary<string, int>> GetStudentsPerInstructorAsync(CancellationToken cancellationToken = default)
        {
            var pairs = await _userManager.Users
                .SelectMany(u => u.Enrollments.Select(e => new { StudentId = u.Id, InstructorId = e.Course.InstructorId }))
                .AsNoTracking()
                .ToListAsync(cancellationToken);

            return pairs
                .Where(p => !string.IsNullOrEmpty(p.InstructorId))
                .GroupBy(p => p.InstructorId!)
                .ToDictionary(g => g.Key, g => g.Select(p => p.StudentId).Distinct().Count());
        }

        #endregion
    }
}