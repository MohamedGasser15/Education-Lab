using EduLab_MVC.Models.DTOs.Category;
using EduLab_MVC.Services;
using EduLab_MVC.Services.ServiceInterfaces;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_MVC.Areas.Admin.Controllers
{
    /// <summary>
    /// MVC Controller for managing categories in admin area
    /// </summary>
    [Area("Admin")]
    [Authorize(Roles = SD.Admin)]
    public class CategoryController : Controller
    {
        private readonly ICategoryService _categoryService;
        private readonly ILogger<CategoryController> _logger;

        /// <summary>
        /// Initializes a new instance of the CategoryController class
        /// </summary>
        /// <param name="categoryService">Category service</param>
        /// <param name="logger">Logger instance</param>
        public CategoryController(ICategoryService categoryService, ILogger<CategoryController> logger)
        {
            _categoryService = categoryService;
            _logger = logger;
        }

        #region View Actions

        /// <summary>
        /// Displays the categories index view
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Categories index view</returns>
        public async Task<IActionResult> Index(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Loading categories index view");

                var categories = await _categoryService.GetAllCategoriesAsync(cancellationToken);

                if (categories == null)
                {
                    _logger.LogWarning("No categories found");
                    return NotFound();
                }

                _logger.LogInformation("Categories index view loaded successfully with {Count} categories", categories.Count);
                return View(categories);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while loading categories index view");
                TempData["Error"] = "حدث خطأ أثناء تحميل التصنيفات";
                return View(new System.Collections.Generic.List<CategoryDTO>());
            }
        }

        #endregion

        #region Create Operations

        /// <summary>
        /// Creates a new category
        /// </summary>
        /// <param name="category">Category creation DTO</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Redirect to index if successful</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(CategoryCreateDTO category, CancellationToken cancellationToken = default)
        {
            if (!ModelState.IsValid)
            {
                TempData["Error"] = "البيانات غير صحيحة، يرجى التحقق";
                return RedirectToAction("Index");
            }

            try
            {
                var createdCategory = await _categoryService.CreateCategoryAsync(category, cancellationToken);

                if (createdCategory != null)
                {
                    // نجاح فعلي
                    TempData["Success"] = "تم إنشاء التصنيف بنجاح";
                }
                else
                {
                    // حصل خطأ في الـ API أو duplicate
                    TempData["Error"] = "فشل في إنشاء التصنيف، اسم التصنيف موجود بالفعل";
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while creating category");
                TempData["Error"] = "حدث خطأ أثناء إنشاء التصنيف";
            }

            return RedirectToAction("Index");
        }

        #endregion

        #region Update Operations

        /// <summary>
        /// Updates an existing category
        /// </summary>
        /// <param name="category">Category update DTO</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Redirect to Index with success/error message</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Update(CategoryUpdateDTO category, CancellationToken cancellationToken = default)
        {
            if (!ModelState.IsValid)
            {
                TempData["Error"] = "البيانات غير صحيحة، يرجى التحقق";
                return RedirectToAction("Index");
            }

            try
            {
                var updatedCategory = await _categoryService.UpdateCategoryAsync(category, cancellationToken);

                if (updatedCategory != null)
                {
                    // نجاح فعلي
                    TempData["Success"] = "تم تحديث التصنيف بنجاح";
                }
                else
                {
                    // حصل خطأ في الـ API أو duplicate
                    TempData["Error"] = "فشل في تحديث التصنيف، اسم التصنيف موجود بالفعل";
                }
            }
            catch (InvalidOperationException ex)
            {
                // Duplicate الاسم
                TempData["Error"] = ex.Message;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while updating category with ID: {CategoryId}", category.Category_Id);
                TempData["Error"] = "حدث خطأ أثناء تحديث التصنيف";
            }

            return RedirectToAction("Index");
        }

        #endregion


        #region Delete Operations

        /// <summary>
        /// Deletes a category by its ID
        /// </summary>
        /// <param name="id">Category ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Redirect to index</returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                await _categoryService.DeleteCategoryAsync(id, cancellationToken);
                TempData["Success"] = "تم حذف التصنيف بنجاح";
            }
            catch (InvalidOperationException ex)
            {
                TempData["Error"] = ex.Message; // لو فيه سبب مثل "مرتبط بكورسات"
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while deleting category with ID: {CategoryId}", id);
                TempData["Error"] = "حدث خطأ أثناء حذف التصنيف";
            }

            return RedirectToAction("Index");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> BulkDelete(List<int> ids, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Bulk deleting categories with IDs: {@CategoryIds}", ids);

                if (ids == null || !ids.Any())
                {
                    _logger.LogWarning("No category IDs provided for bulk delete");
                    TempData["Error"] = "لم يتم اختيار أي تصنيفات للحذف";
                    return RedirectToAction("Index");
                }

                var result = await _categoryService.BulkDeleteCategoriesAsync(ids, cancellationToken);

                if (result)
                {
                    _logger.LogInformation("Categories with IDs {@CategoryIds} deleted successfully", ids);
                    TempData["Success"] = "تم حذف التصنيفات المحددة بنجاح";
                }
                else
                {
                    _logger.LogWarning("Failed to bulk delete categories with IDs {@CategoryIds}", ids);
                    TempData["Error"] = "فشل في حذف بعض أو كل التصنيفات";
                }

                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while bulk deleting categories with IDs {@CategoryIds}", ids);
                TempData["Error"] = "حدث خطأ أثناء الحذف الجماعي للتصنيفات";
                return RedirectToAction("Index");
            }
        }

        #endregion
    }
}