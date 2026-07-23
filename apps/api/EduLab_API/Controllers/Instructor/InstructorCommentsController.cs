using EduLab_Domain.Entities;
using EduLab_Infrastructure.DB;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace EduLab_API.Controllers.Instructor
{
    [Route("api/instructor/comments")]
    [ApiController]
    [Authorize(Roles = "Instructor")]
    public class InstructorCommentsController : ControllerBase
    {
        private readonly ApplicationDbContext _db;
        private readonly ILogger<InstructorCommentsController> _logger;

        public InstructorCommentsController(ApplicationDbContext db, ILogger<InstructorCommentsController> logger)
        {
            _db = db;
            _logger = logger;
        }

        [HttpGet]
        public async Task<IActionResult> GetInstructorComments(CancellationToken cancellationToken)
        {
            try
            {
                var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                if (string.IsNullOrEmpty(userId))
                    return Unauthorized();

                var courseIds = await _db.Courses
                    .Where(c => c.InstructorId == userId)
                    .Select(c => c.Id)
                    .ToListAsync(cancellationToken);

                var sectionIds = await _db.Sections
                    .Where(s => courseIds.Contains(s.CourseId))
                    .Select(s => s.Id)
                    .ToListAsync(cancellationToken);

                var lectureIds = await _db.Lectures
                    .Where(l => sectionIds.Contains(l.SectionId))
                    .Select(l => l.Id)
                    .ToListAsync(cancellationToken);

                var comments = await _db.LectureComments
                    .Where(c => lectureIds.Contains(c.LectureId) && c.ParentCommentId == null)
                    .Include(c => c.User)
                    .Include(c => c.Lecture).ThenInclude(l => l.Section)
                    .Include(c => c.Replies).ThenInclude(r => r.User)
                    .OrderByDescending(c => c.CreatedAt)
                    .ToListAsync(cancellationToken);

                var courses = await _db.Courses
                    .Where(c => courseIds.Contains(c.Id))
                    .ToListAsync(cancellationToken);

                var result = courses.Select(course =>
                {
                    var courseLectureIds = _db.Lectures
                        .Where(l => _db.Sections.Any(s => s.Id == l.SectionId && s.CourseId == course.Id))
                        .Select(l => l.Id)
                        .ToHashSet();

                    var courseComments = comments.Where(c => courseLectureIds.Contains(c.LectureId)).ToList();
                    if (!courseComments.Any()) return null;

                    var unanswered = courseComments.Count(c => c.Replies?.Any() != true);
                    return new
                    {
                        CourseId = course.Id,
                        CourseName = course.Title,
                        CourseIcon = GetCourseIcon(course.Title),
                        CourseColor = GetCourseColor(course.Title),
                        TotalCount = courseComments.Count,
                        UnansweredCount = unanswered,
                        Questions = courseComments.Select(c => new
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
                            Replies = (c.Replies ?? new List<LectureComment>()).Select(r => new
                            {
                                Id = r.Id,
                                StudentName = r.User?.FullName ?? "مستخدم",
                                StudentAvatar = r.User?.ProfileImageUrl,
                                Content = r.Content,
                                CreatedAt = r.CreatedAt,
                                TimeAgo = GetTimeAgo(r.CreatedAt),
                                IsInstructorReply = course.InstructorId == r.UserId
                            })
                        })
                    };
                }).Where(r => r != null).ToList();

                return Ok(result);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching instructor comments");
                return StatusCode(500, new { message = "حدث خطأ" });
            }
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
            if (string.IsNullOrEmpty(title)) return "gray";
            var t = title.ToLower();
            if (t.Contains("ويب") || t.Contains("web")) return "blue";
            if (t.Contains("ui") || t.Contains("ux") || t.Contains("design")) return "purple";
            if (t.Contains("تسويق") || t.Contains("marketing")) return "emerald";
            if (t.Contains("جوال") || t.Contains("mobile")) return "amber";
            if (t.Contains("بيانات") || t.Contains("data")) return "rose";
            return "gray";
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
    }
}
