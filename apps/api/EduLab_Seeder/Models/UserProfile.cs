namespace EduLab_Seeder.Models
{
    /// <summary>
    /// Describes a user account to be seeded (instructor or student).
    /// </summary>
    internal sealed record UserProfile(
        string FullName,
        string Email,
        string Title,
        string Location,
        string About,
        string ProfileImageUrl,
        string GitHubUrl,
        string LinkedInUrl,
        string TwitterUrl,
        string FacebookUrl,
        List<string> Subjects,
        string PreferredLanguage,
        string Password);

    /// <summary>
    /// Helpers to build realistic-looking emails and profile portraits.
    /// </summary>
    internal static class UserProfileHelpers
    {
        /// <summary>
        /// The shared password for every seeded account (satisfies Identity policy).
        /// </summary>
        public const string DefaultPassword = "EduLab@123";

        /// <summary>
        /// Publicly hosted realistic person portrait (randomuser.me).
        /// </summary>
        public static string Portrait(string gender, int n) =>
            $"https://randomuser.me/api/portraits/{gender}/{n}.jpg";

        /// <summary>
        /// Builds a unique gmail-style address from a first/last name + counter.
        /// </summary>
        public static string Email(string first, string last, int n) =>
            $"{first.ToLowerInvariant()}.{last.ToLowerInvariant()}{n}@gmail.com";
    }
}