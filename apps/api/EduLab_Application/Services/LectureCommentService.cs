using AutoMapper;
using EduLab_Application.Common;
using EduLab_Application.DTOs.Instructor;
using EduLab_Application.DTOs.LectureComment;
using EduLab_Application.DTOs.Notification;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using Microsoft.AspNetCore.Identity;
using System.Text.Json;

namespace EduLab_Application.Services
{
    /// <summary>
    /// Service implementation for managing lecture comments
    /// </summary>
    public class LectureCommentService : ILectureCommentService
    {
        private readonly ILectureCommentRepository _repository;
        private readonly ICourseRepository _courseRepository;
        private readonly IRepository<Section> _sectionRepository;
        private readonly IRepository<Lecture> _lectureRepository;
        private readonly INotificationService _notificationService;
        private readonly IEmailSender _emailSender;
        private readonly IEmailTemplateService _emailTemplateService;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IMapper _mapper;

        public LectureCommentService(
            ILectureCommentRepository repository,
            ICourseRepository courseRepository,
            IRepository<Section> sectionRepository,
            IRepository<Lecture> lectureRepository,
            INotificationService notificationService,
            IEmailSender emailSender,
            IEmailTemplateService emailTemplateService,
            UserManager<ApplicationUser> userManager,
            IMapper mapper)
        {
            _repository = repository;
            _courseRepository = courseRepository;
            _sectionRepository = sectionRepository;
            _lectureRepository = lectureRepository;
            _notificationService = notificationService;
            _emailSender = emailSender;
            _emailTemplateService = emailTemplateService;
            _userManager = userManager;
            _mapper = mapper;
        }

        public async Task<List<LectureCommentDTO>> GetLectureCommentsAsync(int lectureId, CancellationToken cancellationToken = default)
        {
            var comments = await _repository.GetLectureCommentsAsync(lectureId, cancellationToken);
            var dtos = _mapper.Map<List<LectureCommentDTO>>(comments);

            foreach (var dto in dtos)
            {
                var comment = comments.FirstOrDefault(c => c.Id == dto.Id);
                if (comment != null)
                    dto.IsInstructorReply = await IsUserInstructor(comment.UserId, comment.LectureId, cancellationToken);

                foreach (var reply in dto.Replies)
                {
                    var replyEntity = comment?.Replies.FirstOrDefault(r => r.Id == reply.Id);
                    if (replyEntity != null)
                        reply.IsInstructorReply = await IsUserInstructor(replyEntity.UserId, replyEntity.LectureId, cancellationToken);
                }
            }

            return dtos;
        }

        /// <summary>
        /// Adds a new comment to a lecture
        /// </summary>
        /// <param name="userId">Unique identifier of the commenting user</param>
        /// <param name="dto">Comment creation data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The created comment DTO</returns>
        public async Task<LectureCommentDTO> AddCommentAsync(string userId, CreateLectureCommentDTO dto, CancellationToken cancellationToken = default)
        {
            var comment = new LectureComment
            {
                LectureId = dto.LectureId,
                UserId = userId,
                Content = dto.Content,
                ParentCommentId = dto.ParentCommentId,
                CreatedAt = DateTime.UtcNow
            };

            await _repository.CreateAsync(comment, cancellationToken);
            await _repository.SaveAsync(cancellationToken);

            var saved = await _repository.GetAsync(
                c => c.Id == comment.Id,
                includeProperties: "User,Lecture.Section",
                cancellationToken: cancellationToken);

            // Notify instructor when a student posts a comment
            if (saved?.Lecture?.Section?.CourseId != null)
            {
                var course = await _courseRepository.GetCourseByIdAsync(saved.Lecture.Section.CourseId, cancellationToken: cancellationToken);
                if (course != null && course.InstructorId != userId)
                {
                    var studentName = saved.User?.FullName ?? "طالب";
                    var lectureTitle = saved.Lecture?.Title ?? "";
                    await _notificationService.CreateNotificationAsync(new CreateNotificationDto
                    {
                        Title = "💬 تعليق جديد",
                        Message = $"قام {studentName} بإضافة تعليق في محاضرة \"{lectureTitle}\"",
                        TitleKey = NotificationMessages.NewComment_Title,
                        MessageKey = NotificationMessages.NewComment_Msg,
                        Parameters = JsonSerializer.Serialize(new { studentName, lectureTitle }),
                        Type = NotificationTypeDto.Course,
                        UserId = course.InstructorId,
                        RelatedEntityId = $"{course.Id}_{dto.LectureId}_{saved.Id}",
                        RelatedEntityType = "LectureComment"
                    }, cancellationToken);
                }
            }

            return _mapper.Map<LectureCommentDTO>(saved);
        }

        /// <summary>
        /// Replies to an existing lecture comment
        /// </summary>
        /// <param name="userId">Unique identifier of the replying user</param>
        /// <param name="parentCommentId">Unique identifier of the parent comment</param>
        /// <param name="dto">Reply creation data</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>The created reply DTO, or null if the parent comment was not found</returns>
        public async Task<LectureCommentDTO> ReplyToCommentAsync(string userId, int parentCommentId, CreateLectureCommentDTO dto, CancellationToken cancellationToken = default)
        {
            var parent = await _repository.GetAsync(
                c => c.Id == parentCommentId,
                includeProperties: "User",
                cancellationToken: cancellationToken);
            if (parent == null) return null;

            dto.ParentCommentId = parentCommentId;
            dto.LectureId = parent.LectureId;
            var reply = await AddCommentAsync(userId, dto, cancellationToken);

            // If the reply is from the instructor, notify + email the student
            var courseId = await _courseRepository.GetCourseIdByLectureAsync(parent.LectureId, cancellationToken);
            if (courseId != null)
            {
                var course = await _courseRepository.GetCourseByIdAsync(courseId.Value, cancellationToken: cancellationToken);
                if (course?.InstructorId == userId && parent.UserId != userId)
                {
                    var instructor = await _userManager.FindByIdAsync(userId);
                    var student = await _userManager.FindByIdAsync(parent.UserId);
                    var instructorName = instructor?.FullName ?? "مدرب";
                    var courseName = course.Title;
                    var lecture = parent.Lecture;

                    // Notification
                    await _notificationService.CreateNotificationAsync(new CreateNotificationDto
                    {
                        Title = "📩 رد على تعليقك",
                        Message = $"قام {instructorName} بالرد على تعليقك في دورة \"{courseName}\"",
                        TitleKey = NotificationMessages.CommentReply_Title,
                        MessageKey = NotificationMessages.CommentReply_Msg,
                        Parameters = JsonSerializer.Serialize(new { instructorName, courseName }),
                        Type = NotificationTypeDto.Course,
                        UserId = parent.UserId,
                        RelatedEntityId = $"{course.Id}_{parent.LectureId}_{reply.Id}",
                        RelatedEntityType = "LectureComment"
                    }, cancellationToken);

                    // Email
                    if (student?.Email != null)
                    {
                        var emailBody = _emailTemplateService.GenerateInstructorNotificationEmail(
                            student,
                            new InstructorNotificationRequestDto
                            {
                                Title = "رد على تعليقك 💬",
                                Message = $"قام {instructorName} بالرد على تعليقك في دورة \"{courseName}\".\n\nالرد: {dto.Content}"
                            },
                            instructor,
                            student.PreferredLanguage ?? "en"
                        );
                        await _emailSender.SendEmailAsync(student.Email, _emailTemplateService.GetFormattedText("EmailSubjectCommentReply", student.PreferredLanguage ?? "en", courseName), emailBody);
                    }
                }
            }

            return reply;
        }

        /// <summary>
        /// Deletes a comment if the user owns it
        /// </summary>
        /// <param name="commentId">Unique identifier of the comment</param>
        /// <param name="userId">Unique identifier of the requesting user</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>True if the comment was deleted, otherwise false</returns>
        public async Task<bool> DeleteCommentAsync(int commentId, string userId, CancellationToken cancellationToken = default)
        {
            var comment = await _repository.GetAsync(
                c => c.Id == commentId,
                includeProperties: "Replies",
                isTracking: true,
                cancellationToken: cancellationToken);

            if (comment == null || comment.UserId != userId)
                return false;

            if (comment.Replies?.Any() == true)
                await _repository.DeleteRangeAsync(comment.Replies, cancellationToken);

            await _repository.DeleteAsync(comment, cancellationToken);
            await _repository.SaveAsync(cancellationToken);
            return true;
        }

        /// <summary>
        /// Retrieves all lecture comments for an instructor's courses, grouped by course
        /// </summary>
        /// <param name="instructorId">Instructor identifier</param>
        /// <param name="cancellationToken">Cancellation token to cancel the operation</param>
        /// <returns>List of comment groups per course</returns>
        public async Task<List<InstructorCommentsGroupDTO>> GetInstructorCommentsAsync(string instructorId, CancellationToken cancellationToken = default)
        {
            var courses = (await _courseRepository.GetCoursesByInstructorAsync(instructorId, cancellationToken) ?? new List<Course>()).ToList();
            var courseIds = courses.Select(c => c.Id).ToList();

            if (!courseIds.Any())
                return new List<InstructorCommentsGroupDTO>();

            var sections = await _sectionRepository.GetAllAsync(
                s => courseIds.Contains(s.CourseId),
                cancellationToken: cancellationToken);
            var sectionIds = sections.Select(s => s.Id).ToList();

            var lectures = await _lectureRepository.GetAllAsync(
                l => sectionIds.Contains(l.SectionId),
                cancellationToken: cancellationToken);
            var lectureIds = lectures.Select(l => l.Id).ToList();

            var comments = await _repository.GetAllAsync(
                c => lectureIds.Contains(c.LectureId) && c.ParentCommentId == null,
                includeProperties: "User,Lecture.Section,Replies.User",
                orderBy: q => q.OrderByDescending(c => c.CreatedAt),
                cancellationToken: cancellationToken);

            var sectionCourseId = sections.ToDictionary(s => s.Id, s => s.CourseId);
            var lectureCourseIds = lectures.ToDictionary(l => l.Id, l => sectionCourseId.GetValueOrDefault(l.SectionId));

            var result = new List<InstructorCommentsGroupDTO>();
            foreach (var course in courses)
            {
                var courseComments = comments.Where(c => lectureCourseIds.GetValueOrDefault(c.LectureId) == course.Id).ToList();
                if (!courseComments.Any()) continue;

                var unanswered = courseComments.Count(c => c.Replies?.Any() != true);
                result.Add(new InstructorCommentsGroupDTO
                {
                    CourseId = course.Id,
                    CourseName = course.Title,
                    CourseIcon = GetCourseIcon(course.Title),
                    CourseColor = GetCourseColor(course.Title),
                    TotalCount = courseComments.Count,
                    UnansweredCount = unanswered,
                    Questions = courseComments.Select(c => new InstructorCommentDTO
                    {
                        CourseId = course.Id,
                        Id = c.Id,
                        StudentName = c.User?.FullName ?? "مستخدم",
                        StudentAvatar = c.User?.ProfileImageUrl,
                        Content = c.Content,
                        CreatedAt = c.CreatedAt,
                        TimeAgo = GetTimeAgo(c.CreatedAt),
                        LectureName = c.Lecture?.Title ?? "",
                        IsAnswered = c.Replies?.Any() == true,
                        RepliesCount = c.Replies?.Count ?? 0,
                        Replies = (c.Replies ?? new List<LectureComment>()).Select(r => new InstructorCommentReplyDTO
                        {
                            Id = r.Id,
                            StudentName = r.User?.FullName ?? "مستخدم",
                            StudentAvatar = r.User?.ProfileImageUrl,
                            Content = r.Content,
                            CreatedAt = r.CreatedAt,
                            TimeAgo = GetTimeAgo(r.CreatedAt),
                            IsInstructorReply = course.InstructorId == r.UserId
                        }).ToList()
                    }).ToList()
                });
            }

            return result;
        }

        private static string GetCourseIcon(string title)
        {
            if (string.IsNullOrEmpty(title)) return "fa-book";
            var t = title.ToLower();
            if (t.Contains("ويب") || t.Contains("web")) return "fa-globe";
            if (t.Contains("ui") || t.Contains("ux") || t.Contains("design")) return "fa-paint-brush";
            if (t.Contains("تسويق") || t.Contains("marketing")) return "fa-chart-line";
            if (t.Contains("جوال") || t.Contains("mobile")) return "fa-mobile-alt";
            if (t.Contains("بيانات") || t.Contains("data")) return "fa-database";
            return "fa-book";
        }

        private static string GetCourseColor(string title)
        {
            if (string.IsNullOrEmpty(title)) return "text-gray-500";
            var t = title.ToLower();
            if (t.Contains("ويب") || t.Contains("web")) return "text-blue-500";
            if (t.Contains("ui") || t.Contains("ux") || t.Contains("design")) return "text-purple-500";
            if (t.Contains("تسويق") || t.Contains("marketing")) return "text-emerald-500";
            if (t.Contains("جوال") || t.Contains("mobile")) return "text-amber-500";
            if (t.Contains("بيانات") || t.Contains("data")) return "text-rose-500";
            return "text-gray-500";
        }

        private static string GetTimeAgo(DateTime dateTime)
        {
            var diff = DateTime.UtcNow - dateTime;
            if (diff.TotalMinutes < 1) return "الآن";
            if (diff.TotalMinutes < 60) return $"منذ {(int)diff.TotalMinutes} دقيقة";
            if (diff.TotalHours < 24) return $"منذ {(int)diff.TotalHours} ساعة";
            if (diff.TotalDays < 7) return $"منذ {(int)diff.TotalDays} يوم";
            return dateTime.ToString("MMM dd");
        }

        private async Task<bool> IsUserInstructor(string userId, int lectureId, CancellationToken cancellationToken)
        {
            var courseId = await _courseRepository.GetCourseIdByLectureAsync(lectureId, cancellationToken);
            if (courseId == null) return false;
            var course = await _courseRepository.GetCourseByIdAsync(courseId.Value, cancellationToken: cancellationToken);
            return course?.InstructorId == userId;
        }
    }
}
