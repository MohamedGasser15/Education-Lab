using System.ComponentModel.DataAnnotations;

namespace EduLab_Application.DTOs.Payment
{
    public class RefundRequestDto
    {
        [Required]
        public int PaymentId { get; set; }

        public string Reason { get; set; }
    }

    public class RefundResponseDto
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public string RefundId { get; set; }
        public decimal RefundedAmount { get; set; }
    }
}
