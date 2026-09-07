using EduLab_Domain.Entities;

namespace EduLab_Seeder.Data
{
    /// <summary>
    /// Programmatically generates realistic Approved courses for instructors.
    /// Structure per course matches the MVC publish validation rules:
    ///   4 sections x 10 video lectures, exactly ONE free-preview section (5-10 videos),
    ///   >=3 Requirements, >=3 Learnings, Title/ShortDescription/Category/Thumbnail set,
    ///   every video Duration >= 60s.
    /// Ensures every course generated has a globally UNIQUE title and unique, tailored descriptions.
    /// </summary>
    internal static class CourseSeedData
    {
        public const int SectionsPerCourse = 4;
        public const int LecturesPerSection = 10;

        /// <summary>
        /// Global registry to guarantee 100% unique course titles across all instructors and categories.
        /// </summary>
        private static readonly HashSet<string> GlobalUsedTitles = new(StringComparer.OrdinalIgnoreCase);

        /// <summary>
        /// Maps an instructor's subject keywords to an existing category English name.
        /// Falls back to "Programming".
        /// </summary>
        private static readonly Dictionary<string, string> SubjectToCategory = new(StringComparer.OrdinalIgnoreCase)
        {
            ["C#"] = "Programming",
            ["ASP.NET Core"] = "Programming",
            ["Python"] = "Programming",
            ["Django"] = "Programming",
            ["FastAPI"] = "Programming",
            ["C Programming"] = "Programming",
            ["Scratch"] = "Programming",
            ["Kids Coding"] = "Programming",
            ["Automation"] = "Programming",
            ["JavaScript"] = "Web Development",
            ["React"] = "Web Development",
            ["Angular"] = "Web Development",
            ["Vue.js"] = "Web Development",
            ["Node.js"] = "Web Development",
            ["HTML"] = "Web Development",
            ["CSS"] = "Web Development",
            ["PHP"] = "Web Development",
            ["Laravel"] = "Web Development",
            ["Backend"] = "Web Development",
            ["APIs"] = "Web Development",
            ["Clean Architecture"] = "Software Engineering",
            ["OOP"] = "Software Engineering",
            ["Software Engineering"] = "Software Engineering",
            ["Flutter"] = "Mobile Development",
            ["Dart"] = "Mobile Development",
            ["Android"] = "Mobile Development",
            ["Kotlin"] = "Mobile Development",
            ["Apple"] = "Mobile Development",
            ["Unity"] = "Game Development",
            ["2D Games"] = "Game Development",
            ["Unreal Engine"] = "Game Development",
            ["Blender"] = "Game Development",
            ["3D Design"] = "Game Development",
            ["Game Design"] = "Game Development",
            ["Game Development"] = "Game Development",
            ["DevOps"] = "DevOps",
            ["CI/CD"] = "DevOps",
            ["Kubernetes"] = "DevOps",
            ["Data Science"] = "Data Science",
            ["Statistics"] = "Data Science",
            ["Data Analysis"] = "Data Analysis",
            ["Power BI"] = "Data Analysis",
            ["Excel"] = "Data Analysis",
            ["Machine Learning"] = "Machine Learning",
            ["AI"] = "Artificial Intelligence",
            ["Deep Learning"] = "Artificial Intelligence",
            ["NLP"] = "Artificial Intelligence",
            ["AI Basics"] = "Artificial Intelligence",
            ["SQL Server"] = "Databases",
            ["PostgreSQL"] = "Databases",
            ["SQL"] = "Databases",
            ["Databases"] = "Databases",
            ["Database Design"] = "Databases",
            ["DB Admin"] = "Databases",
            ["Cyber Security"] = "Cyber Security",
            ["Penetration Testing"] = "Cyber Security",
            ["Network Security"] = "Cyber Security",
            ["Reverse Engineering"] = "Cyber Security",
            ["Malware Analysis"] = "Cyber Security",
            ["Security"] = "Cyber Security",
            ["Networking"] = "Networking",
            ["CCNA"] = "Networking",
            ["CCNP"] = "Networking",
            ["AWS"] = "Cloud Computing",
            ["Azure"] = "Cloud Computing",
            ["Cloud Computing"] = "Cloud Computing",
            ["Cloud Architecture"] = "Cloud Computing",
            ["Business"] = "Business",
            ["HR"] = "Business",
            ["Recruitment"] = "Business",
            ["Entrepreneurship"] = "Entrepreneurship",
            ["Creativity"] = "Entrepreneurship",
            ["Startups"] = "Entrepreneurship",
            ["Business Model"] = "Entrepreneurship",
            ["E-commerce"] = "Business",
            ["Project Management"] = "Project Management",
            ["CAPM"] = "Project Management",
            ["Sales"] = "Sales",
            ["Marketing"] = "Marketing",
            ["Digital Marketing"] = "Digital Marketing",
            ["SEO"] = "Digital Marketing",
            ["Google Ads"] = "Digital Marketing",
            ["Content Strategy"] = "Digital Marketing",
            ["Social Media"] = "Digital Marketing",
            ["Copywriting"] = "Content Writing",
            ["Content Writing"] = "Content Writing",
            ["Creative Writing"] = "Content Writing",
            ["Storytelling"] = "Content Writing",
            ["Finance"] = "Finance & Accounting",
            ["Investing"] = "Investing",
            ["Financial Analysis"] = "Finance & Accounting",
            ["Personal Finance"] = "Finance & Accounting",
            ["Budgeting"] = "Finance & Accounting",
            ["Financial Planning"] = "Finance & Accounting",
            ["Stock Market"] = "Investing",
            ["Real Estate"] = "Investing",
            ["Crypto"] = "Investing",
            ["Technical Analysis"] = "Investing",
            ["Accounting"] = "Finance & Accounting",
            ["QuickBooks"] = "Finance & Accounting",
            ["Office Productivity"] = "Office Productivity",
            ["Personal Development"] = "Personal Development",
            ["Time Management"] = "Personal Development",
            ["Productivity"] = "Personal Development",
            ["Leadership"] = "Leadership",
            ["Team Building"] = "Leadership",
            ["Coaching"] = "Leadership",
            ["Public Speaking"] = "Communication",
            ["Presentation"] = "Communication",
            ["Communication"] = "Communication",
            ["Interviews"] = "Communication",
            ["Soft Skills"] = "Communication",
            ["Negotiation"] = "Negotiation",
            ["Design"] = "Design",
            ["Design Thinking"] = "Design",
            ["Graphic Design"] = "Graphic Design",
            ["Photoshop"] = "Graphic Design",
            ["Illustrator"] = "Graphic Design",
            ["Branding"] = "Graphic Design",
            ["Digital Art"] = "Graphic Design",
            ["Illustration"] = "Graphic Design",
            ["UI/UX"] = "UI/UX Design",
            ["UX Research"] = "UI/UX Design",
            ["Product Design"] = "UI/UX Design",
            ["Figma"] = "UI/UX Design",
            ["AutoCAD"] = "Design",
            ["Interior Design"] = "Design",
            ["Decoration"] = "Design",
            ["Fashion"] = "Fashion",
            ["Fashion Design"] = "Fashion",
            ["Styling"] = "Fashion",
            ["Sewing"] = "Fashion",
            ["Cooking"] = "Cooking",
            ["Culinary"] = "Cooking",
            ["Pastry"] = "Cooking",
            ["Middle Eastern Cuisine"] = "Cooking",
            ["Health & Fitness"] = "Health & Fitness",
            ["Fitness"] = "Health & Fitness",
            ["Home Workout"] = "Health & Fitness",
            ["Nutrition"] = "Nutrition",
            ["Sports Nutrition"] = "Nutrition",
            ["Healthy Habits"] = "Nutrition",
            ["Sports"] = "Sports",
            ["Lifestyle"] = "Lifestyle",
            ["Photography"] = "Photography & Video",
            ["Mobile Photography"] = "Photography & Video",
            ["Video Editing"] = "Photography & Video",
            ["Lightroom"] = "Photography & Video",
            ["Media"] = "Photography & Video",
            ["Music"] = "Music",
            ["Piano"] = "Music",
            ["Guitar"] = "Music",
            ["Music Theory"] = "Music",
            ["Teaching"] = "Teaching & Academics",
            ["Education"] = "Teaching & Academics",
            ["Teaching & Academics"] = "Teaching & Academics",
            ["Math"] = "Math",
            ["Mental Math"] = "Math",
            ["Numbers"] = "Math",
            ["Physics"] = "Physics",
            ["Chemistry"] = "Chemistry",
            ["Medicine"] = "Medicine",
            ["Engineering"] = "Engineering",
            ["Law"] = "Law",
            ["Legal Writing"] = "Law",
            ["Psychology"] = "Psychology",
            ["Personality"] = "Psychology",
            ["History"] = "History",
            ["Geography"] = "Geography",
            ["English"] = "English Language",
            ["IELTS"] = "English Language",
            ["TOEFL"] = "English Language",
            ["English Conversation"] = "English Language",
            ["Translation"] = "Languages",
            ["Interpretation"] = "Languages",
            ["Languages"] = "Languages",
            ["Chinese"] = "Languages",
            ["French"] = "Languages",
            ["Arabic"] = "Arabic Language",
            ["Arabic Language"] = "Arabic Language",
            ["Writing"] = "Arabic Language",
            ["Professional Training"] = "Professional Training"
        };

        public static Category PickCategory(List<Category> categories, ApplicationUser instructor)
        {
            foreach (var subject in instructor.Subjects)
            {
                if (SubjectToCategory.TryGetValue(subject, out var categoryName))
                {
                    var match = categories.FirstOrDefault(c =>
                        string.Equals(c.Category_EnglishName, categoryName, StringComparison.OrdinalIgnoreCase));
                    if (match != null) return match;
                }
            }
            return categories.First(c => c.Category_EnglishName == "Programming");
        }

        /// <summary>
        /// Generates courses (with sections & lectures attached) for a single instructor.
        /// </summary>
        public static List<Course> GenerateForInstructor(
            ApplicationUser instructor, Category category, int courseCount, Random rng)
        {
            var isEnglish = instructor.PreferredLanguage == "en";
            var courses = new List<Course>();

            for (var i = 0; i < courseCount; i++)
            {
                var course = BuildCourse(instructor, category, i, isEnglish, rng);
                BuildSections(course, isEnglish, rng, i);
                courses.Add(course);
            }

            return courses;
        }

        private static Course BuildCourse(
            ApplicationUser instructor, Category category, int index, bool isEnglish, Random rng)
        {
            var catName = isEnglish
                ? category.Category_EnglishName ?? category.Category_Name
                : category.Category_Name;

            // Pick specific subject from instructor's expertise
            var subject = instructor.Subjects != null && instructor.Subjects.Count > 0
                ? instructor.Subjects[index % instructor.Subjects.Count]
                : catName;

            var level = (isEnglish
                ? new[] { "Beginner", "Intermediate", "Advanced", "All Levels" }
                : new[] { "مبتدئ", "متوسط", "متقدم", "جميع المستويات" })[rng.Next(0, 4)];

            var title = GenerateUniqueTitle(subject, catName, instructor, level, index, isEnglish, rng);
            var shortDesc = GenerateShortDescription(subject, catName, isEnglish, index, rng);
            var fullDesc = GenerateDescription(subject, catName, instructor, level, isEnglish, index, rng);

            var price = 149m + rng.Next(0, 60) * 10m + 0.99m;
            // Discount is a PERCENTAGE (0-100) as the app computes FinalPrice = Price - Price*Discount/100.
            var hasDiscount = rng.Next(0, 3) == 0; // ~33% of courses discounted
            var discount = hasDiscount ? (decimal?)rng.Next(10, 46) : null;
            var language = isEnglish ? "English" : "العربية";

            // Unique thumbnail per course: seed = instructor id + course index + slug.
            var thumbnailKey = Slugify($"{instructor.Id}-{index}-{title}");

            var requirements = isEnglish
                ? new List<string>
                {
                    $"A computer with internet access and dedication to learn {subject}",
                    $"Willingness to complete practical exercises and build real projects",
                    $"Basic computer literacy and enthusiasm for {catName}"
                }
                : new List<string>
                {
                    $"جهاز كمبيوتر متصل بالإنترنت ورغبة جادة في تعلم {subject} وتطبيقه عملياً",
                    $"الالتزام بتخصيص وقت للمشاهدة وبناء المشاريع التطبيقية أولاً بأول",
                    $"معرفة أساسية باستخدام الحاسوب وشغف بتطوير المهارات في {catName}"
                };

            var learnings = isEnglish
                ? new List<string>
                {
                    $"Master core principles and modern workflows in {subject}",
                    $"Build production-ready, portfolio-worthy projects from scratch",
                    $"Apply industry best practices, clean design, and performance optimizations",
                    $"Gain the confidence to pass technical interviews and solve real-world challenges"
                }
                : new List<string>
                {
                    $"إتقان المفاهيم الجوهرية وأحدث التقنيات العملية في {subject}",
                    $"بناء مشاريع متكاملة قابلة للإضافة إلى معرض أعمالك المهني",
                    $"تطبيق أفضل الممارسات والمعايير المهنية لتجنب الأخطاء الشائعة",
                    $"اكتساب الثقة والمهارات اللازمة لسوق العمل واجتياز المقابلات الوظيفية"
                };

            var targetAudience = isEnglish
                ? $"Aspiring and current professionals seeking practical, industry-grade expertise in {subject}."
                : $"المهتمون بتعلم {subject} من المبتدئين والمحترفين الراغبين في تعزيز مهاراتهم العملية لسوق العمل.";

            return new Course
            {
                Title = title,
                ShortDescription = shortDesc,
                Description = fullDesc,
                Price = price,
                Discount = discount,
                ThumbnailUrl = $"https://picsum.photos/seed/{thumbnailKey}/640/360",
                CreatedAt = DateTime.UtcNow,
                InstructorId = instructor.Id,
                CategoryId = category.Category_Id,
                Level = level,
                Language = language,
                HasCertificate = true,
                Requirements = requirements,
                Learnings = learnings,
                TargetAudience = targetAudience,
                Status = Coursestatus.Approved
            };
        }

        private static string GenerateUniqueTitle(
            string subject, string catName, ApplicationUser instructor, string level, int index, bool isEnglish, Random rng)
        {
            var enTemplates = new[]
            {
                $"{subject}: From Zero to Mastery",
                $"The Complete {subject} Masterclass",
                $"Professional {subject} & Modern Architecture",
                $"Hands-On {subject}: Real-World Projects",
                $"Mastering {subject}: Step by Step",
                $"Complete {subject} Bootcamp for Beginners",
                $"Advanced {subject} & Best Industry Practices",
                $"Accelerated {subject}: Practical Career Roadmap",
                $"{subject} in Practice: Deep Dive & Architecture",
                $"Building Scalable Solutions with {subject}",
                $"The Ultimate {subject} Guide: Zero to Production",
                $"{subject} Essentials & High-Performance Engineering",
                $"Practical {subject} for Modern Developers",
                $"Comprehensive {subject}: Design, Build & Deploy",
                $"{subject} Case Studies & Real-World Implementation"
            };

            var arTemplates = new[]
            {
                $"الدورة الشاملة في {subject}: من الصفر إلى الاحتراف",
                $"ماستركلاس {subject}: دليلك العملي المتكامل",
                $"احتراف {subject} المتقدم وأفضل الممارسات",
                $"مشاريع عملية متكاملة باستخدام {subject}",
                $"{subject} للمبتدئين: خطوة بخطوة حتى الإتقان",
                $"بناء وتطوير أنظمة حقيقية باستخدام {subject}",
                $"أسرار وتقنيات {subject} لسوق العمل الحديث",
                $"{subject} المكثف: من الأساسيات إلى بيئة الإنتاج",
                $"التطبيق العملي وحل المشكلات في {subject}",
                $"المسار المهني الكامل لإتقان {subject}",
                $"أساسيات وتطبيقات {subject} الحديثة",
                $"المرجع الشامل في {subject} للمطورين والمحترفين",
                $"هندسة الحلول المتقدمة باستخدام {subject}",
                $"{subject} بالتطبيق العملي والمشاريع الواقعية",
                $"ورشة عمل متقدمة في {subject} وبناء سابقة الأعمال"
            };

            var pool = isEnglish ? enTemplates : arTemplates;
            var baseTitle = pool[(index + Math.Abs(instructor.FullName?.GetHashCode() ?? 0)) % pool.Length];

            // If collision occurs, disambiguate with clean variations
            var title = baseTitle;
            var attempt = 1;
            while (GlobalUsedTitles.Contains(title))
            {
                attempt++;
                if (isEnglish)
                {
                    title = attempt switch
                    {
                        2 => $"{baseTitle} — {level} Edition",
                        3 => $"{baseTitle} (Comprehensive Masterclass)",
                        4 => $"{baseTitle} - with {instructor.FullName}",
                        5 => $"{baseTitle} [Advanced Projects]",
                        _ => $"{baseTitle} — Part {attempt}"
                    };
                }
                else
                {
                    title = attempt switch
                    {
                        2 => $"{baseTitle} — إصدار {level}",
                        3 => $"{baseTitle} (المسار الاحترافي)",
                        4 => $"{baseTitle} - مع {instructor.FullName}",
                        5 => $"{baseTitle} [مشاريع متقدمة]",
                        _ => $"{baseTitle} — الجزء {attempt}"
                    };
                }
            }

            GlobalUsedTitles.Add(title);
            return title;
        }

        private static string GenerateShortDescription(
            string subject, string catName, bool isEnglish, int index, Random rng)
        {
            var enTemplates = new[]
            {
                $"A comprehensive, project-driven course designed to help you master {subject} and build industry-ready skills.",
                $"Learn {subject} step-by-step through clear explanations, hands-on exercises, and real-world implementation.",
                $"Gain practical experience with {subject}, exploring modern tools, architectural best practices, and clean code.",
                $"An intensive masterclass in {subject} tailored for professionals who want to accelerate their career and practical expertise.",
                $"Master core concepts and advanced features in {subject} while building production-grade projects from scratch.",
                $"A practical deep-dive into {subject} featuring commercial case studies, interactive assignments, and portfolio building.",
                $"Accelerate your journey in {subject} with guided walkthroughs, real-world examples, and expert problem-solving strategies.",
                $"From fundamentals to advanced concepts, explore {subject} with practical exercises and production-ready architectures."
            };

            var arTemplates = new[]
            {
                $"دورة تدريبية متكاملة لتعلم {subject} بأسلوب عملي شيق يركز على التطبيق المباشر وبناء مشاريع واقعية تلائم متطلبات سوق العمل.",
                $"تعلم أهم مبادئ وتقنيات {subject} واكتسب المهارات المطلوبة لسوق العمل مع تمارين عملية وتوجيه مستمر خطوة بخطوة.",
                $"دليلك السريع والمنظم لإتقان {subject}، يشمل شروحات مبسطة وتطبيقات عملية لبناء سابقة أعمال قوية تبرز مهاراتك.",
                $"مسار تطبيقي مميز يجمع بين المفاهيم الجوهرية في {subject} والتطبيق الفعلي عبر نماذج وحالات دراسية حديثة.",
                $"اكتشف أسرار وأفضل ممارسات {subject} وكيفية توظيفها في إنجاز مشاريع احترافية بكفاءة وثقة عالية.",
                $"تعلم {subject} من منظور عملي واحترافي يساعدك على اجتياز مقابلات العمل وبناء حلول برمجية وتقنية متقدمة.",
                $"تدريب مكثف في {subject} يركز على حل المشكلات الحقيقية وكتابة كود نظيف وتصميم بنية قابلة للتوسع.",
                $"اكتسب خبرة عملية مباشرة في {subject} من خلال بناء تطبيقات تفاعلية متكاملة وشروحات تفصيلية لأدق التفاصيل."
            };

            var pool = isEnglish ? enTemplates : arTemplates;
            return pool[index % pool.Length];
        }

        private static string GenerateDescription(
            string subject, string catName, ApplicationUser instructor, string level, bool isEnglish, int index, Random rng)
        {
            if (isEnglish)
            {
                var intros = new[]
                {
                    $"Welcome to the comprehensive masterclass on {subject}, curated for students and professionals passionate about {catName}. Whether you are just getting started or seeking to refine your professional edge, this course provides a structured, rigorous path forward.",
                    $"Step into the world of modern {subject} with this thorough, hands-on training program. Designed to bridge the gap between abstract theory and commercial industry demands, this course emphasizes real-world applications within {catName}.",
                    $"In today's fast-moving industry, mastering {subject} is an invaluable advantage. This course delivers deep architectural understanding, practical development patterns, and production-tested methodologies tailored for ambitious learners.",
                    $"Explore the full spectrum of {subject} from the ground up. This course combines interactive demonstrations, clear breakdowns of complex ideas, and practical exercises that reinforce every concept covered."
                };

                var bodies = new[]
                {
                    $"Throughout the lessons, you will build robust, scalable projects step-by-step. We delve into core foundations, environment configuration, modern design patterns, and debugging strategies. Each section is reinforced with downloadable resources, real code examples, and actionable assignments.",
                    $"We will examine practical case studies and tackle common pitfalls that developers encounter in production. You will learn how to write maintainable, clean code, optimize runtime performance, and adhere to industry standards and security best practices.",
                    $"The curriculum is carefully scaffolded: beginning with fundamental mechanics, progressing through intermediate architecture, and culminating in advanced capstone implementations that prove your competence."
                };

                var conclusions = new[]
                {
                    $"By the end of this course, you will possess a battle-tested understanding of {subject}, a portfolio of tangible projects, and an accredited Certificate of Completion to showcase to prospective employers.",
                    $"Enroll today to transform your skills in {subject} and join thousands of motivated students on EduLab taking their careers to the next level!",
                    $"Gain the confidence to architect, implement, and maintain production-ready solutions using {subject}, fully equipped with industry best practices and a verified completion credential."
                };

                var p1 = intros[(index + 0) % intros.Length];
                var p2 = bodies[(index + 1) % bodies.Length];
                var p3 = conclusions[(index + 2) % conclusions.Length];
                return $"{p1}\n\n{p2}\n\n{p3}";
            }
            else
            {
                var intros = new[]
                {
                    $"مرحباً بك في هذا المسار التدريبي المتكامل لتعلم {subject} ضمن تخصص {catName}. تم إعداد هذه الدورة بعناية فائقة لتجمع بين الفهم النظري العميق والتطبيق العملي المباشر الذي يؤهلك للتميز في سوق العمل.",
                    $"انطلق في رحلة تعليمية وتطبيقية مميزة لإتقان {subject}. سواء كنت في بداية مسيرتك أو ترغب في صقل مهاراتك والوصول إلى مستوى الاحتراف، ستجد هنا منهجاً تدريبياً متدرجاً يغطي أدق التفاصيل.",
                    $"يعد {subject} من أهم المهارات والتقنيات المطلوبة حالياً في مجالات {catName}. تركز هذه الدورة على تزويدك بالخبرة العملية الحقيقية التي تبحث عنها الشركات وأصحاب المشاريع.",
                    $"دليل عملي وتطبيقي شامل يأخذك في جولة مفصلة داخل {subject}. ستتعلم كيفية التفكير المنطقي وحل المشكلات المعقدة بأسلوب مبسط وممتع بعيداً عن التعقيد."
                };

                var bodies = new[]
                {
                    $"خلال مسار الكورس، ستقوم ببناء وتطوير مشاريع حقيقية من الصفر خطوة بخطوة. سنناقش بالتفصيل إعداد بيئة العمل، المعمارية النظيفة، تحسين الأداء، وتفادي الأخطاء البرمجية والتقنية الشائعة في بيئات الإنتاج الفعلية.",
                    $"يتميز المحتوى بالتركيز على أفضل الممارسات والمعايير العالمية. ستتعامل مع حالات دراسية من واقع السوق وتتعلم كيفية كتابة كود نظيف وقابل للصيانة والتوسع بسهولة.",
                    $"تم تنظيم المنهج وفق خطة محكمة: نبدأ بالأساسيات والمفاهيم الجوهرية، ثم نتدرج نحو المستويات المتوسطة والمتقدمة، ونختتم بمشروع عملي متكامل يرسخ كل ما تعلمته."
                };

                var conclusions = new[]
                {
                    $"بنهاية هذه الدورة، ستكون قد بنيت سابقة أعمال قوية تثبت كفاءتك في {subject}، وستحصل على شهادة إتمام معتمدة من EduLab تعزز سيرتك الذاتية في سوق العمل.",
                    $"انضم الآن إلى آلاف الطلاب والمهنيين على منصة EduLab، وابدأ خطوتك القادمة بثقة نحو احتراف {subject} وتحقيق أهدافك المهنية!",
                    $"ستكتسب الثقة التامة للعمل في مشاريع كبرى وتطوير حلول احترافية متكاملة باستخدام {subject} مع الالتزام بأعلى معايير الجودة."
                };

                var p1 = intros[(index + 0) % intros.Length];
                var p2 = bodies[(index + 1) % bodies.Length];
                var p3 = conclusions[(index + 2) % conclusions.Length];
                return $"{p1}\n\n{p2}\n\n{p3}";
            }
        }

        private static void BuildSections(Course course, bool isEnglish, Random rng, int courseIndex)
        {
            var sectionTitles = isEnglish
                ? new[] { "Introduction & Getting Started", "Core Fundamentals", "Hands-On Application", "Final Capstone Project" }
                : new[] { "مقدمة وبداية المسار", "الأساسيات الجوهرية", "التطبيق العملي", "المشروع الختامي" };

            // Rotate the preview pool start so different courses have different previews,
            // while keeping all 10 preview videos distinct from each other (pool has 12).
            var previewStart = courseIndex % 3;

            for (var s = 0; s < SectionsPerCourse; s++)
            {
                var isFree = s == 0; // exactly one free-preview section
                var section = new Section
                {
                    Title = sectionTitles[s],
                    Order = s + 1,
                    CourseId = course.Id,
                    IsFreePreview = isFree,
                    Lectures = new List<Lecture>()
                };

                for (var l = 0; l < LecturesPerSection; l++)
                {
                    var lectureIndex = courseIndex * SectionsPerCourse + s;

                    // Free-preview section: every video is a DIFFERENT url from the pool.
                    var video = isFree
                        ? VideoSeedData.Pool[(previewStart + l) % VideoSeedData.Pool.Length]
                        : VideoSeedData.Pool[(lectureIndex * LecturesPerSection + l) % VideoSeedData.Pool.Length];

                    section.Lectures.Add(new Lecture
                    {
                        Title = isEnglish
                            ? $"Lesson {l + 1}: {LectureTopic(isEnglish, s, l)}"
                            : $"الدرس {l + 1}: {LectureTopic(isEnglish, s, l)}",
                        VideoUrl = video.Url,
                        ContentType = ContentType.Video,
                        Duration = video.DurationSeconds - rng.Next(0, 45), // real duration, all >= 5 min
                        Order = l + 1,
                        IsFreePreview = isFree,
                        SectionId = section.Id
                    });
                }

                course.Sections ??= new List<Section>();
                course.Sections.Add(section);
            }

            course.Duration = course.Sections.Sum(s => s.Lectures.Sum(l => l.Duration));
        }

        private static string LectureTopic(bool isEnglish, int section, int lecture)
        {
            var topics = isEnglish
                ? new[]
                {
                    "Course overview and roadmap",
                    "Environment setup & essential tools",
                    "Core architectural concepts explained",
                    "Hands-on exercise & first implementation",
                    "Deep-dive into essential mechanisms",
                    "Building real-world components",
                    "Common pitfalls and how to avoid them",
                    "Optimization, security & performance",
                    "Testing, validation & deployment",
                    "Section wrap-up, recap & next steps"
                }
                : new[]
                {
                    "نظرة عامة على الكورس وخارطة الطريق",
                    "تجهيز بيئة العمل والأدوات الأساسية",
                    "شرح المفاهيم المعمارية والجوهرية",
                    "تطبيق عملي وتدريب تنفيذي أول",
                    "التعمق في الآليات والتقنيات الأساسية",
                    "بناء المكونات والمشاريع الفعلية",
                    "الأخطاء الشائعة وطرق تفاديها",
                    "تحسين الأداء والأمان وأفضل الممارسات",
                    "الاختبار والتحقق والإطلاق للإنتاج",
                    "مراجعة شاملة وخلاصة القسم والخطوات التالية"
                };

            var topic = topics[lecture % topics.Length];
            return topic;
        }

        private static string Slugify(string input)
        {
            var slug = string.Concat(input.Select(c => char.IsLetterOrDigit(c) || c == ' ' ? c : '-'));
            return string.Join("-", slug.Split(' ', StringSplitOptions.RemoveEmptyEntries)).ToLowerInvariant();
        }
    }
}
