using EduLab_Domain.Entities;

namespace EduLab_Seeder.Data
{
    /// <summary>
    /// The full category list. Mirrors DbInitializer.SeedCategories exactly
    /// (same names, same English keys) so categories stay consistent.
    /// </summary>
    internal static class CategorySeedData
    {
        public static List<Category> All { get; } = new()
        {
            new Category { Category_Name = "برمجة", Category_EnglishName = "Programming" },
            new Category { Category_Name = "تطوير الويب", Category_EnglishName = "Web Development" },
            new Category { Category_Name = "تطوير تطبيقات الموبايل", Category_EnglishName = "Mobile Development" },
            new Category { Category_Name = "تطوير الألعاب", Category_EnglishName = "Game Development" },
            new Category { Category_Name = "هندسة البرمجيات", Category_EnglishName = "Software Engineering" },
            new Category { Category_Name = "DevOps", Category_EnglishName = "DevOps" },
            new Category { Category_Name = "علوم البيانات", Category_EnglishName = "Data Science" },
            new Category { Category_Name = "تحليل البيانات", Category_EnglishName = "Data Analysis" },
            new Category { Category_Name = "التعلم الآلي", Category_EnglishName = "Machine Learning" },
            new Category { Category_Name = "الذكاء الاصطناعي", Category_EnglishName = "Artificial Intelligence" },
            new Category { Category_Name = "قواعد البيانات", Category_EnglishName = "Databases" },
            new Category { Category_Name = "تقنية المعلومات", Category_EnglishName = "IT & Software" },
            new Category { Category_Name = "أمن المعلومات", Category_EnglishName = "Cyber Security" },
            new Category { Category_Name = "الشبكات", Category_EnglishName = "Networking" },
            new Category { Category_Name = "الحوسبة السحابية", Category_EnglishName = "Cloud Computing" },
            new Category { Category_Name = "أعمال", Category_EnglishName = "Business" },
            new Category { Category_Name = "ريادة الأعمال", Category_EnglishName = "Entrepreneurship" },
            new Category { Category_Name = "إدارة المشاريع", Category_EnglishName = "Project Management" },
            new Category { Category_Name = "المبيعات", Category_EnglishName = "Sales" },
            new Category { Category_Name = "التسويق", Category_EnglishName = "Marketing" },
            new Category { Category_Name = "التسويق الرقمي", Category_EnglishName = "Digital Marketing" },
            new Category { Category_Name = "المالية والمحاسبة", Category_EnglishName = "Finance & Accounting" },
            new Category { Category_Name = "الاستثمار", Category_EnglishName = "Investing" },
            new Category { Category_Name = "إنتاجية المكتب", Category_EnglishName = "Office Productivity" },
            new Category { Category_Name = "التنمية الشخصية", Category_EnglishName = "Personal Development" },
            new Category { Category_Name = "القيادة", Category_EnglishName = "Leadership" },
            new Category { Category_Name = "التواصل", Category_EnglishName = "Communication" },
            new Category { Category_Name = "التفاوض", Category_EnglishName = "Negotiation" },
            new Category { Category_Name = "تصميم", Category_EnglishName = "Design" },
            new Category { Category_Name = "تصميم الجرافيك", Category_EnglishName = "Graphic Design" },
            new Category { Category_Name = "تصميم واجهات المستخدم", Category_EnglishName = "UI/UX Design" },
            new Category { Category_Name = "نشر التصميمات", Category_EnglishName = "Design Tools" },
            new Category { Category_Name = "نمط الحياة", Category_EnglishName = "Lifestyle" },
            new Category { Category_Name = "الموضة", Category_EnglishName = "Fashion" },
            new Category { Category_Name = "الطبخ", Category_EnglishName = "Cooking" },
            new Category { Category_Name = "الصحة واللياقة", Category_EnglishName = "Health & Fitness" },
            new Category { Category_Name = "التغذية", Category_EnglishName = "Nutrition" },
            new Category { Category_Name = "الرياضة", Category_EnglishName = "Sports" },
            new Category { Category_Name = "التصوير والفيديو", Category_EnglishName = "Photography & Video" },
            new Category { Category_Name = "الموسيقى", Category_EnglishName = "Music" },
            new Category { Category_Name = "التعليم والأكاديميات", Category_EnglishName = "Teaching & Academics" },
            new Category { Category_Name = "الهندسة", Category_EnglishName = "Engineering" },
            new Category { Category_Name = "الرياضيات", Category_EnglishName = "Math" },
            new Category { Category_Name = "الفيزياء", Category_EnglishName = "Physics" },
            new Category { Category_Name = "الكيمياء", Category_EnglishName = "Chemistry" },
            new Category { Category_Name = "الطب", Category_EnglishName = "Medicine" },
            new Category { Category_Name = "القانون", Category_EnglishName = "Law" },
            new Category { Category_Name = "علم النفس", Category_EnglishName = "Psychology" },
            new Category { Category_Name = "التاريخ", Category_EnglishName = "History" },
            new Category { Category_Name = "الجغرافيا", Category_EnglishName = "Geography" },
            new Category { Category_Name = "لغات", Category_EnglishName = "Languages" },
            new Category { Category_Name = "اللغة الإنجليزية", Category_EnglishName = "English Language" },
            new Category { Category_Name = "اللغة العربية", Category_EnglishName = "Arabic Language" },
            new Category { Category_Name = "كتابة المحتوى", Category_EnglishName = "Content Writing" },
            new Category { Category_Name = "التدريب المهني", Category_EnglishName = "Professional Training" }
        };
    }
}