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
        private readonly IVideoDurationService _videoDurationService;

        public CourseService(ICourseRepository courseRepository, IUserRepository userRepository, IVideoDurationService videoDurationService)
        {
            _courseRepository = courseRepository;
            _userRepository = userRepository;
            _videoDurationService = videoDurationService;
        }

        private int CalculateTotalDuration(IEnumerable<SectionDTO> sections)
        {
            if (sections == null || !sections.Any())
                return 0;

            return sections
                .SelectMany(s => s.Lectures ?? new List<LectureDTO>())
                 .Sum(l => l.Duration);
        }

        private int CalculateTotalDuration(IEnumerable<Section> sections)
        {
            if (sections == null || !sections.Any())
                return 0;

            return sections
                .SelectMany(s => s.Lectures ?? new List<Lecture>())
                .Sum(l => l.Duration);
        }

        private async Task CalculateLecturesDurationAsync(IEnumerable<Lecture> lectures)
        {
            if (lectures == null) return;

            foreach (var lecture in lectures)
            {
                if (!string.IsNullOrEmpty(lecture.VideoUrl) && lecture.Duration == 0)
                {
                    try
                    {
                        lecture.Duration = await _videoDurationService.GetVideoDurationFromUrlAsync(lecture.VideoUrl);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Error calculating duration for lecture {lecture.Title}: {ex.Message}");
                    }
                }
            }
        }

        public async Task<IEnumerable<CourseDTO>> GetAllCoursesAsync()
        {
            var courses = await _courseRepository.GetAllAsync(null, "Category,Sections.Lectures", false);
            var courseDTOs = new List<CourseDTO>();

            foreach (var c in courses)
            {
                // Fetch instructor name
                var instructor = await _userRepository.GetUserById(c.InstructorId);
                var instructorName = instructor?.FullName ?? "غير متوفر";

                // حساب المدة التلقائي من المحاضرات
                var totalDuration = CalculateTotalDuration(c.Sections);

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
                    InstructorName = instructorName,
                    CategoryId = c.CategoryId,
                    CategoryName = c.Category?.Category_Name ?? "غير معروف",
                    Level = c.Level,
                    Language = c.Language,
                    Duration = totalDuration, // استخدام المدة المحسوبة تلقائياً
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
                            Duration = l.Duration,
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
            var instructor = await _userRepository.GetUserById(course.InstructorId);
            var instructorName = instructor?.FullName ?? "غير متوفر";

            // حساب المدة التلقائي من المحاضرات
            var totalDuration = CalculateTotalDuration(course.Sections);

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
                InstructorName = instructorName,
                CategoryId = course.CategoryId,
                CategoryName = course.Category?.Category_Name ?? "غير معروف",
                Level = course.Level,
                Language = course.Language,
                Duration = totalDuration, // استخدام المدة المحسوبة تلقائياً
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
                        Duration = l.Duration,
                        Order = l.Order,
                        IsFreePreview = l.IsFreePreview
                    }).ToList()
                }).ToList()
            };
        }

        public async Task<CourseDTO> AddCourseAsync(CourseCreateDTO courseDto)
        {
            // إنشاء الأقسام والمحاضرات
            var sections = courseDto.Sections?.Select(s => new Section
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
                    Duration = l.Duration, // سيتم تحديثها لاحقاً إذا كانت 0
                    Order = l.Order,
                    IsFreePreview = l.IsFreePreview
                }).ToList()
            }).ToList();

            // حساب مدة المحاضرات تلقائياً من الفيديو
            if (sections != null)
            {
                foreach (var section in sections)
                {
                    await CalculateLecturesDurationAsync(section.Lectures);
                }
            }

            // حساب المدة الإجمالية
            var totalDuration = CalculateTotalDuration(sections);

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
                Duration = totalDuration, // استخدام المدة المحسوبة تلقائياً
                HasCertificate = courseDto.HasCertificate,
                Requirements = courseDto.Requirements,
                Learnings = courseDto.Learnings,
                TargetAudience = courseDto.TargetAudience,
                CreatedAt = DateTime.UtcNow,
                ThumbnailUrl = string.IsNullOrEmpty(courseDto.ThumbnailUrl)
                    ? "/images/Courses/default.jpg"
                    : courseDto.ThumbnailUrl,
                Sections = sections
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
                Duration = totalDuration, // استخدام نفس المدة المحسوبة
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
                        Duration = l.Duration,
                        Order = l.Order,
                        IsFreePreview = l.IsFreePreview
                    }).ToList()
                }).ToList()
            };

            return courseDtoResult;
        }

        public async Task<CourseDTO> UpdateCourseAsync(CourseUpdateDTO courseDto)
        {
            // إنشاء الأقسام والمحاضرات
            var sections = courseDto.Sections?.Select(s => new Section
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
                    Duration = l.Duration, // سيتم تحديثها لاحقاً إذا كانت 0
                    Order = l.Order,
                    IsFreePreview = l.IsFreePreview,
                    SectionId = s.Id
                }).ToList()
            }).ToList();

            // حساب مدة المحاضرات تلقائياً من الفيديو
            if (sections != null)
            {
                foreach (var section in sections)
                {
                    await CalculateLecturesDurationAsync(section.Lectures);
                }
            }

            // حساب المدة الإجمالية
            var totalDuration = CalculateTotalDuration(sections);

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
                Duration = totalDuration, // استخدام المدة المحسوبة تلقائياً
                HasCertificate = courseDto.HasCertificate,
                Requirements = courseDto.Requirements,
                Learnings = courseDto.Learnings,
                TargetAudience = courseDto.TargetAudience,
                Sections = sections
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
                Duration = CalculateTotalDuration(updatedCourse.Sections), // حساب تلقائي للمدة
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
                        Duration = l.Duration,
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
                Duration = CalculateTotalDuration(c.Sections), // حساب تلقائي للمدة
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
                        Duration = l.Duration,
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
                Duration = CalculateTotalDuration(c.Sections), // حساب تلقائي للمدة
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
                        Duration = l.Duration,
                        Order = l.Order,
                        IsFreePreview = l.IsFreePreview
                    }).ToList()
                }).ToList()
            });
        }
    }
}