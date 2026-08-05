namespace EduLab_MVC.Common
{
    public static class LevelData
    {
        public static readonly List<(string Code, string ArabicName, string EnglishName)> Levels = new()
        {
        ("beginner",     "مبتدئ",          "Beginner"),
        ("intermediate", "متوسط",          "Intermediate"),
        ("advanced",     "متقدم",          "Advanced"),
        };
    }
}
