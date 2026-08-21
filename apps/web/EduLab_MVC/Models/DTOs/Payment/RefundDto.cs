namespace EduLab_MVC.Models.DTOs.Payment
{
    /// <summary>
    /// Represents a refund request data transfer object.
    /// </summary>
    public class RefundRequestDto
    {
        public int PaymentId { get; set; }
        public string? Reason { get; set; }
    }

    /// <summary>
    /// Represents a refund response data transfer object.
    /// </summary>
    public class RefundResponseDto
    {
        public bool Success { get; set; }
        public string Message { get; set; } = string.Empty;
        public string? RefundId { get; set; }
    }
}
