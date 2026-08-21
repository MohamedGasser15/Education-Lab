using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Wishlist
{
    /// <summary>
    /// Represents an add to wishlist request.
    /// </summary>
    public class AddToWishlistRequest
    {
        public int CourseId { get; set; }
    }
}
