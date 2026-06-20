using EduLab_MVC.Models.DTOs.Category;
using EduLab_MVC.Services;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Threading;
using System.Threading.Tasks;
using EduLab_MVC.Common;
using Microsoft.Extensions.Localization;
using EduLab_MVC.Resources;

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
        private readonly IStringLocalizer<SharedResources> _localizer;

        /// <summary>
        /// Initializes a new instance of the CategoryController class
        /// </summary>
        /// <param name="categoryService">Category service</param>
        /// <param name="logger">Logger instance</param>
        public CategoryController(ICategoryService categoryService, ILogger<CategoryController> logger, IStringLocalizer<SharedResources> localizer)
        {
            _categoryService = categoryService;
            _logger = logger;
            _localizer = localizer;
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
                TempData["Error"] = _localizer["CategoryLoadError"].Value;
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
                TempData["Error"] = _localizer["InvalidDataCheck"].Value;
                return RedirectToAction("Index");
            }

            try
            {
                var createdCategory = await _categoryService.CreateCategoryAsync(category, cancellationToken);

                if (createdCategory != null)
                {
                    TempData["Success"] = _localizer["CategoryCreated"].Value;
                }
                else
                {
                    TempData["Error"] = _localizer["CategoryCreateFailed"].Value;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while creating category");
                TempData["Error"] = _localizer["CategoryCreateError"].Value;
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
                TempData["Error"] = _localizer["InvalidDataCheck"].Value;
                return RedirectToAction("Index");
            }

            try
            {
                var updatedCategory = await _categoryService.UpdateCategoryAsync(category, cancellationToken);

                if (updatedCategory != null)
                {
                    TempData["Success"] = _localizer["CategoryUpdated"].Value;
                }
                else
                {
                    TempData["Error"] = _localizer["CategoryUpdateFailed"].Value;
                }
            }
            catch (InvalidOperationException ex)
            {
                TempData["Error"] = ex.Message;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while updating category with ID: {CategoryId}", category.Category_Id);
                TempData["Error"] = _localizer["CategoryUpdateError"].Value;
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
                TempData["Success"] = _localizer["CategoryDeleted"].Value;
            }
            catch (InvalidOperationException ex)
            {
                TempData["Error"] = ex.Message;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while deleting category with ID: {CategoryId}", id);
                TempData["Error"] = _localizer["CategoryDeleteError"].Value;
            }

            return RedirectToAction("Index");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> BulkDelete(string ids, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Bulk deleting categories with IDs: {CategoryIds}", ids);

                if (string.IsNullOrEmpty(ids))
                {
                    _logger.LogWarning("No category IDs provided for bulk delete");
                    TempData["Error"] = _localizer["NoCategoriesSelected"].Value;
                    return RedirectToAction("Index");
                }

                var categoryIds = ids.Split(',', StringSplitOptions.RemoveEmptyEntries)
                                     .Select(int.Parse)
                                     .ToList();

                var result = await _categoryService.BulkDeleteCategoriesAsync(categoryIds, cancellationToken);

                if (result)
                {
                    _logger.LogInformation("Categories with IDs {CategoryIds} deleted successfully", ids);
                    TempData["Success"] = _localizer["CategoriesBulkDeleted"].Value;
                }
                else
                {
                    _logger.LogWarning("Failed to bulk delete categories with IDs {CategoryIds}", ids);
                    TempData["Error"] = _localizer["CategoriesBulkDeleteFailed"].Value;
                }

                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while bulk deleting categories with IDs {CategoryIds}", ids);
                TempData["Error"] = _localizer["CategoriesBulkDeleteError"].Value;
                return RedirectToAction("Index");
            }
        }

        #endregion
    }
}