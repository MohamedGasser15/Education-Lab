using EduLab_MVC.Services;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.ViewComponents
{
    public class CategoriesDropdownViewComponent : ViewComponent
    {
        private readonly ICategoryService _categoryService;

        public CategoriesDropdownViewComponent(ICategoryService categoryService)
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