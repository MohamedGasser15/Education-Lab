using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Payment
{
    public class CheckoutRequest
    {
        public bool SavePaymentMethod { get; set; }
        public string ReturnUrl { get; set; }
    }
}
