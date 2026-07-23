using EduLab_MVC.Models.DTOs.Instructor;
using EduLab_MVC.Models.DTOs.LectureComment;
using EduLab_MVC.Services.ServiceInterfaces;
using Newtonsoft.Json;
using System.Text;

namespace EduLab_MVC.Services
{
    public class CommentsService : ICommentsService
    {
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly ILogger<CommentsService> _logger;

        public CommentsService(IAuthorizedHttpClientService httpClientService, ILogger<CommentsService> logger)
        {
            _httpClientService = httpClientService;
            _logger = logger;
        }

        public async Task<List<LectureCommentDTO>> GetLectureCommentsAsync(int lectureId, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync($"comments/lecture/{lectureId}", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    var comments = JsonConvert.DeserializeObject<List<LectureCommentDTO>>(content) ?? new();
                    foreach (var c in comments)
                    {
                        c.TimeAgo = GetTimeAgo(c.CreatedAt);
                        foreach (var r in c.Replies)
                            r.TimeAgo = GetTimeAgo(r.CreatedAt);
                    }
                    return comments;
                }

                return new List<LectureCommentDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching comments for lecture {LectureId}", lectureId);
                return new List<LectureCommentDTO>();
            }
        }

        public async Task<LectureCommentDTO> AddCommentAsync(CreateLectureCommentDTO dto, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(dto);
                var content = new StringContent(json, Encoding.UTF8, "application/json");
                var response = await client.PostAsync("comments", content, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadAsStringAsync();
                    var comment = JsonConvert.DeserializeObject<LectureCommentDTO>(result);
                    if (comment != null)
                        comment.TimeAgo = GetTimeAgo(comment.CreatedAt);
                    return comment;
                }

                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error adding comment");
                return null;
            }
        }

        public async Task<LectureCommentDTO> ReplyToCommentAsync(int commentId, string content, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var json = JsonConvert.SerializeObject(new { content });
                var httpContent = new StringContent(json, Encoding.UTF8, "application/json");
                var response = await client.PostAsync($"comments/{commentId}/reply", httpContent, cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadAsStringAsync();
                    return JsonConvert.DeserializeObject<LectureCommentDTO>(result);
                }

                _logger.LogWarning("Reply failed with status {Status}", response.StatusCode);
                return null;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error replying to comment {CommentId}", commentId);
                return null;
            }
        }

        public async Task<bool> DeleteCommentAsync(int commentId, CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.DeleteAsync($"comments/{commentId}", cancellationToken);
                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting comment {CommentId}", commentId);
                return false;
            }
        }

        public async Task<List<QuestionGroupDTO>> GetInstructorQuestionsAsync(CancellationToken cancellationToken = default)
        {
            try
            {
                var client = _httpClientService.CreateClient();
                var response = await client.GetAsync("instructor/comments", cancellationToken);

                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    return JsonConvert.DeserializeObject<List<QuestionGroupDTO>>(content) ?? new();
                }

                return new List<QuestionGroupDTO>();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error fetching instructor questions");
                return new List<QuestionGroupDTO>();
            }
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
