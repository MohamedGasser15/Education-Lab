using EduLab_MVC.Models.DTOs.Course; // افترضت إن الـ DTOs في namespace ده
using EduLab_MVC.Services.Helper_Services;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Services
{
    public class CourseService
    {
        private readonly ILogger<CourseService> _logger;
        private readonly AuthorizedHttpClientService _httpClientService;

        public CourseService(ILogger<CourseService> logger, AuthorizedHttpClientService httpClientService)
        {
            _logger = logger;
            _httpClientService = httpClientService;
        }

        public async Task<List<CourseDTO>> GetAllCoursesAsync()
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("course");

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning($"Failed to get courses. Status code: {response.StatusCode}");
                    return new List<CourseDTO>();
                }

                var content = await response.Content.ReadAsStringAsync();
                var courses = JsonConvert.DeserializeObject<List<CourseDTO>>(content);

                // تعديل مسار الصورة لو مش URL كامل
                if (courses != null)
                {
                    foreach (var course in courses)
                    {
                        if (!string.IsNullOrEmpty(course.ThumbnailUrl) && !course.ThumbnailUrl.StartsWith("https"))
                        {
                            course.ThumbnailUrl = "https://localhost:7292" + course.ThumbnailUrl;
                        }
                    }
                }

                return courses ?? new List<CourseDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching courses.");
                return new List<CourseDTO>();
            }
        }

        public async Task<CourseDTO?> GetCourseByIdAsync(int id)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"course/{id}");

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning($"Failed to get course with ID {id}. Status code: {response.StatusCode}");
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                var course = JsonConvert.DeserializeObject<CourseDTO>(content);

                if (course != null && !string.IsNullOrEmpty(course.ThumbnailUrl) && !course.ThumbnailUrl.StartsWith("https"))
                {
                    course.ThumbnailUrl = "https://localhost:7292" + course.ThumbnailUrl;
                }

                return course;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Exception occurred while fetching course with ID {id}.");
                return null;
            }
        }


        public async Task<List<CourseDTO>> GetCoursesByInstructorAsync(string instructorId)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"course/instructor/{instructorId}");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var courses = JsonConvert.DeserializeObject<List<CourseDTO>>(content);
                    return courses ?? new List<CourseDTO>();
                }
                else
                {
                    _logger.LogWarning($"Failed to get courses for instructor {instructorId}. Status code: {response.StatusCode}");
                    return new List<CourseDTO>();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Exception occurred while fetching courses for instructor {instructorId}.");
                return new List<CourseDTO>();
            }
        }

        public async Task<List<CourseDTO>> GetCoursesWithCategoryAsync(int categoryId)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"course/category/{categoryId}");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var courses = JsonConvert.DeserializeObject<List<CourseDTO>>(content);
                    return courses ?? new List<CourseDTO>();
                }
                else
                {
                    _logger.LogWarning($"Failed to get courses for category {categoryId}. Status code: {response.StatusCode}");
                    return new List<CourseDTO>();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Exception occurred while fetching courses for category {categoryId}.");
                return new List<CourseDTO>();
            }
        }

        public async Task<CourseDTO> AddCourseAsync(CourseCreateDTO course)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                using var formData = new MultipartFormDataContent();

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

                // Image upload
                if (course.Image != null)
                {
                    var imageContent = new StreamContent(course.Image.OpenReadStream());
                    imageContent.Headers.ContentType = new MediaTypeHeaderValue(course.Image.ContentType);
                    formData.Add(imageContent, "Image", course.Image.FileName);
                }

                // Sections and Lectures (without Ids)
                if (course.Sections != null)
                {
                    for (int i = 0; i < course.Sections.Count; i++)
                    {
                        var section = course.Sections[i];

                        // Don't send section.Id
                        formData.Add(new StringContent(section.Title ?? ""), $"Sections[{i}].Title");
                        formData.Add(new StringContent(section.Order.ToString()), $"Sections[{i}].Order");

                        if (section.Lectures != null)
                        {
                            for (int j = 0; j < section.Lectures.Count; j++)
                            {
                                var lecture = section.Lectures[j];

                                // Don't send lecture.Id
                                formData.Add(new StringContent(lecture.Title ?? ""), $"Sections[{i}].Lectures[{j}].Title");
                                formData.Add(new StringContent(lecture.ArticleContent ?? ""), $"Sections[{i}].Lectures[{j}].ArticleContent");
                                formData.Add(new StringContent(lecture.IsFreePreview.ToString()), $"Sections[{i}].Lectures[{j}].IsFreePreview");
                                formData.Add(new StringContent(lecture.ContentType?.Trim() ?? "video"), $"Sections[{i}].Lectures[{j}].ContentType");
                                formData.Add(new StringContent(lecture.Duration.ToString()), $"Sections[{i}].Lectures[{j}].Duration");
                                formData.Add(new StringContent(lecture.Order.ToString()), $"Sections[{i}].Lectures[{j}].Order");

                                // Skip QuizId unless you know it's required
                                if (lecture.Video != null && lecture.ContentType?.Trim().ToLower() == "video")
                                {
                                    var videoContent = new StreamContent(lecture.Video.OpenReadStream());
                                    videoContent.Headers.ContentType = new MediaTypeHeaderValue(lecture.Video.ContentType);
                                    formData.Add(videoContent, $"Sections[{i}].Lectures[{j}].Video", lecture.Video.FileName);
                                }
                            }
                        }
                    }
                }

                var response = await client.PostAsync("course", formData);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var createdCourse = JsonConvert.DeserializeObject<CourseDTO>(content);
                    return createdCourse;
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    _logger.LogWarning($"Failed to add course. Status code: {response.StatusCode}, Error: {errorContent}");

                    return null;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while adding course.");
                return null;
            }
        }


        public async Task<CourseDTO?> UpdateCourseAsync(int id, CourseUpdateDTO course)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                using var formData = new MultipartFormDataContent();

                // Basic fields
                formData.Add(new StringContent(course.Id.ToString()), "Id");
                formData.Add(new StringContent(course.Title ?? ""), "Title");
                formData.Add(new StringContent(course.ShortDescription ?? ""), "ShortDescription");
                formData.Add(new StringContent(course.Description ?? ""), "Description");
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

                // Sections & Lectures
                for (int i = 0; i < course.Sections.Count; i++)
                {
                    var section = course.Sections[i];
                    formData.Add(new StringContent(section.Id.ToString()), $"Sections[{i}].Id");
                    formData.Add(new StringContent(section.Title ?? ""), $"Sections[{i}].Title");
                    formData.Add(new StringContent(section.Order.ToString()), $"Sections[{i}].Order");

                    for (int j = 0; j < section.Lectures.Count; j++)
                    {
                        var lecture = section.Lectures[j];
                        formData.Add(new StringContent(lecture.Id.ToString()), $"Sections[{i}].Lectures[{j}].Id");
                        formData.Add(new StringContent(lecture.Title ?? ""), $"Sections[{i}].Lectures[{j}].Title");
                        formData.Add(new StringContent(lecture.ContentType ?? "video"), $"Sections[{i}].Lectures[{j}].ContentType");
                        formData.Add(new StringContent(lecture.Duration.ToString()), $"Sections[{i}].Lectures[{j}].Duration");
                        formData.Add(new StringContent(lecture.IsFreePreview.ToString()), $"Sections[{i}].Lectures[{j}].IsFreePreview");

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

                var response = await client.PutAsync($"course/{id}", formData);
                if (!response.IsSuccessStatusCode)
                {
                    var error = await response.Content.ReadAsStringAsync();
                    _logger.LogWarning($"Failed to update course {id}: {error}");
                    return null;
                }

                var content = await response.Content.ReadAsStringAsync();
                return JsonConvert.DeserializeObject<CourseDTO>(content);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Exception updating course {id}");
                return null;
            }
        }


        public async Task<bool> DeleteCourseAsync(int id)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync($"course/{id}");

                if (response.IsSuccessStatusCode)
                {
                    return true;
                }
                else
                {
                    _logger.LogWarning($"Failed to delete course with ID {id}. Status code: {response.StatusCode}");
                    return false;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Exception occurred while deleting course with ID {id}.");
                return false;
            }
        }

        // في ملف EduLab_MVC/Services/CourseService.cs
        public async Task<bool> BulkDeleteCoursesAsync(List<int> ids)
        {
            try
            {
                var client = _httpClientService.CreateClient();

                _logger.LogInformation($"Sending bulk delete request for IDs: {string.Join(",", ids)}");

                var response = await client.PostAsJsonAsync("course/BulkDelete", ids);

                if (response.IsSuccessStatusCode)
                {
                    return true;
                }

                var errorContent = await response.Content.ReadAsStringAsync();
                _logger.LogWarning($"Failed to bulk delete courses. Status code: {response.StatusCode}, Error: {errorContent}");
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while bulk deleting courses.");
                return false;
            }
        }

        public async Task<bool> AcceptCourseAsync(int id)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.PostAsync($"course/{id}/Accept", null);
                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Exception occurred while accepting course {id}.");
                return false;
            }
        }

        public async Task<bool> RejectCourseAsync(int id)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.PostAsync($"course/{id}/Reject", null);
                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Exception occurred while rejecting course {id}.");
                return false;
            }
        }

        public async Task<List<CourseDTO>> GetApprovedCoursesByCategoriesAsync(List<int> categoryIds, int countPerCategory = 10)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var url = $"course/approved/by-categories?{string.Join("&", categoryIds.Select(id => $"categoryIds={id}"))}&countPerCategory={countPerCategory}";

                var response = await client.GetAsync(url);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var courses = JsonConvert.DeserializeObject<List<CourseDTO>>(content);

                    // تعديل مسار الصورة إذا لزم الأمر
                    courses?.ForEach(c => {
                        if (!string.IsNullOrEmpty(c.ThumbnailUrl) && !c.ThumbnailUrl.StartsWith("https"))
                        {
                            c.ThumbnailUrl = "https://localhost:7292" + c.ThumbnailUrl;
                        }
                    });

                    return courses ?? new List<CourseDTO>();
                }

                _logger.LogWarning($"Failed to get approved courses by categories. Status code: {response.StatusCode}");
                return new List<CourseDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching approved courses by categories");
                return new List<CourseDTO>();
            }
        }

        public async Task<List<CourseDTO>> GetApprovedCoursesByCategoryAsync(int categoryId, int count = 10)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"course/approved/by-category/{categoryId}?count={count}");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var courses = JsonConvert.DeserializeObject<List<CourseDTO>>(content);

                    // تعديل مسار الصورة إذا لزم الأمر
                    courses?.ForEach(c => {
                        if (!string.IsNullOrEmpty(c.ThumbnailUrl) && !c.ThumbnailUrl.StartsWith("https"))
                        {
                            c.ThumbnailUrl = "https://localhost:7292" + c.ThumbnailUrl;
                        }
                    });

                    return courses ?? new List<CourseDTO>();
                }

                _logger.LogWarning($"Failed to get approved courses by category {categoryId}. Status code: {response.StatusCode}");
                return new List<CourseDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Exception occurred while fetching approved courses for category {categoryId}");
                return new List<CourseDTO>();
            }
        }
    }
}
