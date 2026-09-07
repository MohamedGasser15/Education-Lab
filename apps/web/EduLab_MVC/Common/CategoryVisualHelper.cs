using System;

namespace EduLab_MVC.Common
{
    /// <summary>
    /// Central helper to provide icons, colors, backgrounds, text colors, and gradients
    /// for all categories in the system, matching CategorySeedData.
    /// </summary>
    public static class CategoryVisualHelper
    {
        /// <summary>
        /// Gets the FontAwesome icon class for a category.
        /// </summary>
        public static string GetCategoryIcon(string? categoryName)
        {
            if (string.IsNullOrWhiteSpace(categoryName))
                return "fa-folder";

            var lower = categoryName.Trim().ToLowerInvariant();

            // 1. Mobile Development
            if (lower.Contains("موبايل") || lower.Contains("mobile") || lower.Contains("أندرويد") || lower.Contains("android") || lower.Contains("ios") || lower.Contains("هاتف"))
                return "fa-mobile-alt";

            // 2. Web Development
            if (lower.Contains("تطوير الويب") || lower.Contains("web development") || lower.Contains("ويب") || lower.Contains("web dev"))
                return "fa-laptop-code";

            // 3. Game Development
            if (lower.Contains("ألعاب") || lower.Contains("العاب") || lower.Contains("game development") || lower.Contains("game dev") || lower.Contains("gaming"))
                return "fa-gamepad";

            // 4. Software Engineering
            if (lower.Contains("هندسة البرمجيات") || lower.Contains("software engineering"))
                return "fa-cogs";

            // 5. DevOps
            if (lower.Contains("devops") || lower.Contains("ديف اوبس"))
                return "fa-infinity";

            // 6. Data Science
            if (lower.Contains("علوم البيانات") || lower.Contains("data science"))
                return "fa-brain";

            // 7. Data Analysis
            if (lower.Contains("تحليل البيانات") || lower.Contains("data analysis") || lower.Contains("تحليل بيانات"))
                return "fa-chart-pie";

            // 8. Machine Learning
            if (lower.Contains("التعلم الآلي") || lower.Contains("تعلم آلي") || lower.Contains("machine learning"))
                return "fa-network-wired";

            // 9. Artificial Intelligence
            if (lower.Contains("ذكاء") || lower.Contains("اصطناعي") || lower.Contains("artificial intelligence") || lower.Contains("ai"))
                return "fa-robot";

            // 10. Databases
            if (lower.Contains("قواعد البيانات") || lower.Contains("قواعد بيانات") || lower.Contains("database") || lower.Contains("databases") || lower.Contains("sql") || lower.Contains("داتابيس"))
                return "fa-database";

            // 11. Cyber Security
            if (lower.Contains("أمن المعلومات") || lower.Contains("امن المعلومات") || lower.Contains("cyber security") || lower.Contains("cybersecurity") || lower.Contains("سايبر") || lower.Contains("أمن") || lower.Contains("امن") || lower.Contains("حماية") || lower.Contains("اختراق"))
                return "fa-shield-alt";

            // 12. Networking
            if (lower.Contains("الشبكات") || lower.Contains("شبكات") || lower.Contains("شبكة") || lower.Contains("networking") || lower.Contains("network"))
                return "fa-network-wired";

            // 13. Cloud Computing
            if (lower.Contains("الحوسبة السحابية") || lower.Contains("سحابي") || lower.Contains("سحابية") || lower.Contains("cloud computing") || lower.Contains("cloud"))
                return "fa-cloud";

            // 14. IT & Software
            if (lower.Contains("تقنية المعلومات") || lower.Contains("it & software") || lower.Contains("it &") || lower.Contains("information technology"))
                return "fa-server";

            // 15. General Programming / Languages
            if (lower.Contains("برمجة") || lower.Contains("programming") || lower.Contains("برمج") || lower.Contains("developer") || lower.Contains("جافا") || lower.Contains("java") || lower.Contains("بايثون") || lower.Contains("python"))
                return "fa-code";

            // 16. UI/UX Design
            if (lower.Contains("واجهات") || lower.Contains("واجهة") || lower.Contains("ui/ux") || lower.Contains("ui") || lower.Contains("ux") || lower.Contains("user interface"))
                return "fa-desktop";

            // 17. Graphic Design
            if (lower.Contains("تصميم الجرافيك") || lower.Contains("graphic design") || lower.Contains("جرافيك") || lower.Contains("فوتوشوب") || lower.Contains("photoshop") || lower.Contains("illustrator"))
                return "fa-paint-brush";

            // 18. Design Tools
            if (lower.Contains("نشر التصميم") || lower.Contains("أدوات التصميم") || lower.Contains("design tools"))
                return "fa-vector-square";

            // 19. General Design
            if (lower.Contains("تصميم") || lower.Contains("design") || lower.Contains("ديزاين") || lower.Contains("رسم") || lower.Contains("art") || lower.Contains("تشكيل"))
                return "fa-palette";

            // 20. Photography & Video
            if (lower.Contains("تصوير") || lower.Contains("photography") || lower.Contains("فوتوغرافي") || lower.Contains("كاميرا"))
                return "fa-camera";
            if (lower.Contains("فيديو") || lower.Contains("video") || lower.Contains("مونتاج") || lower.Contains("افتر") || lower.Contains("animation") || lower.Contains("متحركة"))
                return "fa-video";

            // 21. Entrepreneurship
            if (lower.Contains("ريادة الأعمال") || lower.Contains("ريادة أعمال") || lower.Contains("ريادة") || lower.Contains("entrepreneurship") || lower.Contains("startup"))
                return "fa-lightbulb";

            // 22. Project Management
            if (lower.Contains("إدارة المشاريع") || lower.Contains("ادارة المشاريع") || lower.Contains("إدارة مشاريع") || lower.Contains("project management") || lower.Contains("pmp"))
                return "fa-tasks";

            // 23. Sales
            if (lower.Contains("المبيعات") || lower.Contains("مبيعات") || lower.Contains("sales") || lower.Contains("بيع"))
                return "fa-funnel-dollar";

            // 24. Digital Marketing
            if (lower.Contains("التسويق الرقمي") || lower.Contains("تسويق رقمي") || lower.Contains("digital marketing") || lower.Contains("seo"))
                return "fa-ad";

            // 25. General Marketing
            if (lower.Contains("تسويق") || lower.Contains("marketing") || lower.Contains("إعلان") || lower.Contains("اعلان") || lower.Contains("ترويج"))
                return "fa-bullhorn";

            // 26. Finance & Accounting
            if (lower.Contains("المالية والمحاسبة") || lower.Contains("مالية") || lower.Contains("محاسبة") || lower.Contains("finance") || lower.Contains("accounting"))
                return "fa-calculator";

            // 27. Investing
            if (lower.Contains("الاستثمار") || lower.Contains("استثمار") || lower.Contains("investing") || lower.Contains("invest") || lower.Contains("بورصة") || lower.Contains("تداول") || lower.Contains("أسهم") || lower.Contains("crypto") || lower.Contains("عملات"))
                return "fa-chart-line";

            // 28. Office Productivity
            if (lower.Contains("إنتاجية المكتب") || lower.Contains("انتاجية المكتب") || lower.Contains("office productivity") || lower.Contains("إكسل") || lower.Contains("excel") || lower.Contains("word") || lower.Contains("أوفيس") || lower.Contains("office"))
                return "fa-file-excel";

            // 29. Personal Development
            if (lower.Contains("التنمية الشخصية") || lower.Contains("تنمية شخصية") || lower.Contains("personal development") || lower.Contains("تطوير ذاتي") || lower.Contains("تطوير الذات"))
                return "fa-user-graduate";

            // 30. Leadership
            if (lower.Contains("القيادة") || lower.Contains("قيادة") || lower.Contains("leadership"))
                return "fa-users";

            // 31. Communication
            if (lower.Contains("التواصل") || lower.Contains("تواصل") || lower.Contains("communication") || lower.Contains("اتصال"))
                return "fa-comments";

            // 32. Negotiation
            if (lower.Contains("التفاوض") || lower.Contains("تفاوض") || lower.Contains("negotiation") || lower.Contains("اقناع"))
                return "fa-handshake";

            // 33. General Business
            if (lower.Contains("أعمال") || lower.Contains("اعمال") || lower.Contains("business") || lower.Contains("إدارة") || lower.Contains("ادارة"))
                return "fa-briefcase";

            // 34. Lifestyle & Fashion
            if (lower.Contains("الموضة") || lower.Contains("موضة") || lower.Contains("fashion") || lower.Contains("أزياء"))
                return "fa-tshirt";
            if (lower.Contains("نمط الحياة") || lower.Contains("نمط حياة") || lower.Contains("lifestyle"))
                return "fa-sun";

            // 35. Cooking
            if (lower.Contains("طبخ") || lower.Contains("cooking") || lower.Contains("طهي") || lower.Contains("مطبخ") || lower.Contains("culinary"))
                return "fa-utensils";

            // 36. Health & Fitness
            if (lower.Contains("الصحة واللياقة") || lower.Contains("لياقة") || lower.Contains("fitness") || lower.Contains("جيم") || lower.Contains("رياضة بدنية"))
                return "fa-heartbeat";

            // 37. Nutrition
            if (lower.Contains("التغذية") || lower.Contains("تغذية") || lower.Contains("nutrition") || lower.Contains("دايت") || lower.Contains("رجيم"))
                return "fa-apple-alt";

            // 38. Sports
            if (lower.Contains("الرياضة") || lower.Contains("رياضة") || lower.Contains("sports") || lower.Contains("sport"))
                return "fa-running";

            // 39. Music
            if (lower.Contains("الموسيقى") || lower.Contains("موسيقى") || lower.Contains("music") || lower.Contains("غناء") || lower.Contains("عزف") || lower.Contains("بيانو"))
                return "fa-music";

            // 40. Teaching & Academics
            if (lower.Contains("التعليم والأكاديميات") || lower.Contains("تعليم") || lower.Contains("أكاديم") || lower.Contains("اكاديم") || lower.Contains("teaching") || lower.Contains("academics") || lower.Contains("تدريس"))
                return "fa-graduation-cap";

            // 41. Engineering
            if (lower.Contains("الهندسة") || lower.Contains("هندسة") || lower.Contains("engineering") || lower.Contains("مهندس") || lower.Contains("معماري") || lower.Contains("مدني"))
                return "fa-ruler-combined";

            // 42. Math
            if (lower.Contains("الرياضيات") || lower.Contains("رياضيات") || lower.Contains("math") || lower.Contains("حساب") || lower.Contains("جبر"))
                return "fa-square-root-alt";

            // 43. Physics
            if (lower.Contains("الفيزياء") || lower.Contains("فيزياء") || lower.Contains("physics"))
                return "fa-atom";

            // 44. Chemistry
            if (lower.Contains("الكيمياء") || lower.Contains("كيمياء") || lower.Contains("chemistry"))
                return "fa-flask";

            // 45. Medicine
            if (lower.Contains("الطب") || lower.Contains("طب") || lower.Contains("medicine") || lower.Contains("medical") || lower.Contains("صيدلة") || lower.Contains("علاج"))
                return "fa-stethoscope";

            // 46. Law
            if (lower.Contains("القانون") || lower.Contains("قانون") || lower.Contains("law") || lower.Contains("حقوق") || lower.Contains("محاماة") || lower.Contains("تشريع"))
                return "fa-gavel";

            // 47. Psychology
            if (lower.Contains("علم النفس") || lower.Contains("نفس") || lower.Contains("psychology") || lower.Contains("سيكولوجي"))
                return "fa-brain";

            // 48. History
            if (lower.Contains("التاريخ") || lower.Contains("تاريخ") || lower.Contains("history") || lower.Contains("حضار") || lower.Contains("آثار"))
                return "fa-landmark";

            // 49. Geography
            if (lower.Contains("الجغرافيا") || lower.Contains("جغرافيا") || lower.Contains("geography") || lower.Contains("خرائط") || lower.Contains("map") || lower.Contains("gis"))
                return "fa-globe-africa";

            // 50. English Language
            if (lower.Contains("الإنجليزية") || lower.Contains("الانجليزية") || lower.Contains("انجليزي") || lower.Contains("english"))
                return "fa-font";

            // 51. Arabic Language
            if (lower.Contains("العربية") || lower.Contains("عربي") || lower.Contains("arabic") || lower.Contains("نحو") || lower.Contains("بلاغة"))
                return "fa-pen-nib";

            // 52. Content Writing
            if (lower.Contains("كتابة المحتوى") || lower.Contains("صناعة المحتوى") || lower.Contains("content writing") || lower.Contains("كتابة") || lower.Contains("writing") || lower.Contains("تأليف"))
                return "fa-pen-fancy";

            // 53. Professional Training
            if (lower.Contains("التدريب المهني") || lower.Contains("تدريب مهني") || lower.Contains("professional training") || lower.Contains("تدريب") || lower.Contains("training"))
                return "fa-chalkboard-teacher";

            // 54. General Languages
            if (lower.Contains("لغات") || lower.Contains("languages") || lower.Contains("لغة") || lower.Contains("language") || lower.Contains("ترجمة") || lower.Contains("translation"))
                return "fa-language";

            return "fa-folder";
        }

        /// <summary>
        /// Gets the primary color key (e.g. "blue", "indigo", "purple", "emerald", "amber", etc.)
        /// for a category. Matches the Tailwind dictionaries in _HomeCategoriesPartial.
        /// </summary>
        public static string GetCategoryColor(string? categoryName)
        {
            if (string.IsNullOrWhiteSpace(categoryName))
                return "gray";

            var lower = categoryName.Trim().ToLowerInvariant();

            // Mobile & Web
            if (lower.Contains("موبايل") || lower.Contains("mobile") || lower.Contains("أندرويد") || lower.Contains("android") || lower.Contains("ios"))
                return "cyan";
            if (lower.Contains("تطوير الويب") || lower.Contains("web development") || lower.Contains("ويب") || lower.Contains("web dev"))
                return "indigo";
            if (lower.Contains("ألعاب") || lower.Contains("العاب") || lower.Contains("game"))
                return "purple";
            if (lower.Contains("هندسة البرمجيات") || lower.Contains("software engineering"))
                return "sky";
            if (lower.Contains("devops") || lower.Contains("ديف اوبس"))
                return "teal";

            // Data & AI
            if (lower.Contains("علوم البيانات") || lower.Contains("data science"))
                return "violet";
            if (lower.Contains("تحليل البيانات") || lower.Contains("data analysis"))
                return "blue";
            if (lower.Contains("التعلم الآلي") || lower.Contains("machine learning") || lower.Contains("ذكاء") || lower.Contains("ai"))
                return "indigo";
            if (lower.Contains("قواعد البيانات") || lower.Contains("database") || lower.Contains("sql"))
                return "emerald";

            // Cyber & Infrastructure
            if (lower.Contains("أمن") || lower.Contains("امن") || lower.Contains("cyber") || lower.Contains("security"))
                return "red";
            if (lower.Contains("شبكات") || lower.Contains("networking") || lower.Contains("network"))
                return "sky";
            if (lower.Contains("سحابي") || lower.Contains("cloud"))
                return "cyan";
            if (lower.Contains("تقنية المعلومات") || lower.Contains("it &") || lower.Contains("it software"))
                return "blue";

            // Programming general
            if (lower.Contains("برمجة") || lower.Contains("programming") || lower.Contains("برمج") || lower.Contains("developer"))
                return "blue";

            // Design
            if (lower.Contains("واجهات") || lower.Contains("ui") || lower.Contains("ux"))
                return "pink";
            if (lower.Contains("جرافيك") || lower.Contains("graphic"))
                return "fuchsia";
            if (lower.Contains("أدوات التصميم") || lower.Contains("design tools"))
                return "purple";
            if (lower.Contains("تصميم") || lower.Contains("design"))
                return "purple";

            // Photography & Video
            if (lower.Contains("تصوير") || lower.Contains("photography"))
                return "pink";
            if (lower.Contains("فيديو") || lower.Contains("video") || lower.Contains("مونتاج"))
                return "red";

            // Business & Management
            if (lower.Contains("ريادة") || lower.Contains("entrepreneurship") || lower.Contains("startup"))
                return "yellow";
            if (lower.Contains("إدارة المشاريع") || lower.Contains("ادارة المشاريع") || lower.Contains("project management"))
                return "orange";
            if (lower.Contains("مبيعات") || lower.Contains("sales") || lower.Contains("بيع"))
                return "emerald";
            if (lower.Contains("تسويق رقمي") || lower.Contains("digital marketing"))
                return "teal";
            if (lower.Contains("تسويق") || lower.Contains("marketing") || lower.Contains("إعلان"))
                return "green";
            if (lower.Contains("مالية") || lower.Contains("محاسبة") || lower.Contains("finance") || lower.Contains("accounting"))
                return "emerald";
            if (lower.Contains("استثمار") || lower.Contains("investing") || lower.Contains("invest") || lower.Contains("بورصة"))
                return "lime";
            if (lower.Contains("إنتاجية") || lower.Contains("productivity") || lower.Contains("مكتب") || lower.Contains("office"))
                return "blue";
            if (lower.Contains("أعمال") || lower.Contains("اعمال") || lower.Contains("business"))
                return "amber";

            // Personal Development
            if (lower.Contains("تنمية شخصية") || lower.Contains("personal development") || lower.Contains("تطوير ذاتي"))
                return "violet";
            if (lower.Contains("قيادة") || lower.Contains("leadership"))
                return "indigo";
            if (lower.Contains("تواصل") || lower.Contains("communication"))
                return "cyan";
            if (lower.Contains("تفاوض") || lower.Contains("negotiation"))
                return "amber";

            // Lifestyle & Health
            if (lower.Contains("موضة") || lower.Contains("fashion"))
                return "rose";
            if (lower.Contains("نمط الحياة") || lower.Contains("lifestyle"))
                return "amber";
            if (lower.Contains("طبخ") || lower.Contains("cooking") || lower.Contains("طهي"))
                return "red";
            if (lower.Contains("لياقة") || lower.Contains("fitness") || lower.Contains("صحة") || lower.Contains("health"))
                return "rose";
            if (lower.Contains("تغذية") || lower.Contains("nutrition") || lower.Contains("دايت"))
                return "green";
            if (lower.Contains("رياضة") || lower.Contains("sports") || lower.Contains("sport"))
                return "orange";
            if (lower.Contains("موسيقى") || lower.Contains("music") || lower.Contains("غناء"))
                return "purple";

            // Academics
            if (lower.Contains("تعليم") || lower.Contains("أكاديم") || lower.Contains("اكاديم") || lower.Contains("teaching") || lower.Contains("academics"))
                return "sky";
            if (lower.Contains("هندسة") || lower.Contains("engineering") || lower.Contains("مهندس"))
                return "orange";
            if (lower.Contains("رياضيات") || lower.Contains("math") || lower.Contains("حساب"))
                return "pink";
            if (lower.Contains("فيزياء") || lower.Contains("physics"))
                return "indigo";
            if (lower.Contains("كيمياء") || lower.Contains("chemistry"))
                return "teal";
            if (lower.Contains("طب") || lower.Contains("medicine") || lower.Contains("medical"))
                return "red";
            if (lower.Contains("قانون") || lower.Contains("law") || lower.Contains("حقوق"))
                return "amber";
            if (lower.Contains("نفس") || lower.Contains("psychology"))
                return "violet";
            if (lower.Contains("تاريخ") || lower.Contains("history"))
                return "amber";
            if (lower.Contains("جغرافيا") || lower.Contains("geography"))
                return "blue";

            // Languages
            if (lower.Contains("إنجليز") || lower.Contains("انجليز") || lower.Contains("english"))
                return "blue";
            if (lower.Contains("عرب") || lower.Contains("arabic"))
                return "emerald";
            if (lower.Contains("محتوى") || lower.Contains("content") || lower.Contains("كتابة") || lower.Contains("writing"))
                return "cyan";
            if (lower.Contains("مهني") || lower.Contains("professional") || lower.Contains("تدريب") || lower.Contains("training"))
                return "blue";
            if (lower.Contains("لغات") || lower.Contains("languages") || lower.Contains("لغة") || lower.Contains("language"))
                return "indigo";

            return "gray";
        }

        /// <summary>
        /// Gets the Tailwind background color class for category icon containers.
        /// </summary>
        public static string GetCategoryBgColor(string? categoryName)
        {
            var color = GetCategoryColor(categoryName);
            return color switch
            {
                "blue" => "bg-blue-100 dark:bg-blue-900/40",
                "indigo" => "bg-indigo-100 dark:bg-indigo-900/40",
                "sky" => "bg-sky-100 dark:bg-sky-900/40",
                "cyan" => "bg-cyan-100 dark:bg-cyan-900/40",
                "teal" => "bg-teal-100 dark:bg-teal-900/40",
                "emerald" => "bg-emerald-100 dark:bg-emerald-900/40",
                "green" => "bg-green-100 dark:bg-green-900/40",
                "lime" => "bg-lime-100 dark:bg-lime-900/40",
                "yellow" => "bg-yellow-100 dark:bg-yellow-900/40",
                "amber" => "bg-amber-100 dark:bg-amber-900/40",
                "orange" => "bg-orange-100 dark:bg-orange-900/40",
                "red" => "bg-red-100 dark:bg-red-900/40",
                "rose" => "bg-rose-100 dark:bg-rose-900/40",
                "pink" => "bg-pink-100 dark:bg-pink-900/40",
                "purple" => "bg-purple-100 dark:bg-purple-900/40",
                "violet" => "bg-violet-100 dark:bg-violet-900/40",
                "fuchsia" => "bg-fuchsia-100 dark:bg-fuchsia-900/40",
                _ => "bg-gray-100 dark:bg-gray-800"
            };
        }

        /// <summary>
        /// Gets the Tailwind text color class for category icons or labels.
        /// </summary>
        public static string GetCategoryTextColor(string? categoryName)
        {
            var color = GetCategoryColor(categoryName);
            return color switch
            {
                "blue" => "text-blue-700 dark:text-blue-300",
                "indigo" => "text-indigo-700 dark:text-indigo-300",
                "sky" => "text-sky-700 dark:text-sky-300",
                "cyan" => "text-cyan-700 dark:text-cyan-300",
                "teal" => "text-teal-700 dark:text-teal-300",
                "emerald" => "text-emerald-700 dark:text-emerald-300",
                "green" => "text-green-700 dark:text-green-300",
                "lime" => "text-lime-700 dark:text-lime-300",
                "yellow" => "text-yellow-700 dark:text-yellow-300",
                "amber" => "text-amber-700 dark:text-amber-300",
                "orange" => "text-orange-700 dark:text-orange-300",
                "red" => "text-red-700 dark:text-red-300",
                "rose" => "text-rose-700 dark:text-rose-300",
                "pink" => "text-pink-700 dark:text-pink-300",
                "purple" => "text-purple-700 dark:text-purple-300",
                "violet" => "text-violet-700 dark:text-violet-300",
                "fuchsia" => "text-fuchsia-700 dark:text-fuchsia-300",
                _ => "text-gray-700 dark:text-gray-300"
            };
        }

        /// <summary>
        /// Gets vibrant text color class (600 in light, 400 in dark).
        /// </summary>
        public static string GetCategoryTextClass(string? categoryName)
        {
            var color = GetCategoryColor(categoryName);
            return color switch
            {
                "blue" => "text-blue-600 dark:text-blue-400",
                "indigo" => "text-indigo-600 dark:text-indigo-400",
                "sky" => "text-sky-600 dark:text-sky-400",
                "cyan" => "text-cyan-600 dark:text-cyan-400",
                "teal" => "text-teal-600 dark:text-teal-400",
                "emerald" => "text-emerald-600 dark:text-emerald-400",
                "green" => "text-green-600 dark:text-green-400",
                "lime" => "text-lime-600 dark:text-lime-400",
                "yellow" => "text-yellow-600 dark:text-yellow-400",
                "amber" => "text-amber-600 dark:text-amber-400",
                "orange" => "text-orange-600 dark:text-orange-400",
                "red" => "text-red-600 dark:text-red-400",
                "rose" => "text-rose-600 dark:text-rose-400",
                "pink" => "text-pink-600 dark:text-pink-400",
                "purple" => "text-purple-600 dark:text-purple-400",
                "violet" => "text-violet-600 dark:text-violet-400",
                "fuchsia" => "text-fuchsia-600 dark:text-fuchsia-400",
                _ => "text-gray-600 dark:text-gray-400"
            };
        }

        /// <summary>
        /// Gets the Tailwind gradient class (from-... to-...) for featured category cards.
        /// </summary>
        public static string GetCategoryGradient(string? categoryName)
        {
            var color = GetCategoryColor(categoryName);
            return color switch
            {
                "blue" => "from-blue-500 to-blue-600",
                "indigo" => "from-indigo-500 to-indigo-600",
                "sky" => "from-sky-500 to-sky-600",
                "cyan" => "from-cyan-500 to-cyan-600",
                "teal" => "from-teal-500 to-teal-600",
                "emerald" => "from-emerald-500 to-emerald-600",
                "green" => "from-green-500 to-green-600",
                "lime" => "from-lime-500 to-lime-600",
                "yellow" => "from-yellow-500 to-yellow-600",
                "amber" => "from-amber-500 to-amber-600",
                "orange" => "from-orange-500 to-orange-600",
                "red" => "from-red-500 to-red-600",
                "rose" => "from-rose-500 to-rose-600",
                "pink" => "from-pink-500 to-pink-600",
                "purple" => "from-purple-500 to-purple-600",
                "violet" => "from-violet-500 to-violet-600",
                "fuchsia" => "from-fuchsia-500 to-fuchsia-600",
                _ => "from-gray-500 to-gray-600"
            };
        }
    }
}
