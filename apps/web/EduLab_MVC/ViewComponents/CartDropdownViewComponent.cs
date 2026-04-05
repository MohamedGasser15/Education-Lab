using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.ViewComponents
{
    public class WishlistDropdownViewComponent : ViewComponent
    {
        private readonly IWishlistService _wishlistService;

        public WishlistDropdownViewComponent(IWishlistService wishlistService)
        {
            _wishlistService = wishlistService;
        }

        public async Task<IViewComponentResult> InvokeAsync()
        {
            var wishlist = await _wishlistService.GetUserWishlistAsync();
            return View("_WishlistDropdown", wishlist);
        }
    }
}
