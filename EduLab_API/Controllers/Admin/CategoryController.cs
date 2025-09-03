using EduLab_Application.ServiceInterfaces;
using EduLab_Shared.DTOs.Category;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace EduLab_API.Controllers.Admin
{
    /// <summary>
    /// API controller for managing categories
    /// </summary>
    [Produces("application/json")]
    [Route("api/[Controller]")]
    [ApiController]
    public class CategoryController : ControllerBase
    {
        private readonly ICategoryService _categoryService;
        private readonly ICourseService _courseService;
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

        #region Get Operations

        /// <summary>
        /// Retrieves all categories
        /// </summary>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of categories</returns>
        /// <response code="200">Returns the list of categories</response>
        /// <response code="404">If no categories are found</response>
        /// <response code="500">If an error occurs while retrieving categories</response>
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(IEnumerable<CategoryDTO>))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetCategories(CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting all categories");

                var categories = await _categoryService.GetAllCategoriesAsync(cancellationToken);

                if (categories == null || !categories.Any())
                {
                    _logger.LogWarning("No categories found");
                    return NotFound(new { message = "No categories found" });
                }

                _logger.LogInformation("Retrieved {Count} categories successfully", categories.Count());
                return Ok(categories);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving categories");
                return StatusCode(500, new { message = "An error occurred while retrieving categories", error = ex.Message });
            }
        }
        /// <summary>
        /// Retrieves a category by its ID
        /// </summary>
        /// <param name="id">Category ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Category details</returns>
        /// <response code="200">Returns the category</response>
        /// <response code="400">If the ID is invalid</response>
        /// <response code="404">If the category is not found</response>
        /// <response code="500">If an error occurs while retrieving the category</response>
        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(CategoryDTO))]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> GetCategoryById(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting category by ID: {CategoryId}", id);

                var category = await _categoryService.GetCategoryByIdAsync(id, cancellationToken);

                if (category == null)
                {
                    _logger.LogWarning("Category with ID: {CategoryId} not found", id);
                    return NotFound(new { message = $"No category found with ID {id}" });
                }

                _logger.LogInformation("Category with ID: {CategoryId} retrieved successfully", id);
                return Ok(category);
            }
            catch (ArgumentException ex)
            {
                _logger.LogWarning(ex, "Invalid category ID: {CategoryId}", id);
                return BadRequest(new { message = ex.Message });
            }
            catch (KeyNotFoundException ex)
            {
                _logger.LogWarning(ex, "Category with ID: {CategoryId} not found", id);
                return NotFound(new { message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving category with ID: {CategoryId}", id);
                return StatusCode(500, new { message = "An error occurred while retrieving the category", error = ex.Message });
            }
        }

        /// <summary>
        /// Retrieves top categories by course count
        /// </summary>
        /// <param name="count">Number of categories to retrieve (default: 6)</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>List of top categories</returns>
        /// <response code="200">Returns the top categories</response>
        [HttpGet("top")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(IEnumerable<CategoryDTO>))]
        public async Task<IActionResult> GetTopCategories([FromQuery] int count = 6, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Getting top {Count} categories", count);

                var categories = await _categoryService.GetTopCategoriesAsync(count, cancellationToken);

                _logger.LogInformation("Top {Count} categories retrieved successfully", count);
                return Ok(categories);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving top categories");
                return StatusCode(500, new { message = "An error occurred while retrieving top categories", error = ex.Message });
            }
        }

        #endregion

        #region Create Operations

        /// <summary>
        /// Creates a new category
        /// </summary>
        /// <param name="category">Category data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Created category</returns>
        /// <response code="201">Returns the created category</response>
        /// <response code="400">If the category data is invalid</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="403">If the user is not authorized</response>
        /// <response code="500">If an error occurs while creating the category</response>
        [HttpPost]
        [Authorize(Roles = SD.Admin)]
        [ProducesResponseType(StatusCodes.Status201Created, Type = typeof(CategoryDTO))]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<ActionResult> CreateCategory([FromBody] CategoryCreateDTO category, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Creating new category");

                if (category == null)
                {
                    _logger.LogWarning("Category data is null");
                    return BadRequest(new { message = "Category data is required" });
                }

                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid category data");
                    return BadRequest(new { message = "Invalid category data", errors = ModelState.Values.SelectMany(v => v.Errors) });
                }

                var createdCategory = await _categoryService.CreateCategoryAsync(category, cancellationToken);

                _logger.LogInformation("Category created successfully with ID: {CategoryId}", createdCategory.Category_Id);
                return CreatedAtAction(nameof(GetCategoryById), new { id = createdCategory.Category_Id }, createdCategory);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while creating category");
                return StatusCode(500, new
                {
                    message = "An error occurred while creating the category",
                    error = ex.Message
                });
            }
        }

        #endregion

        #region Update Operations

        /// <summary>
        /// Updates an existing category
        /// </summary>
        /// <param name="category">Category data</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>Updated category</returns>
        /// <response code="200">Returns the updated category</response>
        /// <response code="400">If the category data is invalid</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="403">If the user is not authorized</response>
        /// <response code="404">If the category is not found</response>
        /// <response code="500">If an error occurs while updating the category</response>
        [HttpPut]
        [Authorize(Roles = SD.Admin)]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(CategoryDTO))]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> UpdateCategory([FromBody] CategoryUpdateDTO category, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Updating category with ID: {CategoryId}", category?.Category_Id);

                if (category == null || category.Category_Id <= 0)
                {
                    _logger.LogWarning("Invalid category data");
                    return BadRequest(new { message = "Valid category data is required" });
                }

                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid category data for update");
                    return BadRequest(new { message = "Invalid category data", errors = ModelState.Values.SelectMany(v => v.Errors) });
                }

                var updatedCategory = await _categoryService.UpdateCategoryAsync(category, cancellationToken);

                _logger.LogInformation("Category with ID: {CategoryId} updated successfully", category.Category_Id);
                return Ok(updatedCategory);
            }
            catch (KeyNotFoundException ex)
            {
                _logger.LogWarning(ex, "Category with ID: {CategoryId} not found for update", category?.Category_Id);
                return NotFound(new { message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while updating category with ID: {CategoryId}", category?.Category_Id);
                return StatusCode(500, new { message = "An error occurred while updating the category", error = ex.Message });
            }
        }

        #endregion

        #region Delete Operations

        /// <summary>
        /// Deletes a category by its ID
        /// </summary>
        /// <param name="id">Category ID</param>
        /// <param name="cancellationToken">Cancellation token</param>
        /// <returns>No content if successful</returns>
        /// <response code="204">If the category was deleted successfully</response>
        /// <response code="400">If the ID is invalid</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="403">If the user is not authorized</response>
        /// <response code="404">If the category is not found</response>
        /// <response code="500">If an error occurs while deleting the category</response>
        [HttpDelete("{id}")]
        [Authorize(Roles = SD.Admin)]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> DeleteCategory(int id, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Deleting category with ID: {CategoryId}", id);

                if (id <= 0)
                {
                    _logger.LogWarning("Invalid category ID: {CategoryId}", id);
                    return BadRequest(new { message = "Invalid category ID" });
                }

                var result = await _categoryService.DeleteCategoryAsync(id, cancellationToken);

                if (!result)
                {
                    _logger.LogWarning("Category with ID: {CategoryId} not found for deletion", id);
                    return NotFound(new { message = $"No category found with ID {id}" });
                }

                _logger.LogInformation("Category with ID: {CategoryId} deleted successfully", id);
                return NoContent();
            }
            catch (KeyNotFoundException ex)
            {
                _logger.LogWarning(ex, "Category with ID: {CategoryId} not found for deletion", id);
                return NotFound(new { message = ex.Message });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while deleting category with ID: {CategoryId}", id);
                return StatusCode(500, new
                {
                    message = "An error occurred while deleting the category",
                    error = ex.Message
                });
            }
        }

        [HttpDelete("bulk")]
        [Authorize(Roles = SD.Admin)]
        public async Task<IActionResult> BulkDeleteCategories([FromQuery] string ids, CancellationToken cancellationToken = default)
        {
            try
            {
                _logger.LogInformation("Bulk deleting categories with IDs: {Ids}", ids);

                if (string.IsNullOrEmpty(ids))
                {
                    return BadRequest(new { message = "Category IDs are required" });
                }

                var categoryIds = ids.Split(',').Select(id => int.Parse(id)).ToList();

                foreach (var id in categoryIds)
                {
                    await _categoryService.DeleteCategoryAsync(id, cancellationToken);
                }

                _logger.LogInformation("Bulk delete completed successfully for {Count} categories", categoryIds.Count);
                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred during bulk delete");
                return StatusCode(500, new { message = "An error occurred during bulk delete", error = ex.Message });
            }
        }
        #endregion
    }
}