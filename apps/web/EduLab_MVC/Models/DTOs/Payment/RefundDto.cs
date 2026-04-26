namespace EduLab_MVC.Models.DTOs.Payment
{
    public class RefundRequestDto
    {
        public int PaymentId { get; set; }
        public string? Reason { get; set; }
    }

    public class RefundResponseDto
    {
        public bool Success { get; set; }
        public string Message { get; set; } = string.Empty;
        public string? RefundId { get; set; }
    }
}
