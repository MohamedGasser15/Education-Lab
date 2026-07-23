using AutoMapper;
using EduLab_Application.DTOs.LectureComment;
using EduLab_Application.DTOs.Notification;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using Microsoft.AspNetCore.Identity;

namespace EduLab_Application.Services
{
    public class LectureCommentService : ILectureCommentService
    {
        private readonly ILectureCommentRepository _repository;
        private readonly ICourseRepository _courseRepository;
        private readonly INotificationService _notificationService;
        private readonly IEmailSender _emailSender;
        private readonly IEmailTemplateService _emailTemplateService;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IMapper _mapper;

        public LectureCommentService(
            ILectureCommentRepository repository,
            ICourseRepository courseRepository,
            INotificationService notificationService,
            IEmailSender emailSender,
            IEmailTemplateService emailTemplateService,
            UserManager<ApplicationUser> userManager,
            IMapper mapper)
        {
            _repository = repository;
            _courseRepository = courseRepository;
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
                        Type = NotificationTypeDto.Course,
                        UserId = course.InstructorId,
                        RelatedEntityId = $"{course.Id}_{dto.LectureId}_{saved.Id}",
                        RelatedEntityType = "LectureComment"
                    }, cancellationToken);
                }
            }

            return _mapper.Map<LectureCommentDTO>(saved);
        }

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
                            instructor
                        );
                        await _emailSender.SendEmailAsync(student.Email, $"📩 رد على تعليقك - {courseName}", emailBody);
                    }
                }
            }

            return reply;
        }

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

        private async Task<bool> IsUserInstructor(string userId, int lectureId, CancellationToken cancellationToken)
        {
            var courseId = await _courseRepository.GetCourseIdByLectureAsync(lectureId, cancellationToken);
            if (courseId == null) return false;
            var course = await _courseRepository.GetCourseByIdAsync(courseId.Value, cancellationToken: cancellationToken);
            return course?.InstructorId == userId;
        }
    }
}
