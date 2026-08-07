using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
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
            1 => "op-delete",   // Delete
            10 => "op-delete",  // Reject
            7 => "op-delete",   // Lock
            2 => "op-create",   // Create
            9 => "op-create",   // Approve
            8 => "op-create",   // Unlock
            6 => "op-create",   // Publish
            4 => "op-update",   // Edit
            _ => "op-default"
        };
    }
}
