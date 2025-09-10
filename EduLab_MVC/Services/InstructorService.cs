using EduLab_MVC.Models.DTOs.Instructor;
using EduLab_MVC.Services.ServiceInterfaces;
using Newtonsoft.Json;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// Service for handling instructor-related operations in MVC application
    /// </summary>
    public class InstructorService : IInstructorService
    {
        #region Private Fields

        private readonly IHttpClientFactory _clientFactory;
        private readonly ILogger<InstructorService> _logger;
        private readonly IAuthorizedHttpClientService _httpClientService;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the <see cref="InstructorService"/> class
        /// </summary>
        /// <param name="clientFactory">HTTP client factory for creating HTTP clients</param>
        /// <param name="logger">Logger for logging operations</param>
        /// <param name="httpClientService">Authorized HTTP client service</param>
        public InstructorService(
            IHttpClientFactory clientFactory,
            ILogger<InstructorService> logger,
            IAuthorizedHttpClientService httpClientService)
        {
            _clientFactory = clientFactory ?? throw new ArgumentNullException(nameof(clientFactory));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _httpClientService = httpClientService ?? throw new ArgumentNullException(nameof(httpClientService));
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// Retrieves all instructors from the API asynchronously
        /// </summary>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of all instructors</returns>
        public async Task<List<InstructorDTO>> GetAllInstructorsAsync(CancellationToken cancellationToken = default)
        {
            const string methodName = nameof(GetAllInstructorsAsync);
            _logger.LogInformation("Starting {MethodName}", methodName);

            try
            {
                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.GetAsync("Instructor", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var instructorList = JsonConvert.DeserializeObject<InstructorListDTO>(content);

                    var instructors = instructorList?.Instructors ?? new List<InstructorDTO>();

                    FixProfileImageUrls(instructors);
                    _logger.LogInformation("Successfully retrieved {Count} instructors", instructors.Count);
                    return instructors;
                }

                _logger.LogWarning("Failed to get instructors. Status code: {StatusCode}", response.StatusCode);
                return new List<InstructorDTO>();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {MethodName} was cancelled", methodName);
                return new List<InstructorDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching instructors");
                return new List<InstructorDTO>();
            }
        }

        /// <summary>
        /// Retrieves a specific instructor by their ID from the API asynchronously
        /// </summary>
        /// <param name="id">The unique identifier of the instructor</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>Instructor details if found, null otherwise</returns>
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
                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.GetAsync($"Instructor/{id}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var instructor = JsonConvert.DeserializeObject<InstructorDTO>(content);

                    if (instructor != null && !string.IsNullOrEmpty(instructor.ProfileImageUrl) && !instructor.ProfileImageUrl.StartsWith("https"))
                    {
                        instructor.ProfileImageUrl = "https://localhost:7292" + instructor.ProfileImageUrl;
                    }

                    _logger.LogInformation("Successfully retrieved instructor with ID: {InstructorId}", id);
                    return instructor;
                }

                _logger.LogWarning("Failed to get instructor {InstructorId}. Status code: {StatusCode}", id, response.StatusCode);
                return null;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {MethodName} was cancelled for instructor ID: {InstructorId}", methodName, id);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching instructor {InstructorId}", id);
                return null;
            }
        }

        /// <summary>
        /// Retrieves top instructors from the API asynchronously
        /// </summary>
        /// <param name="count">Number of top instructors to retrieve</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of top instructors</returns>
        public async Task<List<InstructorDTO>> GetTopInstructorsAsync(int count = 4, CancellationToken cancellationToken = default)
        {
            const string methodName = nameof(GetTopInstructorsAsync);
            _logger.LogInformation("Starting {MethodName} for {Count} instructors", methodName, count);
            
            if (count <= 0)
            {
                _logger.LogWarning("Invalid count value {Count} provided in {MethodName}", count, methodName);
                return new List<InstructorDTO>();
            }

            try
            {
                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.GetAsync($"Instructor/top/{count}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var instructors = JsonConvert.DeserializeObject<List<InstructorDTO>>(content) ?? new List<InstructorDTO>();

                    FixProfileImageUrls(instructors);
                    _logger.LogInformation("Successfully retrieved {Count} top instructors", instructors.Count);
                    return instructors;
                }

                _logger.LogWarning("Failed to get top instructors. Status code: {StatusCode}", response.StatusCode);
                return new List<InstructorDTO>();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Operation {MethodName} was cancelled for count: {Count}", methodName, count);
                return new List<InstructorDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching top instructors");
                return new List<InstructorDTO>();
            }
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// Fixes profile image URLs by adding the base URL if needed
        /// </summary>
        /// <param name="instructors">List of instructors to fix URLs for</param>
        private void FixProfileImageUrls(IEnumerable<InstructorDTO> instructors)
        {
            foreach (var instructor in instructors)
            {
                if (!string.IsNullOrEmpty(instructor.ProfileImageUrl) && !instructor.ProfileImageUrl.StartsWith("https"))
                {
                    instructor.ProfileImageUrl = "https://localhost:7292" + instructor.ProfileImageUrl;
                }
            }
        }

        #endregion
    }
}