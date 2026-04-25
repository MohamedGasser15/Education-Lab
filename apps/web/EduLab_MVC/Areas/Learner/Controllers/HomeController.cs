using EduLab_MVC.Models.ViewModels;
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
        public IActionResult blog(int page = 1, string category = null)
        {
            int pageSize = 6;
            var filteredBlogs = AllBlogs;

            // فلترة بسيطة بالفئة (اختياري - فقط للشكل)
            if (!string.IsNullOrEmpty(category) && category != "الكل")
            {
                filteredBlogs = AllBlogs.Where(b => b.Category == category).ToList();
            }

            int totalItems = filteredBlogs.Count;
            int totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            // التأكد من أن الصفحة ضمن النطاق
            page = Math.Max(1, Math.Min(page, totalPages));

            var pagedBlogs = filteredBlogs
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            var model = new BlogListViewModel
            {
                Blogs = pagedBlogs,
                CurrentPage = page,
                TotalPages = totalPages
            };

            ViewBag.CurrentCategory = category ?? "الكل";
            return View(model);
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

        public IActionResult blogDetails(int id)
        {
            var blog = AllBlogs.FirstOrDefault(b => b.Id == id);
            if (blog == null)
            {
                return NotFound();
            }
            return View(blog);
        }

        public IActionResult Roadmap(string id)
        {
            var roadmap = AllRoadmaps.FirstOrDefault(r => r.Id == id);
            if (roadmap == null)
            {
                return NotFound();
            }
            return View(roadmap);
        }

        private static readonly List<RoadmapViewModel> AllRoadmaps = new List<RoadmapViewModel>
        {
            new RoadmapViewModel
            {
                Id = "web",
                Title = "مسار مطور الويب الشامل",
                Subtitle = "تطوير الويب",
                Description = "من الصفر حتى الاحتراف، دليلك المتكامل لتعلم بناء المواقع والتطبيقات باستخدام أحدث التقنيات.",
                BadgeText = "خارطة الطريق",
                HeroGradient = "radial-gradient(circle at 20% 30%, rgba(37, 99, 235, 0.15) 0%, transparent 50%), radial-gradient(circle at 80% 70%, rgba(6, 182, 212, 0.1) 0%, transparent 50%), linear-gradient(135deg, #0f172a 0%, #1e293b 100%)",
                ThemeColor = "#2563eb",
                Steps = new List<RoadmapStep>
                {
                    new RoadmapStep { Number = "1", Title = "أساسيات الواجهة الأمامية", Description = "ابدأ بتعلم اللبنات الأساسية للويب: HTML5 لبناء الهيكل، CSS3 للتنسيق، و JavaScript لجعل صفحاتك تفاعلية.", Icon = "fab fa-html5", ColorClass = "blue", Tags = new List<string> { "HTML5", "CSS3", "Flexbox", "JS Basics" } },
                    new RoadmapStep { Number = "2", Title = "التصميم المتجاوب والمكتبات", Description = "تعلم كيف تجعل مواقعك تعمل على جميع الشاشات باستخدام Tailwind CSS أو Bootstrap، واكتشف كيفية التعامل مع الـ Git للتحكم في الإصدارات.", Icon = "fas fa-magic", ColorClass = "cyan", Tags = new List<string> { "Tailwind CSS", "Responsive Design", "Git & GitHub" } },
                    new RoadmapStep { Number = "3", Title = "إطارات عمل الواجهة الأمامية", Description = "انتقل إلى المستوى التالي بتعلم React.js لبناء تطبيقات الصفحة الواحدة (SPA) ذات الأداء العالي والتجربة السلسة.", Icon = "fab fa-react", ColorClass = "purple", Tags = new List<string> { "React Basics", "Hooks", "State Management" } },
                    new RoadmapStep { Number = "4", Title = "تطوير الجهة الخلفية (Back-End)", Description = "تعلم لغة C# وإطار عمل ASP.NET Core لبناء خوادم قوية وآمنة تتعامل مع البيانات والمنطق البرمجي.", Icon = "fas fa-server", ColorClass = "indigo", Tags = new List<string> { "C# Programming", "ASP.NET Core", "API Design" } },
                    new RoadmapStep { Number = "5", Title = "قواعد البيانات", Description = "أتقن التعامل مع قواعد البيانات SQL Server وكيفية ربطها بتطبيقاتك باستخدام Entity Framework Core.", Icon = "fas fa-database", ColorClass = "emerald", Tags = new List<string> { "SQL Server", "EF Core", "LINQ" } },
                    new RoadmapStep { Number = "", Title = "مشروع التخرج والاحتراف", Description = "قم ببناء مشروع متكامل من البداية (Full-Stack) يجمع كل ما تعلمته، وقم برفعه على الإنترنت ليكون جزءاً من معرض أعمالك.", Icon = "fas fa-flag-checkered", ColorClass = "blue", Tags = new List<string> { "Full Stack", "Deployment", "Portfolio" }, IsFinal = true }
                }
            },
            new RoadmapViewModel
            {
                Id = "mobile",
                Title = "مسار تطبيقات الموبايل (Flutter)",
                Subtitle = "تطوير الموبايل",
                Description = "ابنِ تطبيقات تعمل على Android و iOS بكود واحد فقط باستخدام إطار عمل Flutter المذهل.",
                BadgeText = "خارطة الطريق",
                HeroGradient = "radial-gradient(circle at 20% 30%, rgba(139, 92, 246, 0.15) 0%, transparent 50%), radial-gradient(circle at 80% 70%, rgba(167, 139, 250, 0.1) 0%, transparent 50%), linear-gradient(135deg, #1e1b4b 0%, #312e81 100%)",
                ThemeColor = "#8b5cf6",
                Steps = new List<RoadmapStep>
                {
                    new RoadmapStep { Number = "1", Title = "لغة البرمجة Dart", Description = "تعلم أساسيات لغة Dart، اللغة الرسمية لتطوير تطبيقات Flutter، بدءاً من المتغيرات وحتى البرمجة كائنية التوجه (OOP).", Icon = "fas fa-terminal", ColorClass = "blue", Tags = new List<string> { "Variables", "Functions", "OOP", "Async/Await" } },
                    new RoadmapStep { Number = "2", Title = "أساسيات Flutter & UI", Description = "اكتشف عالم الـ Widgets، وكيفية بناء واجهات مستخدم مذهلة وسلسة باستخدام الأدوات التي يوفرها Flutter.", Icon = "fas fa-layer-group", ColorClass = "cyan", Tags = new List<string> { "Stateless & Stateful", "Material Design", "Navigation" } },
                    new RoadmapStep { Number = "3", Title = "إدارة الحالة (State Management)", Description = "تعلم كيف تدير البيانات داخل تطبيقك بكفاءة باستخدام Provider أو BLoC لضمان أداء عالي وسهولة في الصيانة.", Icon = "fas fa-project-diagram", ColorClass = "purple", Tags = new List<string> { "Provider", "BLoC Pattern", "Clean Architecture" } },
                    new RoadmapStep { Number = "4", Title = "التعامل مع البيانات والـ API", Description = "اربط تطبيقك بالإنترنت، تعلم كيفية جلب البيانات من الـ REST API وتخزينها محلياً باستخدام SQLite أو Hive.", Icon = "fas fa-cloud-download-alt", ColorClass = "indigo", Tags = new List<string> { "HTTP Requests", "JSON Parsing", "Local DB" } },
                    new RoadmapStep { Number = "5", Title = "ميزات الجهاز والنشر", Description = "تعامل مع الكاميرا، الموقع (GPS)، والإشعارات، ثم تعلم كيف تجهز تطبيقك للنشر على متجر Play Store و App Store.", Icon = "fas fa-mobile-alt", ColorClass = "pink", Tags = new List<string> { "Native Features", "Firebase", "Deployment" } },
                    new RoadmapStep { Number = "", Title = "أطلق تطبيقك الأول", Description = "الآن أنت مستعد لبناء تطبيق أحلامك ونشره للعالم. ابدأ بمشروعك الخاص وشاركه مع مجتمعنا.", Icon = "fas fa-check", ColorClass = "purple", Tags = new List<string> { "App Store", "Play Store", "Success" }, IsFinal = true }
                }
            },
            new RoadmapViewModel
            {
                Id = "ux",
                Title = "مسار تصميم UI/UX",
                Subtitle = "التصميم الإبداعي",
                Description = "تعلم كيف تبتكر تجارب مستخدم استثنائية وتصاميم واجهات بصرية مذهلة تخطف الأنظار.",
                BadgeText = "خارطة الطريق",
                HeroGradient = "radial-gradient(circle at 20% 30%, rgba(6, 182, 212, 0.15) 0%, transparent 50%), radial-gradient(circle at 80% 70%, rgba(34, 211, 238, 0.1) 0%, transparent 50%), linear-gradient(135deg, #083344 0%, #155e75 100%)",
                ThemeColor = "#06b6d4",
                Steps = new List<RoadmapStep>
                {
                    new RoadmapStep { Number = "1", Title = "مبادئ التصميم المرئي", Description = "ابدأ بتعلم القواعد الأساسية للتصميم: نظرية الألوان، التيبوغرافيا (الخطوط)، الشبكات (Grids)، والتسلسل الهرمي البصري.", Icon = "fas fa-palette", ColorClass = "blue", Tags = new List<string> { "Color Theory", "Typography", "Grid Systems" } },
                    new RoadmapStep { Number = "2", Title = "أبحاث تجربة المستخدم (UX Research)", Description = "تعلم كيف تفهم المستخدمين من خلال إجراء المقابلات، بناء الـ Personas، وتحليل رحلة المستخدم (User Journey).", Icon = "fas fa-search", ColorClass = "cyan", Tags = new List<string> { "User Interviews", "User Personas", "User Flow" } },
                    new RoadmapStep { Number = "3", Title = "التخطيط الأولي (Wireframing)", Description = "حوّل أفكارك إلى مخططات هيكلية بسيطة (Low-fidelity) للتركيز على الوظائف وتجربة الاستخدام قبل البدء في التفاصيل البصرية.", Icon = "fas fa-pen-nib", ColorClass = "purple", Tags = new List<string> { "Sketching", "Lo-Fi Wireframes", "Information Architecture" } },
                    new RoadmapStep { Number = "4", Title = "إتقان أدوات التصميم (Figma)", Description = "أتقن الأداة الأكثر طلباً في سوق العمل حالياً، تعلم كيفية بناء التصاميم النهائية (Hi-fidelity) والـ Prototypes التفاعلية.", Icon = "fab fa-figma", ColorClass = "indigo", Tags = new List<string> { "Figma Basics", "Auto Layout", "Prototyping" } },
                    new RoadmapStep { Number = "5", Title = "نظم التصميم (Design Systems)", Description = "تعلم كيف تبني مكتبة من المكونات (Components) القابلة لإعادة الاستخدام لضمان الاتساق في مشاريعك الكبيرة.", Icon = "fas fa-bezier-curve", ColorClass = "emerald", Tags = new List<string> { "Libraries", "Style Guides", "Documentation" } },
                    new RoadmapStep { Number = "", Title = "بناء معرض الأعمال (Portfolio)", Description = "الآن حان الوقت لجمع أفضل أعمالك في ملف احترافي، وكتابة دراسات الحالة (Case Studies) لتقديمها للشركات.", Icon = "fas fa-gem", ColorClass = "cyan", Tags = new List<string> { "Portfolio", "Case Studies", "Career" }, IsFinal = true }
                }
            }
        };

        private static readonly List<Blog> AllBlogs = new List<Blog>
{
    new Blog { Id = 1,  Title = "أفضل لغات البرمجة لتعلمها في 2023 وكيف تبدأ",
        Summary = "دليل شامل لأفضل لغات البرمجة التي يجب تعلمها هذا العام مع تحليل لفرص العمل والطلب في السوق التقني المتسارع. نناقش Python, JavaScript, C#, Go, و Rust ونقدم خطة تعلم أسبوعية.",
        Content = @"<p>تعتبر البرمجة من أهم المهارات في العصر الحالي. في هذا المقال سنتناول أفضل اللغات التي يجب أن تركز عليها في 2023: </p>
        <ul><li><strong>Python</strong> – مثالية للمبتدئين والمجالات مثل تحليل البيانات والذكاء الاصطناعي.</li>
        <li><strong>JavaScript</strong> – لا غنى عنها لتطوير الويب (الواجهة والخلفية).</li>
        <li><strong>C#</strong> – قوية جداً مع .NET لتطبيقات المؤسسات والألعاب.</li>
        <li><strong>Go</strong> – لغة سريعة ومناسبة للأنظمة الموزعة.</li>
        <li><strong>Rust</strong> – للمشاريع التي تتطلب أداء عالي وأمان.</li></ul>
        <p>الخطة المقترحة: خصص 3 ساعات يومياً، وابدأ بمشروع حقيقي بعد الأسبوع الثالث. تذكر أن الممارسة اليومية هي مفتاح الاحتراف.</p>",
        Category = "برمجة", ImageUrl = "https://images.unsplash.com/photo-1555066931-4365d14bab8c?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
        Date = new DateTime(2023, 6, 15), ReadTime = "8 دقائق", Views = 1200,
        AuthorName = "أحمد سامي", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Ahmed+Sami&background=0D8ABC&color=fff",
        Tags = new List<string>{"برمجة", "تطوير"}
    },
    new Blog { Id = 2,  Title = "أحدث اتجاهات تصميم UI/UX لعام 2023 التي يجب معرفتها",
        Summary = "استكشف أهم 10 اتجاهات في تصميم واجهات المستخدم وتجربة المستخدم، من التصميم المظلم المتقدم إلى التفاعلات الدقيقة والـ Glassmorphism.",
        Content = @"<p>عالم التصميم يتغير بسرعة. إليك أبرز اتجاهات UI/UX في 2023:</p>
        <ol><li><strong>Glassmorphism 2.0</strong> – تأثير زجاجي مع تحسينات في الخلفية والشفافية.</li>
        <li><strong>التفاعلات الدقيقة Micro-interactions</strong> – تعزز تجربة المستخدم عبر رسوم متحركة ذكية.</li>
        <li><strong>التصميم المظلم المتقدم</strong> – ألوان داكنة مريحة للعين مع تباين عالي.</li>
        <li><strong>الطباعة الجريئة</strong> – استخدام خطوط ضخمة لتوجيه الانتباه.</li>
        <li><strong>التصميم الشامل للجميع (Accessibility)</strong> – لم يعد خياراً بل ضرورة.</li>
        <li><strong>واجهات تعتمد على الذكاء الاصطناعي</strong> – تخصيص التجربة لكل مستخدم.</li>
        <li><strong>3D في الويب</strong> – عناصر ثلاثية الأبعاد تفاعلية.</li>
        <li><strong>التنقل القائم على الإيماءات</strong> – خاصة في تطبيقات الموبايل.</li>
        <li><strong>Minimalism المتجدد</strong> – تصميم نظيف مع مساحات بيضاء واسعة.</li>
        <li><strong>التصميم العاطفي</strong> – استخدام الألوان والأشكال لإثارة المشاعر.</li></ol>",
        Category = "تصميم", ImageUrl = "https://images.unsplash.com/photo-1541462608143-67571c6738dd?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
        Date = new DateTime(2023, 6, 10), ReadTime = "10 دقائق", Views = 892,
        AuthorName = "سارة أحمد", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Sara+Ahmed&background=8B5CF6&color=fff",
        Tags = new List<string>{"تصميم", "UI/UX"}
    },
            new Blog { Id = 3,  Title = "استراتيجيات تسويق المحتوى الفعالة للشركات الناشئة",
                Summary = "تعلم كيفية إنشاء استراتيجية تسويق محتوى ناجحة تساعدك في جذب العملاء وزيادة المبيعات بأقل التكاليف الممكنة.",
                Content = "<p>اكتشف كيف تبني خطة محتوى متكاملة، من التدوين إلى الفيديوهات القصيرة، لتصل إلى جمهورك المستهدف بفعالية.</p>",
                Category = "أعمال", ImageUrl = "https://images.unsplash.com/photo-1551288049-bebda4e38f71?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                Date = new DateTime(2023, 6, 5), ReadTime = "6 دقائق", Views = 1500,
                AuthorName = "خالد محمود", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Khaled+M&background=10B981&color=fff",
                Tags = new List<string>{"تسويق", "أعمال"}
            },
            new Blog { Id = 4,  Title = "دليل شامل لتعلم React.js من الصفر إلى الاحتراف",
                Summary = "ابدأ رحلتك في عالم تطوير الواجهات الأمامية باستخدام أشهر مكتبات JavaScript، مع مشاريع عملية ونصائح حصرية.",
                Content = "<p>رياكت هي مكتبة جافاسكريبت لبناء واجهات المستخدم. نبدأ من المكونات (Components) وحتى إدارة الحالة بمشاريع حقيقة.</p>",
                Category = "برمجة", ImageUrl = "https://images.unsplash.com/photo-1633356122544-f134324a6cee?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                Date = new DateTime(2023, 5, 28), ReadTime = "10 دقائق", Views = 2300,
                AuthorName = "فريق EduLab", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Edu+Lab&background=0F172A&color=fff",
                Tags = new List<string>{"برمجة", "React"}
            },
            new Blog { Id = 5,  Title = "كيف تبني متجراً إلكترونياً باستخدام ASP.NET Core في 7 أيام",
                Summary = "خطة عملية لبناء متجر كامل مع سلة شراء وبوابة دفع باستخدام أحدث تقنيات مايكروسوفت.",
                Content = "<p>نستخدم ASP.NET Core MVC مع Entity Framework لبناء متجر متكامل. المقال يشمل الكود الكامل والشروحات.</p>",
                Category = "برمجة", ImageUrl = "https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                Date = new DateTime(2023, 5, 20), ReadTime = "15 دقيقة", Views = 3100,
                AuthorName = "د. نادر فؤاد", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Nader+F&background=DB2777&color=fff",
                Tags = new List<string>{"برمجة", "ويب"}
            },
            new Blog { Id = 6,  Title = "الذكاء الاصطناعي في التعليم: ثورة أم موضة عابرة؟",
                Summary = "تحليل عميق لاستخدام أدوات الذكاء الاصطناعي في الفصول الدراسية وتأثيرها على تجربة الطالب والمعلم.",
                Content = "<p>من ChatGPT إلى التقييم الآلي، ننظر في فوائد وسلبيات دمج الذكاء الاصطناعي في العملية التعليمية.</p>",
                Category = "تقنية", ImageUrl = "https://images.unsplash.com/photo-1677442136019-21780ecad995?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                Date = new DateTime(2023, 5, 15), ReadTime = "7 دقائق", Views = 987,
                AuthorName = "م. ليلى جمال", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Laila+J&background=4F46E5&color=fff",
                Tags = new List<string>{"ذكاء اصطناعي", "تعليم"}
            },
            new Blog { Id = 7,  Title = "أهم 10 نصائح لتحسين سيو موقعك في 2023",
                Summary = "تعرف على أحدث استراتيجيات تحسين محركات البحث التي ستجعل موقعك يتصدر النتائج الأولى في جوجل.",
                Content = "<p>من الكلمات المفتاحية الطويلة إلى تجربة المستخدم، نشاركك خلاصة خبرة 10 سنوات في عالم السيو.</p>",
                Category = "تسويق", ImageUrl = "https://images.unsplash.com/photo-1432888498266-38ffec3eaf0a?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                Date = new DateTime(2023, 5, 8), ReadTime = "9 دقائق", Views = 1650,
                AuthorName = "منى عادل", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Mona+Adel&background=F59E0B&color=fff",
                Tags = new List<string>{"تسويق", "SEO"}
            },
            new Blog { Id = 8,  Title = "تعلم لغة بايثون بأسلوب تفاعلي: من الصفر إلى أول تطبيق",
                Summary = "كورس مجاني داخل مقال: تعلم بايثون خطوة بخطوة مع أمثلة تفاعلية وتمارين عملية.",
                Content = "<p>بايثون لغة سهلة وقوية. نبدأ بكتابة أول برنامج Hello World حتى نصنع لعبة بسيطة في نهاية المقال.</p>",
                Category = "برمجة", ImageUrl = "https://images.unsplash.com/photo-1526379095098-d400fd0bf935?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                Date = new DateTime(2023, 4, 22), ReadTime = "22 دقيقة", Views = 4500,
                AuthorName = "فريق EduLab", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Edu+Lab&background=0F172A&color=fff",
                Tags = new List<string>{"برمجة", "بايثون"}
            },
            new Blog { Id = 9,  Title = "تصميم الشعارات: 5 مبادئ أساسية لشعار لا ينسى",
                Summary = "اكتشف القواعد الذهبية وراء الشعارات الناجحة لأكبر العلامات التجارية وكيف تطبقها على مشروعك.",
                Content = "<p>البساطة، الملاءمة، والخلود... تعلم كيف تجعل شعارك يتحدث عن علامتك التجارية بشكل مثالي.</p>",
                Category = "تصميم", ImageUrl = "https://images.unsplash.com/photo-1634942537034-2531766767d1?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                Date = new DateTime(2023, 4, 15), ReadTime = "6 دقائق", Views = 780,
                AuthorName = "ريم أشرف", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Reem+Ashraf&background=EC4899&color=fff",
                Tags = new List<string>{"تصميم", "جرافيك"}
            },
            new Blog { Id = 10, Title = "إدارة الوقت للمبرمجين: كيف تنجز أكثر في وقت أقل",
                Summary = "استراتيجيات مجربة من خبراء التقنية للتغلب على التشتت وزيادة الإنتاجية أثناء كتابة الكود.",
                Content = "<p>تقنية البومودورو، تحديد أولويات المهام، وأهمية الراحة... دليلك لإدارة وقتك كمطور برمجيات.</p>",
                Category = "أعمال", ImageUrl = "https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                Date = new DateTime(2023, 4, 8), ReadTime = "5 دقائق", Views = 640,
                AuthorName = "د. نادر فؤاد", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Nader+F&background=DB2777&color=fff",
                Tags = new List<string>{"إنتاجية", "برمجة"}
            },
            new Blog { Id = 11, Title = "مستقبل الواقع المعزز في التعليم الإلكتروني",
                Summary = "لمحة عن كيف سيغير الواقع المعزز شكل التعلم عن بعد ويجعله تجربة غامرة غير مسبوقة.",
                Content = "<p>من تطبيقات AR التي تسمح لك بتشريح جسم الإنسان افتراضياً إلى مختبرات الكيمياء التفاعلية، المستقبل هنا.</p>",
                Category = "تقنية", ImageUrl = "https://images.unsplash.com/photo-1633186710891-0f7bf2f6cced?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                Date = new DateTime(2023, 3, 25), ReadTime = "8 دقائق", Views = 1120,
                AuthorName = "م. ليلى جمال", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Laila+J&background=4F46E5&color=fff",
                Tags = new List<string>{"تعليم", "AR"}
            },
            new Blog { Id = 12, Title = "بناء واجهات مستخدم جذابة باستخدام Tailwind CSS",
                Summary = "أسلوب تعليمي سريع لاستخدام Tailwind في تصميم صفحات عصرية دون الحاجة لكتابة CSS تقليدي.",
                Content = "<p>نقارن بين CSS التقليدي و Tailwind، ونبني معاً صفحة هبوط كاملة باستخدام الأدوات المساعدة فقط.</p>",
                Category = "تصميم", ImageUrl = "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                Date = new DateTime(2023, 3, 18), ReadTime = "11 دقيقة", Views = 1350,
                AuthorName = "سارة أحمد", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Sara+Ahmed&background=8B5CF6&color=fff",
                Tags = new List<string>{"تصميم", "CSS"}
            },
            new Blog { Id = 13, Title = "دليلك للعمل الحر كمطور تطبيقات: الخطوات الأولى",
                Summary = "كيف تبدأ مشوارك في العمل الحر على منصات مثل Upwork، وتبني قاعدة عملاء قوية من الصفر.",
                Content = "<p>ابدأ بإنشاء بروفايل مثالي، احصل على أول مشروع لك، وتجنب الأخطاء الشائعة في عالم الفريلانسرز.</p>",
                Category = "أعمال", ImageUrl = "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                Date = new DateTime(2023, 3, 10), ReadTime = "7 دقائق", Views = 890,
                AuthorName = "خالد محمود", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Khaled+M&background=10B981&color=fff",
                Tags = new List<string>{"عمل حر", "تطوير"}
            },
            new Blog { Id = 14, Title = "الأمن السيبراني للمبتدئين: كيف تحمي نفسك على الإنترنت",
                Summary = "دليل مبسط لأساسيات الأمن الرقمي، من كلمات المرور القوية إلى اكتشاف رسائل التصيد.",
                Content = "<p>تعلم كيف تؤمن حساباتك، تستخدم VPN، وتتعرف على محاولات الاختراق قبل فوات الأوان.</p>",
                Category = "تقنية", ImageUrl = "https://images.unsplash.com/photo-1550751827-4bd374c3f58b?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                Date = new DateTime(2023, 2, 28), ReadTime = "6 دقائق", Views = 2100,
                AuthorName = "أحمد سامي", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Ahmed+Sami&background=0D8ABC&color=fff",
                Tags = new List<string>{"أمن سيبراني"}
            },
            new Blog { Id = 15, Title = "أسرار نجاح الشركات الناشئة في الشرق الأوسط",
                Summary = "مقابلات حصرية مع مؤسسي أبرز الشركات الناشئة الناجحة حول التحديات والاستراتيجيات الفائزة.",
                Content = "<p>ما الذي يميز الشركات التي استطاعت النمو في منطقة الشرق الأوسط؟ نكشف الستار عن قصص نجاح ملهمة.</p>",
                Category = "أعمال", ImageUrl = "https://images.unsplash.com/photo-1560179707-f14e90ef3623?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                Date = new DateTime(2023, 2, 14), ReadTime = "12 دقيقة", Views = 1700,
                AuthorName = "منى عادل", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Mona+Adel&background=F59E0B&color=fff",
                Tags = new List<string>{"أعمال", "شركات ناشئة"}
            },
            new Blog { Id = 16, Title = "دورة تعلم أساسيات قواعد البيانات SQL مجاناً",
                Summary = "شرح مفصل من البداية للتعامل مع قواعد البيانات العلائقية باستخدام لغة SQL مع تمارين محلولة.",
                Content = "<p>سنتناول أوامر SELECT, INSERT, UPDATE, DELETE بالإضافة إلى JOINs والاستعلامات الفرعية.</p>",
                Category = "برمجة", ImageUrl = "https://images.unsplash.com/photo-1544383835-bda2bc66a55d?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                Date = new DateTime(2023, 1, 30), ReadTime = "18 دقيقة", Views = 3300,
                AuthorName = "فريق EduLab", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Edu+Lab&background=0F172A&color=fff",
                Tags = new List<string>{"برمجة", "SQL"}
            },
            new Blog { Id = 17, Title = "تصميم تطبيقات الجوال: الفرق بين React Native و Flutter",
                Summary = "مقارنة شاملة بين أقوى إطارين لبناء تطبيقات الجوال عبر المنصات من حيث الأداء والتكلفة والمستقبل الوظيفي.",
                Content = "<p>نحلل مزايا وعيوب كل من React Native و Flutter، ونساعدك في اختيار الأنسب لمشروعك القادم.</p>",
                Category = "برمجة", ImageUrl = "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                Date = new DateTime(2023, 1, 15), ReadTime = "9 دقائق", Views = 2600,
                AuthorName = "أحمد سامي", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Ahmed+Sami&background=0D8ABC&color=fff",
                Tags = new List<string>{"برمجة", "موبايل"}
            },
            new Blog { Id = 18, Title = "فن كتابة المحتوى الإبداعي الذي يجذب القراء",
                Summary = "تقنيات احترافية لصياغة محتوى مؤثر يبقي الزائر متشوقاً حتى آخر كلمة ويزيد من تفاعله.",
                Content = "<p>من العناوين الجذابة إلى استخدام القصص في التسويق، تعلم أسرار صناع المحتوى المحترفين.</p>",
                Category = "تسويق", ImageUrl = "https://images.unsplash.com/photo-1455390582262-044cdead277a?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                Date = new DateTime(2022, 12, 20), ReadTime = "7 دقائق", Views = 930,
                AuthorName = "ريم أشرف", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Reem+Ashraf&background=EC4899&color=fff",
                Tags = new List<string>{"تسويق", "كتابة"}
            },
            new Blog { Id = 19, Title = "إطلاق العنان لإبداعك باستخدام أدوات التصميم المجانية",
                Summary = "قائمة بأفضل 10 بدائل مجانية لبرنامج Photoshop و Illustrator للمصممين المبتدئين والمحترفين.",
                Content = "<p>تعرف على Figma, GIMP, Inkscape وغيرها من الأدوات التي تمكنك من التصميم دون تكاليف باهظة.</p>",
                Category = "تصميم", ImageUrl = "https://images.unsplash.com/photo-1561070791-2526d30994b5?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                Date = new DateTime(2022, 12, 10), ReadTime = "5 دقائق", Views = 680,
                AuthorName = "سارة أحمد", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Sara+Ahmed&background=8B5CF6&color=fff",
                Tags = new List<string>{"تصميم", "أدوات"}
            },
            new Blog { Id = 20, Title = "كيف تختار مسارك المهني في تكنولوجيا المعلومات؟",
                Summary = "دليل إرشادي لمساعدتك في اختيار تخصصك التقني المناسب بناءً على مهاراتك وشغفك وفرص السوق.",
                Content = "<p>نقارن بين تطوير الويب، تحليل البيانات، الأمن السيبراني، والشبكات لمساعدتك في اتخاذ القرار الصحيح.</p>",
                Category = "تقنية", ImageUrl = "https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                Date = new DateTime(2022, 11, 25), ReadTime = "10 دقائق", Views = 2890,
                AuthorName = "د. نادر فؤاد", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Nader+F&background=DB2777&color=fff",
                Tags = new List<string>{"تقنية", "وظائف"}
            },
            new Blog { Id = 21, Title = "مقدمة في تعلم الآلة Machine Learning دون كود",
                Summary = "استخدم منصات AutoML لتدريب نماذج ذكاء اصطناعي دون كتابة سطر برمجي واحد.",
                Content = "<p>منصات مثل Google AutoML تجعل تعلم الآلة متاحاً للجميع. جرب تدريب نموذج يتعرف على الصور بنفسك.</p>",
                Category = "تقنية", ImageUrl = "https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                Date = new DateTime(2022, 11, 10), ReadTime = "6 دقائق", Views = 1450,
                AuthorName = "م. ليلى جمال", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Laila+J&background=4F46E5&color=fff",
                Tags = new List<string>{"ذكاء اصطناعي", "تعلم آلة"}
            },
  new Blog { Id = 22, Title = "كيف تبني نظام مصادقة آمن باستخدام JWT و ASP.NET Core",
        Summary = "دليل خطوة بخطوة لتنفيذ JSON Web Tokens في تطبيقات الويب، مع شرح كامل للتوقيع والتجديد وحماية المسارات.",
        Content = @"<p>يُعد JWT من أكثر الطرق شيوعاً لإدارة المصادقة في الـ APIs الحديثة. في هذا الدليل سنتعلم:</p>
        <ol><li>إنشاء الـ Token مع تضمين Claims مخصصة.</li>
        <li>تكوين الـ Middleware للتحقق من التوكين.</li>
        <li>تطبيق Refresh Tokens لتجديد الجلسة تلقائياً.</li>
        <li>تأمين المسارات باستخدام Policies.</li>
        <li>التعامل مع انتهاء الصلاحية والأخطاء الشائعة.</li></ol>
        <p>كل ذلك مع كود كامل ومشروع جاهز للتحميل.</p>",
        Category = "برمجة", ImageUrl = "https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
        Date = new DateTime(2023, 7, 1), ReadTime = "14 دقيقة", Views = 1750,
        AuthorName = "د. نادر فؤاد", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Nader+F&background=DB2777&color=fff",
        Tags = new List<string>{"برمجة", "أمان"}
    },
    new Blog { Id = 23, Title = "الدليل الكامل لتحسين تجربة المستخدم في تطبيقات الموبايل",
        Summary = "من تحليل سلوك المستخدم إلى اختبارات A/B وتقليل زمن التحميل، كل ما تحتاجه لتطبيق يبقي المستخدمين سعداء.",
        Content = @"<p>UX في الموبايل يختلف عن الويب. نغطي في هذا المقال:</p>
        <ul><li>مبادئ التصميم للشاشات الصغيرة.</li>
        <li>أهمية سرعة الأداء: كيف تقلل زمن التحميل إلى أقل من ثانيتين.</li>
        <li>اختبارات A/B لتحسين نقاط التفاعل.</li>
        <li>تحليل الخرائط الحرارية وسلوك المستخدم.</li>
        <li>دمج التعليقات داخل التطبيق بذكاء.</li></ul>
        <p>مع استراتيجيات عملية تزيد من معدل الاحتفاظ بالمستخدمين بنسبة 40%.</p>",
        Category = "تصميم", ImageUrl = "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
        Date = new DateTime(2023, 7, 5), ReadTime = "11 دقيقة", Views = 1340,
        AuthorName = "سارة أحمد", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Sara+Ahmed&background=8B5CF6&color=fff",
        Tags = new List<string>{"تصميم", "UX"}
    },
    new Blog { Id = 24, Title = "البيانات الضخمة وتحليلات الأعمال: كيف تستفيد منها؟",
        Summary = "مدخل عملي لفهم Big Data وأدوات مثل Hadoop و Spark، مع أمثلة من قطاعات المال والصحة والتجارة.",
        Content = @"<p>لم تعد البيانات الضخمة حكراً على الشركات الكبرى. في هذا الشرح:</p>
        <ol><li>ما هي الـ 5Vs للبيانات الضخمة.</li>
        <li>مقارنة بين Hadoop و Apache Spark.</li>
        <li>بناء Pipeline تحليل بيانات بسيط باستخدام Python و PySpark.</li>
        <li>حالات استخدام حقيقية: التنبؤ بالمبيعات، كشف الاحتيال، والتوصيات.</li></ol>
        <p>ابدأ اليوم واستخرج قيمة من بياناتك حتى لو كنت مبتدئاً.</p>",
        Category = "تقنية", ImageUrl = "https://images.unsplash.com/photo-1551288049-bebda4e38f71?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
        Date = new DateTime(2023, 7, 10), ReadTime = "16 دقيقة", Views = 980,
        AuthorName = "خالد محمود", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Khaled+M&background=10B981&color=fff",
        Tags = new List<string>{"تقنية", "بيانات"}
    },
    new Blog { Id = 25, Title = "تحويل فكرتك إلى شركة ناشئة: الدليل العملي للـ MVP",
        Summary = "تعلم كيف تبني منتجك الأدنى قابل للتطبيق بسرعة وبتكلفة منخفضة، مع نصائح من خبراء وادي السيليكون.",
        Content = @"<p>الـ MVP هو مفتاح النجاح للشركات الناشئة. نناقش:</p>
        <ul><li>تحديد المشكلة الأساسية التي تحلها.</li>
        <li>تقسيم الميزات إلى Must-have و Nice-to-have.</li>
        <li>اختيار التقنية المناسبة للبناء السريع (مثل No-code).</li>
        <li>اختبار الفرضيات مع مستخدمين حقيقيين.</li>
        <li>قياس النجاح باستخدام مقاييس مثل North Star Metric.</li></ul>
        <p>قصص نجاح مثل Dropbox و Airbnb بدأت بـ MVP بسيط جداً.</p>",
        Category = "أعمال", ImageUrl = "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
        Date = new DateTime(2023, 7, 12), ReadTime = "13 دقيقة", Views = 2100,
        AuthorName = "منى عادل", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Mona+Adel&background=F59E0B&color=fff",
        Tags = new List<string>{"أعمال", "شركات ناشئة"}
    },
    new Blog { Id = 26, Title = "أدوات المطور الأساسية التي لا يستغني عنها المحترفون",
        Summary = "قائمة بأهم 15 أداة وبرنامج يستخدمها كبار المطورين يومياً، من VS Code إلى Postman و Docker.",
        Content = @"<p>احصل على إعدادات البيئة المثالية للإنتاجية:</p>
        <ol><li>VS Code مع أفضل الإضافات (Live Share, Prettier, GitLens).</li>
        <li>Git و GitHub للتحكم بالنسخ.</li>
        <li>Postman لاختبار الـ APIs.</li>
        <li>Docker لحاويات التطوير.</li>
        <li>Figma للتعاون في التصميم.</li>
        <li>Terminal متطور مثل Oh My Zsh.</li>
        <li>Slack/Discord للتواصل.</li>
        <li>Notion لتنظيم المهام.</li></ol>
        <p>استثمر في إتقان هذه الأدوات وستوفر ساعات أسبوعياً.</p>",
        Category = "برمجة", ImageUrl = "https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
        Date = new DateTime(2023, 7, 15), ReadTime = "9 دقائق", Views = 1560,
        AuthorName = "أحمد سامي", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Ahmed+Sami&background=0D8ABC&color=fff",
        Tags = new List<string>{"برمجة", "أدوات"}
    },
    new Blog { Id = 27, Title = "التسويق عبر البريد الإلكتروني: استراتيجيات لا تزال فعالة في 2023",
        Summary = "كيف تبني قائمة بريدية متفاعلة وتصمم حملات تحقق مبيعات حقيقية دون أن تُرسل رسائل مزعجة.",
        Content = @"<p>البريد الإلكتروني ليس قديماً، بل يحقق أعلى عائد استثمار في التسويق الرقمي. نكشف:</p>
        <ul><li>طرق جمع المشتركين بطريقة أخلاقية.</li>
        <li>كتابة عنوان بريد يجذب الفتح.</li>
        <li>تقسيم القوائم وتخصيص المحتوى.</li>
        <li>أتمتة الرسائل بناءً على سلوك المستخدم.</li>
        <li>تحليل النتائج وتحسين الحملات.</li></ul>
        <p>أرقام وإحصاءات تثبت أن البريد الإلكتروني لا يزال ملكاً.</p>",
        Category = "تسويق", ImageUrl = "https://images.unsplash.com/photo-1455390582262-044cdead277a?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
        Date = new DateTime(2023, 7, 18), ReadTime = "10 دقائق", Views = 890,
        AuthorName = "ريم أشرف", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Reem+Ashraf&background=EC4899&color=fff",
        Tags = new List<string>{"تسويق", "بريد إلكتروني"}
    },
    new Blog { Id = 28, Title = "مقدمة في إنترنت الأشياء IoT: من الفكرة إلى التنفيذ",
        Summary = "كيف تبدأ مشروع IoT باستخدام Raspberry Pi و Arduino، مع أمثلة عملية على المنازل الذكية والزراعة.",
        Content = @"<p>IoT يربط العالم المادي بالإنترنت. نتعلم:</p>
        <ol><li>الفرق بين Raspberry Pi و Arduino ومتى تستخدم كل منهما.</li>
        <li>توصيل الحساسات (حرارة، رطوبة، حركة) وقراءة البيانات.</li>
        <li>إرسال البيانات إلى السحابة باستخدام MQTT.</li>
        <li>بناء Dashboard لعرض البيانات في الوقت الفعلي.</li>
        <li>مشروع عملي: نظام ري ذكي للنباتات.</li></ol>
        <p>الأجهزة المطلوبة والتكلفة التقريبية داخل المقال.</p>",
        Category = "تقنية", ImageUrl = "https://images.unsplash.com/photo-1518770660439-4636190af475?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
        Date = new DateTime(2023, 7, 20), ReadTime = "17 دقيقة", Views = 1230,
        AuthorName = "م. ليلى جمال", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Laila+J&background=4F46E5&color=fff",
        Tags = new List<string>{"تقنية", "IoT"}
    },
    new Blog { Id = 29, Title = "إدارة المشاريع البرمجية باستخدام Agile و Scrum",
        Summary = "شرح عملي لأفضل منهجيات تطوير البرمجيات الحديثة، مع أمثلة على تنظيم السبرنتات والوقفات اليومية.",
        Content = @"<p>Agile ليست مجرد كلمة رنانة. سنطبقها معاً:</p>
        <ul><li>تقسيم العمل إلى User Stories وتقديرها بنقاط القصة.</li>
        <li>تخطيط الـ Sprint لمدة أسبوعين.</li>
        <li>الوقفة اليومية Daily Scrum: كيفية إدارتها بفعالية.</li>
        <li>مراجعة السبرنت وجمع التعليقات.</li>
        <li>أدوات مثل Jira و Trello لتتبع المهام.</li></ul>
        <p>الفريق الذي يتبع Agile يزيد إنتاجيته بنسبة 30%.</p>",
        Category = "أعمال", ImageUrl = "https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
        Date = new DateTime(2023, 7, 22), ReadTime = "12 دقيقة", Views = 760,
        AuthorName = "د. نادر فؤاد", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Nader+F&background=DB2777&color=fff",
        Tags = new List<string>{"أعمال", "إدارة مشاريع"}
    },
    new Blog { Id = 30, Title = "البرمجة للأطفال: كيف تبدأ مع ابنك في سن مبكرة",
        Summary = "أفضل المنصات والألعاب التعليمية التي تعلم البرمجة للأطفال من سن 6 سنوات فما فوق، بطريقة ممتعة.",
        Content = @"<p>تعليم البرمجة للأطفال يبني تفكيراً منطقياً. هذه أفضل المصادر:</p>
        <ul><li><strong>Scratch</strong> – من MIT، مناسب من 6-12 سنة، يعتمد على السحب والإفلات.</li>
        <li><strong>Code.org</strong> – دروس تفاعلية بشخصيات محبوبة مثل Minecraft و Frozen.</li>
        <li><strong>LEGO Mindstorms</strong> – برمجة الروبوتات بشكل ملموس.</li>
        <li><strong>Swift Playgrounds</strong> – من آبل، لتعلم لغة Swift بألغاز.</li>
        <li>نصائح للآباء: كيف تجعل الجلسات قصيرة ومرحة، وتحتفل بالإنجازات الصغيرة.</li></ul>
        <p>طفلك قد يبني أول لعبة له بعد أسبوعين فقط.</p>",
        Category = "تعليم", ImageUrl = "https://images.unsplash.com/photo-1509062522246-3755977927d7?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
        Date = new DateTime(2023, 7, 25), ReadTime = "7 دقائق", Views = 1850,
        AuthorName = "فريق EduLab", AuthorAvatarUrl = "https://ui-avatars.com/api/?name=Edu+Lab&background=0F172A&color=fff",
        Tags = new List<string>{"تعليم", "برمجة"}
    }
};
    }
}
