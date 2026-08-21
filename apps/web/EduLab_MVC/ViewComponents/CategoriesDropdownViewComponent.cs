using EduLab_MVC.Services;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.ViewComponents
{
    /// <summary>
    /// Renders the category navigation, optionally switching between featured, home and default partials.
    /// </summary>
    public class CategoriesDropdownViewComponent : ViewComponent
    {
        private readonly ICategoryService _categoryService;

        /// <summary>
        /// Initializes a new instance of the <see cref="CategoriesDropdownViewComponent"/> class.
        /// </summary>
        /// <param name="categoryService">The category service.</param>
        public CategoriesDropdownViewComponent(ICategoryService categoryService)
        {
            _categoryService = categoryService;
        }

        /// <summary>
        /// Loads the requested category list and returns the matching partial view.
        /// </summary>
        public async Task<IViewComponentResult> InvokeAsync(string type = "dropdown")
        {
            if (type == "featured")
            {
                var featuredCategories = await _categoryService.GetTopCategoriesAsync(4);
                return View("_FeaturedCategoriesPartial", featuredCategories);
            }
            else if (type == "Home")
            {
                var HomeCategories = await _categoryService.GetTopCategoriesAsync(6);
                return View("_HomeCategoriesPartial", HomeCategories);
            }

                var categories = await _categoryService.GetTopCategoriesAsync(6);
            return View("Default", categories);
        }
    }
}