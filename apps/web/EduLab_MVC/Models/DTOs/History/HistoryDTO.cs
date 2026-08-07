using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.History
{
    public class HistoryDTO
    {
        [JsonPropertyName("id")]
        public int Id { get; set; }

        [JsonPropertyName("userName")]
        public string UserName { get; set; } = string.Empty;

        [JsonPropertyName("profileImageUrl")]
        public string? ProfileImageUrl { get; set; }

        [JsonPropertyName("operation")]
        public string Operation { get; set; } = string.Empty;

        [JsonPropertyName("messageKey")]
        public string? MessageKey { get; set; }

        [JsonPropertyName("parameters")]
        public string? Parameters { get; set; }

        [JsonPropertyName("operationKeyId")]
        public int? OperationKeyId { get; set; }

        [JsonPropertyName("operationKeyName")]
        public string? OperationKeyName { get; set; }

        [JsonPropertyName("date")]
        public DateOnly Date { get; set; }

        [JsonPropertyName("time")]
        public TimeOnly Time { get; set; }

        public string BadgeClass => OperationKeyId switch
        {
            1 => "op-delete",
            10 => "op-delete",
            7 => "op-delete",
            2 => "op-create",
            9 => "op-create",
            8 => "op-create",
            6 => "op-create",
            4 => "op-update",
            _ => "op-default"
        };

        public string LocalizeOperation(Func<string, string> localizer)
        {
            if (string.IsNullOrEmpty(MessageKey))
                return Operation;

            var template = localizer(MessageKey);
            if (string.IsNullOrEmpty(template) || template == MessageKey)
                return Operation;

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
                return Operation;
            }
        }
    }
}
