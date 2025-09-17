using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Payment
{
    public class PaymentRequest
    {
        public string PaymentMethodId { get; set; } = string.Empty;
        public decimal Amount { get; set; }
        public string Currency { get; set; } = "usd";
        public string Description { get; set; } = string.Empty;
        public List<int> CourseIds { get; set; } = new List<int>();
    }
}
