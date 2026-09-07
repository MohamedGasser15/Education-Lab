using EduLab_MVC.Common;
using EduLab_MVC.Models.DTOs.Category;
using EduLab_MVC.Models.DTOs.Course;
using EduLab_MVC.Models.DTOs.CourseProgress;
using EduLab_MVC.Resources;
using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Localization;
using System.Globalization;
using System.Linq;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    /// <summary>
    /// Controller for managing course operations in learner area
    /// </summary>
    [Area("Learner")]
    public class CourseController : Controller
    {
        #region Dependencies

        private readonly ICourseService _courseService;
        private readonly ICategoryService _categoryService;
        private readonly ILogger<CourseController> _logger;
        private readonly IEnrollmentService _enrollmentService;
        private readonly ICartService _cartService;
        private readonly ICourseProgressService _courseProgressService;
        private readonly ICertificateService _certificateService;
        private readonly IStringLocalizer<SharedResources> _localizer;
        private readonly IMemoryCache _cache;
        private readonly string _imageBaseUrl;

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the CourseController class
        /// </summary>
        public CourseController(
            ICourseService courseService,
            ICategoryService categoryService,
            ILogger<CourseController> logger,
            IEnrollmentService enrollmentService,
            ICartService cartService,
            ICourseProgressService courseProgressService,
            ICertificateService certificateService,
            IStringLocalizer<SharedResources> localizer,
            IMemoryCache cache,
            IConfiguration configuration)
        {
            _courseService = courseService;
            _categoryService = categoryService;
            _logger = logger;
            _enrollmentService = enrollmentService;
            _cartService = cartService;
            _courseProgressService = courseProgressService;
            _certificateService = certificateService;
            _localizer = localizer;
            _cache = cache;
            _imageBaseUrl = configuration["ApiBaseUrl"]?.Replace("/api", "").TrimEnd('/') ?? "";
        }

        #endregion

        #region Public Actions

        /// <summary>
        /// GET: Index - Displays all approved courses by categories
        /// </summary>
        /// <returns>Courses index view</returns>
        public async Task<IActionResult> Index()
        {
            try
            {
                _logger.LogInformation("Loading learner courses index page");

                var categoriesWithCourses = await GetCategoriesWithCoursesAsync();
                ViewBag.Categories = categoriesWithCourses;

                // Lazy load: Initial batch renders first 3 categories that have courses
                var initialCategories = categoriesWithCourses.Take(3).ToList();
                var initialCategoryIds = initialCategories.Select(c => c.Category_Id).ToList();

                var initialCourses = new List<CourseDTO>();
                if (initialCategoryIds.Any())
                {
                    initialCourses = await _cache.GetOrCreateAsync("Learner_Courses_Batch_0_3", async entry =>
                    {
                        entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(10);
                        return await _courseService.GetApprovedCoursesByCategoriesAsync(initialCategoryIds, 20, CancellationToken.None);
                    }) ?? new List<CourseDTO>();
                }

                ViewBag.LoadedCategoriesCount = initialCategories.Count;
                ViewBag.TotalCategoriesCount = categoriesWithCourses.Count;
                ViewBag.HasMoreCategories = categoriesWithCourses.Count > initialCategories.Count;
                ViewBag.TotalCourses = categoriesWithCourses.Any() && categoriesWithCourses.Sum(c => c.CoursesCount) > 0 
                    ? categoriesWithCourses.Sum(c => c.CoursesCount) 
                    : initialCourses.Count;

                _logger.LogInformation("Loaded initial {CourseCount} courses for first {CategoryCount} categories (Total: {TotalCats})",
                    initialCourses.Count, initialCategories.Count, categoriesWithCourses.Count);

                return View(initialCourses);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading learner courses index");
                TempData["Error"] = _localizer["ErrorLoadingCourses"].Value;
                ViewBag.Categories = new List<CategoryDTO>();
                return View(new List<CourseDTO>());
            }
        }

        /// <summary>
        /// GET: GetMoreCategories - Lazy loads the next batch of categories on scroll
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> GetMoreCategories(int skip, int take = 3)
        {
            try
            {
                var categoriesWithCourses = await GetCategoriesWithCoursesAsync();
                ViewBag.Categories = categoriesWithCourses;

                var nextCategories = categoriesWithCourses.Skip(skip).Take(take).ToList();
                if (!nextCategories.Any())
                {
                    return Content(string.Empty, "text/html");
                }

                var nextCategoryIds = nextCategories.Select(c => c.Category_Id).ToList();
                var cacheKey = $"Learner_Courses_Batch_{skip}_{take}";
                var courses = await _cache.GetOrCreateAsync(cacheKey, async entry =>
                {
                    entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(10);
                    return await _courseService.GetApprovedCoursesByCategoriesAsync(nextCategoryIds, 20, CancellationToken.None);
                }) ?? new List<CourseDTO>();

                return PartialView("_CategoryRowsPartial", courses);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error lazy loading more categories. Skip: {Skip}, Take: {Take}", skip, take);
                return StatusCode(500, string.Empty);
            }
        }

        /// <summary>
        /// GET: ByCategory - Displays approved courses by specific category with pagination
        /// </summary>
        /// <param name="id">Category ID</param>
        /// <param name="page">Page number</param>
        /// <param name="pageSize">Page size</param>
        /// <returns>Courses by category view</returns>
        public async Task<IActionResult> ByCategory(int id, int page = 1, int? pageSize = null)
        {
            try
            {
                // Dynamic page size: prioritize query string, then cookie, fallback to 24 for large displays
                int resolvedPageSize = 24;
                if (pageSize.HasValue && pageSize.Value > 0)
                {
                    resolvedPageSize = pageSize.Value;
                }
                else if (Request.Cookies.TryGetValue("client_page_size", out var cookieVal) && int.TryParse(cookieVal, out var cpSize) && cpSize > 0)
                {
                    resolvedPageSize = cpSize;
                }

                _logger.LogInformation("Loading courses for category ID: {CategoryId}, page: {Page}, pageSize: {PageSize}", id, page, resolvedPageSize);

                var categoriesWithCourses = await GetCategoriesWithCoursesAsync();
                ViewBag.Categories = categoriesWithCourses;
                ViewBag.CategoryId = id;

                var courses = await _courseService.GetApprovedCoursesByCategoryAsync(id, 200);
                courses ??= new List<CourseDTO>();

                var totalCount = courses.Count;
                var totalPages = (int)Math.Ceiling((double)totalCount / resolvedPageSize);
                if (totalPages < 1) totalPages = 1;
                page = Math.Min(Math.Max(1, page), totalPages);

                var pagedCourses = courses
                    .Skip((page - 1) * resolvedPageSize)
                    .Take(resolvedPageSize)
                    .ToList();

                ViewBag.CurrentPage = page;
                ViewBag.TotalPages = totalPages;
                ViewBag.TotalCount = totalCount;
                ViewBag.PageSize = resolvedPageSize;
                ViewBag.TotalCourses = totalCount;

                _logger.LogInformation("Loaded {CourseCount} courses (page {Page}/{TotalPages}) for category ID: {CategoryId}",
                    pagedCourses.Count, page, totalPages, id);

                return View("Index", pagedCourses);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading courses for category ID: {CategoryId}", id);
                TempData["Error"] = _localizer["ErrorLoadingCategoryCourses"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        /// <summary>
        /// GET: Featured - Displays all featured (top rated) approved courses with pagination
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> Featured(int page = 1, int? pageSize = null)
        {
            try
            {
                int resolvedPageSize = 24;
                if (pageSize.HasValue && pageSize.Value > 0)
                {
                    resolvedPageSize = pageSize.Value;
                }
                else if (Request.Cookies.TryGetValue("client_page_size", out var cookieVal) && int.TryParse(cookieVal, out var cpSize) && cpSize > 0)
                {
                    resolvedPageSize = cpSize;
                }

                var isArabic = CultureInfo.CurrentUICulture.Name.StartsWith("ar");
                var categoriesWithCourses = await GetCategoriesWithCoursesAsync();
                ViewBag.Categories = categoriesWithCourses;

                var allCourses = await _courseService.GetAllCoursesAsync();
                var featuredCourses = allCourses
                    .Where(c => c.Status == SD.CourseStatusApproved)
                    .OrderByDescending(c => c.AverageRating > 0)
                    .ThenByDescending(c => c.AverageRating)
                    .ThenByDescending(c => c.TotalRatings)
                    .ThenByDescending(c => c.CreatedAt)
                    .ToList();

                var totalCount = featuredCourses.Count;
                var totalPages = Math.Max(1, (int)Math.Ceiling((double)totalCount / resolvedPageSize));
                page = Math.Min(Math.Max(1, page), totalPages);

                var pagedCourses = featuredCourses
                    .Skip((page - 1) * resolvedPageSize)
                    .Take(resolvedPageSize)
                    .ToList();

                ViewBag.CollectionMode = true;
                ViewBag.CollectionType = "Featured";
                ViewBag.CollectionBadge = isArabic ? "الأعلى تقييماً" : "Top Rated";
                ViewBag.CollectionTitle = isArabic ? "الدورات المميزة" : "Featured Courses";
                ViewBag.CollectionSubtitle = isArabic ? "استكشف الدورات الأكثر تميزاً والأعلى تقييماً من قبل الطلاب" : "Explore the most distinguished and highly rated courses by students";
                ViewBag.CollectionIcon = "fa-award";
                ViewBag.PageAction = "Featured";
                ViewBag.CurrentPage = page;
                ViewBag.TotalPages = totalPages;
                ViewBag.TotalCount = totalCount;
                ViewBag.PageSize = resolvedPageSize;
                ViewBag.TotalCourses = totalCount;

                return View("Index", pagedCourses);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading featured courses");
                TempData["Error"] = _localizer["ErrorLoadingCourses"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        /// <summary>
        /// GET: New - Displays all newest approved courses with pagination
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> New(int page = 1, int? pageSize = null)
        {
            try
            {
                int resolvedPageSize = 24;
                if (pageSize.HasValue && pageSize.Value > 0)
                {
                    resolvedPageSize = pageSize.Value;
                }
                else if (Request.Cookies.TryGetValue("client_page_size", out var cookieVal) && int.TryParse(cookieVal, out var cpSize) && cpSize > 0)
                {
                    resolvedPageSize = cpSize;
                }

                var isArabic = CultureInfo.CurrentUICulture.Name.StartsWith("ar");
                var categoriesWithCourses = await GetCategoriesWithCoursesAsync();
                ViewBag.Categories = categoriesWithCourses;

                var allCourses = await _courseService.GetAllCoursesAsync();
                var newCourses = allCourses
                    .Where(c => c.Status == SD.CourseStatusApproved)
                    .OrderByDescending(c => c.CreatedAt)
                    .ToList();

                var totalCount = newCourses.Count;
                var totalPages = Math.Max(1, (int)Math.Ceiling((double)totalCount / resolvedPageSize));
                page = Math.Min(Math.Max(1, page), totalPages);

                var pagedCourses = newCourses
                    .Skip((page - 1) * resolvedPageSize)
                    .Take(resolvedPageSize)
                    .ToList();

                ViewBag.CollectionMode = true;
                ViewBag.CollectionType = "New";
                ViewBag.CollectionBadge = isArabic ? "أضيف حديثاً" : "Recently Added";
                ViewBag.CollectionTitle = isArabic ? "أحدث الإصدارات والدورات" : "Latest Course Releases";
                ViewBag.CollectionSubtitle = isArabic ? "استكشف أحدث المحتويات والكورسات التدريبية المضافة للمنصة" : "Discover the latest content and courses newly added to the platform";
                ViewBag.CollectionIcon = "fa-clock";
                ViewBag.PageAction = "New";
                ViewBag.CurrentPage = page;
                ViewBag.TotalPages = totalPages;
                ViewBag.TotalCount = totalCount;
                ViewBag.PageSize = resolvedPageSize;
                ViewBag.TotalCourses = totalCount;

                return View("Index", pagedCourses);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading new courses");
                TempData["Error"] = _localizer["ErrorLoadingCourses"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        /// <summary>
        /// GET: Recommended - Displays all recommended courses for the authenticated user with pagination
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> Recommended(int page = 1, int? pageSize = null)
        {
            try
            {
                var token = Request.Cookies["AuthToken"];
                if (string.IsNullOrEmpty(token))
                {
                    return RedirectToAction("Login", "Auth", new { area = "Learner", returnUrl = Url.Action("Recommended", "Course", new { area = "Learner" }) });
                }

                int resolvedPageSize = 24;
                if (pageSize.HasValue && pageSize.Value > 0)
                {
                    resolvedPageSize = pageSize.Value;
                }
                else if (Request.Cookies.TryGetValue("client_page_size", out var cookieVal) && int.TryParse(cookieVal, out var cpSize) && cpSize > 0)
                {
                    resolvedPageSize = cpSize;
                }

                var isArabic = CultureInfo.CurrentUICulture.Name.StartsWith("ar");
                var categoriesWithCourses = await GetCategoriesWithCoursesAsync();
                ViewBag.Categories = categoriesWithCourses;

                var recommendedCourses = await _courseService.GetRecommendedCoursesAsync(100);
                recommendedCourses ??= new List<CourseDTO>();

                var totalCount = recommendedCourses.Count;
                var totalPages = Math.Max(1, (int)Math.Ceiling((double)totalCount / resolvedPageSize));
                page = Math.Min(Math.Max(1, page), totalPages);

                var pagedCourses = recommendedCourses
                    .Skip((page - 1) * resolvedPageSize)
                    .Take(resolvedPageSize)
                    .ToList();

                ViewBag.CollectionMode = true;
                ViewBag.CollectionType = "Recommended";
                ViewBag.CollectionBadge = isArabic ? "مقترحة لك" : "Recommended for You";
                ViewBag.CollectionTitle = isArabic ? "الدورات المقترحة لك" : "Recommended Courses For You";
                ViewBag.CollectionSubtitle = isArabic ? "دورات تم اختيارها بعناية لتناسب مسارك واهتماماتك بناءً على تسجيلاتك" : "Courses carefully selected to match your path and interests based on your enrollments";
                ViewBag.CollectionIcon = "fa-wand-magic-sparkles";
                ViewBag.PageAction = "Recommended";
                ViewBag.CurrentPage = page;
                ViewBag.TotalPages = totalPages;
                ViewBag.TotalCount = totalCount;
                ViewBag.PageSize = resolvedPageSize;
                ViewBag.TotalCourses = totalCount;

                return View("Index", pagedCourses);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading recommended courses");
                TempData["Error"] = _localizer["ErrorLoadingCourses"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        /// <summary>
        /// GET: GetCategoryCoursesPartial - Returns partial view of paginated category courses for AJAX
        /// </summary>
        public async Task<IActionResult> GetCategoryCoursesPartial(int id, int page = 1, int? pageSize = null)
        {
            try
            {
                int resolvedPageSize = 24;
                if (pageSize.HasValue && pageSize.Value > 0)
                {
                    resolvedPageSize = pageSize.Value;
                }
                else if (Request.Cookies.TryGetValue("client_page_size", out var cookieVal) && int.TryParse(cookieVal, out var cpSize) && cpSize > 0)
                {
                    resolvedPageSize = cpSize;
                }

                List<CourseDTO> courses;
                if (id > 0)
                {
                    courses = await _courseService.GetApprovedCoursesByCategoryAsync(id, 200);
                    courses ??= new List<CourseDTO>();
                }
                else
                {
                    courses = await GetCachedApprovedCoursesAsync(CancellationToken.None);
                }

                var totalCount = courses.Count;
                var totalPages = (int)Math.Ceiling((double)totalCount / resolvedPageSize);
                if (totalPages < 1) totalPages = 1;
                page = Math.Min(Math.Max(1, page), totalPages);

                var pagedCourses = courses
                    .Skip((page - 1) * resolvedPageSize)
                    .Take(resolvedPageSize)
                    .ToList();

                ViewBag.CurrentPage = page;
                ViewBag.TotalPages = totalPages;
                ViewBag.TotalCount = totalCount;
                ViewBag.PageSize = resolvedPageSize;
                ViewBag.CategoryId = id;

                return PartialView("_CategoryCoursesPartial", pagedCourses);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading partial courses for category ID: {CategoryId}", id);
                return StatusCode(500, "Error loading category courses");
            }
        }

        /// <summary>
        /// GET: Search - Dedicated search results page
        /// </summary>
        /// <param name="search">Search term</param>
        /// <param name="page">Page number</param>
        /// <returns>Search results view</returns>
        public async Task<IActionResult> Search(string search, int page = 1,
            string language = "", string rating = "", string duration = "",
            string categories = "", string level = "", string price = "",
            string certificate = "", string sort = "")
        {
            try
            {
                if (string.IsNullOrWhiteSpace(search))
                    return RedirectToAction(nameof(Index));

                var query = search.Trim().ToLower();
                var allApproved = await GetCachedApprovedCoursesAsync(CancellationToken.None);

                // --- Filter options (from static sources, not DB distinct) ---
                var isAr = CultureInfo.CurrentUICulture.Name.StartsWith("ar");
                ViewBag.AllLanguages = LanguageData.GetAll().Select(l => l.Code).ToList();
                ViewBag.AllLevels     = LevelData.Levels.Select(l => l.Code).ToList();
                ViewBag.LanguageNames = LanguageData.GetAll().ToDictionary(l => l.Code, l => isAr ? l.ArabicName : l.EnglishName);
                ViewBag.LevelNames    = LevelData.Levels.ToDictionary(l => l.Code, l => isAr ? l.ArabicName : l.EnglishName);
                ViewBag.AllCategories = allApproved.Where(c => !string.IsNullOrEmpty(c.CategoryName))
                    .GroupBy(c => c.CategoryId)
                    .Select(g => new CategoryDTO
                    {
                        Category_Id = g.Key,
                        Category_Name = g.First().CategoryName,
                        Category_EnglishName = g.First().CategoryEnglishName
                    })
                    .OrderBy(c => c.Category_Name)
                    .ToList();

                // --- Text search ---
                var results = allApproved.Where(c =>
                        (c.Title?.ToLower().Contains(query) ?? false) ||
                        (c.ShortDescription?.ToLower().Contains(query) ?? false) ||
                        (c.Description?.ToLower().Contains(query) ?? false) ||
                        (c.InstructorName?.ToLower().Contains(query) ?? false) ||
                        (c.CategoryName?.ToLower().Contains(query) ?? false) ||
                        (c.CategoryEnglishName?.ToLower().Contains(query) ?? false))
                    .ToList();

                // --- Filter: Language (multi) ---
                var langs = ParseCsvFilter(language);
                if (langs.Length > 0)
                    results = results.Where(c => !string.IsNullOrEmpty(c.Language) && langs.Contains(c.Language, StringComparer.OrdinalIgnoreCase)).ToList();

                // --- Filter: Rating ---
                if (!string.IsNullOrWhiteSpace(rating) && double.TryParse(rating, out var minRating))
                    results = results.Where(c => c.AverageRating >= minRating).ToList();

                // --- Filter: Duration ---
                if (!string.IsNullOrWhiteSpace(duration))
                {
                    results = duration switch
                    {
                        "0-1" => results.Where(c => c.Duration <= 3600).ToList(),
                        "1-3" => results.Where(c => c.Duration > 3600 && c.Duration <= 10800).ToList(),
                        "3-6" => results.Where(c => c.Duration > 10800 && c.Duration <= 21600).ToList(),
                        "6-17" => results.Where(c => c.Duration > 21600 && c.Duration <= 61200).ToList(),
                        "17+" => results.Where(c => c.Duration > 61200).ToList(),
                        _ => results
                    };
                }

                // --- Filter: Categories (multi) ---
                var catIds = ParseCsvFilter(categories).Select(s => int.TryParse(s, out var id) ? id : 0).Where(id => id > 0).ToArray();
                if (catIds.Length > 0)
                    results = results.Where(c => catIds.Contains(c.CategoryId)).ToList();

                // --- Filter: Level (multi) ---
                var levels = ParseCsvFilter(level);
                if (levels.Length > 0)
                    results = results.Where(c => !string.IsNullOrEmpty(c.Level) && levels.Contains(c.Level, StringComparer.OrdinalIgnoreCase)).ToList();

                // --- Filter: Price ---
                if (!string.IsNullOrWhiteSpace(price))
                {
                    results = price switch
                    {
                        "free" => results.Where(c => c.Price <= 0).ToList(),
                        "under50" => results.Where(c => c.Price > 0 && c.Price < 50).ToList(),
                        "50to200" => results.Where(c => c.Price >= 50 && c.Price <= 200).ToList(),
                        "200to500" => results.Where(c => c.Price > 200 && c.Price <= 500).ToList(),
                        "500plus" => results.Where(c => c.Price > 500).ToList(),
                        _ => results
                    };
                }

                // --- Filter: Certificate ---
                if (!string.IsNullOrWhiteSpace(certificate) && certificate.Equals("true", StringComparison.OrdinalIgnoreCase))
                    results = results.Where(c => c.HasCertificate).ToList();

                // --- Sort ---
                results = sort switch
                {
                    "highest_rated" => results.OrderByDescending(c => c.AverageRating).ToList(),
                    "most_reviewed" => results.OrderByDescending(c => c.TotalRatings).ToList(),
                    "newest" => results.OrderByDescending(c => c.CreatedAt).ToList(),
                    _ => results
                };

                const int pageSize = 12;
                var totalPages = Math.Max(1, (int)Math.Ceiling(results.Count / (double)pageSize));
                if (page < 1) page = 1;
                if (page > totalPages) page = totalPages;

                ViewBag.Search = search.Trim();
                ViewBag.LanguageFilter = language;
                ViewBag.RatingFilter = rating;
                ViewBag.DurationFilter = duration;
                ViewBag.CategoriesFilter = categories;
                ViewBag.LevelFilter = level;
                ViewBag.PriceFilter = price;
                ViewBag.CertificateFilter = certificate;
                ViewBag.SortFilter = sort;
                ViewBag.TotalResults = results.Count;
                ViewBag.TotalPages = totalPages;
                ViewBag.CurrentPage = page;

                _logger.LogInformation("Search '{Search}' returned {CourseCount} courses after filters", search, results.Count);
                return View(results.Skip((page - 1) * pageSize).Take(pageSize).ToList());
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error performing course search");
                TempData["Error"] = _localizer["ErrorLoadingCourses"].Value;
                return View(new List<CourseDTO>());
            }
        }

        private static string[] ParseCsvFilter(string input)
        {
            return !string.IsNullOrWhiteSpace(input) ? input.Split(',', StringSplitOptions.RemoveEmptyEntries).Select(s => s.Trim()).Where(s => s.Length > 0).ToArray() : Array.Empty<string>();
        }

        /// <summary>
        /// GET: Suggest - Live search suggestions for the navbar search
        /// </summary>
        /// <param name="term">Partial course title</param>
        /// <returns>JSON list of matching courses</returns>
        [HttpGet]
        public async Task<IActionResult> Suggest(string term, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(term) || term.Trim().Length < 2)
                return Json(new List<object>());

            try
            {
                var query = term.Trim().ToLower();
                var isArabic = System.Globalization.CultureInfo.CurrentUICulture.Name.StartsWith("ar");

                var courses = await GetCachedApprovedCoursesAsync(cancellationToken);

                var categories = await _cache.GetOrCreateAsync("Learner_Categories_Suggest", async entry =>
                {
                    entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(5);
                    return await _categoryService.GetAllCategoriesAsync(cancellationToken);
                });

                var categoryResults = categories?
                    .Where(cat =>
                        (!string.IsNullOrEmpty(cat.Category_Name) && cat.Category_Name.ToLower().Contains(query)) ||
                        (!string.IsNullOrEmpty(cat.Category_EnglishName) && cat.Category_EnglishName.ToLower().Contains(query)))
                    .Take(4)
                    .Select(cat => (object)new
                    {
                        type = "category",
                        title = isArabic ? cat.Category_Name : (cat.Category_EnglishName ?? cat.Category_Name),
                        subtitle = isArabic ? (cat.Category_EnglishName ?? "") : (cat.Category_Name ?? ""),
                        category = _localizer["CategoriesLabel"].Value,
                        thumb = "",
                        url = Url.Action("ByCategory", new { id = cat.Category_Id })
                    })
                    .ToList() ?? new List<object>();

                var instructorResults = courses?
                    .Where(c => !string.IsNullOrEmpty(c.InstructorName) && c.InstructorName.ToLower().Contains(query))
                    .GroupBy(c => c.InstructorId)
                    .Select(g => g.First())
                    .Take(3)
                    .Select(c => (object)new
                    {
                        type = "instructor",
                        title = c.InstructorName,
                        subtitle = c.InstructorTitle ?? "",
                        category = _localizer["InstructorLabel"].Value,
                        thumb = c.ProfileImageUrl,
                        url = Url.Action("InstructorProfile", "Profile", new { area = "Learner", id = c.InstructorId })
                    })
                    .ToList() ?? new List<object>();

                var courseResults = courses?
                    .Where(c => !string.IsNullOrEmpty(c.Title) && c.Title.ToLower().Contains(query))
                    .OrderByDescending(c => c.Title.StartsWith(query, StringComparison.OrdinalIgnoreCase))
                    .ThenBy(c => c.Title)
                    .Take(8)
                    .Select(c => (object)new
                    {
                        type = "course",
                        title = c.Title,
                        subtitle = c.InstructorName,
                        category = isArabic ? c.CategoryName : (c.CategoryEnglishName ?? c.CategoryName),
                        thumb = c.ThumbnailUrl,
                        url = Url.Action("Details", new { id = c.Id })
                    })
                    .ToList() ?? new List<object>();

                return Json(instructorResults.Concat(categoryResults).Concat(courseResults).ToList());
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error generating search suggestions for term: {Term}", term);
                return Json(new List<object>());
            }
        }

        /// <summary>
        /// Retrieves categories that have at least one course with an in-memory cache
        /// </summary>
        private async Task<List<CategoryDTO>> GetCategoriesWithCoursesAsync(CancellationToken cancellationToken = default)
        {
            return await _cache.GetOrCreateAsync("Learner_Categories_With_Courses", async entry =>
            {
                entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(10);
                var allCategories = await _categoryService.GetAllCategoriesAsync(cancellationToken);
                if (allCategories == null || !allCategories.Any())
                    return new List<CategoryDTO>();

                var withCourses = allCategories.Where(c => c.CoursesCount > 0).ToList();
                return withCourses.Any() ? withCourses : allCategories;
            }) ?? new List<CategoryDTO>();
        }

        /// <summary>
        /// Gets all approved courses with an in-memory cache (10 min)
        /// </summary>
        private async Task<List<CourseDTO>> GetCachedApprovedCoursesAsync(CancellationToken cancellationToken)
        {
            return await _cache.GetOrCreateAsync("Learner_ApprovedCourses_Suggest", async entry =>
            {
                entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(10);
                
                // Fetch top categories (up to 8) to keep the index page light and ultra-fast
                var topCategories = await _categoryService.GetTopCategoriesAsync(8, cancellationToken);
                var categoryIds = topCategories?.Select(c => c.Category_Id).ToList() ?? new List<int>();

                if (!categoryIds.Any())
                {
                    var allCategories = await _categoryService.GetAllCategoriesAsync(cancellationToken);
                    categoryIds = allCategories?.Take(8).Select(c => c.Category_Id).ToList() ?? new List<int>();
                }

                if (!categoryIds.Any())
                {
                    entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromSeconds(5);
                    return new List<CourseDTO>();
                }

                // Fetch max 6 courses per category for home index sliders
                var courses = await _courseService.GetApprovedCoursesByCategoriesAsync(categoryIds, 6, cancellationToken);
                if (courses == null || !courses.Any())
                {
                    entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromSeconds(5);
                    return new List<CourseDTO>();
                }
                return courses;
            }) ?? new List<CourseDTO>();
        }

        /// <summary>
        /// GET: Details - Displays course details
        /// </summary>
        /// <param name="id">Course ID</param>
        /// <returns>Course details view</returns>
        public async Task<IActionResult> Details(int id)
        {
            try
            {
                _logger.LogInformation("Loading course details for ID: {CourseId}", id);

                var course = await _courseService.GetCourseByIdAsync(id);
                if (course == null)
                {
                    _logger.LogWarning("Course not found for details. ID: {CourseId}", id);
                    return NotFound();
                }

                await LoadCourseDetailsViewData(course);

                ViewBag.IsUserEnrolled = await IsUserEnrolled(id);
                ViewBag.IsCourseInCart = await IsCourseInCart(id);

                _logger.LogInformation("Course details loaded successfully. ID: {CourseId}", id);
                return View(course);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading course details for ID: {CourseId}", id);
                TempData["Error"] = _localizer["ErrorLoadingCourseDetails"].Value;
                return RedirectToAction(nameof(Index));
            }
        }

        #endregion

        #region Learner-Only Actions

        /// <summary>
        /// Handles course learning page access and progress tracking
        /// </summary>
        /// <param name="id">Course identifier</param>
        /// <returns>Course learning view with progress data</returns>
        [Authorize]
        public async Task<IActionResult> Learn(int id)
        {
            try
            {
                // Validate user enrollment in the course
                var isEnrolled = await _enrollmentService.IsUserEnrolledInCourseAsync(id);
                if (!isEnrolled)
                {
                    TempData["Error"] = _localizer["EnrollFirst"].Value;
                    return RedirectToAction("Details", new { id });
                }

                var course = await _courseService.GetCourseByIdAsync(id);
                if (course == null)
                {
                    return NotFound();
                }

                // Get user progress in the course
                var enrollment = await _enrollmentService.GetUserCourseEnrollmentAsync(id);
                var progressSummary = await _courseProgressService.GetCourseProgressAsync(id);

                ViewBag.ProgressPercentage = (int)Math.Round(progressSummary?.ProgressPercentage ?? 0);
                ViewBag.ProgressSummary = progressSummary;

                // Retrieve all course lectures and their status
                var allLectureIds = new List<int>();
                if (course.Sections != null)
                {
                    foreach (var section in course.Sections)
                    {
                        if (section.Lectures != null)
                        {
                            allLectureIds.AddRange(section.Lectures.Select(l => l.Id));
                        }
                    }
                }

                // Get completion status for each lecture
                var lectureStatuses = await _courseProgressService.GetLecturesStatusAsync(id, allLectureIds);

                ViewBag.LectureStatuses = lectureStatuses;
                ViewBag.CompletedLectures = progressSummary?.CompletedLectures ?? 0;
                ViewBag.TotalLectures = progressSummary?.TotalLectures ?? 0;

                // Check if the student earned a certificate for this enrollment
                var certificateCode = string.Empty;
                if (enrollment != null)
                {
                    try
                    {
                        var certificates = await _certificateService.GetMyCertificatesAsync();
                        certificateCode = certificates
                            .FirstOrDefault(c => c.EnrollmentId == enrollment.Id)
                            ?.CertificateCode ?? string.Empty;
                    }
                    catch (Exception certEx)
                    {
                        _logger.LogWarning(certEx, "Failed to load certificate info for enrollment {EnrollmentId}", enrollment.Id);
                    }
                }
                ViewBag.CertificateCode = certificateCode;

                return View(course);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading learn page for course {CourseId}", id);
                TempData["Error"] = _localizer["ErrorLoadingLearningPage"].Value;
                return RedirectToAction("Details", new { id });
            }
        }

        /// <summary>
        /// Checks whether the current user earned a certificate for this course (returns its code if so)
        /// </summary>
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetCourseCertificate(int courseId)
        {
            try
            {
                var enrollment = await _enrollmentService.GetUserCourseEnrollmentAsync(courseId);
                if (enrollment == null)
                {
                    return Ok(new { earned = false });
                }

                var certificates = await _certificateService.GetMyCertificatesAsync();
                var certificate = certificates.FirstOrDefault(c => c.EnrollmentId == enrollment.Id);

                if (certificate == null)
                {
                    return Ok(new { earned = false });
                }

                return Ok(new { earned = true, certificateCode = certificate.CertificateCode });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error checking certificate for course {CourseId}", courseId);
                return Ok(new { earned = false });
            }
        }

        /// <summary>
        /// Retrieves detailed data for a specific lecture
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="lectureId">Lecture identifier</param>
        /// <returns>Lecture data with resources and completion status</returns>
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetLectureData(int courseId, int lectureId)
        {
            try
            {
                var course = await _courseService.GetCourseByIdAsync(courseId);
                if (course == null)
                {
                    return NotFound(new { success = false, message = _localizer["CourseNotFoundJson"].Value });
                }

                var lecture = course.Sections?
                    .SelectMany(s => s.Lectures)
                    .FirstOrDefault(l => l.Id == lectureId);

                if (lecture == null)
                {
                    return NotFound(new { success = false, message = _localizer["LectureNotFound"].Value });
                }

                // Get lecture resources
                var resources = await _courseService.GetLectureResourcesAsync(lectureId);

                // Get lecture completion status
                var isCompleted = await _courseProgressService.GetLectureStatusAsync(courseId, lectureId);

                return Ok(new
                {
                    success = true,
                    lecture = new
                    {
                        lecture.Id,
                        lecture.Title,
                        lecture.VideoUrl,
                        lecture.Duration,
                        lecture.ContentType,
                        Resources = resources,
                        IsCompleted = isCompleted
                    }
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting lecture data for lecture {LectureId}", lectureId);
                return StatusCode(500, new { success = false, message = _localizer["ErrorRetrievingLectureData"].Value });
            }
        }

        /// <summary>
        /// Saves user progress for a specific lecture
        /// </summary>
        /// <param name="request">Progress data containing course ID, lecture ID, and completion status</param>
        /// <returns>Operation result with updated progress information</returns>
        [HttpPost]
        [Authorize]
        public async Task<IActionResult> SaveProgress([FromBody] SaveProgressRequest request)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid model state in SaveProgress: {@Errors}",
                        ModelState.Values.SelectMany(v => v.Errors));
                    return BadRequest(new { success = false, message = _localizer["InvalidData"].Value });
                }

                _logger.LogInformation("SaveProgress - CourseId: {CourseId}, LectureId: {LectureId}, IsCompleted: {IsCompleted}",
                    request.CourseId, request.LectureId, request.IsCompleted);

                bool result;
                if (request.IsCompleted)
                {
                    result = await _courseProgressService.MarkLectureAsCompletedAsync(request.CourseId, request.LectureId);
                }
                else
                {
                    // Don't mark as incomplete if already completed (user rewatching)
                    var currentStatus = await _courseProgressService.GetLectureStatusAsync(request.CourseId, request.LectureId);
                    if (currentStatus)
                    {
                        _logger.LogInformation("Lecture {LectureId} is already completed, skipping mark as incomplete",
                            request.LectureId);
                        var progressSummary = await _courseProgressService.GetCourseProgressAsync(request.CourseId);
                        return Ok(new
                        {
                            success = true,
                            message = _localizer["ProgressSaved"].Value,
                            progressPercentage = (int)Math.Round(progressSummary?.ProgressPercentage ?? 0),
                            completedLectures = progressSummary?.CompletedLectures ?? 0
                        });
                    }
                    result = await _courseProgressService.MarkLectureAsIncompleteAsync(request.CourseId, request.LectureId);
                }

                if (result)
                {
                    _logger.LogInformation("Progress saved successfully - Course: {CourseId}, Lecture: {LectureId}, Completed: {IsCompleted}",
                        request.CourseId, request.LectureId, request.IsCompleted);

                    // Get updated progress summary
                    var progressSummary = await _courseProgressService.GetCourseProgressAsync(request.CourseId);

                    return Ok(new
                    {
                        success = true,
                        message = _localizer["ProgressSavedSuccessfully"].Value,
                        progressPercentage = (int)Math.Round(progressSummary?.ProgressPercentage ?? 0),
                        completedLectures = progressSummary?.CompletedLectures ?? 0
                    });
                }

                _logger.LogWarning("Failed to save progress for lecture {LectureId}", request.LectureId);
                return BadRequest(new { success = false, message = _localizer["FailedToSaveProgress"].Value });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error saving progress for lecture {LectureId}", request?.LectureId);
                return StatusCode(500, new { success = false, message = _localizer["ErrorSavingProgress"].Value });
            }
        }
        /// <summary>
        /// Retrieves overall course progress for the current user
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <returns>Course progress summary</returns>
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetCourseProgress(int courseId)
        {
            try
            {
                var progressSummary = await _courseProgressService.GetCourseProgressAsync(courseId);
                if (progressSummary == null)
                {
                    return NotFound(new { success = false, message = _localizer["NoProgressRecorded"].Value });
                }

                return Ok(new
                {
                    success = true,
                    progress = progressSummary
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting course progress for course {CourseId}", courseId);
                return StatusCode(500, new { success = false, message = _localizer["ErrorRetrievingProgress"].Value });
            }
        }

        /// <summary>
        /// Gets completion status for a specific lecture
        /// </summary>
        /// <param name="courseId">Course identifier</param>
        /// <param name="lectureId">Lecture identifier</param>
        /// <returns>Lecture completion status</returns>
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetLectureStatus(int courseId, int lectureId)
        {
            try
            {
                var isCompleted = await _courseProgressService.GetLectureStatusAsync(courseId, lectureId);
                return Ok(new
                {
                    success = true,
                    isCompleted
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting lecture status for lecture {LectureId}", lectureId);
                return Ok(new { success = true, isCompleted = false });
            }
        }

        /// <summary>
        /// Toggles lecture completion status between completed and incomplete
        /// </summary>
        /// <param name="request">Toggle request containing course and lecture identifiers</param>
        /// <returns>Updated completion status and progress information</returns>
        [HttpPost]
        [Authorize]
        public async Task<IActionResult> ToggleLectureCompletion([FromBody] ToggleLectureRequest request)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Invalid model state: {@Errors}", ModelState.Values.SelectMany(v => v.Errors));
                    return BadRequest(new { success = false, message = _localizer["InvalidData"].Value });
                }

                _logger.LogInformation("ToggleLectureCompletion - CourseId: {CourseId}, LectureId: {LectureId}",
                    request.CourseId, request.LectureId);

                var currentStatus = await _courseProgressService.GetLectureStatusAsync(request.CourseId, request.LectureId);

                bool result;
                if (currentStatus)
                {
                    result = await _courseProgressService.MarkLectureAsIncompleteAsync(request.CourseId, request.LectureId);
                }
                else
                {
                    result = await _courseProgressService.MarkLectureAsCompletedAsync(request.CourseId, request.LectureId);
                }

                if (result)
                {
                    var progressSummary = await _courseProgressService.GetCourseProgressAsync(request.CourseId);
                    var newStatus = !currentStatus;

                    _logger.LogInformation("Successfully toggled lecture {LectureId} to {Status}",
                        request.LectureId, newStatus ? "completed" : "incomplete");

                    return Ok(new
                    {
                        success = true,
                        isCompleted = newStatus,
                        progressPercentage = (int)Math.Round(progressSummary?.ProgressPercentage ?? 0),
                        completedLectures = progressSummary?.CompletedLectures ?? 0
                    });
                }

                _logger.LogWarning("Failed to toggle lecture {LectureId}", request.LectureId);
                return BadRequest(new { success = false, message = _localizer["FailedToUpdateLectureStatus"].Value });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error toggling lecture completion for lecture {LectureId}", request.LectureId);
                return StatusCode(500, new { success = false, message = _localizer["ErrorUpdatingLectureStatus"].Value });
            }
        }

        #endregion

        #region Private Helper Methods

        /// <summary>
        /// Loads view data for course details page
        /// </summary>
        /// <param name="course">Course object</param>
        private async Task LoadCourseDetailsViewData(CourseDTO course)
        {
            try
            {
                // Load instructor courses
                var instructorCourses = await _courseService.GetApprovedCoursesByInstructorAsync(course.InstructorId, 12);
                instructorCourses = instructorCourses?.Where(c => c.Id != course.Id).ToList();
                ProcessInstructorCourses(instructorCourses, course);

                // Load similar courses
                var similarCourses = await _courseService.GetApprovedCoursesByCategoryAsync(course.CategoryId, 4);
                ViewBag.SimilarCourses = similarCourses?.Where(c => c.Id != course.Id).Take(3).ToList();

                ViewBag.InstructorCourses = instructorCourses;
                ViewBag.Count = instructorCourses?.Count ?? 0;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading course details view data for course ID: {CourseId}", course.Id);
                // Set default values to avoid null reference exceptions
                ViewBag.SimilarCourses = new List<CourseDTO>();
                ViewBag.InstructorCourses = new List<CourseDTO>();
                ViewBag.Count = 0;
            }
        }

        private async Task<bool> IsUserEnrolled(int courseId)
        {
            if (!User.Identity.IsAuthenticated) return false;

            try
            {
                return await _enrollmentService.IsUserEnrolledInCourseAsync(courseId);
            }
            catch
            {
                return false;
            }
        }

        private async Task<bool> IsCourseInCart(int courseId)
        {
            if (!User.Identity.IsAuthenticated) return false;

            try
            {
                return await _cartService.IsCourseInCartAsync(courseId);
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Processes instructor courses data
        /// </summary>
        /// <param name="instructorCourses">List of instructor courses</param>
        /// <param name="mainCourse">Main course object for reference</param>
        private void ProcessInstructorCourses(List<CourseDTO> instructorCourses, CourseDTO mainCourse)
        {
            if (instructorCourses == null) return;

            foreach (var course in instructorCourses)
            {
                // Fix thumbnail URL if needed
                if (!string.IsNullOrEmpty(course.ThumbnailUrl) && !course.ThumbnailUrl.StartsWith("http"))
                {
                    course.ThumbnailUrl = $"{_imageBaseUrl}/{course.ThumbnailUrl.TrimStart('/')}";
                }

                // Set instructor name if missing
                if (string.IsNullOrEmpty(course.InstructorName))
                {
                    course.InstructorName = mainCourse.InstructorName;
                }
            }
        }

        #endregion
    }
}