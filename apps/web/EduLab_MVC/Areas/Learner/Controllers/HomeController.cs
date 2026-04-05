using EduLab_MVC.Services.ServiceInterfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    [Area("Learner")]
    [AllowAnonymous]
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IEnrollmentService _enrollmentService;
        private readonly ICourseProgressService _courseProgressService;

        public HomeController(
            ILogger<HomeController> logger,
            IEnrollmentService enrollmentService,
            ICourseProgressService courseProgressService)
        {
            _logger = logger;
            _enrollmentService = enrollmentService;
            _courseProgressService = courseProgressService;
        }

        public async Task<IActionResult> Index()
        {
            try
            {
                _logger.LogInformation("Loading home page");

                // جلب الكورسات المسجلة فيها إذا كان المستخدم مسجل الدخول
                var token = Request.Cookies["AuthToken"];
                if (!string.IsNullOrEmpty(token))
                {
                    var enrollments = await _enrollmentService.GetUserEnrollmentsAsync();

                    // أخذ أول 6 كورسات فقط
                    var limitedEnrollments = enrollments.Take(6).ToList();

                    // تحديث الصور الافتراضية
                    foreach (var enrollment in limitedEnrollments)
                    {
                        if (string.IsNullOrEmpty(enrollment.ThumbnailUrl))
                        {
                            enrollment.ThumbnailUrl = "/images/default-course.jpg";
                        }

                        if (string.IsNullOrEmpty(enrollment.ProfileImageUrl))
                        {
                            enrollment.ProfileImageUrl = "/images/default-instructor.jpg";
                        }
                    }

                    // جلب التقدم لكل كورس
                    var courseProgressDict = new Dictionary<int, decimal>();
                    foreach (var enrollment in limitedEnrollments)
                    {
                        var progressSummary = await _courseProgressService.GetCourseProgressAsync(enrollment.CourseId);
                        var percentage = progressSummary?.ProgressPercentage ?? 0;
                        courseProgressDict[enrollment.CourseId] = percentage;
                    }

                    ViewBag.UserEnrollments = limitedEnrollments;
                    ViewBag.CourseProgress = courseProgressDict;
                    ViewBag.TotalEnrollmentsCount = enrollments.Count(); // إجمالي عدد الكورسات المسجلة
                }

                return View();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error loading home page");
                return View();
            }
        }



        public IActionResult instructors()
        {
            return View();
        }
        public IActionResult Cart()
        {
            return View();
        }
        public IActionResult Checkout()
        {
            return View();
        }
        public IActionResult Profile()
        {
            return View();
        }
        public IActionResult MyCourses()
        {
            return View();
        }
        public IActionResult blog()
        {
            return View();
        }
        public IActionResult about()
        {
            return View();
        }
        public IActionResult wishlist()
        {
            return View();
        }
        public IActionResult Notification()
        {
            return View();
        }
        public IActionResult faq()
        {
            return View();
        }
        public IActionResult contact()
        {
            return View();
        }
        public IActionResult Privacy()
        {
            return View();
        }
        public IActionResult terms()
        {
            return View();
        }
        public IActionResult help()
        {
            return View();
        }
    }
}
