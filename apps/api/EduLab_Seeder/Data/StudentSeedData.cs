using EduLab_Seeder.Models;
using static EduLab_Seeder.Models.UserProfileHelpers;

namespace EduLab_Seeder.Data
{
    /// <summary>
    /// Realistic student accounts. Profiles are lighter than instructors
    /// (no social links) but still look like real learners.
    /// </summary>
    internal static class StudentSeedData
    {
        public static List<UserProfile> All { get; } = new()
        {
            new UserProfile("Yasmeen Khaled", Email("yasmeen", "khaled", 20), "Student", "Cairo, Egypt",
                "Computer science student who loves web development and improving my coding skills.", Portrait("women", 26),
                "", "", "", "", new() { "Web Development", "JavaScript" }, "en", DefaultPassword),

            new UserProfile("Abdallah Fathy", Email("abdallah", "fathy", 21), "Student", "Alexandria, Egypt",
                "Fresh graduate engineer interested in artificial intelligence and data science.", Portrait("men", 56),
                "", "", "", "", new() { "Python", "Data Science" }, "en", DefaultPassword),

            new UserProfile("جنى محمود", Email("jana", "mahmoud", 22), "طالب", "الجيزة، مصر",
                "أدرس إدارة الأعمال وأحب تعلم مهارات التسويق الرقمي.", Portrait("women", 5),
                "", "", "", "", new() { "Marketing", "Business" }, "ar", DefaultPassword),

            new UserProfile("زياد سامي", Email("ziad", "samy", 23), "طالب", "المنصورة، مصر",
                "طالب في كلية الهندسة، شغوف بتطوير الألعاب وتصميمها.", Portrait("men", 2),
                "", "", "", "", new() { "Unity", "Game Design" }, "ar", DefaultPassword),

            new UserProfile("Mariam Essam", Email("mariam", "essam", 24), "Student", "Tanta, Egypt",
                "I love learning foreign languages and improving my English skills.", Portrait("women", 61),
                "", "", "", "", new() { "English", "Languages" }, "en", DefaultPassword),

            new UserProfile("أدهم رمضان", Email("adham", "ramadan", 25), "طالب", "القاهرة، مصر",
                "مطور واجهات أمامية مبتدئ، أتعلم React وأحلم بأن أصبح مطور Full Stack.", Portrait("men", 29),
                "", "", "", "", new() { "React", "Frontend" }, "ar", DefaultPassword),

            new UserProfile("Laila Samir", Email("laila", "samir", 26), "Student", "Alexandria, Egypt",
                "Pharmacy student interested in communication and leadership skills.", Portrait("women", 83),
                "", "", "", "", new() { "Communication", "Leadership" }, "en", DefaultPassword),

            new UserProfile("معاذ ناصر", Email("moaz", "naser", 27), "طالب", "الجيزة، مصر",
                "أدرس علوم الحاسب، أهتم بأمن المعلومات وتعلم اختبار الاختراق.", Portrait("men", 13),
                "", "", "", "", new() { "Cyber Security", "Networking" }, "ar", DefaultPassword),

            new UserProfile("هنا أشرف", Email("hana", "ashraf", 28), "طالب", "القاهرة، مصر",
                "أحب التصميم الجرافيكي وأتعلم Adobe Photoshop و Illustrator.", Portrait("women", 47),
                "", "", "", "", new() { "Graphic Design", "Photoshop" }, "ar", DefaultPassword),

            new UserProfile("Youssef Hamdy", Email("youssef", "hamdy", 29), "Student", "Mansoura, Egypt",
                "Interested in investing and trading, learning financial analysis and portfolio management.", Portrait("men", 67),
                "", "", "", "", new() { "Finance", "Investing" }, "en", DefaultPassword),

            new UserProfile("Malak Said", Email("malak", "said", 30), "Student", "Alexandria, Egypt",
                "High school student learning programming from scratch, started with Python.", Portrait("women", 12),
                "", "", "", "", new() { "Python", "Programming Basics" }, "en", DefaultPassword),

            new UserProfile("فهد الجارحي", Email("fahd", "elgarhy", 31), "طالب", "القاهرة، مصر",
                "أعمل في مجال المبيعات وأطور مهاراتي في التفاوض والإقناع.", Portrait("men", 91),
                "", "", "", "", new() { "Sales", "Negotiation" }, "ar", DefaultPassword),

            new UserProfile("Reham Ahmed", Email("reham", "ahmed", 32), "Student", "Giza, Egypt",
                "Architecture engineer learning 3D design and modeling tools.", Portrait("women", 42),
                "", "", "", "", new() { "3D Design", "Architecture" }, "en", DefaultPassword),

            new UserProfile("مازن أشرف", Email("mazen", "ashraf", 33), "طالب", "طنطا، مصر",
                "أهوى التصوير الفوتوغرافي وأتعلم أساسيات الكاميرا والمونتاج.", Portrait("men", 18),
                "", "", "", "", new() { "Photography", "Video Editing" }, "ar", DefaultPassword),

            new UserProfile("سلمى عطية", Email("salma", "atya", 34), "طالب", "الإسكندرية، مصر",
                "أتعلم أساسيات الطبخ والمطبخ العالمي لأنني أحلم بافتتاح مطعم خاص بي.", Portrait("women", 7),
                "", "", "", "", new() { "Cooking", "Culinary" }, "ar", DefaultPassword),

            new UserProfile("Omar El-Naggar", Email("omar", "elnaggar", 35), "Student", "Cairo, Egypt",
                "Business school student improving my accounting and financial analysis skills.", Portrait("men", 72),
                "", "", "", "", new() { "Accounting", "Finance" }, "en", DefaultPassword),

            new UserProfile("آية سيد", Email("aya", "sayd", 36), "طالب", "الجيزة، مصر",
                "أحب الكتابة والمحتوى، أتعلم كتابة المحتوى التسويقي و SEO.", Portrait("women", 36),
                "", "", "", "", new() { "Content Writing", "SEO" }, "ar", DefaultPassword),

            new UserProfile("محمد جمال", Email("mohamed", "gamal", 37), "طالب", "المنصورة، مصر",
                "مصمم واجهات مستخدم مبتدئ، أتعلم Figma ومبادئ تجربة المستخدم.", Portrait("men", 8),
                "", "", "", "", new() { "UI/UX", "Figma" }, "ar", DefaultPassword),

            new UserProfile("Shahd Tarek", Email("shahd", "tarek", 38), "Student", "Alexandria, Egypt",
                "Studying data science and learning the math and statistics behind machine learning.", Portrait("women", 88),
                "", "", "", "", new() { "Statistics", "Math", "Machine Learning" }, "en", DefaultPassword),

            new UserProfile("حسن عوض", Email("hassan", "awad", 39), "طالب", "القاهرة، مصر",
                "مهتم بصحتي ولياقتي، أتابع دورات التغذية والرياضة.", Portrait("men", 26),
                "", "", "", "", new() { "Health & Fitness", "Nutrition" }, "ar", DefaultPassword),

            new UserProfile("Norhan Yahya", Email("norhan", "yahya", 40), "Student", "Giza, Egypt",
                "I love music and I'm learning to play the piano and music theory.", Portrait("women", 29),
                "", "", "", "", new() { "Music", "Piano" }, "en", DefaultPassword),

            new UserProfile("كريم شعبان", Email("karim", "shabaan", 41), "طالب", "طنطا، مصر",
                "أتعلم أساسيات الحوسبة السحابية وأستعد لشهادة AWS Practitioner.", Portrait("men", 58),
                "", "", "", "", new() { "AWS", "Cloud Computing" }, "ar", DefaultPassword),

            new UserProfile("Hadir Sabry", Email("hadir", "sabry", 42), "Student", "Alexandria, Egypt",
                "Medical student interested in presentation and communication skills.", Portrait("women", 58),
                "", "", "", "", new() { "Presentation", "Communication" }, "en", DefaultPassword),

            new UserProfile("أيمن رمزي", Email("ayman", "ramzy", 43), "طالب", "القاهرة، مصر",
                "مطور مواقع مبتدئ، أتعلم HTML و CSS و JavaScript من الأساسيات.", Portrait("men", 37),
                "", "", "", "", new() { "HTML", "CSS", "JavaScript" }, "ar", DefaultPassword),

            new UserProfile("صفاء الدين محمود", Email("safaa", "mahmoud", 44), "طالب", "الجيزة، مصر",
                "مهتم بتعلم اللغة العربية وأساسيات النحو والإملاء الصحيح.", Portrait("women", 70),
                "", "", "", "", new() { "Arabic", "Writing" }, "ar", DefaultPassword),

            new UserProfile("مؤمن عصام", Email("momen", "essam", 45), "طالب", "المنصورة، مصر",
                "أتعلم أساسيات قواعد البيانات و SQL لأصبح مطور Backend.", Portrait("men", 49),
                "", "", "", "", new() { "SQL", "Databases" }, "ar", DefaultPassword),

            new UserProfile("Dima Hatem", Email("dima", "hateam", 46), "Student", "Alexandria, Egypt",
                "Studying personal development and time management to achieve my academic goals.", Portrait("women", 64),
                "", "", "", "", new() { "Personal Development", "Productivity" }, "en", DefaultPassword),

            new UserProfile("باسم عادل", Email("basem", "adel", 47), "طالب", "القاهرة، مصر",
                "مهتم بالتاريخ والجغرافيا، أحب الاطلاع على الحضارات القديمة.", Portrait("men", 74),
                "", "", "", "", new() { "History", "Geography" }, "ar", DefaultPassword),

            new UserProfile("ميار عبد الوهاب", Email("mayar", "abdelwahab", 48), "طالب", "الجيزة، مصر",
                "أتعلم مهارات الريادة والتفكير الإبداعي لأطلق مشروعي الخاص.", Portrait("women", 15),
                "", "", "", "", new() { "Entrepreneurship", "Creativity" }, "ar", DefaultPassword),

            new UserProfile("طه عادل", Email("taha", "adel", 65), "طالب", "القاهرة، مصر",
                "أدرس هندسة البرمجيات وأتعلم مبادئ التصميم الكائني و SOLID.", Portrait("men", 33),
                "", "", "", "", new() { "Software Engineering", "OOP" }, "ar", DefaultPassword),

            new UserProfile("Joudy Sameh", Email("joudy", "sameh", 66), "Student", "Alexandria, Egypt",
                "I love digital art and learning drawing and illustration basics on the iPad.", Portrait("women", 33),
                "", "", "", "", new() { "Digital Art", "Illustration" }, "en", DefaultPassword),

            new UserProfile("مهاب نبيل", Email("mohab", "nabil", 67), "طالب", "الجيزة، مصر",
                "طالب ثانوي مهتم بالذكاء الاصطناعي وأتعلم أساسيات التعلم الآلي.", Portrait("men", 6),
                "", "", "", "", new() { "Machine Learning", "AI Basics" }, "ar", DefaultPassword),

            new UserProfile("فريدة حسن", Email("farida", "hassan", 68), "طالب", "طنطا، مصر",
                "أدرس القانون وأطور مهاراتي في الكتابة القانونية والبحث.", Portrait("women", 54),
                "", "", "", "", new() { "Law", "Legal Writing" }, "ar", DefaultPassword),

            new UserProfile("عبد الرحمن خليل", Email("abdelrahman", "khalil", 69), "طالب", "المنصورة، مصر",
                "مطور تطبيقات اندرويد مبتدئ، أتعلم Kotlin و Jetpack Compose.", Portrait("men", 68),
                "", "", "", "", new() { "Kotlin", "Android" }, "ar", DefaultPassword),

            new UserProfile("نادية شوقي", Email("nadia", "shawky", 70), "طالب", "القاهرة، مصر",
                "أدرس التصميم الجرافيكي وأتخصص في تصميم الهوية التجارية.", Portrait("women", 81),
                "", "", "", "", new() { "Branding", "Graphic Design" }, "ar", DefaultPassword),

            new UserProfile("Loay Tarek", Email("loay", "tarek", 71), "Student", "Alexandria, Egypt",
                "Interested in e-commerce and learning how to build stores and manage products.", Portrait("men", 79),
                "", "", "", "", new() { "E-commerce", "Business" }, "en", DefaultPassword),

            new UserProfile("تسنيم وائل", Email("tasneem", "wael", 72), "طالب", "الجيزة، مصر",
                "أتعلم أساسيات التصوير الفوتوغرافي بالهاتف وتحرير الصور.", Portrait("women", 1),
                "", "", "", "", new() { "Photography", "Mobile Photography" }, "ar", DefaultPassword),

            new UserProfile("ياسين صلاح", Email("yassen", "salah", 73), "طالب", "القاهرة، مصر",
                "أدرس نظم المعلومات وأتعلم إدارة قواعد البيانات و SQL.", Portrait("men", 16),
                "", "", "", "", new() { "Databases", "SQL", "DB Admin" }, "ar", DefaultPassword),

            new UserProfile("لمى عصام", Email("lama", "essam", 74), "طالب", "الإسكندرية، مصر",
                "أحب الكتابة الإبداعية وأتعلم فن كتابة الروايات والقصص القصيرة.", Portrait("women", 30),
                "", "", "", "", new() { "Creative Writing", "Storytelling" }, "ar", DefaultPassword),

            new UserProfile("أنس عمرو", Email("anas", "amr", 75), "طالب", "المنصورة، مصر",
                "مهتم بالتداول في العملات الرقمية وأتعلم أساسيات التحليل الفني.", Portrait("men", 53),
                "", "", "", "", new() { "Crypto", "Technical Analysis" }, "ar", DefaultPassword),

            new UserProfile("مليكة رشاد", Email("malika", "rashad", 76), "طالب", "الجيزة، مصر",
                "أدرس التمريض وأطور مهاراتي في التواصل مع المرضى.", Portrait("women", 61),
                "", "", "", "", new() { "Communication", "Healthcare" }, "ar", DefaultPassword),

            new UserProfile("حمدي رزق", Email("hamdy", "rezq", 77), "طالب", "القاهرة، مصر",
                "معلم لغة عربية، أتعلم طرق التدريس الحديثة وإدارة الفصول.", Portrait("men", 91),
                "", "", "", "", new() { "Teaching", "Education" }, "ar", DefaultPassword),

            new UserProfile("سيرين عادل", Email("seren", "adel", 78), "طالب", "الإسكندرية، مصر",
                "أحب العزف على الجيتار وأتعلم نظرية الموسيقى من الصفر.", Portrait("women", 20),
                "", "", "", "", new() { "Guitar", "Music Theory" }, "ar", DefaultPassword),

            new UserProfile("إبراهيم هشام", Email("ibrahim", "hesham", 79), "طالب", "طنطا، مصر",
                "مطور Node.js مبتدئ، أتعلم بناء APIs وتطوير الخوادم.", Portrait("men", 84),
                "", "", "", "", new() { "Node.js", "Backend", "APIs" }, "ar", DefaultPassword),

            new UserProfile("Maria Gorg", Email("maria", "gorg", 80), "Student", "Cairo, Egypt",
                "Studying accounting and learning QuickBooks and accounting automation.", Portrait("women", 44),
                "", "", "", "", new() { "Accounting", "QuickBooks" }, "en", DefaultPassword),

            new UserProfile("زياد كمال", Email("ziad", "kamal", 81), "طالب", "الجيزة، مصر",
                "مهتم بريادة الأعمال وأتعلم بناء نموذج العمل التجاري.", Portrait("men", 55),
                "", "", "", "", new() { "Startups", "Business Model" }, "ar", DefaultPassword),

            new UserProfile("ندى عاصم", Email("nada", "assem", 82), "طالب", "الإسكندرية، مصر",
                "أدرس اللغة الصينية وأتعلم أساسيات المحادثة اليومية.", Portrait("women", 32),
                "", "", "", "", new() { "Chinese", "Languages" }, "ar", DefaultPassword),

            new UserProfile("معتز شريف", Email("moataz", "sharif", 83), "طالب", "المنصورة، مصر",
                "أتعلم تطوير الويب باستخدام PHP و Laravel لبناء تطبيقات متكاملة.", Portrait("men", 20),
                "", "", "", "", new() { "PHP", "Laravel" }, "ar", DefaultPassword),

            new UserProfile("برلنتي فؤاد", Email("berlanty", "fouad", 84), "طالب", "القاهرة، مصر",
                "أحب اللياقة البدنية وأتعلم التمارين المنزلية والتغذية الصحية.", Portrait("women", 56),
                "", "", "", "", new() { "Fitness", "Home Workout" }, "ar", DefaultPassword),

            new UserProfile("آدم سمير", Email("adam", "samir", 85), "طالب", "الجيزة، مصر",
                "طالب في كلية الإعلام، أتعلم صناعة الفيديو والمونتاج.", Portrait("men", 36),
                "", "", "", "", new() { "Video Editing", "Media" }, "ar", DefaultPassword),

            new UserProfile("جنى ناصر", Email("jana", "naser", 86), "طالب", "الإسكندرية، مصر",
                "أدرس علم النفس وأحب التعرف على تحليل الشخصية.", Portrait("women", 89),
                "", "", "", "", new() { "Psychology", "Personality" }, "ar", DefaultPassword),

            new UserProfile("حسام رمضان", Email("hosam", "ramadan", 87), "طالب", "القاهرة، مصر",
                "مهندس ميكانيكا، أتعلم البرمجة وأساسيات التحكم الآلي.", Portrait("men", 63),
                "", "", "", "", new() { "Automation", "C Programming" }, "ar", DefaultPassword),

            new UserProfile("شروق عبد الله", Email("shorouk", "abdallah", 88), "طالب", "الجيزة، مصر",
                "أتعلم مهارات إدارة المشاريع وأستعد لشهادة CAPM.", Portrait("women", 10),
                "", "", "", "", new() { "Project Management", "CAPM" }, "ar", DefaultPassword),

            new UserProfile("بسنت هاني", Email("basant", "hany", 89), "طالب", "الإسكندرية، مصر",
                "أحب تصميم الديكور الداخلي وأتعلم أساسياته وأدواته.", Portrait("women", 8),
                "", "", "", "", new() { "Interior Design", "Decoration" }, "ar", DefaultPassword),

            new UserProfile("ريم حسن", Email("reem", "hassan", 94), "طالب", "القاهرة، مصر",
                "أدرس التصميم الداخلي وأتعلم استخدام برنامج AutoCAD للرسم الهندسي.", Portrait("women", 62),
                "", "", "", "", new() { "AutoCAD", "Interior Design" }, "ar", DefaultPassword),

            new UserProfile("مروان فكري", Email("marwan", "fikry", 95), "طالب", "الجيزة، مصر",
                "مطور ألعاب مبتدئ، أتعلم أساسيات Unity وبرمجة الألعاب ثنائية الأبعاد.", Portrait("men", 40),
                "", "", "", "", new() { "Unity", "2D Games", "C#" }, "ar", DefaultPassword),

            new UserProfile("رؤى محسن", Email("roaa", "mohsen", 96), "طالب", "الإسكندرية، مصر",
                "أحب تعلم اللغة الفرنسية والتحدث بطلاقة مع الناطقين بها.", Portrait("women", 91),
                "", "", "", "", new() { "French", "Languages" }, "ar", DefaultPassword),

            new UserProfile("زياد رمضان", Email("ziad", "ramadan", 97), "طالب", "طنطا، مصر",
                "أهتم بتعلم أساسيات الحساب الذهني والأرقام السريعة.", Portrait("men", 31),
                "", "", "", "", new() { "Mental Math", "Numbers" }, "ar", DefaultPassword),

            new UserProfile("حنين أشرف", Email("hanin", "ashraf", 98), "طالب", "المنصورة، مصر",
                "أتعلم أساسيات الخياطة وتصميم الملابس لصنع مشاريعي الخاصة.", Portrait("women", 5),
                "", "", "", "", new() { "Sewing", "Fashion" }, "ar", DefaultPassword),
        };
    }
}