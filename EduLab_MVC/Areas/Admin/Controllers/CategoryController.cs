using EduLab_MVC.Filters;
using EduLab_MVC.Models.DTOs.Category;
using EduLab_MVC.Services;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    [AdminOnly]
    [Area("Admin")]
    public class CategoryController : Controller
    {
        private readonly CategoryService _categoryService;
        public CategoryController(CategoryService categoryService)
        {
            _categoryService = categoryService;
        }
        public async Task<IActionResult> Index()
        {
            var categories = await _categoryService.GetAllCategoriesAsync();
            if (categories == null)
            {
                return NotFound(categories);
            }
            return View(categories);
        }

        [HttpPost]
        public async Task<IActionResult> Create(CategoryCreateDTO category)
        {
            if (ModelState.IsValid)
            {
                var createdCategory = await _categoryService.CreateCategoryAsync(category);
                if (createdCategory != null)
                {
                    TempData["Success"] = "تم انشاء التصنيف بنجاح";
                    return RedirectToAction("Index");
                }
                ModelState.AddModelError("", "فشل في انشاء التصنيف");
            }
            return View(category);
        }

        [HttpPost]
        public async Task<IActionResult> Update(CategoryUpdateDTO category)
        {
            if (ModelState.IsValid)
            {
                var updatedCategory = await _categoryService.UpdateCategoryAsync(category);
                if (updatedCategory != null)
                {
                    TempData["Success"] = "تم تحديث التصنيف بنجاح";
                    return RedirectToAction("Index");
                }
                ModelState.AddModelError("", "فشل في تحديث التصنيف");
            }
            return View(category);
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            if (id <= 0)
            {
                TempData["Error"] = "رقم التصنيف غير صحيح";
                return RedirectToAction("Index");
            }
            var result = await _categoryService.DeleteCategoryAsync(id);
            if (result)
            {
                TempData["Success"] = "تم حذف التصنيف بنجاح";
            }
            else
            {
                TempData["Error"] = "فشل في حذف التصنيف";
            }
            return RedirectToAction("Index");
        }
        //[HttpPost]
        //public async Task<IActionResult> DeleteRange([FromBody] List<int> ids)
        //{
        //    if (ids == null || ids.Count == 0)
        //    {
        //        return Json(new { success = false, message = "No categories selected for deletion." });
        //    }

        //    try
        //    {
        //        var result = await _categoryService.DeleteCategoriesAsync(ids);
        //        if (result)
        //        {
        //            return Json(new { success = true, message = $"{ids.Count} categories deleted successfully." });
        //        }
        //        return Json(new { success = false, message = "Failed to delete selected categories." });
        //    }
        //    catch (Exception ex)
        //    {
        //        return Json(new { success = false, message = $"Error deleting categories: {ex.Message}" });
        //    }
        //}
    }
}
