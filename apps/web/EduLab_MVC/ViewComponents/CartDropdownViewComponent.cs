using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.ViewComponents
{
    /// <summary>
    /// Renders the wishlist dropdown with the current user's wishlist items.
    /// </summary>
    public class WishlistDropdownViewComponent : ViewComponent
    {
        private readonly IWishlistService _wishlistService;

        /// <summary>
        /// Initializes a new instance of the <see cref="WishlistDropdownViewComponent"/> class.
        /// </summary>
        /// <param name="wishlistService">The wishlist service.</param>
        public WishlistDropdownViewComponent(IWishlistService wishlistService)
        {
            _wishlistService = wishlistService;
        }

        /// <summary>
        /// Loads the wishlist data for the dropdown view.
        /// </summary>
        public async Task<IViewComponentResult> InvokeAsync()
        {
            var wishlist = await _wishlistService.GetUserWishlistAsync();
            return View("_WishlistDropdown", wishlist);
        }
    }
}
