namespace EduLab_MVC.Common
{
    public class LanguageEntry
    {
        public string Code { get; set; } = "";
        public string ArabicName { get; set; } = "";
        public string EnglishName { get; set; } = "";
    }

    public static class LanguageData
    {
        private static readonly List<LanguageEntry> _languages = new()
        {
            new() { Code = "ar", ArabicName = "العربية",        EnglishName = "Arabic" },
            new() { Code = "en", ArabicName = "الإنجليزية",      EnglishName = "English" },
            new() { Code = "fr", ArabicName = "الفرنسية",       EnglishName = "French" },
            new() { Code = "es", ArabicName = "الإسبانية",      EnglishName = "Spanish" },
            new() { Code = "de", ArabicName = "الألمانية",      EnglishName = "German" },
            new() { Code = "it", ArabicName = "الإيطالية",      EnglishName = "Italian" },
            new() { Code = "pt", ArabicName = "البرتغالية",     EnglishName = "Portuguese" },
            new() { Code = "ru", ArabicName = "الروسية",        EnglishName = "Russian" },
            new() { Code = "zh", ArabicName = "الصينية",        EnglishName = "Chinese" },
            new() { Code = "ja", ArabicName = "اليابانية",      EnglishName = "Japanese" },
            new() { Code = "ko", ArabicName = "الكورية",        EnglishName = "Korean" },
            new() { Code = "tr", ArabicName = "التركية",        EnglishName = "Turkish" },
            new() { Code = "nl", ArabicName = "الهولندية",      EnglishName = "Dutch" },
            new() { Code = "pl", ArabicName = "البولندية",      EnglishName = "Polish" },
            new() { Code = "vi", ArabicName = "الفيتنامية",     EnglishName = "Vietnamese" },
            new() { Code = "id", ArabicName = "الإندونيسية",    EnglishName = "Indonesian" },
            new() { Code = "ms", ArabicName = "الملايوية",      EnglishName = "Malay" },
            new() { Code = "hi", ArabicName = "الهندية",        EnglishName = "Hindi" },
            new() { Code = "ur", ArabicName = "الأردية",        EnglishName = "Urdu" },
            new() { Code = "uk", ArabicName = "الأوكرانية",     EnglishName = "Ukrainian" },
        };

        public static List<LanguageEntry> GetAll() => _languages;
    }
}
