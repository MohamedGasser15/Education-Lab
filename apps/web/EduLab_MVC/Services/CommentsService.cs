using EduLab_MVC.Models.DTOs.Instructor;
using EduLab_MVC.Models.DTOs.LectureComment;
using EduLab_MVC.Services.ServiceInterfaces;
using Newtonsoft.Json;
using System.Text;

namespace EduLab_MVC.Services
{
    /// <summary>
    /// Service implementation for lecture comment operations.
    /// </summary>
    public class CommentsService : ICommentsService
    {
        private readonly IAuthorizedHttpClientService _httpClientService;
        private readonly ILogger<CommentsService> _logger;

        /// <summary>
        /// Initializes a new instance of the <see cref="CommentsService"/> class.
        /// </summary>
        /// <param name="httpClientService">The authorized HTTP client service.</param>
        /// <param name="logger">The logger instance.</param>
        public CommentsService(IAuthorizedHttpClientService httpClientService, ILogger<CommentsService> logger)
        {
            _httpClientService = httpClientService;
            _logger = logger;
        }

        /// <summary>
        /// Retrieves the comments for a lecture.
        /// </summary>
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

        /// <summary>
        /// Adds a comment to a lecture.
        /// </summary>
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

        /// <summary>
        /// Adds a reply to an existing comment.
        /// </summary>
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

        /// <summary>
        /// Deletes a comment.
        /// </summary>
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

        /// <summary>
        /// Retrieves the question groups used by instructors.
        /// </summary>
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
            if (diff.TotalMinutes < 1) return Common.TimeAgoHelper.GetTimeAgo(dateTime);
            if (diff.TotalDays >= 7) return dateTime.ToString("MMM dd", System.Globalization.CultureInfo.CurrentUICulture);
            return Common.TimeAgoHelper.GetTimeAgo(dateTime);
        }
    }
}
