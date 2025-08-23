using EduLab_MVC.Models.DTOs.Instructor;
using EduLab_MVC.Services.Helper_Services;
using Newtonsoft.Json;

namespace EduLab_MVC.Services
{
    public class InstructorService
    {
        private readonly IHttpClientFactory _clientFactory;
        private readonly ILogger<InstructorService> _logger;
        private readonly AuthorizedHttpClientService _httpClientService;

        public InstructorService(
            IHttpClientFactory clientFactory,
            ILogger<InstructorService> logger,
            AuthorizedHttpClientService httpClientService)
        {
            _clientFactory = clientFactory;
            _logger = logger;
            _httpClientService = httpClientService;
        }

        public async Task<List<InstructorDTO>> GetAllInstructorsAsync()
        {
            try
            {
                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.GetAsync("Instructor");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var instructorList = JsonConvert.DeserializeObject<InstructorListDTO>(content);

                    var instructors = instructorList?.Instructors ?? new List<InstructorDTO>();

                    FixProfileImageUrls(instructors);
                    return instructors;
                }

                _logger.LogWarning($"Failed to get instructors. Status code: {response.StatusCode}");
                return new List<InstructorDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching instructors.");
                return new List<InstructorDTO>();
            }
        }


        public async Task<InstructorDTO?> GetInstructorByIdAsync(string id)
        {
            try
            {
                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.GetAsync($"Instructor/{id}");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var instructor = JsonConvert.DeserializeObject<InstructorDTO>(content);

                    if (instructor != null && !string.IsNullOrEmpty(instructor.ProfileImageUrl) && !instructor.ProfileImageUrl.StartsWith("https"))
                    {
                        instructor.ProfileImageUrl = "https://localhost:7292" + instructor.ProfileImageUrl;
                    }

                    return instructor;
                }

                _logger.LogWarning($"Failed to get instructor {id}. Status code: {response.StatusCode}");
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Exception occurred while fetching instructor {id}.");
                return null;
            }
        }

        public async Task<List<InstructorDTO>> GetTopInstructorsAsync(int count = 4)
        {
            try
            {
                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.GetAsync($"Instructor/top/{count}");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var instructors = JsonConvert.DeserializeObject<List<InstructorDTO>>(content) ?? new List<InstructorDTO>();

                    FixProfileImageUrls(instructors);
                    return instructors;
                }

                _logger.LogWarning($"Failed to get top instructors. Status code: {response.StatusCode}");
                return new List<InstructorDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching top instructors.");
                return new List<InstructorDTO>();
            }
        }

        private void FixProfileImageUrls(IEnumerable<InstructorDTO> instructors)
        {
            foreach (var i in instructors)
            {
                if (!string.IsNullOrEmpty(i.ProfileImageUrl) && !i.ProfileImageUrl.StartsWith("https"))
                {
                    i.ProfileImageUrl = "https://localhost:7292" + i.ProfileImageUrl;
                }
            }
        }
    }
}
