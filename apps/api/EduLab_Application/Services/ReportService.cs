using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using EduLab_Application.Common;
using EduLab_Application.Common.Constants;
using EduLab_Application.DTOs.Notification;
using EduLab_Application.DTOs.Report;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;

namespace EduLab_Application.Services
{
    public class ReportService : IReportService
    {
        private readonly IReportRepository _reportRepository;
        private readonly IRepository<LectureComment> _commentRepository;
        private readonly ICourseRepository _courseRepository;
        private readonly IRatingRepository _ratingRepository;
        private readonly INotificationService _notificationService;
        private readonly IEmailSender _emailSender;
        private readonly IEmailTemplateService _emailTemplateService;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly ILogger<ReportService> _logger;

        public ReportService(
            IReportRepository reportRepository,
            IRepository<LectureComment> commentRepository,
            ICourseRepository courseRepository,
            IRatingRepository ratingRepository,
            INotificationService notificationService,
            IEmailSender emailSender,
            IEmailTemplateService emailTemplateService,
            UserManager<ApplicationUser> userManager,
            ILogger<ReportService> logger)
        {
            _reportRepository = reportRepository;
            _commentRepository = commentRepository;
            _courseRepository = courseRepository;
            _ratingRepository = ratingRepository;
            _notificationService = notificationService;
            _emailSender = emailSender;
            _emailTemplateService = emailTemplateService;
            _userManager = userManager;
            _logger = logger;
        }

        public async Task<AdminReportDto> CreateReportAsync(string userId, CreateReportDto dto, CancellationToken cancellationToken = default)
        {
            var validTypes = new[] { SD.ReportTypeCourse, SD.ReportTypeComment, SD.ReportTypeReview };
            if (!validTypes.Contains(dto.Type))
                throw new ArgumentException("نوع البلاغ غير صالح");

            var allowedReasons = SD.GetReportReasons(dto.Type);
            if (!allowedReasons.Contains(dto.Reason))
                throw new ArgumentException("سبب البلاغ غير صالح");

            string ownerId = null;
            string targetSummary = "";
            int? courseId = null;

            switch (dto.Type)
            {
                case SD.ReportTypeCourse:
                    var course = await _courseRepository.GetAsync(c => c.Id == dto.TargetId, isTracking: false, cancellationToken: cancellationToken);
                    if (course == null)
                        throw new KeyNotFoundException("الكورس غير موجود");
                    ownerId = course.InstructorId;
                    targetSummary = course.Title;
                    courseId = course.Id;
                    break;

                case SD.ReportTypeComment:
                    var comment = await _commentRepository.GetAsync(
                        c => c.Id == dto.TargetId,
                        includeProperties: "Lecture.Section.Course",
                        isTracking: false,
                        cancellationToken: cancellationToken);
                    if (comment == null)
                        throw new KeyNotFoundException("التعليق غير موجود");
                    ownerId = comment.UserId;
                    targetSummary = comment.Content;
                    courseId = comment.Lecture?.Section?.CourseId;
                    break;

                case SD.ReportTypeReview:
                    var rating = await _ratingRepository.GetAsync(r => r.Id == dto.TargetId, isTracking: false, cancellationToken: cancellationToken);
                    if (rating == null)
                        throw new KeyNotFoundException("المراجعة غير موجودة");
                    ownerId = rating.UserId;
                    targetSummary = string.IsNullOrWhiteSpace(rating.Comment) ? $"⭐ {rating.Value}/5" : rating.Comment;
                    courseId = rating.CourseId;
                    break;
            }

            if (!string.IsNullOrEmpty(ownerId) && ownerId == userId)
                throw new InvalidOperationException("لا يمكنك الإبلاغ عن المحتوى الخاص بك");

            var duplicate = await _reportRepository.AnyAsync(
                r => r.ReporterId == userId && r.Type == dto.Type && r.TargetId == dto.TargetId,
                cancellationToken);
            if (duplicate)
                throw new InvalidOperationException("لقد قمت بالإبلاغ عن هذا المحتوى بالفعل");

            var report = new Report
            {
                Type = dto.Type,
                TargetId = dto.TargetId,
                Reason = dto.Reason,
                Details = dto.Details,
                ReporterId = userId,
                Status = SD.ReportStatusPending,
                CreatedAt = DateTime.UtcNow
            };

            await _reportRepository.CreateAsync(report, cancellationToken);
            await _reportRepository.SaveAsync(cancellationToken);

            await NotifyAdminsAsync(report, targetSummary, courseId, cancellationToken);

            return await BuildDtoAsync(report, targetSummary, courseId, cancellationToken);
        }

        public async Task<ReportListResultDto> GetAdminReportsAsync(string? status, string? type, string? search, int page, int pageSize, CancellationToken cancellationToken = default)
        {
            page = Math.Max(1, page);
            pageSize = Math.Clamp(pageSize, 1, 100);

            var totalCount = await _reportRepository.CountFilteredAsync(status, type, search, cancellationToken);

            var reports = await _reportRepository.GetFilteredAsync(
                status, type, search, (page - 1) * pageSize, pageSize, cancellationToken);

            var items = new List<AdminReportDto>();
            foreach (var report in reports)
            {
                var (targetSummary, courseId, _) = await ResolveTargetAsync(report, cancellationToken);
                items.Add(await BuildDtoAsync(report, targetSummary, courseId, cancellationToken));
            }

            return new ReportListResultDto
            {
                Items = items,
                TotalCount = totalCount,
                PendingCount = await _reportRepository.CountAsync(r => r.Status == SD.ReportStatusPending, cancellationToken),
                ResolvedCount = await _reportRepository.CountAsync(r => r.Status == SD.ReportStatusResolved, cancellationToken),
                DismissedCount = await _reportRepository.CountAsync(r => r.Status == SD.ReportStatusDismissed, cancellationToken),
                PageNumber = page,
                PageSize = pageSize
            };
        }

        public async Task<int> GetPendingCountAsync(CancellationToken cancellationToken = default)
        {
            return await _reportRepository.CountAsync(r => r.Status == SD.ReportStatusPending, cancellationToken);
        }

        public async Task<bool> HasReportedAsync(string userId, string type, int targetId, CancellationToken cancellationToken = default)
        {
            return await _reportRepository.AnyAsync(
                r => r.ReporterId == userId && r.Type == type && r.TargetId == targetId,
                cancellationToken);
        }

        public async Task<List<int>> GetReportedTargetIdsAsync(string userId, string type, List<int> targetIds, CancellationToken cancellationToken = default)
        {
            if (targetIds == null || targetIds.Count == 0)
                return new List<int>();

            return await _reportRepository.GetReportedTargetIdsAsync(userId, type, targetIds, cancellationToken);
        }

        public async Task UpdateStatusAsync(string adminId, int reportId, UpdateReportStatusDto dto, CancellationToken cancellationToken = default)
        {
            if (dto.Status != SD.ReportStatusResolved && dto.Status != SD.ReportStatusDismissed)
                throw new ArgumentException("حالة البلاغ غير صالحة");

            var report = await _reportRepository.GetByIdAsync(reportId, cancellationToken);
            if (report == null)
                throw new KeyNotFoundException("البلاغ غير موجود");

            var action = dto.Action ?? "";

            if (dto.Status == SD.ReportStatusResolved && action == SD.ReportActionRemovedContent)
            {
                if (report.Type == SD.ReportTypeCourse)
                    throw new InvalidOperationException("لا يمكن حذف الكورس من هنا");

                await DeleteTargetContentAsync(report, cancellationToken);
                await NotifyOwnerContentRemovedAsync(report, cancellationToken);
                report.AdminNote = string.IsNullOrWhiteSpace(dto.AdminNote) ? "تم حذف المحتوى المخالف" : dto.AdminNote;
            }
            else if (dto.Status == SD.ReportStatusResolved && action == SD.ReportActionWarnedUser)
            {
                await WarnOwnerAsync(report, cancellationToken);
            }

            report.Status = dto.Status;
            report.AdminNote = dto.AdminNote;
            report.ResolvedActions = string.IsNullOrEmpty(action) ? null : action;
            report.HandledById = adminId;
            report.HandledAt = DateTime.UtcNow;

            await _reportRepository.SaveAsync(cancellationToken);
        }

        public async Task<AdminReportDto> DeleteReportedContentAsync(string adminId, int reportId, CancellationToken cancellationToken = default)
        {
            var report = await _reportRepository.GetByIdAsync(reportId, cancellationToken);
            if (report == null)
                throw new KeyNotFoundException("البلاغ غير موجود");

            if (report.Type == SD.ReportTypeCourse)
                throw new InvalidOperationException("لا يمكن حذف هذا النوع من المحتوى من هنا");

            await DeleteTargetContentAsync(report, cancellationToken);
            await NotifyOwnerContentRemovedAsync(report, cancellationToken);

            report.Status = SD.ReportStatusResolved;
            report.AdminNote = "تم حذف المحتوى المخالف";
            report.ResolvedActions = SD.ReportActionRemovedContent;
            report.HandledById = adminId;
            report.HandledAt = DateTime.UtcNow;

            await _reportRepository.SaveAsync(cancellationToken);

            var (targetSummary, courseId, _) = await ResolveTargetAsync(report, cancellationToken);
            return await BuildDtoAsync(report, targetSummary, courseId, cancellationToken);
        }

        #region Helpers

        private async Task DeleteTargetContentAsync(Report report, CancellationToken cancellationToken)
        {
            switch (report.Type)
            {
                case SD.ReportTypeComment:
                    var comment = await _commentRepository.GetAsync(c => c.Id == report.TargetId, isTracking: true, cancellationToken: cancellationToken);
                    if (comment != null)
                    {
                        var replies = await _commentRepository.GetAllAsync(c => c.ParentCommentId == comment.Id, isTracking: true, cancellationToken: cancellationToken);
                        if (replies.Count > 0)
                            await _commentRepository.DeleteRangeAsync(replies, cancellationToken);
                        await _commentRepository.DeleteAsync(comment, cancellationToken);
                    }
                    break;

                case SD.ReportTypeReview:
                    var rating = await _ratingRepository.GetAsync(r => r.Id == report.TargetId, isTracking: true, cancellationToken: cancellationToken);
                    if (rating != null)
                        await _ratingRepository.DeleteAsync(rating, cancellationToken);
                    break;

                default:
                    throw new InvalidOperationException("لا يمكن حذف هذا النوع من المحتوى من هنا");
            }
        }

        private async Task<ApplicationUser?> ResolveOwnerAsync(Report report, CancellationToken cancellationToken)
        {
            switch (report.Type)
            {
                case SD.ReportTypeCourse:
                    var course = await _courseRepository.GetAsync(c => c.Id == report.TargetId, isTracking: false, cancellationToken: cancellationToken);
                    if (course != null && !string.IsNullOrEmpty(course.InstructorId))
                        return await _userManager.FindByIdAsync(course.InstructorId);
                    return null;

                case SD.ReportTypeComment:
                    var comment = await _commentRepository.GetAsync(c => c.Id == report.TargetId, isTracking: false, cancellationToken: cancellationToken);
                    if (comment != null)
                        return await _userManager.FindByIdAsync(comment.UserId);
                    return null;

                default:
                    var rating = await _ratingRepository.GetAsync(r => r.Id == report.TargetId, isTracking: false, cancellationToken: cancellationToken);
                    if (rating != null)
                        return await _userManager.FindByIdAsync(rating.UserId);
                    return null;
            }
        }

        private async Task WarnOwnerAsync(Report report, CancellationToken cancellationToken)
        {
            try
            {
                var owner = await ResolveOwnerAsync(report, cancellationToken);
                if (owner == null)
                    return;

                var (targetSummary, _, _) = await ResolveTargetAsync(report, cancellationToken);
                var language = owner.PreferredLanguage ?? "en";
                var reasonLabel = _emailTemplateService.GetLocalizedText($"ReportReason_{report.Reason}", language);

                if (!string.IsNullOrEmpty(owner.Email))
                {
                    var subject = _emailTemplateService.GetFormattedText("EmailSubjectReportWarning", language);
                    var body = _emailTemplateService.GenerateReportWarningEmail(owner, reasonLabel, targetSummary, language);
                    await _emailSender.SendEmailAsync(owner.Email, subject, body);
                }

                var notificationDto = new CreateNotificationDto
                {
                    Title = "تحذير بخصوص بلاغ",
                    Message = $"تم رصد مخالفة على المحتوى الخاص بك: {targetSummary}",
                    TitleKey = NotificationMessages.ReportWarn_Title,
                    MessageKey = NotificationMessages.ReportWarn_Msg,
                    Parameters = JsonSerializer.Serialize(new { target = targetSummary }),
                    Type = NotificationTypeDto.System,
                    UserId = owner.Id,
                    RelatedEntityId = report.Id.ToString(),
                    RelatedEntityType = "Report"
                };

                await _notificationService.CreateNotificationAsync(notificationDto, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to warn owner for report {ReportId}", report.Id);
            }
        }

        private async Task NotifyOwnerContentRemovedAsync(Report report, CancellationToken cancellationToken)
        {
            try
            {
                var owner = await ResolveOwnerAsync(report, cancellationToken);
                if (owner == null)
                    return;

                var (targetSummary, _, _) = await ResolveTargetAsync(report, cancellationToken);

                var notificationDto = new CreateNotificationDto
                {
                    Title = "تم حذف محتوى مخالف",
                    Message = $"تم حذف المحتوى الخاص بك بسبب مخالفة: {targetSummary}",
                    TitleKey = NotificationMessages.ReportContentRemoved_Title,
                    MessageKey = NotificationMessages.ReportContentRemoved_Msg,
                    Parameters = JsonSerializer.Serialize(new { target = targetSummary }),
                    Type = NotificationTypeDto.System,
                    UserId = owner.Id,
                    RelatedEntityId = report.Id.ToString(),
                    RelatedEntityType = "Report"
                };

                await _notificationService.CreateNotificationAsync(notificationDto, cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to notify owner about removed content for report {ReportId}", report.Id);
            }
        }

        private async Task<(string summary, int? courseId, string? courseTitle)> ResolveTargetAsync(Report report, CancellationToken cancellationToken)
        {
            switch (report.Type)
            {
                case SD.ReportTypeCourse:
                    var course = await _courseRepository.GetAsync(c => c.Id == report.TargetId, isTracking: false, cancellationToken: cancellationToken);
                    return (course?.Title ?? "الكورس محذوف", course?.Id, course?.Title);

                case SD.ReportTypeComment:
                    var comment = await _commentRepository.GetAsync(
                        c => c.Id == report.TargetId,
                        includeProperties: "Lecture.Section.Course",
                        isTracking: false,
                        cancellationToken: cancellationToken);
                    if (comment == null)
                        return ("التعليق محذوف", null, null);
                    return (comment.Content, comment.Lecture?.Section?.CourseId, comment.Lecture?.Section?.Course?.Title);

                default:
                    var rating = await _ratingRepository.GetAsync(r => r.Id == report.TargetId, isTracking: false, cancellationToken: cancellationToken);
                    if (rating == null)
                        return ("المراجعة محذوفة", null, null);
                    var summary = string.IsNullOrWhiteSpace(rating.Comment) ? $"⭐ {rating.Value}/5" : $"{rating.Comment} (⭐ {rating.Value}/5)";
                    var rc = await _courseRepository.GetAsync(c => c.Id == rating.CourseId, isTracking: false, cancellationToken: cancellationToken);
                    return (summary, rating.CourseId, rc?.Title);
            }
        }

        private async Task<AdminReportDto> BuildDtoAsync(Report report, string targetSummary, int? courseId, CancellationToken cancellationToken)
        {
            var reporter = report.Reporter ?? await _userManager.FindByIdAsync(report.ReporterId);
            string? handledByName = null;
            if (!string.IsNullOrEmpty(report.HandledById))
            {
                var handledBy = await _userManager.FindByIdAsync(report.HandledById);
                handledByName = handledBy?.UserName;
            }

            string? ownerName = null;
            if (report.Type == SD.ReportTypeCourse)
            {
                var course = await _courseRepository.GetAsync(c => c.Id == report.TargetId, isTracking: false, cancellationToken: cancellationToken);
                if (course != null && !string.IsNullOrEmpty(course.InstructorId))
                {
                    var owner = await _userManager.FindByIdAsync(course.InstructorId);
                    ownerName = owner?.UserName;
                }
            }
            else if (report.Type == SD.ReportTypeComment)
            {
                var comment = await _commentRepository.GetAsync(c => c.Id == report.TargetId, isTracking: false, cancellationToken: cancellationToken);
                if (comment != null)
                {
                    var owner = await _userManager.FindByIdAsync(comment.UserId);
                    ownerName = owner?.UserName;
                }
            }
            else
            {
                var rating = await _ratingRepository.GetAsync(r => r.Id == report.TargetId, isTracking: false, cancellationToken: cancellationToken);
                if (rating != null)
                {
                    var owner = await _userManager.FindByIdAsync(rating.UserId);
                    ownerName = owner?.UserName;
                }
            }

            return new AdminReportDto
            {
                Id = report.Id,
                Type = report.Type,
                TargetId = report.TargetId,
                Reason = report.Reason,
                Details = report.Details,
                Status = report.Status,
                CreatedAt = report.CreatedAt,
                HandledAt = report.HandledAt,
                AdminNote = report.AdminNote,
                ResolvedActions = report.ResolvedActions,
                HandledById = report.HandledById,
                HandledByName = handledByName,
                ReporterId = report.ReporterId,
                ReporterName = reporter?.UserName ?? report.ReporterId,
                ReporterEmail = reporter?.Email ?? "",
                TargetSummary = targetSummary,
                TargetOwnerName = ownerName,
                CourseId = courseId,
                CourseTitle = courseId == null ? null : (await _courseRepository.GetAsync(c => c.Id == courseId.Value, isTracking: false, cancellationToken: cancellationToken))?.Title,
                CanDeleteContent = report.Type != SD.ReportTypeCourse
            };
        }

        private async Task NotifyAdminsAsync(Report report, string targetSummary, int? courseId, CancellationToken cancellationToken)
        {
            try
            {
                var admins = await _userManager.GetUsersInRoleAsync(SD.Admin);
                if (admins == null || admins.Count == 0)
                    return;

                var parameters = JsonSerializer.Serialize(new { type = report.Type, target = targetSummary });
                foreach (var admin in admins)
                {
                    var dto = new CreateNotificationDto
                    {
                        Title = "بلاغ جديد",
                        Message = $"تم استلام بلاغ جديد ({report.Type}): {targetSummary}",
                        TitleKey = NotificationMessages.NewReport_Title,
                        MessageKey = NotificationMessages.NewReport_Msg,
                        Parameters = parameters,
                        Type = NotificationTypeDto.System,
                        UserId = admin.Id,
                        RelatedEntityId = report.Id.ToString(),
                        RelatedEntityType = "Report"
                    };

                    await _notificationService.CreateNotificationAsync(dto, cancellationToken);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to notify admins about report {ReportId}", report.Id);
            }
        }

        #endregion
    }
}
