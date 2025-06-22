using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Course;
using EduLab_Shared.DTOs.Lecture;
using EduLab_Shared.DTOs.Section;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class CourseService : ICourseService
    {
        private readonly ICourseRepository _courseRepository;
        private readonly IUserRepository _userRepository;
        public CourseService(ICourseRepository courseRepository , IUserRepository userRepository)
        {
            _courseRepository = courseRepository;
            _userRepository = userRepository;

        }

        public async Task<IEnumerable<CourseDTO>> GetAllCoursesAsync()
        {
            var courses = await _courseRepository.GetAllAsync(null, "Category,Sections.Lectures", false);
            var courseDTOs = new List<CourseDTO>();

            foreach (var c in courses)
            {
                // Fetch instructor name
                var instructor = await _userRepository.GetUserById(c.InstructorId); // Assuming _userRepository exists
                var instructorName = instructor?.FullName ?? "غير متوفر";

                courseDTOs.Add(new CourseDTO
                {
                    Id = c.Id,
                    Title = c.Title,
                    ShortDescription = c.ShortDescription,
                    Description = c.Description,
                    Price = c.Price,
                    Discount = c.Discount,
                    ThumbnailUrl = c.ThumbnailUrl,
                    CreatedAt = c.CreatedAt,
                    InstructorId = c.InstructorId,
                    InstructorName = instructorName, // Set InstructorName
                    CategoryId = c.CategoryId,
                    CategoryName = c.Category?.Category_Name ?? "غير معروف", // Set CategoryName
                    Level = c.Level,
                    Language = c.Language,
                    Duration = c.Duration,
                    TotalLectures = c.Sections?.Sum(s => s.Lectures?.Count ?? 0) ?? 0,
                    HasCertificate = c.HasCertificate,
                    Requirements = c.Requirements,
                    Learnings = c.Learnings,
                    TargetAudience = c.TargetAudience,
                    Sections = c.Sections?.Select(s => new SectionDTO
                    {
                        Id = s.Id,
                        Title = s.Title,
                        Order = s.Order,
                        Lectures = s.Lectures?.Select(l => new LectureDTO
                        {
                            Id = l.Id,
                            Title = l.Title,
                            VideoUrl = l.VideoUrl,
                            ArticleContent = l.ArticleContent,
                            QuizId = l.QuizId,
                            ContentType = l.ContentType.ToString(),
                            Duration = (int)l.Duration.TotalSeconds,
                            Order = l.Order,
                            IsFreePreview = l.IsFreePreview
                        }).ToList()
                    }).ToList()
                });
            }

            return courseDTOs;
        }

        public async Task<CourseDTO> GetCourseByIdAsync(int id)
        {
            var course = await _courseRepository.GetCourseByIdAsync(id, false);
            if (course == null) return null;

            // Fetch instructor name
            var instructor = await _userRepository.GetUserById(course.InstructorId); // Assuming _userRepository exists
            var instructorName = instructor?.FullName ?? "غير متوفر";

            return new CourseDTO
            {
                Id = course.Id,
                Title = course.Title,
                ShortDescription = course.ShortDescription,
                Description = course.Description,
                Price = course.Price,
                Discount = course.Discount,
                ThumbnailUrl = course.ThumbnailUrl,
                CreatedAt = course.CreatedAt,
                InstructorId = course.InstructorId,
                InstructorName = instructorName, // Set InstructorName
                CategoryId = course.CategoryId,
                CategoryName = course.Category?.Category_Name ?? "غير معروف", // Set CategoryName
                Level = course.Level,
                Language = course.Language,
                Duration = course.Duration,
                TotalLectures = course.Sections?.Sum(s => s.Lectures?.Count ?? 0) ?? 0,
                HasCertificate = course.HasCertificate,
                Requirements = course.Requirements,
                Learnings = course.Learnings,
                TargetAudience = course.TargetAudience,
                Sections = course.Sections?.Select(s => new SectionDTO
                {
                    Id = s.Id,
                    Title = s.Title,
                    Order = s.Order,
                    Lectures = s.Lectures?.Select(l => new LectureDTO
                    {
                        Id = l.Id,
                        Title = l.Title,
                        VideoUrl = l.VideoUrl,
                        ArticleContent = l.ArticleContent,
                        QuizId = l.QuizId,
                        ContentType = l.ContentType.ToString(),
                        Duration = (int)l.Duration.TotalSeconds,
                        Order = l.Order,
                        IsFreePreview = l.IsFreePreview
                    }).ToList()
                }).ToList()
            };
        }

        public async Task<CourseDTO> AddCourseAsync(CourseCreateDTO courseDto)
        {
            var course = new Course
            {
                Title = courseDto.Title,
                ShortDescription = courseDto.ShortDescription,
                Description = courseDto.Description,
                Price = courseDto.Price,
                Discount = courseDto.Discount,
                InstructorId = courseDto.InstructorId,
                CategoryId = courseDto.CategoryId,
                Level = courseDto.Level,
                Language = courseDto.Language,
                Duration = courseDto.Duration,
                HasCertificate = courseDto.HasCertificate,
                Requirements = courseDto.Requirements,
                Learnings = courseDto.Learnings,
                TargetAudience = courseDto.TargetAudience,
                CreatedAt = DateTime.UtcNow,
                ThumbnailUrl = string.IsNullOrEmpty(courseDto.ThumbnailUrl) ? "/images/Courses/default.jpg" : courseDto.ThumbnailUrl,
                Sections = courseDto.Sections?.Select(s => new Section
                {
                    Title = s.Title,
                    Order = s.Order,
                    Lectures = s.Lectures?.Select(l => new Lecture
                    {
                        Title = l.Title,
                        VideoUrl = l.VideoUrl,
                        ArticleContent = l.ArticleContent,
                        QuizId = l.QuizId,
                        ContentType = Enum.Parse<ContentType>(l.ContentType, true),
                        Duration = TimeSpan.FromSeconds(l.Duration),
                        Order = l.Order,
                        IsFreePreview = l.IsFreePreview
                    }).ToList()
                }).ToList()
            };

            await _courseRepository.AddAsync(course);

            var courseDtoResult = new CourseDTO
            {
                Id = course.Id,
                Title = course.Title,
                ShortDescription = course.ShortDescription,
                Description = course.Description,
                Price = course.Price,
                Discount = course.Discount,
                ThumbnailUrl = course.ThumbnailUrl,
                CreatedAt = course.CreatedAt,
                InstructorId = course.InstructorId,
                CategoryId = course.CategoryId,
                Level = course.Level,
                Language = course.Language,
                Duration = course.Duration,
                TotalLectures = course.Sections?.Sum(s => s.Lectures?.Count ?? 0) ?? 0,
                HasCertificate = course.HasCertificate,
                Requirements = course.Requirements,
                Learnings = course.Learnings,
                TargetAudience = course.TargetAudience,
                Sections = course.Sections?.Select(s => new SectionDTO
                {
                    Id = s.Id,
                    Title = s.Title,
                    Order = s.Order,
                    Lectures = s.Lectures?.Select(l => new LectureDTO
                    {
                        Id = l.Id,
                        Title = l.Title,
                        VideoUrl = l.VideoUrl,
                        ArticleContent = l.ArticleContent,
                        QuizId = l.QuizId,
                        ContentType = l.ContentType.ToString(),
                        Duration = (int)l.Duration.TotalSeconds,
                        Order = l.Order,
                        IsFreePreview = l.IsFreePreview
                    }).ToList()
                }).ToList()
            };

            return courseDtoResult;
        }

        public async Task<CourseDTO> UpdateCourseAsync(CourseUpdateDTO courseDto)
        {
            var course = new Course
            {
                Id = courseDto.Id,
                Title = courseDto.Title,
                ShortDescription = courseDto.ShortDescription,
                Description = courseDto.Description,
                Price = courseDto.Price,
                Discount = courseDto.Discount,
                ThumbnailUrl = courseDto.ThumbnailUrl,
                InstructorId = courseDto.InstructorId,
                CategoryId = courseDto.CategoryId,
                Level = courseDto.Level,
                Language = courseDto.Language,
                Duration = courseDto.Duration,
                HasCertificate = courseDto.HasCertificate,
                Requirements = courseDto.Requirements,
                Learnings = courseDto.Learnings,
                TargetAudience = courseDto.TargetAudience,
                Sections = courseDto.Sections?.Select(s => new Section
                {
                    Id = s.Id,
                    Title = s.Title,
                    Order = s.Order,
                    CourseId = courseDto.Id,
                    Lectures = s.Lectures?.Select(l => new Lecture
                    {
                        Id = l.Id,
                        Title = l.Title,
                        VideoUrl = l.VideoUrl,
                        ArticleContent = l.ArticleContent,
                        QuizId = l.QuizId,
                        ContentType = Enum.Parse<ContentType>(l.ContentType, true),
                        Duration = TimeSpan.FromSeconds(l.Duration),
                        Order = l.Order,
                        IsFreePreview = l.IsFreePreview,
                        SectionId = s.Id
                    }).ToList()
                }).ToList()
            };

            var updatedCourse = await _courseRepository.UpdateAsync(course);
            if (updatedCourse == null)
            {
                return null;
            }

            return new CourseDTO
            {
                Id = updatedCourse.Id,
                Title = updatedCourse.Title,
                ShortDescription = updatedCourse.ShortDescription,
                Description = updatedCourse.Description,
                Price = updatedCourse.Price,
                Discount = updatedCourse.Discount,
                ThumbnailUrl = updatedCourse.ThumbnailUrl,
                CreatedAt = updatedCourse.CreatedAt,
                InstructorId = updatedCourse.InstructorId,
                CategoryId = updatedCourse.CategoryId,
                Level = updatedCourse.Level,
                Language = updatedCourse.Language,
                Duration = updatedCourse.Duration,
                TotalLectures = updatedCourse.Sections?.Sum(s => s.Lectures?.Count ?? 0) ?? 0,
                HasCertificate = updatedCourse.HasCertificate,
                Requirements = updatedCourse.Requirements,
                Learnings = updatedCourse.Learnings,
                TargetAudience = updatedCourse.TargetAudience,
                Sections = updatedCourse.Sections?.Select(s => new SectionDTO
                {
                    Id = s.Id,
                    Title = s.Title,
                    Order = s.Order,
                    Lectures = s.Lectures?.Select(l => new LectureDTO
                    {
                        Id = l.Id,
                        Title = l.Title,
                        VideoUrl = l.VideoUrl,
                        ArticleContent = l.ArticleContent,
                        QuizId = l.QuizId,
                        ContentType = l.ContentType.ToString(),
                        Duration = (int)l.Duration.TotalSeconds,
                        Order = l.Order,
                        IsFreePreview = l.IsFreePreview
                    }).ToList()
                }).ToList()
            };
        }

        public async Task<bool> DeleteCourseAsync(int id)
        {
            return await _courseRepository.DeleteAsync(id);
        }

        public async Task<IEnumerable<CourseDTO>> GetCoursesByInstructorAsync(string instructorId)
        {
            var courses = await _courseRepository.GetCoursesByInstructorAsync(instructorId);
            return courses.Select(c => new CourseDTO
            {
                Id = c.Id,
                Title = c.Title,
                ShortDescription = c.ShortDescription,
                Description = c.Description,
                Price = c.Price,
                Discount = c.Discount,
                ThumbnailUrl = c.ThumbnailUrl,
                CreatedAt = c.CreatedAt,
                InstructorId = c.InstructorId,
                CategoryId = c.CategoryId,
                Level = c.Level,
                Language = c.Language,
                Duration = c.Duration,
                TotalLectures = c.Sections?.Sum(s => s.Lectures?.Count ?? 0) ?? 0,
                HasCertificate = c.HasCertificate,
                Requirements = c.Requirements,
                Learnings = c.Learnings,
                TargetAudience = c.TargetAudience,
                Sections = c.Sections?.Select(s => new SectionDTO
                {
                    Id = s.Id,
                    Title = s.Title,
                    Order = s.Order,
                    Lectures = s.Lectures?.Select(l => new LectureDTO
                    {
                        Id = l.Id,
                        Title = l.Title,
                        VideoUrl = l.VideoUrl,
                        ArticleContent = l.ArticleContent,
                        QuizId = l.QuizId,
                        ContentType = l.ContentType.ToString(),
                        Duration = (int)l.Duration.TotalSeconds,
                        Order = l.Order,
                        IsFreePreview = l.IsFreePreview
                    }).ToList()
                }).ToList()
            });
        }

        public async Task<IEnumerable<CourseDTO>> GetCoursesWithCategoryAsync(int categoryId)
        {
            var courses = await _courseRepository.GetCoursesWithCategoryAsync(categoryId);
            return courses.Select(c => new CourseDTO
            {
                Id = c.Id,
                Title = c.Title,
                ShortDescription = c.ShortDescription,
                Description = c.Description,
                Price = c.Price,
                Discount = c.Discount,
                ThumbnailUrl = c.ThumbnailUrl,
                CreatedAt = c.CreatedAt,
                InstructorId = c.InstructorId,
                CategoryId = c.CategoryId,
                Level = c.Level,
                Language = c.Language,
                Duration = c.Duration,
                TotalLectures = c.Sections?.Sum(s => s.Lectures?.Count ?? 0) ?? 0,
                HasCertificate = c.HasCertificate,
                Requirements = c.Requirements,
                Learnings = c.Learnings,
                TargetAudience = c.TargetAudience,
                Sections = c.Sections?.Select(s => new SectionDTO
                {
                    Id = s.Id,
                    Title = s.Title,
                    Order = s.Order,
                    Lectures = s.Lectures?.Select(l => new LectureDTO
                    {
                        Id = l.Id,
                        Title = l.Title,
                        VideoUrl = l.VideoUrl,
                        ArticleContent = l.ArticleContent,
                        QuizId = l.QuizId,
                        ContentType = l.ContentType.ToString(),
                        Duration = (int)l.Duration.TotalSeconds,
                        Order = l.Order,
                        IsFreePreview = l.IsFreePreview
                    }).ToList()
                }).ToList()
            });
        }
    }
}