using System;
using System.Linq;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace EduLab_MVC.Models.DTOs.Notifications
{
    public enum NotificationTypeDto
    {
        System = 0,
        Promotional = 1,
        Course = 2,
        Enrollment = 3,
        Reminder = 4
    }

    public enum NotificationStatusDto
    {
        Unread = 0,
        Read = 1
    }

    public class NotificationDto
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Message { get; set; }
        public NotificationTypeDto Type { get; set; }
        public NotificationStatusDto Status { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? ReadAt { get; set; }
        public string? RelatedEntityId { get; set; }
        public string? RelatedEntityType { get; set; }
        public string? IconClass { get; set; }
        public string? ColorClass { get; set; }
        public string TimeAgo { get; set; }

        [JsonPropertyName("titleKey")]
        public string? TitleKey { get; set; }

        [JsonPropertyName("messageKey")]
        public string? MessageKey { get; set; }

        [JsonPropertyName("parameters")]
        public string? Parameters { get; set; }

        public string LocalizeTitle(Func<string, string> localizer)
        {
            return Localize(TitleKey, Title, localizer);
        }

        public string LocalizeMessage(Func<string, string> localizer)
        {
            return Localize(MessageKey, Message, localizer);
        }

        private string Localize(string? key, string fallback, Func<string, string> localizer)
        {
            if (string.IsNullOrEmpty(key))
                return fallback;

            var template = localizer(key);
            if (string.IsNullOrEmpty(template) || template == key)
                return fallback;

            if (string.IsNullOrEmpty(Parameters))
                return template;

            try
            {
                var dict = JsonSerializer.Deserialize<Dictionary<string, JsonElement>>(Parameters);
                if (dict == null || dict.Count == 0)
                    return template;

                var args = dict.Values.Select(v => v.ValueKind switch
                {
                    JsonValueKind.String => v.GetString() ?? "",
                    JsonValueKind.Null => "",
                    _ => v.GetRawText()
                }).ToArray<object>();

                var maxIndex = 0;
                foreach (System.Text.RegularExpressions.Match m in System.Text.RegularExpressions.Regex.Matches(template, @"\{(\d+)\}"))
                    maxIndex = Math.Max(maxIndex, int.Parse(m.Groups[1].Value));

                if (maxIndex >= args.Length)
                {
                    var padded = new object[maxIndex + 1];
                    Array.Copy(args, padded, args.Length);
                    for (int i = args.Length; i <= maxIndex; i++) padded[i] = "";
                    args = padded;
                }

                return string.Format(template, args);
            }
            catch
            {
                return fallback;
            }
        }
    }
}
