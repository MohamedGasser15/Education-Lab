using EduLab_Seeder.Models;
using static EduLab_Seeder.Models.UserProfileHelpers;

namespace EduLab_Seeder.Data
{
    /// <summary>
    /// 100 realistic instructor accounts with rich, unique profile data across all domains.
    /// Profile images use publicly hosted realistic person portraits (randomuser.me).
    /// </summary>
    internal static class InstructorSeedData
    {
        public static List<UserProfile> All { get; } = new()
        {
            new UserProfile(
                "أحمد عبد الرحمن", Email("ahmed", "abdelrahman", 1), "مهندس برمجيات أول ومستشار معماريات .NET",
                "القاهرة، مصر",
                "مهندس برمجيات بخبرة تفوق 10 سنوات في تصميم وتطوير الأنظمة المعقدة والمؤسسية باستخدام .NET و ASP.NET Core. شغوف بنقل الخبرة العملية وتبسيط المفاهيم الصعبة للطلاب.",
                Portrait("men", 32),
                "https://github.com/ahmedabdelrahman", "https://linkedin.com/in/ahmedabdelrahman",
                "https://twitter.com/ahmedabdelrahman", "https://facebook.com/ahmedabdelrahman",
                new() { "C#", "ASP.NET Core", "SQL Server" }, "ar", DefaultPassword),

            new UserProfile(
                "Sara Mostafa", Email("sara", "mostafa", 2), "Senior Frontend Engineer & React Specialist",
                "Alexandria, Egypt",
                "Frontend engineer with over 8 years of hands-on experience building high-performance SPAs with React, TypeScript, and Next.js. Passionate about user-centric design and scalable frontend architectures.",
                Portrait("women", 44),
                "https://github.com/saramostafa", "https://linkedin.com/in/saramostafa",
                "https://twitter.com/saramostafa", "https://facebook.com/saramostafa",
                new() { "JavaScript", "React", "UI/UX" }, "en", DefaultPassword),

            new UserProfile(
                "محمد الشناوي", Email("mohamed", "elshinnawy", 3), "مطور تطبيقات موبايل ومستشار Flutter",
                "الجيزة، مصر",
                "مطور Flutter و Android بخبرة 7 سنوات، شاركت في إطلاق أكثر من 30 تطبيقاً على متاجر التطبيقات لملايين المستخدمين. أركز في دوراتي على المعمارية النظيفة وبناء واجهات سلسة.",
                Portrait("men", 12),
                "https://github.com/mohamedelshinnawy", "https://linkedin.com/in/mohamedelshinnawy",
                "https://twitter.com/mohamedelshinnawy", "https://facebook.com/mohamedelshinnawy",
                new() { "Flutter", "Dart", "Android" }, "ar", DefaultPassword),

            new UserProfile(
                "Mona Ibrahim", Email("mona", "ibrahim", 4), "Data Scientist & AI Researcher",
                "Cairo, Egypt",
                "Holds an MSc in Artificial Intelligence with 9 years of research and industry experience. I specialize in turning complex mathematical algorithms into intuitive, practical python implementations.",
                Portrait("women", 68),
                "https://github.com/monaibrahim", "https://linkedin.com/in/monaibrahim",
                "https://twitter.com/monaibrahim", "https://facebook.com/monaibrahim",
                new() { "Python", "Machine Learning", "Data Science" }, "en", DefaultPassword),

            new UserProfile(
                "Khaled Hassan", Email("khaled", "hassan", 5), "Lead DevOps & Cloud Platform Architect",
                "Mansoura, Egypt",
                "Cloud and DevOps architect specializing in AWS, Azure, Kubernetes, and automated infrastructure as code. Dedicated to empowering engineers to deploy reliably at massive scale.",
                Portrait("men", 52),
                "https://github.com/khaledhassan", "https://linkedin.com/in/khaledhassan",
                "https://twitter.com/khaledhassan", "https://facebook.com/khaledhassan",
                new() { "Azure", "Kubernetes", "CI/CD" }, "en", DefaultPassword),

            new UserProfile(
                "Nour Adel", Email("nour", "adel", 6), "Lead Product Designer & UX Researcher",
                "Alexandria, Egypt",
                "Product designer with 6+ years creating intuitive interfaces for SaaS and consumer mobile apps. I guide students through the end-to-end design thinking process using Figma.",
                Portrait("women", 21),
                "https://github.com/nouradel", "https://linkedin.com/in/nouradel",
                "https://twitter.com/nouradel", "https://facebook.com/nouradel",
                new() { "Figma", "UI/UX", "Design" }, "en", DefaultPassword),

            new UserProfile(
                "عمر فاروق", Email("omar", "farouk", 7), "خبير أمن سيبراني واختبار اختراق معتمد",
                "القاهرة، مصر",
                "خبير في أمن المعلومات واختبار الاختراق الأخلاقي، حاصل على شهادات OSCP و CEH، أقدّم تدريباً عملياً متعمقاً في اكتشاف الثغرات وتأمين التطبيقات والشبكات المؤسسية.",
                Portrait("men", 85),
                "https://github.com/omarfarouk", "https://linkedin.com/in/omarfarouk",
                "https://twitter.com/omarfarouk", "https://facebook.com/omarfarouk",
                new() { "Cyber Security", "Penetration Testing", "Network Security" }, "ar", DefaultPassword),

            new UserProfile(
                "Dina Mahmoud", Email("dina", "mahmoud", 8), "Senior Game Developer & Technical Artist",
                "Giza, Egypt",
                "Game developer with 7 years of experience in Unity and Unreal Engine. Successfully released multiple commercial indie titles. Enthusiastic about game physics, AI, and graphics optimization.",
                Portrait("women", 33),
                "https://github.com/dinamahmoud", "https://linkedin.com/in/dinamahmoud",
                "https://twitter.com/dinamahmoud", "https://facebook.com/dinamahmoud",
                new() { "Unity", "C#", "Game Design" }, "en", DefaultPassword),

            new UserProfile(
                "مصطفى كامل", Email("mostafa", "kamel", 9), "مطور Full Stack وقائد تقني",
                "طنطا، مصر",
                "مطور Full Stack بخبرة 8 سنوات في بناء منصات الويب الحديثة باستخدام Node.js و .NET و React. أركز على أفضل الممارسات البرمجية وحل المشاكل التقنية في بيئات العمل الحقيقية.",
                Portrait("men", 11),
                "https://github.com/mostafakamel", "https://linkedin.com/in/mostafakamel",
                "https://twitter.com/mostafakamel", "https://facebook.com/mostafakamel",
                new() { "Node.js", "JavaScript", "ASP.NET Core" }, "ar", DefaultPassword),

            new UserProfile(
                "Hagar El-Sayed", Email("hagar", "elsayed", 10), "Senior Database Administrator & Tuning Expert",
                "Alexandria, Egypt",
                "Specialized in high-load database architecture, performance optimization, and disaster recovery across SQL Server and PostgreSQL. Passionate about indexing strategies and clean schemas.",
                Portrait("women", 78),
                "https://github.com/hagarelsayed", "https://linkedin.com/in/hagarelsayed",
                "https://twitter.com/hagarelsayed", "https://facebook.com/hagarelsayed",
                new() { "SQL Server", "PostgreSQL", "Database Design" }, "en", DefaultPassword),

            new UserProfile(
                "يوسف عاطف", Email("youssef", "atef", 11), "مستشار ريادة أعمال ومدير مشاريع معتمد PMP",
                "القاهرة، مصر",
                "مستشار استراتيجي لرواد الأعمال، دربت وساعدت أكثر من 50 شركة ناشئة في وضع نماذج الأعمال، دراسات الجدوى، وجولات التمويل الاستثماري بنجاح في الشرق الأوسط.",
                Portrait("men", 22),
                "https://github.com/youssefatef", "https://linkedin.com/in/youssefatef",
                "https://twitter.com/youssefatef", "https://facebook.com/youssefatef",
                new() { "Entrepreneurship", "Project Management", "Business" }, "ar", DefaultPassword),

            new UserProfile(
                "Fatma El-Zahraa", Email("fatma", "elzahraa", 12), "Growth Marketing Strategist & SEO Lead",
                "Giza, Egypt",
                "Digital marketing specialist with 8 years of experience managing 7-figure ad budgets across Google, Meta, and LinkedIn. Dedicated to teaching ROI-driven growth frameworks.",
                Portrait("women", 54),
                "https://github.com/fatmaelzahraa", "https://linkedin.com/in/fatmaelzahraa",
                "https://twitter.com/fatmaelzahraa", "https://facebook.com/fatmaelzahraa",
                new() { "Digital Marketing", "SEO", "Google Ads" }, "en", DefaultPassword),

            new UserProfile(
                "إبراهيم صلاح", Email("ibrahim", "salah", 13), "مدرب لغة إنجليزية معتمد وخبير اختبارات IELTS",
                "القاهرة، مصر",
                "مدرب محترف حاصل على شهادات DELTA و CELTA بخبرة 12 عاماً، ساعدت آلاف الطلاب على اجتياز امتحانات IELTS و TOEFL بدرجات مرتفعة وتحقيق طلاقة التحدث باللغة الإنجليزية.",
                Portrait("men", 38),
                "https://github.com/ibrahimsalah", "https://linkedin.com/in/ibrahimsalah",
                "https://twitter.com/ibrahimsalah", "https://facebook.com/ibrahimsalah",
                new() { "English", "IELTS", "TOEFL" }, "ar", DefaultPassword),

            new UserProfile(
                "Shaimaa Hassan", Email("shaimaa", "hassan", 14), "Director of Photography & Colorist",
                "Alexandria, Egypt",
                "Visual storyteller with 9 years directing commercial shoots and documentary films. I teach cinematography techniques, studio lighting setups, and advanced color grading in DaVinci Resolve.",
                Portrait("women", 90),
                "https://github.com/shaimaa_hassan", "https://linkedin.com/in/shaimaa_hassan",
                "https://twitter.com/shaimaa_hassan", "https://facebook.com/shaimaa_hassan",
                new() { "Photography", "Video Editing", "Lightroom" }, "en", DefaultPassword),

            new UserProfile(
                "كريم عادل", Email("karim", "adel", 15), "مهندس بنية شبكات وأمن معلومات معتمد CCNP",
                "المنصورة، مصر",
                "مهندس شبكات أول متخصص في تصميم البنى التحتية الافتراضية وشبكات المؤسسات الكبرى. أقدّم تدريباً شاملاً يؤهل المهندسين لاجتياز شهادات سيسكو المعتمدة والعمل الفعلي.",
                Portrait("men", 64),
                "https://github.com/karimadel", "https://linkedin.com/in/karimadel",
                "https://twitter.com/karimadel", "https://facebook.com/karimadel",
                new() { "Networking", "CCNA", "CCNP" }, "ar", DefaultPassword),

            new UserProfile(
                "Amal Sharif", Email("amal", "sharif", 16), "Chartered Financial Analyst & Portfolio Strategist",
                "Cairo, Egypt",
                "CFA charterholder with 10+ years advising corporate finance departments and wealth management funds. I demystify equity valuation, financial modeling, and asset allocation.",
                Portrait("women", 17),
                "https://github.com/amalsharif", "https://linkedin.com/in/amalsharif",
                "https://twitter.com/amalsharif", "https://facebook.com/amalsharif",
                new() { "Finance", "Investing", "Financial Analysis" }, "en", DefaultPassword),

            new UserProfile(
                "طارق عبد العزيز", Email("tarek", "abdelaziz", 17), "مخرج فني ومصمم هويات بصرية",
                "الجيزة، مصر",
                "مصمم جرافيك ومخرج فني بخبرة 11 عاماً مع وكالات دعاية وإعلان إقليمية. أعلّم الطلاب فن بناء الهويات البصرية القوية والتفكير الإبداعي باستخدام أدوات أدوبي الحديثة.",
                Portrait("men", 75),
                "https://github.com/tarekabdelaziz", "https://linkedin.com/in/tarekabdelaziz",
                "https://twitter.com/tarekabdelaziz", "https://facebook.com/tarekabdelaziz",
                new() { "Photoshop", "Illustrator", "Branding" }, "ar", DefaultPassword),

            new UserProfile(
                "Esraa Waleed", Email("esraa", "waleed", 18), "STEM Educator & Kids Coding Specialist",
                "Alexandria, Egypt",
                "Passionate STEM educator dedicated to making programming engaging for young minds through Scratch, Python, and micro-controllers. Helping the next generation think algorithmically.",
                Portrait("women", 95),
                "https://github.com/esraawaleed", "https://linkedin.com/in/esraawaleed",
                "https://twitter.com/esraawaleed", "https://facebook.com/esraawaleed",
                new() { "Scratch", "Python", "Kids Coding" }, "en", DefaultPassword),

            new UserProfile(
                "حسام الدين محمود", Email("hosam", "mahmoud", 19), "كبير مهندسي الحلول السحابية AWS & Azure",
                "القاهرة، مصر",
                "مهندس معماريات سحابية معتمد AWS Solutions Architect Professional، أصمم أنظمة سحابية هجينة وموزعة تضمن أعلى درجات التوافر والأمان مع تقليل تكاليف التشغيل.",
                Portrait("men", 45),
                "https://github.com/hosammahmoud", "https://linkedin.com/in/hosammahmoud",
                "https://twitter.com/hosammahmoud", "https://facebook.com/hosammahmoud",
                new() { "AWS", "Azure", "Cloud Architecture" }, "ar", DefaultPassword),

            new UserProfile(
                "Rehab Nabil", Email("rehab", "nabil", 20), "Enterprise Angular & Clean Architecture Lead",
                "Alexandria, Egypt",
                "Software engineer with 9 years of experience architecting large enterprise frontends using Angular, RxJS, and clean architecture patterns. Author and international tech speaker.",
                Portrait("women", 28),
                "https://github.com/rehabnabil", "https://linkedin.com/in/rehabnabil",
                "https://twitter.com/rehabnabil", "https://facebook.com/rehabnabil",
                new() { "Angular", "ASP.NET Core", "Clean Architecture" }, "en", DefaultPassword),

            new UserProfile(
                "محمود الجندي", Email("mahmoud", "elgendy", 21), "باحث ومطور ذكاء اصطناعي ونماذج لغوية",
                "القاهرة، مصر",
                "باحث متخصص في التعلم العميق ومعالجة اللغات الطبيعية (NLP) للغة العربية. أساعد الطلاب على بناء وتدريب وتطويع نماذج الذكاء الاصطناعي التوليدي لتطبيقات عملية.",
                Portrait("men", 14),
                "https://github.com/mahmoudelgendy", "https://linkedin.com/in/mahmoudelgendy",
                "https://twitter.com/mahmoudelgendy", "https://facebook.com/mahmoudelgendy",
                new() { "AI", "Deep Learning", "NLP" }, "ar", DefaultPassword),

            new UserProfile(
                "Samar Othman", Email("samar", "othman", 22), "Executive Life & Productivity Coach",
                "Giza, Egypt",
                "ICF certified coach specializing in peak performance habits, stress management, and personal organization. Empowering ambitious professionals to balance work and life efficiently.",
                Portrait("women", 40),
                "https://github.com/samarothman", "https://linkedin.com/in/samarothman",
                "https://twitter.com/samarothman", "https://facebook.com/samarothman",
                new() { "Personal Development", "Time Management", "Productivity" }, "en", DefaultPassword),

            new UserProfile(
                "أحمد فوزي", Email("ahmed", "fawzy", 23), "مدرب تواصل لغوي ومقابلات عمل دولية",
                "الإسكندرية، مصر",
                "مدرب لغويات ومحادثة متقدمة، ساعدت مئات المحترفين التقنيين على اجتياز مقابلات العمل لدى كبرى الشركات العالمية والتحدث بثقة مطلقة واحترافية بدون تردد.",
                Portrait("men", 60),
                "https://github.com/ahmedfawzy", "https://linkedin.com/in/ahmedfawzy",
                "https://twitter.com/ahmedfawzy", "https://facebook.com/ahmedfawzy",
                new() { "English Conversation", "Interviews", "Soft Skills" }, "ar", DefaultPassword),

            new UserProfile(
                "مي خليل", Email("mai", "khalil", 24), "رئيسة قسم أبحاث تجربة المستخدم وتصميم المنتجات",
                "القاهرة، مصر",
                "خبيرة في تصميم المنتجات الرقمية وأبحاث سلوك المستخدمين. قادت استراتيجيات التصميم لتطبيقات تجاوز عدد مستخدميها 10 ملايين مستخدم. أشارك أسرار التفكير التصميمي والابتكار.",
                Portrait("women", 49),
                "https://github.com/maikhalil", "https://linkedin.com/in/maikhalil",
                "https://twitter.com/maikhalil", "https://facebook.com/maikhalil",
                new() { "UX Research", "Product Design", "Design Thinking" }, "ar", DefaultPassword),

            new UserProfile(
                "وليد سعيد", Email("waleed", "said", 25), "مستشار ذكاء الأعمال وتحليل البيانات المتقدم",
                "المنصورة، مصر",
                "خبير معتمد في Power BI و SQL و Excel المتقدم بخبرة 8 سنوات. ساعدت إدارات كبرى الشركات على تحويل البيانات الضخمة إلى لوحات تفاعلية تدعم اتخاذ القرارات الاستراتيجية.",
                Portrait("men", 28),
                "https://github.com/waleedsaid", "https://linkedin.com/in/waleedsaid",
                "https://twitter.com/waleedsaid", "https://facebook.com/waleedsaid",
                new() { "Power BI", "Excel", "Data Analysis" }, "ar", DefaultPassword),

            new UserProfile(
                "Eman Abdallah", Email("eman", "abdallah", 26), "Global HR Director & Talent Acquisition Lead",
                "Cairo, Egypt",
                "Senior HR director with 12 years across tech multinationals. Specialized in building high-performing remote team cultures, compensation structures, and leadership succession pipelines.",
                Portrait("women", 74),
                "https://github.com/emanabdallah", "https://linkedin.com/in/emanabdallah",
                "https://twitter.com/emanabdallah", "https://facebook.com/emanabdallah",
                new() { "HR", "Recruitment", "Leadership" }, "en", DefaultPassword),

            new UserProfile(
                "مصطفى خيري", Email("mostafa", "khairy", 27), "فنان ومطور بيئات ألعاب ثلاثية الأبعاد",
                "الجيزة، مصر",
                "فنان بيئات ثلاثية الأبعاد ومطور Unreal Engine 5 بخبرة واسعة في محركات الألعاب وبرنامج Blender. أعلّم النمذجة الواقعية والإضاءة السينمائية ومحاكاة الفيزياء لألعاب الجيل القادم.",
                Portrait("men", 70),
                "https://github.com/mostafakhairy", "https://linkedin.com/in/mostafakhairy",
                "https://twitter.com/mostafakhairy", "https://facebook.com/mostafakhairy",
                new() { "Unreal Engine", "Blender", "3D Design" }, "ar", DefaultPassword),

            new UserProfile(
                "Alaa Mostafa", Email("alaa", "mostafa", 28), "Executive Pastry Chef & Culinary Instructor",
                "Alexandria, Egypt",
                "Trained in classic French patisserie and Mediterranean gastronomy. Teaching professional baking fundamentals, pastry arts, and modern plating techniques to aspiring chefs.",
                Portrait("women", 93),
                "https://github.com/alaamostafa", "https://linkedin.com/in/alaamostafa",
                "https://twitter.com/alaamostafa", "https://facebook.com/alaamostafa",
                new() { "Cooking", "Pastry", "Middle Eastern Cuisine" }, "en", DefaultPassword),

            new UserProfile(
                "باسم الرمحي", Email("basem", "elramahy", 29), "مدير تسويق محتوى واستراتيجي علامات تجارية",
                "القاهرة، مصر",
                "خبير صناعة المحتوى الإعلاني والتسويق الفيروسي، ساهمت حملاتي في تحقيق مبيعات بملايين الجنيهات. أشارك منهجية كتابة الإعلانات المقنعة وإدارة الحملات الرقمية الناجحة.",
                Portrait("men", 86),
                "https://github.com/basemelramahy", "https://linkedin.com/in/basemelramahy",
                "https://twitter.com/basemelramahy", "https://facebook.com/basemelramahy",
                new() { "Content Strategy", "Social Media", "Copywriting" }, "ar", DefaultPassword),

            new UserProfile(
                "Rana El-Sayed", Email("rana", "elsayed", 30), "Clinical Sports Nutritionist & Wellness Coach",
                "Giza, Egypt",
                "Registered clinical nutritionist counseling elite athletes and fitness enthusiasts. I teach science-backed macro planning, athletic performance nutrition, and metabolic health.",
                Portrait("women", 25),
                "https://github.com/ranaelsayed", "https://linkedin.com/in/ranaelsayed",
                "https://twitter.com/ranaelsayed", "https://facebook.com/ranaelsayed",
                new() { "Nutrition", "Sports Nutrition", "Healthy Habits" }, "en", DefaultPassword),

            new UserProfile(
                "إيهاب عبد العزيز", Email("ehab", "abdelaziz", 31), "محلل أسواق مالية ومستشار استثمار عقاري",
                "الإسكندرية، مصر",
                "مستثمر ومحلل فني معتمد بخبرة 14 عاماً في البورصات الإقليمية وأسواق العقارات. أقدم دورات عملية تركز على إدارة المخاطر، قراءة الرسوم البيانية، وبناء مصادر دخل سلبي مستدامة.",
                Portrait("men", 7),
                "https://github.com/ehababdelaziz", "https://linkedin.com/in/ehababdelaziz",
                "https://twitter.com/ehababdelaziz", "https://facebook.com/ehababdelaziz",
                new() { "Stock Market", "Real Estate", "Investing" }, "ar", DefaultPassword),

            new UserProfile(
                "نسمة عاطف", Email("nesma", "atef", 32), "مدربة مهارات قيادية وتحدث أمام الجمهور",
                "القاهرة، مصر",
                "مدربة متحدثين ومقدمي عروض تقديمية لدى فعاليات TEDx، أساعد المديرين والرواد على تطوير الكاريزما، إقناع المستثمرين، وإتقان لغة الجسد وصوت التأثير.",
                Portrait("women", 44),
                "https://github.com/nesmaatef", "https://linkedin.com/in/nesmaatef",
                "https://twitter.com/nesmaatef", "https://facebook.com/nesmaatef",
                new() { "Public Speaking", "Presentation", "Leadership" }, "ar", DefaultPassword),

            new UserProfile(
                "سيف الدين عمار", Email("seif", "ammar", 33), "كبير مهندسي بايثون وأتمتة الأنظمة الخلفية",
                "المنصورة، مصر",
                "مهندس برمجيات متخصص في Python و Django و FastAPI وبناء معالجات البيانات الضخمة. أركز في شروحاتي على كتابة كود عالي الجودة والسرعة متوافق مع معايير PEP8 والصيانة المستمرة.",
                Portrait("men", 15),
                "https://github.com/seifammar", "https://linkedin.com/in/seifammar",
                "https://twitter.com/seifammar", "https://facebook.com/seifammar",
                new() { "Python", "Django", "FastAPI" }, "ar", DefaultPassword),

            new UserProfile(
                "Ghada Mohamed", Email("ghada", "mohamed", 34), "Fashion Designer & Apparel Pattern Maker",
                "Alexandria, Egypt",
                "Fashion designer with collections showcased internationally. I teach fashion illustration, textile selection, digital pattern making, and commercial garment manufacturing.",
                Portrait("women", 67),
                "https://github.com/ghadamohamed", "https://linkedin.com/in/ghadamohamed",
                "https://twitter.com/ghadamohamed", "https://facebook.com/ghadamohamed",
                new() { "Fashion", "Fashion Design", "Styling" }, "en", DefaultPassword),

            new UserProfile(
                "هيثم شريف", Email("haytham", "sharif", 35), "محلل برمجيات خبيثة وخبير هندسة عكسية",
                "القاهرة، مصر",
                "خبير أمني متخصص في تحليل الهجمات الإلكترونية المعقدة والهندسة العكسية للملفات التنفيذية. أقدم مسارات تدريبية للمهندسين الراغبين بالاحتراف في مراكز العمليات الأمنية (SOC).",
                Portrait("men", 66),
                "https://github.com/haythamsharif", "https://linkedin.com/in/haythamsharif",
                "https://twitter.com/haythamsharif", "https://facebook.com/haythamsharif",
                new() { "Reverse Engineering", "Malware Analysis", "Cyber Security" }, "ar", DefaultPassword),

            new UserProfile(
                "Asmaa Rashad", Email("asmaa", "rashad", 36), "Financial Planning Specialist & Wealth Advisor",
                "Alexandria, Egypt",
                "Personal wealth coach helping families and young professionals escape debt, design emergency funds, and construct smart automated long-term investment plans.",
                Portrait("women", 52),
                "https://github.com/asmaarashad", "https://linkedin.com/in/asmaarashad",
                "https://twitter.com/asmaarashad", "https://facebook.com/asmaarashad",
                new() { "Personal Finance", "Budgeting", "Financial Planning" }, "en", DefaultPassword),

            new UserProfile(
                "طه إبراهيم", Email("taha", "ibrahim", 37), "مدرب إدارة التغيير والقيادة المؤسسية",
                "الجيزة، مصر",
                "خبير في إدارة الفرق والقيادة التنفيذية بخبرة تتجاوز 15 عاماً. أساعد القادة والمديرين على حل النزاعات، تحفيز فرق العمل، وإدارة التحولات الهيكلية بنجاح.",
                Portrait("men", 97),
                "https://github.com/tahaibrahim", "https://linkedin.com/in/tahaibrahim",
                "https://twitter.com/tahaibrahim", "https://facebook.com/tahaibrahim",
                new() { "Leadership", "Team Building", "Coaching" }, "ar", DefaultPassword),

            new UserProfile(
                "Yasmin Saad", Email("yasmin", "saad", 38), "Conference Interpreter & Localization Consultant",
                "Cairo, Egypt",
                "Simultaneous conference interpreter with over a decade of experience at UN and international summits. I teach advanced oral interpretation, CAT tools, and diplomatic translation.",
                Portrait("women", 63),
                "https://github.com/yasminsaad", "https://linkedin.com/in/yasminsaad",
                "https://twitter.com/yasminsaad", "https://facebook.com/yasminsaad",
                new() { "Translation", "Interpretation", "Languages" }, "en", DefaultPassword),

            new UserProfile(
                "زياد عبد القادر", Email("ziad", "abdelkader", 39), "مهندس ذكاء اصطناعي ورؤية حاسوبية",
                "القاهرة، مصر",
                "مهندس ذكاء اصطناعي متخصص في رؤية الحاسوب (Computer Vision) ونماذج PyTorch. قمت بتطوير أنظمة للتعرف على الوجوه والمركبات ذاتية القيادة. أركز على الجانب البرمجي والتطبيقي العملي.",
                Portrait("men", 76),
                "https://github.com/ziadkader", "https://linkedin.com/in/ziadkader",
                "https://twitter.com/ziadkader", "https://facebook.com/ziadkader",
                new() { "AI", "Machine Learning", "Python" }, "ar", DefaultPassword),

            new UserProfile(
                "Elena Rostova", Email("elena", "rostova", 40), "Classical Pianist & Music Theory Instructor",
                "London, UK",
                "Concert pianist and graduate of the Royal Academy of Music. Teaching ear training, harmony, sight reading, and expressive piano technique to students worldwide.",
                Portrait("women", 11),
                "https://github.com/elenarostova", "https://linkedin.com/in/elenarostova",
                "https://twitter.com/elenarostova", "https://facebook.com/elenarostova",
                new() { "Music", "Piano", "Music Theory" }, "en", DefaultPassword),

            new UserProfile(
                "كريم عبد الجواد", Email("karim", "abdelgawad", 41), "مدرب لياقة بدنية وبناء أجسام معتمد",
                "القاهرة، مصر",
                "مدرب لياقة بدنية معتمد دولياً (ISSA)، أساعد المتدربين على تصميم برامج تدريبية احترافية، بناء العضلات، حرق الدهون، وتجنب الإصابات الرياضية عبر تدريب علمي مدروس.",
                Portrait("men", 83),
                "https://github.com/karimgawad", "https://linkedin.com/in/karimgawad",
                "https://twitter.com/karimgawad", "https://facebook.com/karimgawad",
                new() { "Fitness", "Health & Fitness", "Home Workout" }, "ar", DefaultPassword),

            new UserProfile(
                "Nadia Mansoor", Email("nadia", "mansoor", 42), "Lead Copywriter & Creative Brand Strategist",
                "Dubai, UAE",
                "Advertising copywriter who has written award-winning campaigns for global consumer brands. Passionate about storytelling, persuasive psychology, and conversion copywriting.",
                Portrait("women", 36),
                "https://github.com/nadiamansoor", "https://linkedin.com/in/nadiamansoor",
                "https://twitter.com/nadiamansoor", "https://facebook.com/nadiamansoor",
                new() { "Copywriting", "Content Writing", "Creative Writing" }, "en", DefaultPassword),

            new UserProfile(
                "عمرو عبد العزيز", Email("amr", "abdelaziz", 43), "مستشار قانوني ومحاضر في قانون الشركات والملكية الفكرية",
                "الرياض، السعودية",
                "مستشار قانوني للشركات الناشئة والمؤسسات التجارية، متخصص في صياغة العقود التجارية الدولية، قوانين التجارة الإلكترونية، وحماية حقوق الملكية الفكرية وبراءات الاختراع.",
                Portrait("men", 54),
                "https://github.com/amrabdelaziz", "https://linkedin.com/in/amrabdelaziz",
                "https://twitter.com/amrabdelaziz", "https://facebook.com/amrabdelaziz",
                new() { "Law", "Legal Writing", "Business" }, "ar", DefaultPassword),

            new UserProfile(
                "Dr. Sarah Jenkins", Email("sarah", "jenkins", 44), "Cognitive Psychologist & Behavioral Science Author",
                "London, UK",
                "PhD in Cognitive Psychology with 12 years of clinical research on habit formation, cognitive biases, and emotional resilience. Teaching behavioral psychology for personal impact.",
                Portrait("women", 47),
                "https://github.com/sarahjenkins", "https://linkedin.com/in/sarahjenkins",
                "https://twitter.com/sarahjenkins", "https://facebook.com/sarahjenkins",
                new() { "Psychology", "Personality", "Personal Development" }, "en", DefaultPassword),

            new UserProfile(
                "محمد خفاجي", Email("mohamed", "khafagi", 45), "أستاذ رياضيات ورياضيات حاسوبية",
                "طنطا، مصر",
                "مدرس رياضيات وخوارزميات حاسوبية، شغوف بتبسيط التفاضل والتكامل، الجبر الخطي، والإحصاء الرياضي اللازم لعلوم البيانات والذكاء الاصطناعي بأسلوب مرئي تفاعلي ممتع.",
                Portrait("men", 41),
                "https://github.com/mohamedkhafagi", "https://linkedin.com/in/mohamedkhafagi",
                "https://twitter.com/mohamedkhafagi", "https://facebook.com/mohamedkhafagi",
                new() { "Math", "Mental Math", "Statistics" }, "ar", DefaultPassword),

            new UserProfile(
                "Lucas Silva", Email("lucas", "silva", 46), "Senior Flutter & Mobile Solutions Architect",
                "Lisbon, Portugal",
                "Mobile architect dedicated to Flutter and cross-platform native plugins. Passionate about state management with Riverpod and Bloc, and creating fluid 60fps animations.",
                Portrait("men", 59),
                "https://github.com/lucassilva", "https://linkedin.com/in/lucassilva",
                "https://twitter.com/lucassilva", "https://facebook.com/lucassilva",
                new() { "Flutter", "Dart", "Mobile Development" }, "en", DefaultPassword),

            new UserProfile(
                "هدى رضوان", Email("hoda", "radwan", 47), "أستاذة لغة عربية ونقد أدبي",
                "القاهرة، مصر",
                "باحثة وأستاذة في النحو والصرف والبلاغة العربية، أقدم دورات متخصصة في الإعراب التطبيقي، تصحيح الأخطاء اللغوية الشائعة، وفنون الكتابة الصحفية والأدبية الراقية.",
                Portrait("women", 19),
                "https://github.com/hodaradwan", "https://linkedin.com/in/hodaradwan",
                "https://twitter.com/hodaradwan", "https://facebook.com/hodaradwan",
                new() { "Arabic Language", "Writing", "Teaching & Academics" }, "ar", DefaultPassword),

            new UserProfile(
                "Marcus Vance", Email("marcus", "vance", 48), "Senior Golang & Distributed Systems Engineer",
                "San Francisco, USA",
                "Backend specialist with 10 years crafting fault-tolerant microservices, gRPC backbones, and event-driven architectures in Go. Dedicated to high-throughput concurrency.",
                Portrait("men", 27),
                "https://github.com/marcusvance", "https://linkedin.com/in/marcusvance",
                "https://twitter.com/marcusvance", "https://facebook.com/marcusvance",
                new() { "Programming", "Clean Architecture", "Backend" }, "en", DefaultPassword),

            new UserProfile(
                "ياسمين الشربيني", Email("yasmin", "elsherbini", 49), "مصممة ديكور داخلي ومعمارية معتمدة",
                "الإسكندرية، مصر",
                "مهندسة معمارية ومصممة ديكور داخلي حاصلة على جوائز تصميم إقليمية. أعلّم برامج AutoCAD و 3Ds Max وتوزيع الإضاءة وتنسيق الأثاث والمواد السكنية والتجارية باحتراف.",
                Portrait("women", 82),
                "https://github.com/yasminsherbini", "https://linkedin.com/in/yasminsherbini",
                "https://twitter.com/yasminsherbini", "https://facebook.com/yasminsherbini",
                new() { "Design", "AutoCAD", "Interior Design" }, "ar", DefaultPassword),

            new UserProfile(
                "Dr. Tariq Al-Hashimi", Email("tariq", "alhashimi", 50), "Professor of Middle Eastern History & Civilizations",
                "Amman, Jordan",
                "Historian and academic researcher specializing in Islamic civilization and ancient Near Eastern archaeological history. Delivering engaging, documentary-style historical lectures.",
                Portrait("men", 62),
                "https://github.com/tariqhashimi", "https://linkedin.com/in/tariqhashimi",
                "https://twitter.com/tariqhashimi", "https://facebook.com/tariqhashimi",
                new() { "History", "Teaching & Academics", "Geography" }, "en", DefaultPassword),

            new UserProfile(
                "مروان النجار", Email("marwan", "elnaggar", 51), "مطور ألعاب ومبرمج محرك Godot و C++",
                "القاهرة، مصر",
                "مبرمج ألعاب مستقل بخبرة 6 سنوات في محركات Godot و C++. أساعد المطورين على كتابة كود الألعاب من الصفر، إدارة الذاكرة، وبرمجة ميكانيكا الألعاب ثنائية وثلاثية الأبعاد.",
                Portrait("men", 35),
                "https://github.com/marwannaggar", "https://linkedin.com/in/marwannaggar",
                "https://twitter.com/marwannaggar", "https://facebook.com/marwannaggar",
                new() { "Game Development", "2D Games", "Game Design" }, "ar", DefaultPassword),

            new UserProfile(
                "Chloe Dupont", Email("chloe", "dupont", 52), "Certified French Language Teacher & FLE Trainer",
                "Paris, France",
                "Native French instructor with 8 years preparing students for DELF/DALF exams. I use immersion-based interactive communication techniques so students speak naturally from day one.",
                Portrait("women", 65),
                "https://github.com/chloedupont", "https://linkedin.com/in/chloedupont",
                "https://twitter.com/chloedupont", "https://facebook.com/chloedupont",
                new() { "French", "Languages", "Teaching & Academics" }, "en", DefaultPassword),

            new UserProfile(
                "سامي الجيار", Email("samy", "elgayar", 53), "مهندس استشارات DevOps وحاويات Docker",
                "الجيزة، مصر",
                "مهندس بنى تحتية متخصص في أتمتة النشر باستخدام Docker و Kubernetes و Terraform ومراقبة الأنظمة عبر Prometheus و Grafana لضمان تشغيل التطبيقات على مدار الساعة.",
                Portrait("men", 91),
                "https://github.com/samygayar", "https://linkedin.com/in/samygayar",
                "https://twitter.com/samygayar", "https://facebook.com/samygayar",
                new() { "DevOps", "Kubernetes", "CI/CD" }, "ar", DefaultPassword),

            new UserProfile(
                "Amina Touré", Email("amina", "toure", 54), "Digital Transformation & Agile Scrum Coach",
                "Casablanca, Morocco",
                "Certified Scrum Master (PSM III) and Agile coach. I guide engineering leaders and product teams to implement efficient Scrum ceremonies, reduce backlog waste, and deliver faster.",
                Portrait("women", 58),
                "https://github.com/aminatoure", "https://linkedin.com/in/aminatoure",
                "https://twitter.com/aminatoure", "https://facebook.com/aminatoure",
                new() { "Project Management", "Business", "Leadership" }, "en", DefaultPassword),

            new UserProfile(
                "أشرف القاضي", Email("ashraf", "elkady", 55), "مطور ويب أول ومتخصص Laravel و PHP الحديث",
                "المنصورة، مصر",
                "مطور تطبيقات ويب بخبرة 9 سنوات في بناء أنظمة التجارة الإلكترونية ومنصات الدفع باستخدام Laravel و Vue.js و MySQL، مع التركيز على الأمان والأداء العالي.",
                Portrait("men", 18),
                "https://github.com/ashrafkady", "https://linkedin.com/in/ashrafkady",
                "https://twitter.com/ashrafkady", "https://facebook.com/ashrafkady",
                new() { "PHP", "Laravel", "Web Development" }, "ar", DefaultPassword),

            new UserProfile(
                "Jennifer Wu", Email("jennifer", "wu", 56), "Mandarin Chinese Specialist & HSK Instructor",
                "Singapore",
                "Bilingual educator specializing in Business Chinese and standard Mandarin for non-native professionals. Helping learners master pronunciation, tones, and character radicals efficiently.",
                Portrait("women", 22),
                "https://github.com/jenniferwu", "https://linkedin.com/in/jenniferwu",
                "https://twitter.com/jenniferwu", "https://facebook.com/jenniferwu",
                new() { "Chinese", "Languages", "Communication" }, "en", DefaultPassword),

            new UserProfile(
                "حازم العراقي", Email("hazem", "eliraqi", 57), "مدرب مبيعات واستراتيجيات تفاوض صفقات كبرى",
                "دبي، الإمارات",
                "مدير مبيعات إقليمي أدار صفقات B2B بملايين الدولارات. أعلّم محترفي المبيعات أساليب التنقيب، إغلاق الصفقات المعقدة، والتفاوض بحرفية لتعظيم هوامش الربح للشركات.",
                Portrait("men", 48),
                "https://github.com/hazemiraqi", "https://linkedin.com/in/hazemiraqi",
                "https://twitter.com/hazemiraqi", "https://facebook.com/hazemiraqi",
                new() { "Sales", "Negotiation", "Business" }, "ar", DefaultPassword),

            new UserProfile(
                "Dr. Arthur Campbell", Email("arthur", "campbell", 58), "Astrophysicist & Quantum Physics Lecturer",
                "Edinburgh, UK",
                "University lecturer with a passion for demystifying quantum mechanics, relativity, and modern physics through intuitive visual analogies and thought experiments.",
                Portrait("men", 72),
                "https://github.com/arthurcampbell", "https://linkedin.com/in/arthurcampbell",
                "https://twitter.com/arthurcampbell", "https://facebook.com/arthurcampbell",
                new() { "Physics", "Math", "Engineering" }, "en", DefaultPassword),

            new UserProfile(
                "منى السعدني", Email("mona", "elsaadani", 59), "خبيرة تسويق عبر منصات التواصل الاجتماعي والتيك توك",
                "القاهرة، مصر",
                "مديرة حملات تسويق رقمي وإعلانات السوشيال ميديا، ساعدت علامات تجارية رائدة على بناء مجتمعات رقمية نشطة وصناعة محتوى فيديو سريع الانتشار يجلب مبيعات قياسية.",
                Portrait("women", 31),
                "https://github.com/monasaadani", "https://linkedin.com/in/monasaadani",
                "https://twitter.com/monasaadani", "https://facebook.com/monasaadani",
                new() { "Social Media", "Digital Marketing", "Marketing" }, "ar", DefaultPassword),

            new UserProfile(
                "Oliver Schmidt", Email("oliver", "schmidt", 60), "Cloud Security Architect & Zero Trust Specialist",
                "Berlin, Germany",
                "Information security specialist focused on Zero Trust cloud architecture, container hardening, IAM policy governance, and compliance auditing across multi-cloud environments.",
                Portrait("men", 23),
                "https://github.com/oliverschmidt", "https://linkedin.com/in/oliverschmidt",
                "https://twitter.com/oliverschmidt", "https://facebook.com/oliverschmidt",
                new() { "Security", "Cyber Security", "Cloud Computing" }, "en", DefaultPassword),

            new UserProfile(
                "رامي الباز", Email("ramy", "elbaz", 61), "عازف جيتار ومؤلف موسيقى تصويرية",
                "الإسكندرية، مصر",
                "موسيقي محترف ومؤلف مقطوعات للإعلانات والأفلام القصيرة. أعلّم العزف على الجيتار الأكوستيك والكهربائي، قراءة التابات والنوتة الموسيقية، وتكنيك الارتجال الإبداعي.",
                Portrait("men", 80),
                "https://github.com/ramyelbaz", "https://linkedin.com/in/ramyelbaz",
                "https://twitter.com/ramyelbaz", "https://facebook.com/ramyelbaz",
                new() { "Music", "Guitar", "Music Theory" }, "ar", DefaultPassword),

            new UserProfile(
                "Leila Benali", Email("leila", "benali", 62), "Certified Public Accountant & QuickBooks ProAdvisor",
                "Tunis, Tunisia",
                "CPA with 11 years running accounting audits and corporate taxation. I train business owners and junior accountants on automated bookkeeping and financial reporting in QuickBooks.",
                Portrait("women", 51),
                "https://github.com/leilabenali", "https://linkedin.com/in/leilabenali",
                "https://twitter.com/leilabenali", "https://facebook.com/leilabenali",
                new() { "Accounting", "QuickBooks", "Finance & Accounting" }, "en", DefaultPassword),

            new UserProfile(
                "شريف البحيري", Email("sharif", "elbeheiry", 63), "مطور واجهات أمامية متخصص في Vue.js و Nuxt",
                "طنطا، مصر",
                "مطور واجهات أمامية شغوف ببيئة عمل Vue.js و Nuxt 3 و Pinia، أركز على بناء مواقع سريعة جداً لمحركات البحث (SEO Friendly) وبكود معياري نظيف يسهل اختباره.",
                Portrait("men", 53),
                "https://github.com/sharifbeheiry", "https://linkedin.com/in/sharifbeheiry",
                "https://twitter.com/sharifbeheiry", "https://facebook.com/sharifbeheiry",
                new() { "Vue.js", "JavaScript", "Web Development" }, "ar", DefaultPassword),

            new UserProfile(
                "Dr. Maya Lin", Email("maya", "lin", 64), "Organic Chemist & Biochemistry Researcher",
                "Boston, USA",
                "Biochemistry educator with over 10 years of experience teaching pre-med and pharmacy students. Specializing in reaction mechanisms, chemical kinetics, and drug discovery fundamentals.",
                Portrait("women", 79),
                "https://github.com/mayalin", "https://linkedin.com/in/mayalin",
                "https://twitter.com/mayalin", "https://facebook.com/mayalin",
                new() { "Chemistry", "Medicine", "Teaching & Academics" }, "en", DefaultPassword),

            new UserProfile(
                "عادل ممدوح", Email("adel", "mamdouh", 65), "مدرب أدوات الأوفيس وأتمتة جداول البيانات",
                "القاهرة، مصر",
                "مدرب محترف في تطبيقات Microsoft 365 و Google Workspace. أساعد الموظفين والشركات على توفير مئات الساعات شهرياً عبر أتمتة مهام الإكسيل واستخدام معادلات الماكرو المتقدمة.",
                Portrait("men", 73),
                "https://github.com/adelmamdouh", "https://linkedin.com/in/adelmamdouh",
                "https://twitter.com/adelmamdouh", "https://facebook.com/adelmamdouh",
                new() { "Office Productivity", "Excel", "Personal Development" }, "ar", DefaultPassword),

            new UserProfile(
                "Jessica Taylor", Email("jessica", "taylor", 66), "Mindfulness & Mental Health Educator",
                "London, UK",
                "Mental wellbeing consultant and mindfulness facilitator. Teaching evidence-based stress reduction, emotional intelligence, and resilient mindset techniques for modern living.",
                Portrait("women", 37),
                "https://github.com/jessicataylor", "https://linkedin.com/in/jessicataylor",
                "https://twitter.com/jessicataylor", "https://facebook.com/jessicataylor",
                new() { "Personal Development", "Psychology", "Healthy Habits" }, "en", DefaultPassword),

            new UserProfile(
                "تامر الشافعي", Email("tamer", "elshafey", 67), "مطور تطبيقات أندرويد بلغة Kotlin ومكتبة Jetpack Compose",
                "الجيزة، مصر",
                "مطور Android متمرس أعمل مع كبرى شركات التقنية المالية. أعلّم بنية تطبيقات الأندرويد الحديثة وفق معايير Google الرسمية باستخدام Kotlin Coroutines و Compose.",
                Portrait("men", 88),
                "https://github.com/tamershafey", "https://linkedin.com/in/tamershafey",
                "https://twitter.com/tamershafey", "https://facebook.com/tamershafey",
                new() { "Android", "Kotlin", "Mobile Development" }, "ar", DefaultPassword),

            new UserProfile(
                "Hannah Berg", Email("hannah", "berg", 68), "Motion Graphics Designer & After Effects Animator",
                "Stockholm, Sweden",
                "Motion designer creating animated explainers and broadcast graphics for tech giants. I teach motion principles, kinetic typography, and advanced 2D visual effects in After Effects.",
                Portrait("women", 29),
                "https://github.com/hannahberg", "https://linkedin.com/in/hannahberg",
                "https://twitter.com/hannahberg", "https://facebook.com/hannahberg",
                new() { "Graphic Design", "Digital Art", "Design" }, "en", DefaultPassword),

            new UserProfile(
                "عماد خضير", Email("emad", "khodeir", 69), "مستشار التجارة الإلكترونية وإدارة المتاجر الرقمية",
                "القاهرة، مصر",
                "خبير تأسيس وإدارة المتاجر الإلكترونية على Shopify و WooCommerce. دربت أكثر من 1000 تاجر على اختيار المنتجات المربحة، إدارة المخازن، وتحسين معدل التحويل (CRO).",
                Portrait("men", 61),
                "https://github.com/emadkhodeir", "https://linkedin.com/in/emadkhodeir",
                "https://twitter.com/emadkhodeir", "https://facebook.com/emadkhodeir",
                new() { "E-commerce", "Business", "Digital Marketing" }, "ar", DefaultPassword),

            new UserProfile(
                "Sophia Martinez", Email("sophia", "martinez", 70), "Creative Storyteller & Screenwriting Mentor",
                "Madrid, Spain",
                "Screenwriter and creative writing mentor with scripts produced for independent television. I teach character development, narrative arcs, and script formatting that captivates audiences.",
                Portrait("women", 86),
                "https://github.com/sophiamartinez", "https://linkedin.com/in/sophiamartinez",
                "https://twitter.com/sophiamartinez", "https://facebook.com/sophiamartinez",
                new() { "Creative Writing", "Storytelling", "Content Writing" }, "en", DefaultPassword),

            new UserProfile(
                "فادي نصار", Email("fady", "nassar", 71), "مهندس أنظمة مدمجة وبرمجة ميكروكنترولر",
                "بيروت، لبنان",
                "مهندس إلكترونيات وأنظمة مدمجة بخبرة 8 سنوات في برمجة وحدات ARM و STM32 و Arduino بلغات C و C++. شغوف بتعليم إنترنت الأشياء (IoT) والأنظمة الذكية في الوقت الحقيقي.",
                Portrait("men", 26),
                "https://github.com/fadynassar", "https://linkedin.com/in/fadynassar",
                "https://twitter.com/fadynassar", "https://facebook.com/fadynassar",
                new() { "C Programming", "Engineering", "Programming" }, "ar", DefaultPassword),

            new UserProfile(
                "Rachel Adams", Email("rachel", "adams", 72), "Lead Technical Writer & Developer Advocate",
                "Austin, USA",
                "Technical writer with 8 years crafting developer documentation, API references, and architecture guides for open-source frameworks. Teaching clear, accurate technical communication.",
                Portrait("women", 42),
                "https://github.com/racheladams", "https://linkedin.com/in/racheladams",
                "https://twitter.com/racheladams", "https://facebook.com/racheladams",
                new() { "Content Writing", "Communication", "APIs" }, "en", DefaultPassword),

            new UserProfile(
                "ياسر رضوان", Email("yasser", "radwan", 73), "مدرب إدارة الجودة الشاملة وسداسية سيجما Lean Six Sigma",
                "الإسكندرية، مصر",
                "حزام أسود معتمد في Lean Six Sigma بخبرة 15 عاماً في تحسين سلاسل الإمداد وتقليل الهدر في المصانع والشركات الخدمية. أعلّم أدوات الجودة والتحسين المستمر المعتمدة عالمياً.",
                Portrait("men", 34),
                "https://github.com/yasserradwan", "https://linkedin.com/in/yasserradwan",
                "https://twitter.com/yasserradwan", "https://facebook.com/yasserradwan",
                new() { "Professional Training", "Project Management", "Business" }, "ar", DefaultPassword),

            new UserProfile(
                "Emily Watson", Email("emily", "watson", 74), "Corporate Law Advisor & Contract Specialist",
                "Toronto, Canada",
                "Corporate attorney advising tech startups on SaaS contracts, intellectual property rights, data privacy regulations (GDPR), and cross-border vendor negotiation agreements.",
                Portrait("women", 69),
                "https://github.com/emilywatson", "https://linkedin.com/in/emilywatson",
                "https://twitter.com/emilywatson", "https://facebook.com/emilywatson",
                new() { "Law", "Legal Writing", "Business" }, "en", DefaultPassword),

            new UserProfile(
                "حاتم درويش", Email("hatem", "darwish", 75), "خبير هندسة قواعد بيانات NoSQL و MongoDB و Redis",
                "القاهرة، مصر",
                "مهندس معماريات بيانات متقدمة، متخصص في تصميم قواعد البيانات الموزعة عالية التوافر ومحركات الكاشنج المؤقت السريعة لدعم ملايين الطلبات في الثانية بدون تأخير.",
                Portrait("men", 46),
                "https://github.com/hatemdarwish", "https://linkedin.com/in/hatemdarwish",
                "https://twitter.com/hatemdarwish", "https://facebook.com/hatemdarwish",
                new() { "Databases", "DB Admin", "Backend" }, "ar", DefaultPassword),

            new UserProfile(
                "Chloe Bennett", Email("chloe", "bennett", 76), "Certified Clinical Dietitian & Meal Prep Coach",
                "Melbourne, Australia",
                "Clinical dietitian focusing on metabolic health, sustainable dietary changes, and practical meal prepping strategies for busy working professionals and families.",
                Portrait("women", 16),
                "https://github.com/chloebennett", "https://linkedin.com/in/chloebennett",
                "https://twitter.com/chloebennett", "https://facebook.com/chloebennett",
                new() { "Nutrition", "Healthy Habits", "Cooking" }, "en", DefaultPassword),

            new UserProfile(
                "محمود عياد", Email("mahmoud", "ayad", 77), "مصور احترافي ومدرب تصوير بالهواتف الذكية",
                "الجيزة، مصر",
                "مصور فوتوغرافي ومحتوى بصري معتمد، دربت آلاف الهواة وصناع المحتوى على استغلال كاميرا الموبايل لإنتاج صور وفيديوهات سينمائية واحترافية تلفت الأنظار.",
                Portrait("men", 87),
                "https://github.com/mahmoudayad", "https://linkedin.com/in/mahmoudayad",
                "https://twitter.com/mahmoudayad", "https://facebook.com/mahmoudayad",
                new() { "Mobile Photography", "Photography", "Photography & Video" }, "ar", DefaultPassword),

            new UserProfile(
                "Dr. Benjamin Cole", Email("benjamin", "cole", 78), "Neuroscience Researcher & Cognitive Enhancement Coach",
                "Oxford, UK",
                "Neuroscientist exploring brain plasticity, memory enhancement techniques, and optimal sleep architecture for cognitive endurance and learning speed.",
                Portrait("men", 56),
                "https://github.com/benjamincole", "https://linkedin.com/in/benjamincole",
                "https://twitter.com/benjamincole", "https://facebook.com/benjamincole",
                new() { "Psychology", "Personal Development", "Medicine" }, "en", DefaultPassword),

            new UserProfile(
                "أحمد عاشور", Email("ahmed", "ashour", 79), "مطور Full Stack متخصص في Node.js و React و Next.js",
                "المنصورة، مصر",
                "مهندس برمجيات ومطور واجهات وتطبيقات سحابية، متخصص في معمارية Serverless ومكتبة React الحديثة ومحرك Node.js، شغوف ببناء تطبيقات فائقة السرعة ومتوافقة مع الويب الحديث.",
                Portrait("men", 13),
                "https://github.com/ahmedashour", "https://linkedin.com/in/ahmedashour",
                "https://twitter.com/ahmedashour", "https://facebook.com/ahmedashour",
                new() { "React", "Node.js", "Web Development" }, "ar", DefaultPassword),

            new UserProfile(
                "Victoria Stone", Email("victoria", "stone", 80), "Certified Financial Planner & Crypto Asset Analyst",
                "New York, USA",
                "Wall Street financial analyst turned independent educator. I break down digital asset valuation, decentralized finance mechanisms, and macro risk hedging strategies.",
                Portrait("women", 43),
                "https://github.com/victoriastone", "https://linkedin.com/in/victoriastone",
                "https://twitter.com/victoriastone", "https://facebook.com/victoriastone",
                new() { "Crypto", "Investing", "Technical Analysis" }, "en", DefaultPassword),

            new UserProfile(
                "كريم الصاوي", Email("karim", "elsawy", 81), "مهندس معمارية السحابة وإدارة البنية التحتية GCP",
                "القاهرة، مصر",
                "مهندس معتمد Google Cloud Professional Cloud Architect، متخصص في ترحيل الأنظمة الضخمة إلى السحابة، إدارة الشبكات الافتراضية، وحماية البيانات على منصة GCP.",
                Portrait("men", 77),
                "https://github.com/karimsawy", "https://linkedin.com/in/karimsawy",
                "https://twitter.com/karimsawy", "https://facebook.com/karimsawy",
                new() { "Cloud Computing", "Cloud Architecture", "DevOps" }, "ar", DefaultPassword),

            new UserProfile(
                "Zoe Kravitz", Email("zoe", "kravitz", 82), "Illustration Artist & Digital Character Designer",
                "Berlin, Germany",
                "Concept artist illustrating characters for graphic novels and animated shorts. I teach digital painting techniques in Procreate and Photoshop, shading, anatomy, and color theory.",
                Portrait("women", 94),
                "https://github.com/zoekravitz", "https://linkedin.com/in/zoekravitz",
                "https://twitter.com/zoekravitz", "https://facebook.com/zoekravitz",
                new() { "Digital Art", "Illustration", "Graphic Design" }, "en", DefaultPassword),

            new UserProfile(
                "أشرف متولي", Email("ashraf", "metwally", 83), "مدرب لغات برمجة أطفال ومنهجية التفكير الإبداعي",
                "الإسكندرية، مصر",
                "تربوي متخصص في تعليم البرمجة التفاعلية والتفكير الحسابي للأطفال والناشئين باستخدام لغة Scratch و Roblox و Python بطرق تدريبية قائمة على حل الألغاز وصناعة الألعاب.",
                Portrait("men", 92),
                "https://github.com/ashrafmetwally", "https://linkedin.com/in/ashrafmetwally",
                "https://twitter.com/ashrafmetwally", "https://facebook.com/ashrafmetwally",
                new() { "Scratch", "Kids Coding", "Programming" }, "ar", DefaultPassword),

            new UserProfile(
                "Danielle Cooper", Email("danielle", "cooper", 84), "Corporate Communications & Conflict Resolution Coach",
                "Chicago, USA",
                "Executive communications advisor coaching C-level executives in cross-cultural negotiation, crisis communication, and empathetic workplace leadership.",
                Portrait("women", 71),
                "https://github.com/daniellecooper", "https://linkedin.com/in/daniellecooper",
                "https://twitter.com/daniellecooper", "https://facebook.com/daniellecooper",
                new() { "Communication", "Negotiation", "Leadership" }, "en", DefaultPassword),

            new UserProfile(
                "عمرو غنيم", Email("amr", "ghoneim", 85), "مهندس ذكاء اصطناعي وأتمتة العمليات الروبوتية RPA",
                "القاهرة، مصر",
                "مهندس أتمتة متخصص في بناء روبوتات برمجية لتقليل الأعمال الروتينية باستخدام UiPath و Python. أساعد الشركات على زيادة الكفاءة وخفض الأخطاء البشرية بنسبة 90%.",
                Portrait("men", 55),
                "https://github.com/amrghoneim", "https://linkedin.com/in/amrghoneim",
                "https://twitter.com/amrghoneim", "https://facebook.com/amrghoneim",
                new() { "Automation", "AI Basics", "Python" }, "ar", DefaultPassword),

            new UserProfile(
                "Claire Dupont", Email("claire", "dupont", 86), "Master Baker & Artisan Bread Specialist",
                "Lyon, France",
                "Artisan baker specializing in wild sourdough fermentation, viennoiserie, and traditional European bread craft. Bringing the science and sensory art of baking to your kitchen.",
                Portrait("women", 57),
                "https://github.com/clairedupont", "https://linkedin.com/in/clairedupont",
                "https://twitter.com/clairedupont", "https://facebook.com/clairedupont",
                new() { "Cooking", "Pastry", "Culinary" }, "en", DefaultPassword),

            new UserProfile(
                "باهر وجدي", Email("baher", "wagdy", 87), "مهندس صوتيات ومكساج وموسيقى رقمية",
                "القاهرة، مصر",
                "مهندس صوتيات معتمد قمت بمكساج مئات الإعلانات والألبومات الصوتية. أعلّم برامج الهندسة الصوتية Cubase و Pro Tools، معالجة الترددات، وفنون إخراج البودكاست بجودة استوديو.",
                Portrait("men", 39),
                "https://github.com/baherwagdy", "https://linkedin.com/in/baherwagdy",
                "https://twitter.com/baherwagdy", "https://facebook.com/baherwagdy",
                new() { "Music", "Media", "Video Editing" }, "ar", DefaultPassword),

            new UserProfile(
                "Stephanie Meyer", Email("stephanie", "meyer", 88), "Sustainable Fashion Stylist & Wardrobe Consultant",
                "Milan, Italy",
                "Fashion stylist and wardrobe consultant educating clients on timeless capsule wardrobes, personal color analysis, textile quality, and sustainable consumer choices.",
                Portrait("women", 84),
                "https://github.com/stephaniemeyer", "https://linkedin.com/in/stephaniemeyer",
                "https://twitter.com/stephaniemeyer", "https://facebook.com/stephaniemeyer",
                new() { "Styling", "Fashion", "Lifestyle" }, "en", DefaultPassword),

            new UserProfile(
                "محسن زهران", Email("mohsen", "zahran", 89), "أستاذ جغرافيا ونظم معلومات جغرافية GIS",
                "أسيوط، مصر",
                "أستاذ وباحث في نظم المعلومات الجغرافية (GIS) والاستشعار عن بعد. أقدم تدريباً تطبيقياً باستخدام برامج ArcGIS و QGIS لتحليل الخرائط والمواقع الجغرافية للأغراض التنموية.",
                Portrait("men", 67),
                "https://github.com/mohsenzahran", "https://linkedin.com/in/mohsenzahran",
                "https://twitter.com/mohsenzahran", "https://facebook.com/mohsenzahran",
                new() { "Geography", "Teaching & Academics", "History" }, "ar", DefaultPassword),

            new UserProfile(
                "Dr. Nathan Reed", Email("nathan", "reed", 90), "Biomedical Engineer & Medical Device Innovator",
                "Cambridge, UK",
                "Biomedical engineer passionate about the intersection of medicine, sensor technology, and digital healthcare. Delivering courses on physiological monitoring and medical tech trends.",
                Portrait("men", 89),
                "https://github.com/nathanreed", "https://linkedin.com/in/nathanreed",
                "https://twitter.com/nathanreed", "https://facebook.com/nathanreed",
                new() { "Medicine", "Engineering", "Teaching & Academics" }, "en", DefaultPassword),

            new UserProfile(
                "وليد عبد المنعم", Email("waleed", "abdelmonem", 91), "مطور تطبيقات iOS بلغة Swift وتقنية SwiftUI",
                "الجيزة، مصر",
                "مطور iOS أول، طوّرت تطبيقات تجاوز عدد تحميلاتها 5 ملايين مستخدم. أعلّم لغة Swift الحديثة، إطار العمل SwiftUI، وربط التطبيقات بالسحابة واجتياز مراجعات متجر آبل بسهولة.",
                Portrait("men", 16),
                "https://github.com/waleedmonem", "https://linkedin.com/in/waleedmonem",
                "https://twitter.com/waleedmonem", "https://facebook.com/waleedmonem",
                new() { "Mobile Development", "Apple", "Clean Architecture" }, "ar", DefaultPassword),

            new UserProfile(
                "Laura Bishop", Email("laura", "bishop", 92), "Educational Psychologist & Pedagogy Specialist",
                "Dublin, Ireland",
                "Educational consultant helping schools and digital educators design curriculum frameworks that optimize cognitive retention, engagement, and adaptive learning outcomes.",
                Portrait("women", 48),
                "https://github.com/laurabishop", "https://linkedin.com/in/laurabishop",
                "https://twitter.com/laurabishop", "https://facebook.com/laurabishop",
                new() { "Education", "Teaching & Academics", "Psychology" }, "en", DefaultPassword),

            new UserProfile(
                "عصام فكري", Email("essam", "fekry", 93), "مستشار حلول أمان قواعد البيانات والمراجعة الجنائية الرقمية",
                "القاهرة، مصر",
                "خبير أمن قواعد بيانات ومحقق جنائي رقمي، متخصص في تحليل حوادث الاختراق وتتبع تسريب البيانات وتشفير قواعد البيانات المؤسسية الحساسة لحمايتها من التهديدات الداخلية والخارجية.",
                Portrait("men", 65),
                "https://github.com/essamfekry", "https://linkedin.com/in/essamfekry",
                "https://twitter.com/essamfekry", "https://facebook.com/essamfekry",
                new() { "Databases", "Cyber Security", "Security" }, "ar", DefaultPassword),

            new UserProfile(
                "Kimberly Park", Email("kimberly", "park", 94), "Certified Yoga Instructor & Postural Alignment Specialist",
                "Vancouver, Canada",
                "E-RYT 500 yoga educator teaching anatomical alignment, breathwork (pranayama), functional mobility, and mindful movement routines to counteract sedentary desk habits.",
                Portrait("women", 35),
                "https://github.com/kimberlypark", "https://linkedin.com/in/kimberlypark",
                "https://twitter.com/kimberlypark", "https://facebook.com/kimberlypark",
                new() { "Health & Fitness", "Lifestyle", "Sports" }, "en", DefaultPassword),

            new UserProfile(
                "مختار السروجي", Email("mokhtar", "elsorougy", 95), "مدرب كتابة سيناريو وصناعة الأفلام الوثائقية",
                "الإسكندرية، مصر",
                "مخرج وصانع أفلام وثائقية عُرضت أعماله في مهرجانات دولية. أعلّم فن البحث الوثائقي، إجراء المقابلات الحية، كتابة السيناريو الواقعي، وبناء الحبكة الدرامية المؤثرة.",
                Portrait("men", 47),
                "https://github.com/mokhtarsorougy", "https://linkedin.com/in/mokhtarsorougy",
                "https://twitter.com/mokhtarsorougy", "https://facebook.com/mokhtarsorougy",
                new() { "Storytelling", "Content Writing", "Photography & Video" }, "ar", DefaultPassword),

            new UserProfile(
                "Charlotte Green", Email("charlotte", "green", 96), "Interior Architecture & Ergonomic Workspace Designer",
                "Copenhagen, Denmark",
                "Architectural designer specializing in Scandinavian ergonomics, home office optimization, functional lighting design, and sustainable residential space planning.",
                Portrait("women", 53),
                "https://github.com/charlottegreen", "https://linkedin.com/in/charlottegreen",
                "https://twitter.com/charlottegreen", "https://facebook.com/charlottegreen",
                new() { "Interior Design", "Decoration", "Design" }, "en", DefaultPassword),

            new UserProfile(
                "سامح الديب", Email("sameh", "eldeeb", 97), "مطور Full Stack بلغة C# و Blazor و SQL Server",
                "المنصورة، مصر",
                "مطور أنظمة مؤسسية متخصص في تقنية Blazor WebAssembly و .NET 9، أركز على بناء لوحات تحكم ولوحات إدارة داخلية قوية وسريعة تلبي المعايير الأمنية العالية.",
                Portrait("men", 24),
                "https://github.com/samehdeeb", "https://linkedin.com/in/samehdeeb",
                "https://twitter.com/samehdeeb", "https://facebook.com/samehdeeb",
                new() { "C#", "Web Development", "SQL Server" }, "ar", DefaultPassword),

            new UserProfile(
                "Maya Patel", Email("maya", "patel", 98), "Senior Data Engineer & Apache Spark Architect",
                "London, UK",
                "Data platform architect building distributed data lakes, streaming ETL pipelines with Kafka and Spark, and managing cloud data warehouses for enterprise analytics.",
                Portrait("women", 87),
                "https://github.com/mayapatel", "https://linkedin.com/in/mayapatel",
                "https://twitter.com/mayapatel", "https://facebook.com/mayapatel",
                new() { "Data Science", "Databases", "Python" }, "en", DefaultPassword),

            new UserProfile(
                "ماجد النحاس", Email("maged", "elnahas", 99), "خبير إدارة منتجات رقمية Agile Product Manager",
                "القاهرة، مصر",
                "مدير منتجات رقمية أدار خارطة طريق منتجات تقنية تخدم ملايين المستخدمين. أعلّم تحديد أولويات الميزات، كتابة متطلبات المستخدم (User Stories)، ومواءمة الرؤية مع فرق الهندسة والتسويق.",
                Portrait("men", 17),
                "https://github.com/magednahas", "https://linkedin.com/in/magednahas",
                "https://twitter.com/magednahas", "https://facebook.com/magednahas",
                new() { "Product Design", "Project Management", "Business" }, "ar", DefaultPassword),

            new UserProfile(
                "Alexandra Scott", Email("alexandra", "scott", 100), "Senior Brand Strategist & Visual Identity Consultant",
                "London, UK",
                "Brand director helping emerging tech companies discover their core identity, visual language, design system, and brand story for international competitive distinction.",
                Portrait("women", 64),
                "https://github.com/alexandrascott", "https://linkedin.com/in/alexandrascott",
                "https://twitter.com/alexandrascott", "https://facebook.com/alexandrascott",
                new() { "Branding", "Design", "Graphic Design" }, "en", DefaultPassword),

        };
    }
}
