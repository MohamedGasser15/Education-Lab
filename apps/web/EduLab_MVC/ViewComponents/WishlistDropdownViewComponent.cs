using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.ViewComponents
{
    /// <summary>
    /// Renders the cart dropdown with the current user's cart.
    /// </summary>
    public class CartDropdownViewComponent : ViewComponent
    {
        private readonly ICartService _cartService;

        /// <summary>
        /// Initializes a new instance of the <see cref="CartDropdownViewComponent"/> class.
        /// </summary>
        /// <param name="cartService">The cart service.</param>
        public CartDropdownViewComponent(ICartService cartService)
        {
            _cartService = cartService;
        }

        /// <summary>
        /// Loads the cart data for the dropdown view.
        /// </summary>
        public async Task<IViewComponentResult> InvokeAsync()
        {
            var cart = await _cartService.GetUserCartAsync();
            return View("_CartDropdown", cart);
        }
    }
}
