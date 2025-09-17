using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Payment
{
    public class PaymentResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public string PaymentIntentId { get; set; }
        public string ClientSecret { get; set; }
        public decimal Amount { get; set; }
        public string Currency { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
