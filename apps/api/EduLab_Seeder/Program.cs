        using EduLab_Domain;
using EduLab_Domain.Entities;
using EduLab_Infrastructure.DB;
using EduLab_Seeder.Services;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace EduLab_Seeder
{
    /// <summary>
    /// Entry point for the EduLab seeder. Reads the connection string, wires up
    /// EF Core + Identity (same setup as the API), then runs the seed engine.
    /// </summary>
    internal static class Program
    {
        private static async Task Main(string[] args)
        {
            Console.OutputEncoding = System.Text.Encoding.UTF8;

            if (args.Contains("--verify", StringComparer.OrdinalIgnoreCase))
            {
                Console.WriteLine("=== VERIFYING SEED DATA ===");
                var instructors = Data.InstructorSeedData.All;
                Console.WriteLine($"Instructors count: {instructors.Count}");
                var distinctEmails = instructors.Select(i => i.Email).Distinct().Count();
                Console.WriteLine($"Distinct emails: {distinctEmails}");
                if (instructors.Count != distinctEmails)
                {
                    Console.WriteLine("ERROR: Duplicate instructor emails detected!");
                    return;
                }

                var categories = Data.CategorySeedData.All;
                Console.WriteLine($"Categories count: {categories.Count}");

                var rng = new Random(12345);
                var allCourses = new List<Course>();
                foreach (var inst in instructors)
                {
                    var user = new ApplicationUser
                    {
                        Id = Guid.NewGuid().ToString(),
                        FullName = inst.FullName,
                        Email = inst.Email,
                        PreferredLanguage = inst.PreferredLanguage,
                        Subjects = inst.Subjects
                    };
                    var cat = Data.CourseSeedData.PickCategory(categories, user);
                    var courses = Data.CourseSeedData.GenerateForInstructor(user, cat, 10, rng);
                    allCourses.AddRange(courses);
                }

                Console.WriteLine($"Generated courses count: {allCourses.Count}");
                var distinctTitles = allCourses.Select(c => c.Title).Distinct().Count();
                Console.WriteLine($"Distinct course titles: {distinctTitles}");
                if (allCourses.Count != distinctTitles)
                {
                    Console.WriteLine($"ERROR: Title duplicates found! {allCourses.Count - distinctTitles} duplicates.");
                    return;
                }

                var distinctShortDesc = allCourses.Select(c => c.ShortDescription).Distinct().Count();
                Console.WriteLine($"Distinct short descriptions: {distinctShortDesc}");

                var distinctDesc = allCourses.Select(c => c.Description).Distinct().Count();
                Console.WriteLine($"Distinct full descriptions: {distinctDesc}");

                var allHaveSections = allCourses.All(c => c.Sections.Count == 4);
                var allHaveLectures = allCourses.All(c => c.Sections.All(s => s.Lectures.Count == 10));
                Console.WriteLine($"All courses have 4 sections: {allHaveSections}");
                Console.WriteLine($"All sections have 10 lectures: {allHaveLectures}");
                Console.WriteLine("=== VERIFICATION PASSED SUCCESSFULLY! ===");
                return;
            }

            var config = new ConfigurationBuilder()
                .SetBasePath(AppContext.BaseDirectory)
                .AddJsonFile("appsettings.json", optional: true, reloadOnChange: false)
                .AddEnvironmentVariables()
                .Build();

            var connectionString = config.GetConnectionString("DefaultConnectionString");
            if (string.IsNullOrWhiteSpace(connectionString))
            {
                Console.WriteLine("Connection string not found. Pass it via --connection \"...\" or appsettings.json.");
                return;
            }

            var services = new ServiceCollection();
            services.AddLogging();
            services.AddDbContext<ApplicationDbContext>(options =>
                options.UseSqlServer(connectionString));

            services.AddIdentity<ApplicationUser, ApplicationRole>(options =>
            {
                options.Password.RequireDigit = true;
                options.Password.RequiredLength = 8;
                options.Password.RequireNonAlphanumeric = false;
                options.Password.RequireUppercase = true;
                options.Password.RequireLowercase = false;
                options.User.RequireUniqueEmail = true;
            })
            .AddEntityFrameworkStores<ApplicationDbContext>()
            .AddDefaultTokenProviders();

            var provider = services.BuildServiceProvider();
            var db = provider.GetRequiredService<ApplicationDbContext>();
            var userManager = provider.GetRequiredService<UserManager<ApplicationUser>>();
            var roleManager = provider.GetRequiredService<RoleManager<ApplicationRole>>();

            if (args.Contains("--fix-users", StringComparer.OrdinalIgnoreCase))
            {
                await SeedEngine.FixCorruptedUserProfilesAsync(db);
                return;
            }

            if (args.Contains("--expand-students", StringComparer.OrdinalIgnoreCase))
            {
                Console.WriteLine("Step 1: Adding 291 students (to reach 1000 total students)...");
                await SeedEngine.SeedAdditionalStudentsAsync(db, userManager, 291);

                Console.WriteLine("\nStep 2: Activating 450 students with enrollments, payments, ratings & progress...");
                await SeedEngine.ActivateAdditionalStudentsAsync(db, 450);

                Console.WriteLine("\nStep 3: Verification & Statistics:");
                args = new[] { "--stats" };
            }

            if (args.Contains("--stats", StringComparer.OrdinalIgnoreCase))
            {
                var totalUsers = await db.Users.CountAsync();
                var userRoles = await db.UserRoles.ToListAsync();
                var roles = await db.Roles.ToDictionaryAsync(r => r.Id, r => r.Name ?? "Unknown");

                var usersByRole = userRoles
                    .GroupBy(ur => roles.TryGetValue(ur.RoleId, out var name) ? name : "Unknown")
                    .ToDictionary(g => g.Key, g => g.Count());

                var studentRole = await db.Roles.FirstOrDefaultAsync(r => r.Name == "Student");
                var studentUserIds = studentRole != null
                    ? (await db.UserRoles.Where(ur => ur.RoleId == studentRole.Id).Select(ur => ur.UserId).ToListAsync()).ToHashSet()
                    : new HashSet<string>();

                var enrollments = await db.Enrollments.Select(e => new { e.Id, e.UserId, e.CourseId }).ToListAsync();
                var enrolledUserIds = enrollments.Select(e => e.UserId).Distinct().ToHashSet();

                var certificates = await db.CourseCertificates.Select(c => new { c.Id, c.EnrollmentId }).ToListAsync();
                var certEnrollmentIds = certificates.Select(c => c.EnrollmentId).ToHashSet();
                var certifiedUserIds = enrollments.Where(e => certEnrollmentIds.Contains(e.Id)).Select(e => e.UserId).Distinct().ToHashSet();

                var ratings = await db.Ratings.Select(r => new { r.Id, r.UserId, r.CourseId, r.Value }).ToListAsync();
                var ratingUserIds = ratings.Select(r => r.UserId).Distinct().ToHashSet();

                var reviews = await db.Reviews.Select(r => new { r.Id, r.UserId, r.CourseId, r.Comment }).ToListAsync();
                var reviewUserIds = reviews.Select(r => r.UserId).Distinct().ToHashSet();

                var progressEnrollmentIds = await db.CourseProgresses.Select(p => p.EnrollmentId).Distinct().ToListAsync();
                var progressUserIds = enrollments.Where(e => progressEnrollmentIds.Contains(e.Id)).Select(e => e.UserId).Distinct().ToHashSet();

                var carts = await db.Carts.Include(c => c.CartItems).ToListAsync();
                var cartUserIds = carts.Where(c => c.UserId != null && c.CartItems.Any()).Select(c => c.UserId!).Distinct().ToHashSet();
                var totalCartItems = carts.Sum(c => c.CartItems.Count);

                var wishlists = await db.WishlistItems.Select(w => new { w.UserId, w.CourseId }).ToListAsync();
                var wishlistUserIds = wishlists.Select(w => w.UserId).Distinct().ToHashSet();

                var payments = await db.Payments.Select(p => new { p.Id, p.UserId, p.Status, p.Amount }).ToListAsync();
                var paymentUserIds = payments.Select(p => p.UserId).Distinct().ToHashSet();

                var comments = await db.LectureComments.Select(c => new { c.Id, c.UserId }).ToListAsync();
                var commentUserIds = comments.Select(c => c.UserId).Distinct().ToHashSet();

                Console.WriteLine("=== DATABASE USER ACTIVITY STATS ===");
                Console.WriteLine($"Total Users in DB: {totalUsers}");
                foreach (var kvp in usersByRole)
                {
                    Console.WriteLine($"  Role '{kvp.Key}': {kvp.Value} users");
                }
                Console.WriteLine($"Total Students: {studentUserIds.Count}");
                Console.WriteLine($"Students with >= 1 Enrollment: {studentUserIds.Intersect(enrolledUserIds).Count()} / {studentUserIds.Count}");
                var zeroStudents = studentUserIds.Except(enrolledUserIds).ToList();
                Console.WriteLine($"Students with zero Enrollments: {zeroStudents.Count}");

                var sampleZero = await db.Users.Where(u => zeroStudents.Take(5).Contains(u.Id)).ToListAsync();
                Console.WriteLine("Sample zero-enrollment users:");
                foreach (var sz in sampleZero)
                {
                    Console.WriteLine($"  Id: {sz.Id}, Email: {sz.Email}, Name: '{sz.FullName}', CreatedAt: {sz.CreatedAt}, Subjects: {(sz.Subjects != null ? string.Join(",", sz.Subjects) : "null")}");
                }

                Console.WriteLine($"\n--- ENROLLMENTS & COURSES ---");
                Console.WriteLine($"Total Enrollments: {enrollments.Count}");
                Console.WriteLine($"Students who completed courses (Earned Certificates): {studentUserIds.Intersect(certifiedUserIds).Count()} ({certificates.Count} total certificates)");
                Console.WriteLine($"Students with lecture progress: {studentUserIds.Intersect(progressUserIds).Count()}");

                Console.WriteLine($"\n--- RATINGS & REVIEWS ---");
                Console.WriteLine($"Total Star Ratings: {ratings.Count} by {ratingUserIds.Count} students");
                Console.WriteLine($"Total Text Reviews: {reviews.Count} by {reviewUserIds.Count} students");

                Console.WriteLine($"\n--- COMMERCE & ENGAGEMENT ---");
                Console.WriteLine($"Total Payments: {payments.Count} by {paymentUserIds.Count} students");
                Console.WriteLine($"Cart Items: {totalCartItems} across {cartUserIds.Count} students");
                Console.WriteLine($"Wishlist Items: {wishlists.Count} across {wishlistUserIds.Count} students");
                Console.WriteLine($"Discussion Comments: {comments.Count} by {commentUserIds.Count} users");

                var studentsWithAnyActivity = studentUserIds.Where(id =>
                    enrolledUserIds.Contains(id) ||
                    progressUserIds.Contains(id) ||
                    ratingUserIds.Contains(id) ||
                    cartUserIds.Contains(id) ||
                    wishlistUserIds.Contains(id) ||
                    paymentUserIds.Contains(id) ||
                    commentUserIds.Contains(id)
                ).Count();
                Console.WriteLine($"\nStudents with ANY active interaction: {studentsWithAnyActivity} / {studentUserIds.Count}");

                return;
            }

            var pilot = args.Contains("pilot", StringComparer.OrdinalIgnoreCase);
            if (pilot)
            {
                Console.WriteLine("PILOT MODE: seeding 2 courses for the built-in EduLab instructor.");
            }

            await SeedEngine.RunAsync(db, userManager, roleManager, pilot);
        }
    }
}