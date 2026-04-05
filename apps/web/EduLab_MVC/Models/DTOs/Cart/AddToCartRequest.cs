using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Cart
{
    public class AddToCartRequest
    {
        public int CourseId { get; set; }
        public int Quantity { get; set; } = 1;
    }
}
