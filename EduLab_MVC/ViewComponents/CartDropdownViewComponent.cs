using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.ViewComponents
{
    public class CartDropdownViewComponent : ViewComponent
    {
        private readonly ICartService _cartService;

        public CartDropdownViewComponent(ICartService cartService)
        {
            _cartService = cartService;
        }

        public async Task<IViewComponentResult> InvokeAsync()
        {
            var cart = await _cartService.GetUserCartAsync();
            return View("_CartDropdown", cart);
        }
    }
}
