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
        private readonly ICurrentUserService _currentUserService;
        private readonly IHistoryService _historyService;
        public CourseService(ICourseRepository courseRepository, IUserRepository userRepository, IVideoDurationService videoDurationService, ICurrentUserService currentUserService ,IHistoryService historyService )
        {
            _courseRepository = courseRepository;
            _userRepository = userRepository;
            _videoDurationService = videoDurationService;
            _currentUserService = currentUserService;
            _historyService = historyService;
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
                var instructor = await _userRepository.GetUserById(c.InstructorId);
                var instructorName = instructor?.FullName ?? "غير متوفر";
                var instructorImage = instructor?.ProfileImageUrl;

                if (!string.IsNullOrEmpty(instructorImage) && !instructorImage.StartsWith("https"))
                {
                    instructorImage = "https://localhost:7292" + instructorImage;
                }
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
                    Status = c.Status.ToString(),
                    ThumbnailUrl = c.ThumbnailUrl,
                    CreatedAt = c.CreatedAt,
                    InstructorId = c.InstructorId,
                    InstructorName = instructorName,
                    ProfileImageUrl = instructorImage,
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
            var instructorImage = instructor?.ProfileImageUrl;

            if (!string.IsNullOrEmpty(instructorImage) && !instructorImage.StartsWith("https"))
            {
                instructorImage = "https://localhost:7292" + instructorImage;
            }
            // حساب المدة التلقائي من المحاضرات
            var totalDuration = CalculateTotalDuration(course.Sections);

            return new CourseDTO
            {
                Id = course.Id,
                Title = course.Title,
                ShortDescription = course.ShortDescription,
                Description = course.Description,
                Price = course.Price,
                Status = course.Status.ToString(),
                Discount = course.Discount,
                ThumbnailUrl = course.ThumbnailUrl,
                CreatedAt = course.CreatedAt,
                InstructorId = course.InstructorId,
                InstructorName = instructorName,
                ProfileImageUrl = instructorImage,
                CategoryId = course.CategoryId,
                CategoryName = course.Category?.Category_Name ?? "غير معروف",
                Level = course.Level,
                Language = course.Language,
                Duration = totalDuration,
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

        public async Task<IEnumerable<CourseDTO>> GetInstructorCoursesAsync(string instructorId)
        {
            var courses = await _courseRepository.GetAllAsync(
                filter: c => c.InstructorId == instructorId,
                includeProperties: "Category,Sections.Lectures"
            );

            var courseDTOs = new List<CourseDTO>();

            foreach (var c in courses)
            {
                var totalDuration = CalculateTotalDuration(c.Sections);

                courseDTOs.Add(new CourseDTO
                {
                    Id = c.Id,
                    Title = c.Title,
                    ShortDescription = c.ShortDescription,
                    Description = c.Description,
                    Price = c.Price,
                    Discount = c.Discount,
                    Status = c.Status.ToString(),
                    ThumbnailUrl = c.ThumbnailUrl,
                    CreatedAt = c.CreatedAt,
                    CategoryId = c.CategoryId,
                    CategoryName = c.Category?.Category_Name ?? "غير معروف",
                    Level = c.Level,
                    Language = c.Language,
                    Duration = totalDuration,
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

        public async Task<CourseDTO> AddCourseAsync(CourseCreateDTO courseDto)
        {
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
                    Duration = l.Duration,
                    Order = l.Order,
                    IsFreePreview = l.IsFreePreview
                }).ToList()
            }).ToList();

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
            var currentUserId = await _currentUserService.GetUserIdAsync();
            if (!string.IsNullOrEmpty(currentUserId))
            {
                await _historyService.LogOperationAsync(
                    currentUserId,
                $"قام المستخدم بإضافة كورس جديد [ID: {course.Id}] بعنوان \"{course.Title}\"."
                );
            }
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
            // جلب الكورس الحالي مع الأقسام والمحاضرات
            var existingCourse = await _courseRepository.GetAsync(
                c => c.Id == courseDto.Id,
                includeProperties: "Sections.Lectures"
            );


            if (existingCourse == null)
                return null;

            // إنشاء الأقسام والمحاضرات الجديدة
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

            // حساب مدة المحاضرات تلقائياً
            if (sections != null)
            {
                foreach (var section in sections)
                {
                    await CalculateLecturesDurationAsync(section.Lectures);
                }
            }

            // حساب المدة الإجمالية
            var totalDuration = CalculateTotalDuration(sections);

            // تحديث الكورس الحالي فقط مع الحفاظ على CreatedAt
            existingCourse.Title = courseDto.Title;
            existingCourse.ShortDescription = courseDto.ShortDescription;
            existingCourse.Description = courseDto.Description;
            existingCourse.Price = courseDto.Price;
            existingCourse.Discount = courseDto.Discount;
            existingCourse.ThumbnailUrl = courseDto.ThumbnailUrl;
            existingCourse.InstructorId = courseDto.InstructorId;
            existingCourse.CategoryId = courseDto.CategoryId;
            existingCourse.Level = courseDto.Level;
            existingCourse.Language = courseDto.Language;
            existingCourse.Duration = totalDuration;
            existingCourse.HasCertificate = courseDto.HasCertificate;
            existingCourse.Requirements = courseDto.Requirements;
            existingCourse.Learnings = courseDto.Learnings;
            existingCourse.TargetAudience = courseDto.TargetAudience;
            existingCourse.Sections = sections;

            var updatedCourse = await _courseRepository.UpdateAsync(existingCourse);

            var currentUserId = await _currentUserService.GetUserIdAsync();
            if (!string.IsNullOrEmpty(currentUserId))
            {
                await _historyService.LogOperationAsync(
                    currentUserId,
                    $"قام المستخدم بتعديل الكورس [ID: {updatedCourse.Id}] بعنوان \"{updatedCourse.Title}\"."
                );
            }

            if (updatedCourse == null)
                return null;

            return new CourseDTO
            {
                Id = updatedCourse.Id,
                Title = updatedCourse.Title,
                ShortDescription = updatedCourse.ShortDescription,
                Description = updatedCourse.Description,
                Price = updatedCourse.Price,
                Discount = updatedCourse.Discount,
                ThumbnailUrl = updatedCourse.ThumbnailUrl,
                CreatedAt = updatedCourse.CreatedAt, // محفوظة صح دلوقتي
                InstructorId = updatedCourse.InstructorId,
                CategoryId = updatedCourse.CategoryId,
                Level = updatedCourse.Level,
                Language = updatedCourse.Language,
                Duration = CalculateTotalDuration(updatedCourse.Sections),
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

        public async Task<CourseDTO> UpdateCourseAsInstructorAsync(CourseUpdateDTO courseDto)
        {
            // جلب الكورس الحالي مع الأقسام والمحاضرات
            var existingCourse = await _courseRepository.GetAsync(
                c => c.Id == courseDto.Id,
                includeProperties: "Sections.Lectures"
            );

            if (existingCourse == null)
                return null;

            // جلب Id المستخدم الحالي (Instructor)
            var instructorId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(instructorId))
                throw new UnauthorizedAccessException("المستخدم غير مسجل دخول");

            // التأكد إن الـ Instructor الحالي هو صاحب الكورس
            if (existingCourse.InstructorId != instructorId)
                throw new UnauthorizedAccessException("لا يمكن تعديل كورس لا يخصك");

            // إنشاء الأقسام والمحاضرات الجديدة
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
                    Duration = l.Duration,
                    Order = l.Order,
                    IsFreePreview = l.IsFreePreview,
                    SectionId = s.Id
                }).ToList()
            }).ToList();

            // حساب مدة المحاضرات تلقائياً
            if (sections != null)
            {
                foreach (var section in sections)
                {
                    await CalculateLecturesDurationAsync(section.Lectures);
                }
            }

            // حساب المدة الإجمالية
            var totalDuration = CalculateTotalDuration(sections);

            // تحديث الكورس الحالي
            existingCourse.Title = courseDto.Title;
            existingCourse.ShortDescription = courseDto.ShortDescription;
            existingCourse.Description = courseDto.Description;
            existingCourse.Price = courseDto.Price;
            existingCourse.Discount = courseDto.Discount;
            existingCourse.ThumbnailUrl = courseDto.ThumbnailUrl;
            existingCourse.CategoryId = courseDto.CategoryId;
            existingCourse.Level = courseDto.Level;
            existingCourse.Language = courseDto.Language;
            existingCourse.Duration = totalDuration;
            existingCourse.HasCertificate = courseDto.HasCertificate;
            existingCourse.Requirements = courseDto.Requirements;
            existingCourse.Learnings = courseDto.Learnings;
            existingCourse.TargetAudience = courseDto.TargetAudience;
            existingCourse.Sections = sections;

            var updatedCourse = await _courseRepository.UpdateAsync(existingCourse);

            // تسجيل العملية
            await _historyService.LogOperationAsync(
                instructorId,
                $"قام المستخدم بتعديل الكورس [ID: {updatedCourse.Id}] بعنوان \"{updatedCourse.Title}\"."
            );

            // تحويل الكورس إلى DTO للإرجاع
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
                Duration = totalDuration,
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


        public async Task<CourseDTO> AddCourseAsInstructorAsync(CourseCreateDTO courseDto)
        {
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
                    Duration = l.Duration,
                    Order = l.Order,
                    IsFreePreview = l.IsFreePreview
                }).ToList()
            }).ToList();

            if (sections != null)
            {
                foreach (var section in sections)
                {
                    await CalculateLecturesDurationAsync(section.Lectures);
                }
            }

            // حساب المدة الإجمالية
            var totalDuration = CalculateTotalDuration(sections);

            // جلب Id المستخدم الحالي (Instructor)
            var instructorId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(instructorId))
            {
                throw new UnauthorizedAccessException("User is not authenticated");
            }
            
            var course = new Course
            {
                Title = courseDto.Title,
                ShortDescription = courseDto.ShortDescription,
                Description = courseDto.Description,
                Price = courseDto.Price,
                Discount = courseDto.Discount,
                InstructorId = instructorId, // هنا الفرق الرئيسي
                CategoryId = courseDto.CategoryId,
                Level = courseDto.Level,
                Language = courseDto.Language,
                Duration = totalDuration,
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

            // تسجيل العملية في التاريخ
            await _historyService.LogOperationAsync(
                instructorId,
                $"قام المستخدم بإضافة كورس جديد [ID: {course.Id}] بعنوان \"{course.Title}\"."
            );

            // تحويل الـ Course إلى DTO للإرجاع
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
                Duration = totalDuration,
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


        public async Task<bool> DeleteCourseAsync(int id)
        {
            var course = await _courseRepository.GetCourseByIdAsync(id, false);
            var result = await _courseRepository.DeleteAsync(id);

            if (result && course != null)
            {
                var currentUserId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(currentUserId))
                {
                    await _historyService.LogOperationAsync(
                        currentUserId,
                       $"قام المستخدم بحذف الكورس [ID: {course.Id}] بعنوان \"{course.Title}\"."
                    );
                }
            }

            return result;
        }
        public async Task<bool> DeleteCourseAsInstructorAsync(int id)
        {
            var course = await _courseRepository.GetCourseByIdAsync(id, false);
            if (course == null)
                return false;

            // جلب Id الInstructor الحالي
            var instructorId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(instructorId))
                throw new UnauthorizedAccessException("المستخدم غير مسجل دخول");

            // التأكد إن الكورس يخص هذا الـ Instructor
            if (course.InstructorId != instructorId)
                throw new UnauthorizedAccessException("لا يمكن حذف كورس لا يخصك");

            var result = await _courseRepository.DeleteAsync(id);

            if (result)
            {
                await _historyService.LogOperationAsync(
                    instructorId,
                    $"قام المستخدم بحذف الكورس [ID: {course.Id}] بعنوان \"{course.Title}\"."
                );
            }

            return result;
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

        public async Task<bool> BulkDeleteCoursesAsync(List<int> ids)
        {
            var courses = await _courseRepository.GetAllAsync(c => ids.Contains(c.Id));
            var result = await _courseRepository.BulkDeleteAsync(ids);

            if (result && courses.Any())
            {
                var currentUserId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(currentUserId))
                {
                    var titles = string.Join(", ", courses.Select(c => c.Title));
                    await _historyService.LogOperationAsync(
                        currentUserId,
                        $"قام المستخدم بحذف الكورسات التالية: {titles}."
                    );
                }
            }

            return result;
        }

        public async Task<bool> BulkDeleteCoursesAsInstructorAsync(List<int> ids)
        {
            var instructorId = await _currentUserService.GetUserIdAsync();
            if (string.IsNullOrEmpty(instructorId))
                throw new UnauthorizedAccessException("المستخدم غير مسجل دخول");

            var courses = await _courseRepository.GetAllAsync(c => ids.Contains(c.Id) && c.InstructorId == instructorId);
            if (!courses.Any())
                return false;

            var idsToDelete = courses.Select(c => c.Id).ToList();
            var result = await _courseRepository.BulkDeleteAsync(idsToDelete);

            if (result)
            {
                var titles = string.Join(", ", courses.Select(c => c.Title));
                await _historyService.LogOperationAsync(
                    instructorId,
                    $"قام المستخدم بحذف الكورسات التالية: {titles}."
                );
            }

            return result;
        }

        public async Task<bool> BulkPublishCoursesAsync(List<int> ids)
        {
            var courses = await _courseRepository.GetAllAsync(c => ids.Contains(c.Id));
            var result = await _courseRepository.BulkUpdateStatusAsync(ids, Coursestatus.Approved);

            if (result && courses.Any())
            {
                var currentUserId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(currentUserId))
                {
                    var titles = string.Join(", ", courses.Select(c => c.Title));
                    await _historyService.LogOperationAsync(
                        currentUserId,
                        $"قام المستخدم بالموافقة على الكورسات التالية: {titles}."
                    );
                }
            }

            return result;
        }


        public async Task<bool> BulkUnpublishCoursesAsync(List<int> ids)
        {
            var courses = await _courseRepository.GetAllAsync(c => ids.Contains(c.Id));
            var result = await _courseRepository.BulkUpdateStatusAsync(ids, Coursestatus.Rejected);

            if (result && courses.Any())
            {
                var currentUserId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(currentUserId))
                {
                    var titles = string.Join(", ", courses.Select(c => c.Title));
                    await _historyService.LogOperationAsync(
                        currentUserId,
                        $"قام المستخدم برفض الكورسات التالية: {titles}."
                    );
                }
            }

            return result;
        }

        public async Task<bool> AcceptCourseAsync(int id)
        {
            var course = await _courseRepository.GetCourseByIdAsync(id, false);
            var result = await _courseRepository.UpdateStatusAsync(id, Coursestatus.Approved);

            if (result && course != null)
            {
                var currentUserId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(currentUserId))
                {
                    await _historyService.LogOperationAsync(
                        currentUserId,
                       $"قام المستخدم بالموافقة على الكورس [ID: {course.Id}] بعنوان \"{course.Title}\"."
                    );
                }
            }

            return result;
        }

        public async Task<bool> RejectCourseAsync(int id)
        {
            var course = await _courseRepository.GetCourseByIdAsync(id, false);
            var result = await _courseRepository.UpdateStatusAsync(id, Coursestatus.Rejected);

            if (result && course != null)
            {
                var currentUserId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(currentUserId))
                {
                    await _historyService.LogOperationAsync(
                        currentUserId,
                       $"قام المستخدم برفض الكورس [ID: {course.Id}] بعنوان \"{course.Title}\"."
                    );
                }
            }

            return result;
        }
        // في CourseService
        public async Task<IEnumerable<CourseDTO>> GetApprovedCoursesByCategoriesAsync(List<int> categoryIds, int countPerCategory)
        {
            var courses = await _courseRepository.GetApprovedCoursesByCategoriesAsync(categoryIds, countPerCategory);
            return courses.Select(c => MapToCourseDTO(c)).ToList();
        }

        public async Task<IEnumerable<CourseDTO>> GetApprovedCoursesByCategoryAsync(int categoryId, int count)
        {
            var courses = await _courseRepository.GetApprovedCoursesByCategoryAsync(categoryId, count);
            return courses.Select(c => MapToCourseDTO(c)).ToList();
        }

        // دالة مساعدة للتحويل
        private CourseDTO MapToCourseDTO(Course c)
        {
            var instructor = _userRepository.GetUserById(c.InstructorId).Result;
            var instructorName = instructor?.FullName ?? "غير متوفر";
            var instructorImage = instructor?.ProfileImageUrl;

            if (!string.IsNullOrEmpty(instructorImage) && !instructorImage.StartsWith("https"))
            {
                instructorImage = "https://localhost:7292" + instructorImage;
            }

            return new CourseDTO
            {
                Id = c.Id,
                Title = c.Title,
                ShortDescription = c.ShortDescription,
                Description = c.Description,
                Price = c.Price,
                Discount = c.Discount,
                Status = c.Status.ToString(),
                ThumbnailUrl = c.ThumbnailUrl,
                CreatedAt = c.CreatedAt,
                InstructorId = c.InstructorId,
                InstructorName = instructorName,
                ProfileImageUrl = instructorImage, // ✅ ربطناها هنا
                CategoryId = c.CategoryId,
                CategoryName = c.Category?.Category_Name ?? "غير معروف",
                Level = c.Level,
                Language = c.Language,
                Duration = CalculateTotalDuration(c.Sections),
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
            };
        }
    }
}