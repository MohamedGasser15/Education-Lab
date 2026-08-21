using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Wishlist
{
    /// <summary>
    /// Represents a wishlist response.
    /// </summary>
    public class WishlistResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public int WishlistCount { get; set; }
    }
}
