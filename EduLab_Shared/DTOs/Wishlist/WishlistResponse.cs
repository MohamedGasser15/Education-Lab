using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Wishlist
{
    public class WishlistResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public int WishlistCount { get; set; }
    }
}
