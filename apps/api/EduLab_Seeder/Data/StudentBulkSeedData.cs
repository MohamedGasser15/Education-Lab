using EduLab_Seeder.Models;
using static EduLab_Seeder.Models.UserProfileHelpers;

namespace EduLab_Seeder.Data
{
    /// <summary>
    /// Generates 100 additional realistic student accounts (mix of Arabic & English),
    /// each with a unique email, a real-looking portrait and interest-related subjects.
    /// </summary>
    internal static class StudentBulkSeedData
    {
        private static readonly (string Name, string Latin)[] ArabicMaleNames =
        {
            ("يوسف", "youssef"), ("كريم", "karim"), ("مصطفى", "mostafa"), ("طارق", "tarek"),
            ("هشام", "hesham"), ("سامح", "sameh"), ("وليد", "waleed"), ("ياسر", "yasser"),
            ("رامي", "ramy"), ("شريف", "sharif"), ("عادل", "adel"), ("حسن", "hassan"),
            ("فادي", "fady"), ("مازن", "mazen"), ("مؤمن", "momen"), ("أيمن", "ayman"),
            ("باسم", "basem"), ("ناصر", "naser"), ("حمزة", "hamza"), ("لؤي", "loay")
        };

        private static readonly (string Name, string Latin)[] ArabicFemaleNames =
        {
            ("مريم", "mariam"), ("نور", "nour"), ("منة", "menna"), ("هدير", "hadir"),
            ("أسماء", "asmaa"), ("ريم", "reem"), ("غادة", "ghada"), ("نسمة", "nesma"),
            ("رنا", "rana"), ("دينا", "dina"), ("منى", "mona"), ("شهد", "shahd"),
            ("هنا", "hanna"), ("ملك", "malak"), ("فاطمة", "fatma"), ("ليلى", "laila"),
            ("سلمى", "salma"), ("جنى", "jana"), ("مليكة", "malika"), ("رؤى", "roaa")
        };

        private static readonly (string Name, string Latin)[] ArabicLastNames =
        {
            ("عبد الله", "abdallah"), ("السيد", "elsayed"), ("مصطفى", "mostafa"), ("حسن", "hassan"),
            ("محمود", "mahmoud"), ("الشناوي", "elshinnawy"), ("عادل", "adel"), ("سعيد", "said"),
            ("خليل", "khalil"), ("حمدي", "hamdy"), ("رشاد", "rashad"), ("فؤاد", "fouad"),
            ("نبيل", "nabil"), ("الجندي", "elgendy"), ("النجار", "elnaggar"), ("عطية", "atya"),
            ("سالم", "salem"), ("الصاوي", "elsawy"), ("رجب", "ragab"), ("عاشور", "ashour")
        };

        private static readonly string[] ArabicCities =
        {
            "القاهرة، مصر", "الإسكندرية، مصر", "الجيزة، مصر", "المنصورة، مصر",
            "طنطا، مصر", "أسيوط، مصر", "بورسعيد، مصر", "الزقازيق، مصر"
        };

        private static readonly (string Name, string Latin, string Gender)[] EnglishNames =
        {
            ("David", "david", "men"), ("John", "john", "men"), ("Michael", "michael", "men"),
            ("James", "james", "men"), ("Daniel", "daniel", "men"), ("Liam", "liam", "men"),
            ("Noah", "noah", "men"), ("Lucas", "lucas", "men"), ("Oliver", "oliver", "men"),
            ("Ethan", "ethan", "men"), ("Emma", "emma", "women"), ("Olivia", "olivia", "women"),
            ("Ava", "ava", "women"), ("Sophia", "sophia", "women"), ("Isabella", "isabella", "women"),
            ("Mia", "mia", "women"), ("Amelia", "amelia", "women"), ("Lily", "lily", "women"),
            ("Chloe", "chloe", "women"), ("Ella", "ella", "women")
        };

        private static readonly string[] EnglishLastNames =
        {
            "Smith", "Johnson", "Brown", "Garcia", "Miller", "Davis", "Wilson", "Moore",
            "Taylor", "Anderson", "Thomas", "Jackson"
        };

        private static readonly string[] EnglishCities =
        {
            "London, UK", "Dubai, UAE", "Riyadh, Saudi Arabia", "Amman, Jordan",
            "Casablanca, Morocco", "Tunis, Tunisia", "Doha, Qatar", "Kuwait City, Kuwait"
        };

        private static readonly string[] Subjects =
        {
            "Web Development", "JavaScript", "Python", "Data Science", "Machine Learning",
            "Mobile Development", "Flutter", "Graphic Design", "UI/UX", "Digital Marketing",
            "English", "Cooking", "Photography", "Music", "Finance", "Leadership",
            "Cyber Security", "Cloud Computing", "Databases", "Entrepreneurship"
        };

        public static List<UserProfile> All { get; } = Generate(1500);

        private static List<UserProfile> Generate(int count)
        {
            var rng = new Random(777);
            var profiles = new List<UserProfile>();

            for (var i = 0; i < count; i++)
            {
                var n = 100 + i;
                var isEnglish = rng.Next(100) < 35; // ~35% English, ~65% Arabic

                var subjects = new List<string>
                {
                    Subjects[rng.Next(Subjects.Length)],
                    Subjects[rng.Next(Subjects.Length)]
                }.Distinct().ToList();
                if (subjects.Count < 2) subjects.Add(Subjects[rng.Next(Subjects.Length)]);

                if (isEnglish)
                {
                    var first = EnglishNames[rng.Next(EnglishNames.Length)];
                    var last = EnglishLastNames[rng.Next(EnglishLastNames.Length)];
                    var location = EnglishCities[rng.Next(EnglishCities.Length)];
                    var about = $"Student interested in {string.Join(" and ", subjects).ToLowerInvariant()} and improving my skills.";
                    var email = $"{first.Latin}.{last.ToLowerInvariant()}{n}@gmail.com";

                    profiles.Add(new UserProfile(
                        $"{first.Name} {last}", email, "Student", location, about,
                        Portrait(first.Gender, rng.Next(1, 100)), "", "", "", "",
                        subjects, "en", DefaultPassword));
                }
                else
                {
                    var isMale = rng.Next(100) < 50;
                    var (first, latinFirst) = isMale
                        ? ArabicMaleNames[rng.Next(ArabicMaleNames.Length)]
                        : ArabicFemaleNames[rng.Next(ArabicFemaleNames.Length)];
                    var (last, latinLast) = ArabicLastNames[rng.Next(ArabicLastNames.Length)];
                    var location = ArabicCities[rng.Next(ArabicCities.Length)];
                    var about = $"طالب مهتم بمجال {string.Join(" و ", subjects)} ويتعلم لتحسين مهاراته.";
                    var email = $"{latinFirst}.{latinLast}{n}@gmail.com";

                    profiles.Add(new UserProfile(
                        $"{first} {last}", email, "طالب", location, about,
                        Portrait(isMale ? "men" : "women", rng.Next(1, 100)), "", "", "", "",
                        subjects, "ar", DefaultPassword));
                }
            }

            return profiles;
        }
    }
}