using EduLab_MVC.Services;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.ViewComponents
{
    public class CategoriesDropdownViewComponent : ViewComponent
    {
        private readonly CategoryService _categoryService;

        public CategoriesDropdownViewComponent(CategoryService categoryService)
        {
            _categoryService = categoryService;
        }

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