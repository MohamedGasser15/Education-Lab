using EduLab_MVC.Models.DTOs.Course;
using EduLab_MVC.Services.ServiceInterfaces;
using Newtonsoft.Json;
using System.IdentityModel.Tokens.Jwt;
using System.Net.Http.Headers;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// Service for managing course operations in MVC application
    /// </summary>
    public class CourseService : ICourseService
    {
        private readonly ILogger<CourseService> _logger;
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly IHttpContextAccessor _httpContextAccessor;

        /// <summary>
        /// Initializes a new instance of the CourseService class
        /// </summary>
        /// <param name="logger">Logger instance</param>
        /// <param name="httpClientService">Authorized HTTP client service</param>
        /// <param name="httpContextAccessor">HTTP context accessor</param>
        public CourseService(
            ILogger<CourseService> logger,
            IAuthorizedHttpClientService httpClientService,
            IHttpContextAccessor httpContextAccessor)
        {
            _logger = logger;
            _httpClientService = httpClientService;
            _httpContextAccessor = httpContextAccessor;
        }

        #region Public Course Operations

        /// <summary>
        /// Gets all courses
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of all courses</returns>
        public async Task<List<CourseDTO>> GetAllCoursesAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting all courses");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("course", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to get courses. Status code: {StatusCode}", response.StatusCode);
                    return new List<CourseDTO>();
                }

                var content = await response.Content.ReadAsStringAsync();
                var courses = JsonConvert.DeserializeObject<List<CourseDTO>>(content);

                // ✅ تعديل مسار الصور (الكورس + المحاضر)
                UpdateImageUrls(courses);

                _logger.LogInformation("Retrieved {Count} courses", courses?.Count ?? 0);
                return courses ?? new List<CourseDTO>();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get all courses operation was cancelled");
                return new List<CourseDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching courses");
                return new List<CourseDTO>();
            }
        }

        /// <summary>
        /// Gets a course by ID
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Course details</returns>
        public async Task<CourseDTO?> GetCourseByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting course by ID: {CourseId}", id);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"course/{id}", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to get course with ID {CourseId}. Status code: {StatusCode}", id, response.StatusCode);
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                var course = JsonConvert.DeserializeObject<CourseDTO>(content);

                // ✅ تعديل مسار الصور
                UpdateImageUrl(course);

                _logger.LogInformation("Retrieved course ID: {CourseId}", id);
                return course;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get course by ID operation was cancelled. ID: {CourseId}", id);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching course with ID {CourseId}", id);
                return null;
            }
        }

        /// <summary>
        /// Gets courses by instructor ID
        /// </summary>
        /// <param name="instructorId">Instructor ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of courses by instructor</returns>
        public async Task<List<CourseDTO>> GetCoursesByInstructorAsync(string instructorId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting courses for instructor ID: {InstructorId}", instructorId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"course/instructor/{instructorId}", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to get courses for instructor {InstructorId}. Status code: {StatusCode}",
                        instructorId, response.StatusCode);
                    return new List<CourseDTO>();
                }

                var content = await response.Content.ReadAsStringAsync();
                var courses = JsonConvert.DeserializeObject<List<CourseDTO>>(content);

                _logger.LogInformation("Retrieved {Count} courses for instructor ID: {InstructorId}",
                    courses?.Count ?? 0, instructorId);
                return courses ?? new List<CourseDTO>();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get courses by instructor operation was cancelled. Instructor ID: {InstructorId}", instructorId);
                return new List<CourseDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching courses for instructor {InstructorId}", instructorId);
                return new List<CourseDTO>();
            }
        }

        /// <summary>
        /// Gets courses with category
        /// </summary>
        /// <param name="categoryId">Category ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of courses in category</returns>
        public async Task<List<CourseDTO>> GetCoursesWithCategoryAsync(int categoryId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting courses for category ID: {CategoryId}", categoryId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"course/category/{categoryId}", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to get courses for category {CategoryId}. Status code: {StatusCode}",
                        categoryId, response.StatusCode);
                    return new List<CourseDTO>();
                }

                var content = await response.Content.ReadAsStringAsync();
                var courses = JsonConvert.DeserializeObject<List<CourseDTO>>(content);

                _logger.LogInformation("Retrieved {Count} courses for category ID: {CategoryId}",
                    courses?.Count ?? 0, categoryId);
                return courses ?? new List<CourseDTO>();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get courses by category operation was cancelled. Category ID: {CategoryId}", categoryId);
                return new List<CourseDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching courses for category {CategoryId}", categoryId);
                return new List<CourseDTO>();
            }
        }

        #endregion

        #region Approved Courses Operations

        /// <summary>
        /// Gets approved courses by instructor
        /// </summary>
        /// <param name="instructorId">Instructor ID</param>
        /// <param name="count">Number of courses to return</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of approved courses by instructor</returns>
        public async Task<List<CourseDTO>> GetApprovedCoursesByInstructorAsync(string instructorId, int count = 0, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting {Count} approved courses for instructor ID: {InstructorId}", count, instructorId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"LearnerCourse/approved/by-instructor/{instructorId}?count={count}", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {

                    return new List<CourseDTO>();
                }

                var content = await response.Content.ReadAsStringAsync();
                var courses = JsonConvert.DeserializeObject<List<CourseDTO>>(content);

                _logger.LogInformation("Retrieved {Count} approved courses for instructor ID: {InstructorId}",
                    courses?.Count ?? 0, instructorId);
                return courses ?? new List<CourseDTO>();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get approved courses by instructor operation was cancelled. Instructor ID: {InstructorId}", instructorId);
                return new List<CourseDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching approved courses for instructor {InstructorId}", instructorId);
                return new List<CourseDTO>();
            }
        }

        /// <summary>
        /// Gets approved courses by categories
        /// </summary>
        /// <param name="categoryIds">List of category IDs</param>
        /// <param name="countPerCategory">Number of courses per category</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of approved courses by categories</returns>
        public async Task<List<CourseDTO>> GetApprovedCoursesByCategoriesAsync(List<int> categoryIds, int countPerCategory = 10, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting approved courses for {CategoryCount} categories, {CountPerCategory} per category",
                    categoryIds?.Count ?? 0, countPerCategory);

                var client = _httpClientService.CreateClient();
                var url = $"LearnerCourse/approved/by-categories?{string.Join("&", categoryIds.Select(id => $"categoryIds={id}"))}&countPerCategory={countPerCategory}";

                var response = await client.GetAsync(url, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to get approved courses by categories. Status code: {StatusCode}", response.StatusCode);
                    return new List<CourseDTO>();
                }

                var content = await response.Content.ReadAsStringAsync();
                var courses = JsonConvert.DeserializeObject<List<CourseDTO>>(content);

                // تعديل مسار الصورة إذا لزم الأمر
                UpdateImageUrls(courses);

                _logger.LogInformation("Retrieved {Count} approved courses for {CategoryCount} categories",
                    courses?.Count ?? 0, categoryIds.Count);
                return courses ?? new List<CourseDTO>();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get approved courses by categories operation was cancelled");
                return new List<CourseDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching approved courses by categories");
                return new List<CourseDTO>();
            }
        }

        /// <summary>
        /// Gets approved courses by category
        /// </summary>
        /// <param name="categoryId">Category ID</param>
        /// <param name="count">Number of courses to return</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of approved courses by category</returns>
        public async Task<List<CourseDTO>> GetApprovedCoursesByCategoryAsync(int categoryId, int count = 10, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting {Count} approved courses for category ID: {CategoryId}", count, categoryId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"LearnerCourse/approved/by-category/{categoryId}?count={count}", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to get approved courses for category {CategoryId}. Status code: {StatusCode}",
                        categoryId, response.StatusCode);
                    return new List<CourseDTO>();
                }

                var content = await response.Content.ReadAsStringAsync();
                var courses = JsonConvert.DeserializeObject<List<CourseDTO>>(content);

                // تعديل مسار الصورة إذا لزم الأمر
                UpdateImageUrls(courses);

                _logger.LogInformation("Retrieved {Count} approved courses for category ID: {CategoryId}",
                    courses?.Count ?? 0, categoryId);
                return courses ?? new List<CourseDTO>();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get approved courses by category operation was cancelled. Category ID: {CategoryId}", categoryId);
                return new List<CourseDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching approved courses for category {CategoryId}", categoryId);
                return new List<CourseDTO>();
            }
        }

        #endregion

        #region Course Management Operations
        public async Task<LectureResourceDTO> AddResourceToLectureAsync(int lectureId, IFormFile resourceFile, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Adding resource to lecture ID: {LectureId}", lectureId);

                var client = _httpClientService.CreateClient();
                using var formData = new MultipartFormDataContent();

                var fileContent = new StreamContent(resourceFile.OpenReadStream());
                fileContent.Headers.ContentType = new MediaTypeHeaderValue(resourceFile.ContentType);
                formData.Add(fileContent, "resourceFile", resourceFile.FileName);

                var response = await client.PostAsync($"course/lecture/{lectureId}/resources", formData, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    _logger.LogWarning("Failed to add resource to lecture {LectureId}: {Error}", lectureId, errorContent);
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                var resource = JsonConvert.DeserializeObject<LectureResourceDTO>(content);

                _logger.LogInformation("Resource added successfully to lecture ID: {LectureId}", lectureId);
                return resource;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding resource to lecture ID: {LectureId}", lectureId);
                return null;
            }
        }

        public async Task<bool> DeleteResourceAsync(int resourceId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting resource ID: {ResourceId}", resourceId);

                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync($"course/resources/{resourceId}", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to delete resource {ResourceId}: {StatusCode}", resourceId, response.StatusCode);
                    return false;
                }

                _logger.LogInformation("Resource deleted successfully. ID: {ResourceId}", resourceId);
                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting resource ID: {ResourceId}", resourceId);
                return false;
            }
        }

        public async Task<List<LectureResourceDTO>> GetLectureResourcesAsync(int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting resources for lecture ID: {LectureId}", lectureId);

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"course/lecture/{lectureId}/resources", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to get resources for lecture {LectureId}: {StatusCode}", lectureId, response.StatusCode);
                    return new List<LectureResourceDTO>();
                }

                var content = await response.Content.ReadAsStringAsync();
                var resources = JsonConvert.DeserializeObject<List<LectureResourceDTO>>(content);

                _logger.LogInformation("Retrieved {Count} resources for lecture ID: {LectureId}", resources?.Count ?? 0, lectureId);
                return resources ?? new List<LectureResourceDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting resources for lecture ID: {LectureId}", lectureId);
                return new List<LectureResourceDTO>();
            }
        }
        /// <summary>
        /// Adds a new course
        /// </summary>
        /// <param name="course">Course data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Created course</returns>
        public async Task<CourseDTO> AddCourseAsync(CourseCreateDTO course, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Adding new course: {CourseTitle}", course.Title);

                var client = _httpClientService.CreateClient();
                using var formData = new MultipartFormDataContent();

                // إضافة الحقول الأساسية
                AddCourseFormData(formData, course);

                // إضافة الصورة الرئيسية
                if (course.Image != null && course.Image.Length > 0)
                {
                    var imageContent = new StreamContent(course.Image.OpenReadStream());
                    imageContent.Headers.ContentType = new MediaTypeHeaderValue(course.Image.ContentType);
                    formData.Add(imageContent, "Image", course.Image.FileName);
                }

                // إضافة الفيديوهات والموارد
                await AddVideosAndResourcesToFormData(formData, course);

                var response = await client.PostAsync("course", formData, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    _logger.LogWarning("Failed to add course. Status code: {StatusCode}, Error: {Error}",
                        response.StatusCode, errorContent);
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                var createdCourse = JsonConvert.DeserializeObject<CourseDTO>(content);

                _logger.LogInformation("Course added successfully. ID: {CourseId}", createdCourse?.Id);
                return createdCourse;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while adding course: {CourseTitle}", course.Title);
                return null;
            }
        }

        /// <summary>
        /// Updates an existing course
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="course">Updated course data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Updated course</returns>
        public async Task<CourseDTO?> UpdateCourseAsync(int id, CourseUpdateDTO course, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Updating course ID: {CourseId}", id);

                var client = _httpClientService.CreateClient();
                using var formData = new MultipartFormDataContent();

                // إضافة الحقول الأساسية للتحديث
                AddCourseUpdateFormData(formData, course);

                // إضافة الصورة الرئيسية إذا كانت موجودة
                if (course.Image != null && course.Image.Length > 0)
                {
                    var imageContent = new StreamContent(course.Image.OpenReadStream());
                    imageContent.Headers.ContentType = new MediaTypeHeaderValue(course.Image.ContentType);
                    formData.Add(imageContent, "Image", course.Image.FileName);
                }

                // إضافة الفيديوهات والموارد الجديدة
                await AddVideosAndResourcesToFormDataForUpdate(formData, course);
                if (course.Sections != null)
                {
                    foreach (var section in course.Sections)
                    {
                        foreach (var lecture in section.Lectures)
                        {
                            if (lecture.Resources != null && lecture.Resources.Any())
                            {
                                foreach (var resource in lecture.Resources)
                                {
                                    // نبعت الـ Id بتاع الريسورس القديم
                                    formData.Add(new StringContent(resource.Id.ToString()),
                                                 $"OldResourceIds[{lecture.Id}]");
                                }
                            }
                        }
                    }
                }
                var response = await client.PutAsync($"course/{id}", formData, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    var error = await response.Content.ReadAsStringAsync();
                    _logger.LogWarning("Failed to update course {CourseId}: {Error}", id, error);
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                var updatedCourse = JsonConvert.DeserializeObject<CourseDTO>(content);

                _logger.LogInformation("Course updated successfully. ID: {CourseId}", id);
                return updatedCourse;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Update course operation was cancelled. ID: {CourseId}", id);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while updating course {CourseId}", id);
                return null;
            }
        }

        /// <summary>
        /// Deletes a course
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if deleted successfully</returns>
        public async Task<bool> DeleteCourseAsync(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting course ID: {CourseId}", id);

                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync($"course/{id}", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to delete course with ID {CourseId}. Status code: {StatusCode}",
                        id, response.StatusCode);
                    return false;
                }

                _logger.LogInformation("Course deleted successfully. ID: {CourseId}", id);
                return true;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Delete course operation was cancelled. ID: {CourseId}", id);
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while deleting course with ID {CourseId}", id);
                return false;
            }
        }

        #endregion

        #region Bulk Operations

        /// <summary>
        /// Bulk delete courses
        /// </summary>
        /// <param name="ids">List of course IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if bulk delete successful</returns>
        public async Task<bool> BulkDeleteCoursesAsync(List<int> ids, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Bulk deleting {Count} courses", ids.Count);

                var client = _httpClientService.CreateClient();
                var response = await client.PostAsJsonAsync("course/BulkDelete", ids, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    _logger.LogWarning("Failed to bulk delete courses. Status code: {StatusCode}, Error: {Error}",
                        response.StatusCode, errorContent);
                    return false;
                }

                _logger.LogInformation("Bulk delete completed successfully. Deleted {Count} courses", ids.Count);
                return true;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Bulk delete courses operation was cancelled");
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while bulk deleting courses");
                return false;
            }
        }

        #endregion

        #region Status Management

        /// <summary>
        /// Accepts a course
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if accepted successfully</returns>
        public async Task<bool> AcceptCourseAsync(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Accepting course ID: {CourseId}", id);

                var client = _httpClientService.CreateClient();
                var response = await client.PostAsync($"course/{id}/Accept", null, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to accept course {CourseId}. Status code: {StatusCode}", id, response.StatusCode);
                    return false;
                }

                _logger.LogInformation("Course accepted successfully. ID: {CourseId}", id);
                return true;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Accept course operation was cancelled. ID: {CourseId}", id);
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while accepting course {CourseId}", id);
                return false;
            }
        }

        /// <summary>
        /// Rejects a course
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if rejected successfully</returns>
        public async Task<bool> RejectCourseAsync(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Rejecting course ID: {CourseId}", id);

                var client = _httpClientService.CreateClient();
                var response = await client.PostAsync($"course/{id}/Reject", null, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to reject course {CourseId}. Status code: {StatusCode}", id, response.StatusCode);
                    return false;
                }

                _logger.LogInformation("Course rejected successfully. ID: {CourseId}", id);
                return true;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Reject course operation was cancelled. ID: {CourseId}", id);
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while rejecting course {CourseId}", id);
                return false;
            }
        }

        #endregion

        #region Instructor Course Operations

        /// <summary>
        /// Gets courses for the current instructor
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of instructor's courses</returns>
        public async Task<List<CourseDTO>> GetInstructorCoursesAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting courses for current instructor");

                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("InstructorCourse/instructor-courses", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to fetch instructor courses. Status code: {StatusCode}", response.StatusCode);
                    return new List<CourseDTO>();
                }

                var content = await response.Content.ReadAsStringAsync();
                var courses = JsonConvert.DeserializeObject<List<CourseDTO>>(content);

                // ✅ تعديل مسار الصور
                UpdateImageUrls(courses);

                _logger.LogInformation("Retrieved {Count} instructor courses", courses?.Count ?? 0);
                return courses ?? new List<CourseDTO>();
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Get instructor courses operation was cancelled");
                return new List<CourseDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching instructor courses");
                return new List<CourseDTO>();
            }
        }

        /// <summary>
        /// Adds a new course as instructor
        /// </summary>
        /// <param name="course">Course data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Created course</returns>
        public async Task<CourseDTO?> AddCourseAsInstructorAsync(CourseCreateDTO course, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Adding new course as instructor: {CourseTitle}", course.Title);

                var instructorId = GetCurrentInstructorId();
                if (string.IsNullOrEmpty(instructorId))
                {
                    _logger.LogWarning("InstructorId not found in token");
                    return null;
                }

                // Override any front-end value
                course.InstructorId = instructorId;

                var client = _httpClientService.CreateClient();
                using var formData = new MultipartFormDataContent();

                // إضافة الحقول الأساسية - بنفس الطريقة المستخدمة في AddCourseAsync
                AddCourseFormData(formData, course);

                // إضافة الصورة الرئيسية - بنفس الطريقة المستخدمة في AddCourseAsync
                if (course.Image != null && course.Image.Length > 0)
                {
                    var imageContent = new StreamContent(course.Image.OpenReadStream());
                    imageContent.Headers.ContentType = new MediaTypeHeaderValue(course.Image.ContentType);
                    formData.Add(imageContent, "Image", course.Image.FileName);
                }

                // إضافة الفيديوهات والموارد - بنفس الطريقة المستخدمة في AddCourseAsync
                await AddVideosAndResourcesToFormData(formData, course);

                // استخدام endpoint الخاص بالمحاضر بدلاً من endpoint العام
                var response = await client.PostAsync("InstructorCourse/instructor", formData, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    _logger.LogWarning("Failed to add course as instructor. Status code: {StatusCode}, Error: {Error}",
                        response.StatusCode, errorContent);
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                var createdCourse = JsonConvert.DeserializeObject<CourseDTO>(content);

                _logger.LogInformation("Course added successfully as instructor. ID: {CourseId}", createdCourse?.Id);
                return createdCourse;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Add course as instructor operation was cancelled. Course: {CourseTitle}", course.Title);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while adding course as instructor: {CourseTitle}", course.Title);
                return null;
            }
        }

        /// <summary>
        /// Updates an existing course as instructor
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="course">Updated course data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Updated course</returns>
        public async Task<CourseDTO?> UpdateCourseAsInstructorAsync(int id, CourseUpdateDTO course, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Updating course as instructor. ID: {CourseId}", id);

                var instructorId = GetCurrentInstructorId();
                if (string.IsNullOrEmpty(instructorId))
                {
                    _logger.LogWarning("InstructorId not found in token");
                    return null;
                }

                // Override any front-end value
                course.InstructorId = instructorId;

                var client = _httpClientService.CreateClient();
                using var formData = new MultipartFormDataContent();

                // إضافة الحقول الأساسية للتحديث
                AddCourseUpdateFormData(formData, course);

                var response = await client.PutAsync($"InstructorCourse/instructor/{id}", formData, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    _logger.LogWarning("Failed to update course as instructor. Status code: {StatusCode}, Error: {Error}",
                        response.StatusCode, errorContent);
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                var updatedCourse = JsonConvert.DeserializeObject<CourseDTO>(content);

                _logger.LogInformation("Course updated successfully as instructor. ID: {CourseId}", id);
                return updatedCourse;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Update course as instructor operation was cancelled. ID: {CourseId}", id);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while updating course as instructor. ID: {CourseId}", id);
                return null;
            }
        }

        /// <summary>
        /// Deletes a course as instructor
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if deleted successfully</returns>
        public async Task<bool> DeleteCourseAsInstructorAsync(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting course as instructor. ID: {CourseId}", id);

                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync($"InstructorCourse/instructor/{id}", cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to delete course as instructor {CourseId}: {StatusCode}", id, response.StatusCode);
                    return false;
                }

                _logger.LogInformation("Course deleted successfully as instructor. ID: {CourseId}", id);
                return true;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Delete course as instructor operation was cancelled. ID: {CourseId}", id);
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while deleting course as instructor. ID: {CourseId}", id);
                return false;
            }
        }

        /// <summary>
        /// Bulk delete courses as instructor
        /// </summary>
        /// <param name="ids">List of course IDs</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>True if bulk delete successful</returns>
        public async Task<bool> BulkDeleteCoursesAsInstructorAsync(List<int> ids, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Bulk deleting {Count} courses as instructor", ids.Count);

                var client = _httpClientService.CreateClient();
                var response = await client.PostAsJsonAsync("InstructorCourse/instructor/BulkDelete", ids, cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Failed to bulk delete courses as instructor: {StatusCode}", response.StatusCode);
                    return false;
                }

                _logger.LogInformation("Bulk delete completed successfully as instructor. Deleted {Count} courses", ids.Count);
                return true;
            }
            catch (OperationCanceledException)
            {
                _logger.LogWarning("Bulk delete courses as instructor operation was cancelled");
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while bulk deleting courses as instructor");
                return false;
            }
        }

        #endregion

        #region Private Helper Methods

        /// <summary>
        /// Gets the current instructor ID from JWT token
        /// </summary>
        /// <returns>Instructor ID or null</returns>
        private string? GetCurrentInstructorId()
        {
            try
            {
                var token = _httpContextAccessor.HttpContext?.Request.Cookies["AuthToken"];
                if (string.IsNullOrEmpty(token))
                    return null;

                var handler = new JwtSecurityTokenHandler();
                var jwtToken = handler.ReadJwtToken(token);
                return jwtToken.Claims.FirstOrDefault(c => c.Type == "sub")?.Value;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while getting instructor ID from token");
                return null;
            }
        }

        /// <summary>
        /// Updates image URLs for a list of courses
        /// </summary>
        /// <param name="courses">List of courses</param>
        private void UpdateImageUrls(List<CourseDTO> courses)
        {
            if (courses == null) return;

            foreach (var course in courses)
            {
                UpdateImageUrl(course);
            }
        }

        /// <summary>
        /// Updates image URLs for a single course
        /// </summary>
        /// <param name="course">Course object</param>
        private void UpdateImageUrl(CourseDTO course)
        {
            if (course == null) return;

            string baseUrl = "https://localhost:7292";

            // Thumbnail
            if (!string.IsNullOrEmpty(course.ThumbnailUrl) && !course.ThumbnailUrl.StartsWith("https"))
            {
                course.ThumbnailUrl = baseUrl + course.ThumbnailUrl;
            }

            // Instructor profile image
            if (!string.IsNullOrEmpty(course.ProfileImageUrl) && !course.ProfileImageUrl.StartsWith("https"))
            {
                course.ProfileImageUrl = baseUrl + course.ProfileImageUrl;
            }

            // Sections → Lectures
            if (course.Sections != null)
            {
                foreach (var section in course.Sections)
                {
                    if (section.Lectures == null) continue;

                    foreach (var lecture in section.Lectures)
                    {
                        // Video URL
                        if (!string.IsNullOrEmpty(lecture.VideoUrl) && !lecture.VideoUrl.StartsWith("https"))
                        {
                            lecture.VideoUrl = baseUrl + lecture.VideoUrl;
                        }

                        // Resources
                        if (lecture.Resources != null)
                        {
                            foreach (var res in lecture.Resources)
                            {
                                if (!string.IsNullOrEmpty(res.FileUrl) && !res.FileUrl.StartsWith("https"))
                                {
                                    res.FileUrl = baseUrl + res.FileUrl;
                                }
                            }
                        }
                    }
                }
            }
        }
        /// <summary>
        /// Adds videos and resources to form data for update operations
        /// </summary>
        private async Task AddVideosAndResourcesToFormDataForUpdate(MultipartFormDataContent formData, CourseUpdateDTO course)
        {
            if (course.Sections != null)
            {
                for (int i = 0; i < course.Sections.Count; i++)
                {
                    var section = course.Sections[i];
                    if (section.Lectures != null)
                    {
                        for (int j = 0; j < section.Lectures.Count; j++)
                        {
                            var lecture = section.Lectures[j];

                            // إضافة فيديو المحاضرة الجديد
                            if (lecture.Video != null && lecture.Video.Length > 0)
                            {
                                var videoContent = new StreamContent(lecture.Video.OpenReadStream());
                                videoContent.Headers.ContentType = new MediaTypeHeaderValue(lecture.Video.ContentType);
                                formData.Add(videoContent, $"Sections[{i}].Lectures[{j}].Video", lecture.Video.FileName);
                            }

                            // إضافة موارد المحاضرة الجديدة
                            if (lecture.ResourceFiles != null)
                            {
                                for (int k = 0; k < lecture.ResourceFiles.Count; k++)
                                {
                                    var resourceFile = lecture.ResourceFiles[k];
                                    if (resourceFile.Length > 0)
                                    {
                                        var resourceContent = new StreamContent(resourceFile.OpenReadStream());
                                        resourceContent.Headers.ContentType = new MediaTypeHeaderValue(resourceFile.ContentType);
                                        formData.Add(resourceContent, $"Sections[{i}].Lectures[{j}].ResourceFiles", resourceFile.FileName);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        /// <summary>
        /// Adds videos and resources to form data
        /// </summary>
        private async Task AddVideosAndResourcesToFormData(MultipartFormDataContent formData, CourseCreateDTO course)
        {
            if (course.Sections != null)
            {
                for (int i = 0; i < course.Sections.Count; i++)
                {
                    var section = course.Sections[i];
                    if (section.Lectures != null)
                    {
                        for (int j = 0; j < section.Lectures.Count; j++)
                        {
                            var lecture = section.Lectures[j];

                            // إضافة فيديو المحاضرة
                            if (lecture.Video != null && lecture.Video.Length > 0)
                            {
                                var videoContent = new StreamContent(lecture.Video.OpenReadStream());
                                videoContent.Headers.ContentType = new MediaTypeHeaderValue(lecture.Video.ContentType);
                                formData.Add(videoContent, $"Sections[{i}].Lectures[{j}].Video", lecture.Video.FileName);
                            }

                            // إضافة موارد المحاضرة
                            if (lecture.ResourceFiles != null)
                            {
                                for (int k = 0; k < lecture.ResourceFiles.Count; k++)
                                {
                                    var resourceFile = lecture.ResourceFiles[k];
                                    if (resourceFile.Length > 0)
                                    {
                                        var resourceContent = new StreamContent(resourceFile.OpenReadStream());
                                        resourceContent.Headers.ContentType = new MediaTypeHeaderValue(resourceFile.ContentType);
                                        formData.Add(resourceContent, $"Sections[{i}].Lectures[{j}].ResourceFiles", resourceFile.FileName);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        /// <summary>
        /// Adds course form data for create operations
        /// </summary>
        /// <param name="formData">Form data content</param>
        /// <param name="course">Course data</param>

        private void AddCourseFormData(MultipartFormDataContent formData, CourseCreateDTO course)
        {
            // Basic fields
            formData.Add(new StringContent(course.Title ?? ""), "Title");
            formData.Add(new StringContent(course.ShortDescription ?? ""), "ShortDescription");
            formData.Add(new StringContent(course.Description ?? ""), "Description");
            formData.Add(new StringContent(course.Price.ToString()), "Price");
            formData.Add(new StringContent(course.Discount?.ToString() ?? "0"), "Discount");
            formData.Add(new StringContent(course.InstructorId ?? ""), "InstructorId");
            formData.Add(new StringContent(course.CategoryId.ToString()), "CategoryId");
            formData.Add(new StringContent(course.Level ?? ""), "Level");
            formData.Add(new StringContent(course.Language ?? ""), "Language");
            formData.Add(new StringContent(course.Duration.ToString()), "Duration");
            formData.Add(new StringContent(course.TotalLectures.ToString()), "TotalLectures");
            formData.Add(new StringContent(course.HasCertificate.ToString()), "HasCertificate");
            formData.Add(new StringContent(course.TargetAudience ?? ""), "TargetAudience");

            // Requirements
            if (course.Requirements != null)
            {
                for (int i = 0; i < course.Requirements.Count; i++)
                {
                    formData.Add(new StringContent(course.Requirements[i] ?? ""), $"Requirements[{i}]");
                }
            }

            // Learnings
            if (course.Learnings != null)
            {
                for (int i = 0; i < course.Learnings.Count; i++)
                {
                    formData.Add(new StringContent(course.Learnings[i] ?? ""), $"Learnings[{i}]");
                }
            }

            // Sections and Lectures (بدون الملفات - سيتم إضافتها separately)
            if (course.Sections != null)
            {
                for (int i = 0; i < course.Sections.Count; i++)
                {
                    var section = course.Sections[i];
                    formData.Add(new StringContent(section.Title ?? ""), $"Sections[{i}].Title");
                    formData.Add(new StringContent(section.Order.ToString()), $"Sections[{i}].Order");

                    if (section.Lectures != null)
                    {
                        for (int j = 0; j < section.Lectures.Count; j++)
                        {
                            var lecture = section.Lectures[j];
                            formData.Add(new StringContent(lecture.Title ?? ""), $"Sections[{i}].Lectures[{j}].Title");
                            formData.Add(new StringContent(lecture.Description ?? ""), $"Sections[{i}].Lectures[{j}].Description");
                            formData.Add(new StringContent(lecture.ArticleContent ?? ""), $"Sections[{i}].Lectures[{j}].ArticleContent");
                            formData.Add(new StringContent(lecture.IsFreePreview.ToString()), $"Sections[{i}].Lectures[{j}].IsFreePreview");
                            formData.Add(new StringContent(lecture.ContentType?.Trim() ?? "video"), $"Sections[{i}].Lectures[{j}].ContentType");
                            formData.Add(new StringContent(lecture.Duration.ToString()), $"Sections[{i}].Lectures[{j}].Duration");
                            formData.Add(new StringContent(lecture.Order.ToString()), $"Sections[{i}].Lectures[{j}].Order");
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Adds course form data for update operations
        /// </summary>
        /// <param name="formData">Form data content</param>
        /// <param name="course">Course data</param>
        /// <summary>
        /// Adds course form data for update operations
        /// </summary>
        /// <param name="formData">Form data content</param>
        /// <param name="course">Course data</param>
        private void AddCourseUpdateFormData(MultipartFormDataContent formData, CourseUpdateDTO course)
        {
            // Basic fields - الحقول الأساسية الموجودة
            formData.Add(new StringContent(course.Id.ToString()), "Id");
            formData.Add(new StringContent(course.Title ?? ""), "Title");
            formData.Add(new StringContent(course.ShortDescription ?? ""), "ShortDescription");
            formData.Add(new StringContent(course.Description ?? ""), "Description"); // ✅ تم إصلاح وصف الدورة
            formData.Add(new StringContent(course.Price.ToString()), "Price");
            formData.Add(new StringContent(course.Discount?.ToString() ?? "0"), "Discount");
            formData.Add(new StringContent(course.InstructorId ?? ""), "InstructorId");
            formData.Add(new StringContent(course.CategoryId.ToString()), "CategoryId");
            formData.Add(new StringContent(course.Level ?? ""), "Level");
            formData.Add(new StringContent(course.Language ?? ""), "Language");
            formData.Add(new StringContent(course.HasCertificate.ToString()), "HasCertificate");
            formData.Add(new StringContent(course.TargetAudience ?? ""), "TargetAudience");

            // Requirements & Learnings
            for (int i = 0; i < course.Requirements.Count; i++)
                formData.Add(new StringContent(course.Requirements[i] ?? ""), $"Requirements[{i}]");

            for (int i = 0; i < course.Learnings.Count; i++)
                formData.Add(new StringContent(course.Learnings[i] ?? ""), $"Learnings[{i}]");

            // Image
            if (course.Image != null)
            {
                var imageContent = new StreamContent(course.Image.OpenReadStream());
                imageContent.Headers.ContentType = new MediaTypeHeaderValue(course.Image.ContentType);
                formData.Add(imageContent, "Image", course.Image.FileName);
            }
            else if (!string.IsNullOrEmpty(course.ThumbnailUrl))
            {
                formData.Add(new StringContent(course.ThumbnailUrl), "ThumbnailUrl");
            }

            // ✅ إضافة الموارد القديمة لمنع حذفها
            if (course.Sections != null)
            {
                for (int i = 0; i < course.Sections.Count; i++)
                {
                    var section = course.Sections[i];
                    formData.Add(new StringContent(section.Id.ToString()), $"Sections[{i}].Id");
                    formData.Add(new StringContent(section.Title ?? ""), $"Sections[{i}].Title");
                    formData.Add(new StringContent(section.Order.ToString()), $"Sections[{i}].Order");

                    if (section.Lectures != null)
                    {
                        for (int j = 0; j < section.Lectures.Count; j++)
                        {
                            var lecture = section.Lectures[j];
                            formData.Add(new StringContent(lecture.Id.ToString()), $"Sections[{i}].Lectures[{j}].Id");
                            formData.Add(new StringContent(lecture.Title ?? ""), $"Sections[{i}].Lectures[{j}].Title");
                            formData.Add(new StringContent(lecture.ContentType ?? "video"), $"Sections[{i}].Lectures[{j}].ContentType");
                            formData.Add(new StringContent(lecture.Duration.ToString()), $"Sections[{i}].Lectures[{j}].Duration");
                            formData.Add(new StringContent(lecture.IsFreePreview.ToString()), $"Sections[{i}].Lectures[{j}].IsFreePreview");
                            formData.Add(new StringContent(lecture.Description ?? ""), $"Sections[{i}].Lectures[{j}].Description"); // ✅ إضافة الوصف

                            // ✅ إضافة الموارد القديمة للمحاضرة
                            if (lecture.Resources != null && lecture.Resources.Any())
                            {
                                var resourcesJson = JsonConvert.SerializeObject(lecture.Resources);
                                formData.Add(new StringContent(resourcesJson), $"Sections[{i}].Lectures[{j}].ExistingResources");
                            }

                            // فقط إذا كان هناك فيديو جديد
                            if (lecture.Video != null)
                            {
                                var videoContent = new StreamContent(lecture.Video.OpenReadStream());
                                videoContent.Headers.ContentType = new MediaTypeHeaderValue(lecture.Video.ContentType);
                                formData.Add(videoContent, $"Sections[{i}].Lectures[{j}].Video", lecture.Video.FileName);
                            }
                            else if (!string.IsNullOrEmpty(lecture.VideoUrl))
                            {
                                // إرسال رابط الفيديو القديم إذا لم يتم رفع جديد
                                formData.Add(new StringContent(lecture.VideoUrl), $"Sections[{i}].Lectures[{j}].VideoUrl");
                            }
                        }
                    }
                }
            }
        }

        #endregion
    }
}