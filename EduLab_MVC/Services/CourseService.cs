using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using EduLab_MVC.Models.DTOs.Course; // افترضت إن الـ DTOs في namespace ده
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace EduLab_MVC.Services
{
    public class CourseService
    {
        private readonly IHttpClientFactory _clientFactory;
        private readonly ILogger<CourseService> _logger;

        public CourseService(IHttpClientFactory clientFactory, ILogger<CourseService> logger)
        {
            _clientFactory = clientFactory;
            _logger = logger;
        }

        public async Task<List<CourseDTO>> GetAllCoursesAsync()
        {
            try
            {
                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.GetAsync("course");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var courses = JsonConvert.DeserializeObject<List<CourseDTO>>(content);

                    // إضافة المسار الكامل للصور
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
                else
                {
                    _logger.LogWarning($"Failed to get courses. Status code: {response.StatusCode}");
                    return new List<CourseDTO>();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while fetching courses.");
                return new List<CourseDTO>();
            }
        }

        public async Task<CourseDTO> GetCourseByIdAsync(int id)
        {
            try
            {
                var client = _clientFactory.CreateClient("EduLabAPI");
                var response = await client.GetAsync($"course/{id}");

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var course = JsonConvert.DeserializeObject<CourseDTO>(content);

                    // تعديل مسار الصورة لو مش URL كامل
                    if (course != null && !string.IsNullOrEmpty(course.ThumbnailUrl) && !course.ThumbnailUrl.StartsWith("https"))
                    {
                        course.ThumbnailUrl = "https://localhost:7292" + course.ThumbnailUrl;
                    }

                    return course;
                }
                else
                {
                    _logger.LogWarning($"Failed to get course with ID {id}. Status code: {response.StatusCode}");
                    return null;
                }
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
                var client = _clientFactory.CreateClient("EduLabAPI");
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
                var client = _clientFactory.CreateClient("EduLabAPI");
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
                var client = _clientFactory.CreateClient("EduLabAPI");
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
                var client = _clientFactory.CreateClient("EduLabAPI");
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

                        if (lecture.Video != null)
                        {
                            var videoContent = new StreamContent(lecture.Video.OpenReadStream());
                            videoContent.Headers.ContentType = new MediaTypeHeaderValue(lecture.Video.ContentType);
                            formData.Add(videoContent, $"Sections[{i}].Lectures[{j}].Video", lecture.Video.FileName);
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
                var client = _clientFactory.CreateClient("EduLabAPI");
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
                var client = _clientFactory.CreateClient("EduLabAPI");

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

        public async Task<bool> BulkPublishCoursesAsync(List<int> ids)
        {
            try
            {
                var client = _clientFactory.CreateClient("EduLabAPI");
                var request = new { Action = "publish", Ids = ids };
                var response = await client.PostAsJsonAsync("course/BulkAction", request);

                if (response.IsSuccessStatusCode)
                {
                    return true;
                }

                var errorContent = await response.Content.ReadAsStringAsync();
                _logger.LogWarning($"Failed to bulk publish courses. Status code: {response.StatusCode}, Error: {errorContent}");
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while bulk publishing courses.");
                return false;
            }
        }

        public async Task<bool> BulkUnpublishCoursesAsync(List<int> ids)
        {
            try
            {
                var client = _clientFactory.CreateClient("EduLabAPI");
                var request = new { Action = "unpublish", Ids = ids };
                var response = await client.PostAsJsonAsync("course/BulkAction", request);

                if (response.IsSuccessStatusCode)
                {
                    return true;
                }

                var errorContent = await response.Content.ReadAsStringAsync();
                _logger.LogWarning($"Failed to bulk unpublish courses. Status code: {response.StatusCode}, Error: {errorContent}");
                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Exception occurred while bulk unpublishing courses.");
                return false;
            }
        }
    }
}
