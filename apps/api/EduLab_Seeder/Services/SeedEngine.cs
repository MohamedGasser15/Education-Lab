using EduLab_Application.Common.Constants;
using EduLab_Domain;
using EduLab_Domain.Entities;
using EduLab_Infrastructure.DB;
using EduLab_Seeder.Data;
using EduLab_Seeder.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace EduLab_Seeder.Services
{
    /// <summary>
    /// Orchestrates seeding: roles, categories, then users (instructors & students).
    /// User creation mirrors the MVC registration flow (UserService.CreateUserAsync)
    /// so accounts are always valid for the MVC app.
    /// </summary>
    internal static class SeedEngine
    {
        public static async Task RunAsync(
            ApplicationDbContext db,
            UserManager<ApplicationUser> userManager,
            RoleManager<ApplicationRole> roleManager,
            bool pilot = false)
        {
            await EnsureRolesAsync(roleManager);
            var categoriesAdded = await EnsureCategoriesAsync(db);

            Console.WriteLine($"Categories: {categoriesAdded} added, {55 - categoriesAdded} already exist.");

            var created = 0;
            var updated = 0;
            var skipped = 0;

            Console.WriteLine($"Seeding {InstructorSeedData.All.Count} instructors...");
            foreach (var profile in InstructorSeedData.All)
            {
                var result = await CreateOrUpdateUserAsync(userManager, profile, SD.Instructor);
                if (result == SeedResult.Created) created++;
                else if (result == SeedResult.Updated) updated++;
                else skipped++;
            }

            Console.WriteLine($"Seeding {StudentSeedData.All.Count + StudentBulkSeedData.All.Count} students...");
            foreach (var profile in StudentSeedData.All.Concat(StudentBulkSeedData.All))
            {
                var result = await CreateOrUpdateUserAsync(userManager, profile, SD.Student);
                if (result == SeedResult.Created) created++;
                else if (result == SeedResult.Updated) updated++;
                else skipped++;
            }

            Console.WriteLine($"\nUsers done. Created: {created}, Updated: {updated}, Skipped (unchanged): {skipped}");

            await FixCorruptedUserProfilesAsync(db);

            await SeedCoursesAsync(db, pilot);

            await SeedStudentActivitiesAsync(db);

            await NormalizeCoursePricingAsync(db);

            await SeedPaymentsAsync(db);

            await SeedRatingsAndReviewsAsync(db);

            await SeedProgressAndCertificatesAsync(db);

            await SeedLectureCommentsAsync(db);

            await SeedRefundsAndReportsAsync(db);

            await SeedNotificationsAsync(db);

            await SeedInstructorApplicationsAsync(db);
        }

        private static async Task EnsureRolesAsync(RoleManager<ApplicationRole> roleManager)
        {
            string[] roles = { SD.Admin, SD.Instructor, SD.Student, SD.InstructorPending, SD.Support, SD.Moderator };
            foreach (var role in roles)
            {
                if (!await roleManager.RoleExistsAsync(role))
                {
                    await roleManager.CreateAsync(new ApplicationRole { Name = role });
                }
            }
        }

        /// <summary>
        /// Mirrors DbInitializer.SeedCategories exactly (same names, same keys).
        /// </summary>
        private static async Task<int> EnsureCategoriesAsync(ApplicationDbContext db)
        {
            var existing = await db.Categories.Select(c => c.Category_EnglishName).ToListAsync();

            var added = 0;
            foreach (var category in CategorySeedData.All)
            {
                if (!existing.Contains(category.Category_EnglishName))
                {
                    category.CreatedAt = DateTime.Now;
                    db.Categories.Add(category);
                    added++;
                }
            }

            if (added > 0)
            {
                await db.SaveChangesAsync();
            }

            return added;
        }

        /// <summary>
        /// Mirrors the MVC registration flow (UserService.CreateUserAsync):
        /// UserName = Email, EmailConfirmed = true, CreatedAt = UtcNow, then role assignment.
        /// If the user already exists, keeps the account (password/roles) but syncs the
        /// profile fields to match the seed data (idempotent).
        /// </summary>
        private static async Task<SeedResult> CreateOrUpdateUserAsync(
            UserManager<ApplicationUser> userManager, UserProfile profile, string role)
        {
            var existing = await userManager.FindByEmailAsync(profile.Email);

            if (existing != null)
            {
                var hasChanges =
                    existing.FullName != profile.FullName ||
                    existing.Title != profile.Title ||
                    existing.Location != profile.Location ||
                    existing.About != profile.About ||
                    existing.ProfileImageUrl != profile.ProfileImageUrl ||
                    existing.GitHubUrl != profile.GitHubUrl ||
                    existing.LinkedInUrl != profile.LinkedInUrl ||
                    existing.TwitterUrl != profile.TwitterUrl ||
                    existing.FacebookUrl != profile.FacebookUrl ||
                    existing.PreferredLanguage != profile.PreferredLanguage ||
                    !existing.Subjects.SequenceEqual(profile.Subjects);

                if (!hasChanges)
                {
                    return SeedResult.Skipped;
                }

                existing.FullName = profile.FullName;
                existing.Title = profile.Title;
                existing.Location = profile.Location;
                existing.About = profile.About;
                existing.ProfileImageUrl = profile.ProfileImageUrl;
                existing.GitHubUrl = profile.GitHubUrl;
                existing.LinkedInUrl = profile.LinkedInUrl;
                existing.TwitterUrl = profile.TwitterUrl;
                existing.FacebookUrl = profile.FacebookUrl;
                existing.Subjects = profile.Subjects;
                existing.PreferredLanguage = profile.PreferredLanguage;

                var updateResult = await userManager.UpdateAsync(existing);
                if (!updateResult.Succeeded)
                {
                    Console.WriteLine($"  FAILED UPDATE {profile.Email}: {string.Join("; ", updateResult.Errors.Select(e => e.Description))}");
                    return SeedResult.Skipped;
                }

                await EnsureRoleAsync(userManager, existing, role);
                Console.WriteLine($"  UPD   {role,-10} {profile.Email}");
                return SeedResult.Updated;
            }

            var user = new ApplicationUser
            {
                UserName = profile.Email,
                Email = profile.Email,
                FullName = profile.FullName,
                Title = profile.Title,
                Location = profile.Location,
                About = profile.About,
                ProfileImageUrl = profile.ProfileImageUrl,
                GitHubUrl = profile.GitHubUrl,
                LinkedInUrl = profile.LinkedInUrl,
                TwitterUrl = profile.TwitterUrl,
                FacebookUrl = profile.FacebookUrl,
                Subjects = profile.Subjects,
                PreferredLanguage = profile.PreferredLanguage,
                EmailConfirmed = true,
                CreatedAt = DateTime.UtcNow
            };

            var result = await userManager.CreateAsync(user, profile.Password);
            if (!result.Succeeded)
            {
                Console.WriteLine($"  FAILED {profile.Email}: {string.Join("; ", result.Errors.Select(e => e.Description))}");
                return SeedResult.Skipped;
            }

            await userManager.AddToRoleAsync(user, role);
            Console.WriteLine($"  OK    {role,-10} {profile.Email}");
            return SeedResult.Created;
        }

        private static async Task EnsureRoleAsync(UserManager<ApplicationUser> userManager, ApplicationUser user, string role)
        {
            if (!await userManager.IsInRoleAsync(user, role))
            {
                await userManager.AddToRoleAsync(user, role);
            }
        }

        /// <summary>
        /// Seeds additional students up to targetAddCount (e.g. 291 to reach 1000 total students).
        /// Checks db.Users to avoid duplicate emails.
        /// </summary>
        public static async Task<int> SeedAdditionalStudentsAsync(
            ApplicationDbContext db,
            UserManager<ApplicationUser> userManager,
            int targetAddCount = 291)
        {
            var existingEmails = (await db.Users.Select(u => u.Email).ToListAsync())
                .ToHashSet(StringComparer.OrdinalIgnoreCase);

            var added = 0;
            var candidates = StudentSeedData.All.Concat(StudentBulkSeedData.All);

            foreach (var profile in candidates)
            {
                if (added >= targetAddCount) break;
                if (existingEmails.Contains(profile.Email)) continue;

                var user = new ApplicationUser
                {
                    UserName = profile.Email,
                    Email = profile.Email,
                    FullName = profile.FullName,
                    Title = profile.Title,
                    Location = profile.Location,
                    About = profile.About,
                    ProfileImageUrl = profile.ProfileImageUrl,
                    GitHubUrl = profile.GitHubUrl,
                    LinkedInUrl = profile.LinkedInUrl,
                    TwitterUrl = profile.TwitterUrl,
                    FacebookUrl = profile.FacebookUrl,
                    Subjects = profile.Subjects,
                    PreferredLanguage = profile.PreferredLanguage,
                    EmailConfirmed = true,
                    CreatedAt = DateTime.UtcNow
                };

                var res = await userManager.CreateAsync(user, profile.Password);
                if (res.Succeeded)
                {
                    await userManager.AddToRoleAsync(user, SD.Student);
                    existingEmails.Add(profile.Email);
                    added++;
                    if (added % 50 == 0 || added == targetAddCount)
                    {
                        Console.WriteLine($"  Created student {added}/{targetAddCount}: {profile.FullName} ({profile.Email})");
                    }
                }
                else
                {
                    Console.WriteLine($"  FAILED {profile.Email}: {string.Join("; ", res.Errors.Select(e => e.Description))}");
                }
            }

            Console.WriteLine($"Successfully added {added} new students.");
            return added;
        }

        /// <summary>
        /// Activates targetStudentsCount (e.g. 450) students who currently have 0 enrollments.
        /// Generates realistic enrollments matching their Subjects, carts, wishlists, payments,
        /// progress, certificates, and ratings.
        /// </summary>
        public static async Task<int> ActivateAdditionalStudentsAsync(
            ApplicationDbContext db,
            int targetStudentsCount = 450)
        {
            var studentRole = await db.Roles.FirstOrDefaultAsync(r => r.Name == SD.Student);
            if (studentRole == null)
            {
                Console.WriteLine("Student role not found.");
                return 0;
            }

            var studentIds = await db.UserRoles
                .Where(ur => ur.RoleId == studentRole.Id)
                .Select(ur => ur.UserId)
                .ToListAsync();

            var enrolledUserIds = (await db.Enrollments.Select(e => e.UserId).Distinct().ToListAsync()).ToHashSet();

            var inactiveStudents = await db.Users
                .Where(u => studentIds.Contains(u.Id) && !enrolledUserIds.Contains(u.Id))
                .OrderBy(u => u.Id)
                .Take(targetStudentsCount)
                .Select(u => new { u.Id, u.Subjects, u.PreferredLanguage })
                .ToListAsync();

            Console.WriteLine($"Found {inactiveStudents.Count} inactive students to activate (target: {targetStudentsCount}).");
            if (inactiveStudents.Count == 0) return 0;

            var courses = await db.Courses
                .OrderBy(c => c.Id)
                .Select(c => new { c.Id, c.Title })
                .ToListAsync();

            if (courses.Count == 0)
            {
                Console.WriteLine("No courses available.");
                return 0;
            }

            var existingEnrollments = await db.Enrollments
                .Select(e => new { e.UserId, e.CourseId }).ToListAsync();
            var existingWishlist = await db.WishlistItems
                .Select(w => new { w.UserId, w.CourseId }).ToListAsync();
            var existingCarts = await db.Carts
                .Where(c => c.UserId != null).Select(c => c.UserId).ToListAsync();

            var enrollmentSet = new HashSet<(string, int)>(existingEnrollments.Select(e => (e.UserId, e.CourseId)));
            var wishlistSet = new HashSet<(string, int)>(existingWishlist.Select(w => (w.UserId, w.CourseId)));
            var cartOwnerSet = new HashSet<string>(existingCarts!);

            var newEnrollmentsCount = 0;
            var newWishlistCount = 0;
            var newCartsCount = 0;

            foreach (var student in inactiveStudents)
            {
                Cart? cart = null;
                var studentSubjects = student.Subjects ?? new List<string>();

                // Pick between 5 and 12 courses per student
                var targetCoursesCount = 5 + (int)(StableHash($"count:{student.Id}") % 8);
                var matchingCourses = courses.Where(c =>
                    studentSubjects.Any(s => !string.IsNullOrWhiteSpace(s) && c.Title.Contains(s, StringComparison.OrdinalIgnoreCase))
                ).ToList();

                var enrolledForThisStudent = 0;

                // First enroll in matching courses
                foreach (var mc in matchingCourses)
                {
                    if (enrolledForThisStudent >= targetCoursesCount) break;
                    if (!enrollmentSet.Contains((student.Id, mc.Id)))
                    {
                        var daysAgo = 1 + (int)(StableHash($"enr:{student.Id}:{mc.Id}") % 90);
                        db.Enrollments.Add(new Enrollment
                        {
                            UserId = student.Id,
                            CourseId = mc.Id,
                            EnrolledAt = DateTime.UtcNow.AddDays(-daysAgo)
                        });
                        enrollmentSet.Add((student.Id, mc.Id));
                        enrolledForThisStudent++;
                        newEnrollmentsCount++;
                    }
                }

                // If still need more courses to reach targetCoursesCount, pick from general courses
                if (enrolledForThisStudent < targetCoursesCount)
                {
                    var needed = targetCoursesCount - enrolledForThisStudent;
                    for (var k = 0; k < needed; k++)
                    {
                        var cIdx = (int)((StableHash($"fill:{student.Id}:{k}") >> 4) % (uint)courses.Count);
                        var gc = courses[cIdx];
                        if (!enrollmentSet.Contains((student.Id, gc.Id)))
                        {
                            var daysAgo = 1 + (int)(StableHash($"enr:{student.Id}:{gc.Id}") % 90);
                            db.Enrollments.Add(new Enrollment
                            {
                                UserId = student.Id,
                                CourseId = gc.Id,
                                EnrolledAt = DateTime.UtcNow.AddDays(-daysAgo)
                            });
                            enrollmentSet.Add((student.Id, gc.Id));
                            enrolledForThisStudent++;
                            newEnrollmentsCount++;
                        }
                    }
                }

                // Cart: ~35% chance to have a cart with 1-2 items
                var cartHash = StableHash($"cart:{student.Id}");
                if (cartHash % 100 < 35 && !cartOwnerSet.Contains(student.Id))
                {
                    cart = new Cart { UserId = student.Id, CreatedAt = DateTime.UtcNow };
                    var cartCourseIdx = (int)((cartHash >> 8) % (uint)courses.Count);
                    cart.CartItems.Add(new CartItem { CourseId = courses[cartCourseIdx].Id, AddedAt = DateTime.UtcNow.AddDays(-1) });
                    newCartsCount++;
                }

                // Wishlist: ~60% chance to have 2-4 wishlist items
                var wishHash = StableHash($"wish:{student.Id}");
                if (wishHash % 100 < 60)
                {
                    var wishCount = 2 + (int)((wishHash >> 8) % 3);
                    for (var w = 0; w < wishCount; w++)
                    {
                        var wIdx = (int)((StableHash($"witem:{student.Id}:{w}") >> 4) % (uint)courses.Count);
                        var wCourse = courses[wIdx];
                        if (!wishlistSet.Contains((student.Id, wCourse.Id)))
                        {
                            db.WishlistItems.Add(new Wishlist
                            {
                                UserId = student.Id,
                                CourseId = wCourse.Id,
                                AddedAt = DateTime.UtcNow.AddDays(-5)
                            });
                            wishlistSet.Add((student.Id, wCourse.Id));
                            newWishlistCount++;
                        }
                    }
                }

                if (cart != null)
                {
                    db.Carts.Add(cart);
                    cartOwnerSet.Add(student.Id);
                }

                if ((newEnrollmentsCount + newWishlistCount) > 0 &&
                    (newEnrollmentsCount + newWishlistCount) % 1000 == 0)
                {
                    await db.SaveChangesAsync();
                    db.ChangeTracker.Clear();
                }
            }

            await db.SaveChangesAsync();
            db.ChangeTracker.Clear();

            Console.WriteLine($"Enrollments created: {newEnrollmentsCount}, Wishlist items: {newWishlistCount}, Carts: {newCartsCount}");

            Console.WriteLine("Seeding payments for newly enrolled courses...");
            await SeedPaymentsAsync(db);

            Console.WriteLine("Seeding ratings and reviews for newly enrolled courses...");
            await SeedRatingsAndReviewsAsync(db);

            Console.WriteLine("Seeding progress and certificates for newly enrolled courses...");
            await SeedProgressAndCertificatesAsync(db);

            Console.WriteLine($"Activation completed for {inactiveStudents.Count} students.");
            return inactiveStudents.Count;
        }

        /// <summary>
        /// Seeds Approved courses (with sections & video lectures) for instructors.
        /// Pilot mode = 2 courses for the built-in EduLab instructor only, so the
        /// user can verify the videos play before running the full seed.
        /// Full mode = 10 courses per seeded instructor.
        /// </summary>
        private static async Task SeedCoursesAsync(ApplicationDbContext db, bool pilot)
        {
            var categories = await db.Categories.ToListAsync();
            if (categories.Count == 0)
            {
                Console.WriteLine("No categories found. Skipping course seeding.");
                return;
            }

            List<ApplicationUser> instructors;
            int coursesPerInstructor;

            if (pilot)
            {
                instructors = await db.Users
                    .Where(u => u.Id == SD.EduLabInstructorId)
                    .ToListAsync();
                coursesPerInstructor = 2;
            }
            else
            {
                var role = await db.Roles.FirstOrDefaultAsync(r => r.Name == SD.Instructor);
                instructors = await db.Users
                    .Where(u => u.Id == SD.EduLabInstructorId ||
                                (role != null && db.UserRoles.Any(ur => ur.UserId == u.Id && ur.RoleId == role.Id)))
                    .ToListAsync();
                coursesPerInstructor = 10;
            }

            if (instructors.Count == 0)
            {
                Console.WriteLine("No instructors found. Skipping course seeding.");
                return;
            }

            var rng = new Random(12345);
            var totalCreated = 0;
            var totalSkipped = 0;

            foreach (var instructor in instructors)
            {
                var category = CourseSeedData.PickCategory(categories, instructor);
                var newCourses = CourseSeedData.GenerateForInstructor(instructor, category, coursesPerInstructor, rng);

                var existingTitles = await db.Courses
                    .Where(c => c.InstructorId == instructor.Id)
                    .Select(c => c.Title)
                    .ToListAsync();

                var toInsert = newCourses
                    .Where(c => !existingTitles.Contains(c.Title))
                    .ToList();

                totalSkipped += newCourses.Count - toInsert.Count;

                if (toInsert.Count > 0)
                {
                    db.Courses.AddRange(toInsert);
                    await db.SaveChangesAsync();
                    db.ChangeTracker.Clear();
                    totalCreated += toInsert.Count;
                    Console.WriteLine($"  +{toInsert.Count} courses for {instructor.Email} ({instructor.FullName})");
                }
                else
                {
                    Console.WriteLine($"  =0 (all {coursesPerInstructor} already exist) for {instructor.Email}");
                }
            }

            Console.WriteLine($"\nCourses done. Created: {totalCreated}, Skipped (already exist): {totalSkipped}");
        }

        /// <summary>
        /// Distributes enrollments, carts and wishlists across ALL students matching
        /// student interests and ensuring healthy enrollment distribution across courses.
        /// Deterministic per (student, course) via a stable hash.
        /// </summary>
        private static async Task SeedStudentActivitiesAsync(ApplicationDbContext db)
        {
            var role = await db.Roles.FirstOrDefaultAsync(r => r.Name == SD.Student);
            var students = await db.Users
                .Where(u => role != null && db.UserRoles.Any(ur => ur.UserId == u.Id && ur.RoleId == role.Id))
                .OrderBy(u => u.Id)
                .Select(u => new { u.Id, u.Subjects })
                .ToListAsync();

            var courses = await db.Courses
                .OrderBy(c => c.Id)
                .Select(c => new { c.Id, c.Title })
                .ToListAsync();

            if (students.Count == 0 || courses.Count == 0)
            {
                Console.WriteLine("No students/courses for activities. Skipping.");
                return;
            }

            var existingEnrollments = await db.Enrollments
                .Select(e => new { e.UserId, e.CourseId }).ToListAsync();
            var existingWishlist = await db.WishlistItems
                .Select(w => new { w.UserId, w.CourseId }).ToListAsync();
            var existingCarts = await db.Carts
                .Where(c => c.UserId != null).Select(c => c.UserId).ToListAsync();

            var enrollmentSet = new HashSet<(string, int)>(existingEnrollments.Select(e => (e.UserId, e.CourseId)));
            var wishlistSet = new HashSet<(string, int)>(existingWishlist.Select(w => (w.UserId, w.CourseId)));
            var cartOwnerSet = new HashSet<string>(existingCarts!);

            var enrollmentsCreated = 0;
            var wishlistCreated = 0;
            var cartItemsCreated = 0;

            foreach (var student in students)
            {
                Cart? cart = null;
                var studentSubjects = student.Subjects ?? new List<string>();

                foreach (var course in courses)
                {
                    var courseId = course.Id;
                    var hash = StableHash(student.Id) ^ unchecked((uint)(courseId * 2654435761u));
                    var r = (int)(hash % 1000);

                    // Check if course title matches any student subject
                    var matchesInterest = studentSubjects.Any(s =>
                        !string.IsNullOrWhiteSpace(s) &&
                        course.Title.Contains(s, StringComparison.OrdinalIgnoreCase));

                    // Higher enrollment chance for matching interests (~20%), baseline ~1.5% for others
                    var enrollThreshold = matchesInterest ? 200 : 15;

                    if (r < enrollThreshold)
                    {
                        if (!enrollmentSet.Contains((student.Id, courseId)))
                        {
                            db.Enrollments.Add(new Enrollment
                            {
                                UserId = student.Id,
                                CourseId = courseId,
                                EnrolledAt = DateTime.UtcNow.AddDays(-(r % 90) - 1)
                            });
                            enrollmentSet.Add((student.Id, courseId));
                            enrollmentsCreated++;
                        }
                    }
                    else if (r < enrollThreshold + 10) // ~1% -> cart
                    {
                        if (!cartOwnerSet.Contains(student.Id))
                        {
                            cart ??= new Cart { UserId = student.Id, CreatedAt = DateTime.UtcNow };
                            cart.CartItems.Add(new CartItem { CourseId = courseId, AddedAt = DateTime.UtcNow.AddDays(-(r % 20)) });
                            cartItemsCreated++;
                        }
                    }
                    else if (r < enrollThreshold + 30) // ~2% -> wishlist
                    {
                        if (!wishlistSet.Contains((student.Id, courseId)))
                        {
                            db.WishlistItems.Add(new Wishlist
                            {
                                UserId = student.Id,
                                CourseId = courseId,
                                AddedAt = DateTime.UtcNow.AddDays(-(r % 40))
                            });
                            wishlistSet.Add((student.Id, courseId));
                            wishlistCreated++;
                        }
                    }

                    if ((enrollmentsCreated + wishlistCreated + cartItemsCreated) > 0 &&
                        (enrollmentsCreated + wishlistCreated + cartItemsCreated) % 1000 == 0)
                    {
                        await db.SaveChangesAsync();
                        db.ChangeTracker.Clear();
                    }
                }

                if (cart != null)
                {
                    db.Carts.Add(cart);
                    cartOwnerSet.Add(student.Id);
                }
            }

            // Ensure EVERY course in the platform has at least 4 to 11 enrolled students
            var courseEnrollmentCounts = enrollmentSet
                .GroupBy(e => e.Item2)
                .ToDictionary(g => g.Key, g => g.Count());

            foreach (var course in courses)
            {
                var courseId = course.Id;
                courseEnrollmentCounts.TryGetValue(courseId, out var currentCount);
                if (currentCount < 4)
                {
                    var needed = 4 + (int)(StableHash($"course_min:{courseId}") % 8) - currentCount;
                    for (var k = 0; k < needed; k++)
                    {
                        var studentIdx = (int)((StableHash($"course_fill:{courseId}:{k}") >> 8) % (uint)students.Count);
                        var student = students[studentIdx];
                        if (!enrollmentSet.Contains((student.Id, courseId)))
                        {
                            var daysAgo = 1 + (int)((StableHash($"enrolled_date:{courseId}:{k}") >> 16) % 90);
                            db.Enrollments.Add(new Enrollment
                            {
                                UserId = student.Id,
                                CourseId = courseId,
                                EnrolledAt = DateTime.UtcNow.AddDays(-daysAgo)
                            });
                            enrollmentSet.Add((student.Id, courseId));
                            enrollmentsCreated++;
                        }
                    }
                }
            }

            await db.SaveChangesAsync();
            db.ChangeTracker.Clear();
            Console.WriteLine($"Activities done. Enrollments: +{enrollmentsCreated}, Carts: +{cartItemsCreated} items, Wishlist: +{wishlistCreated}");
        }

        /// <summary>
        /// Stable FNV-1a string hash (not randomized per process like string.GetHashCode).
        /// </summary>
        private static uint StableHash(string value)
        {
            unchecked
            {
                uint hash = 2166136261;
                foreach (var c in value)
                {
                    hash ^= c;
                    hash *= 16777619;
                }
                return hash;
            }
        }

        /// <summary>
        /// Fixes course pricing to match the app's model (Discount is a PERCENTAGE 0-100)
        /// and marks ~5% of courses as fully free (Price = 0). Idempotent.
        /// </summary>
        private static async Task NormalizeCoursePricingAsync(ApplicationDbContext db)
        {
            var courses = await db.Courses.OrderBy(c => c.Id).ToListAsync();
            if (courses.Count == 0) return;

            var changed = 0;

            // Fix any discount that was stored as a fraction (<1) instead of a percentage.
            foreach (var course in courses)
            {
                if (course.Discount is > 0 and < 1)
                {
                    course.Discount = Math.Round(course.Discount.Value * 100, 0); // convert fraction -> percent
                    changed++;
                }
                else if (course.Discount is > 100)
                {
                    course.Discount = 45; // clamp out-of-range to a sane value
                    changed++;
                }
            }

            // Free courses: exactly ~5%, deterministic.
            var freeCount = (int)Math.Ceiling(courses.Count * 0.05);
            for (var i = 0; i < freeCount; i++)
            {
                var idx = (int)Math.Floor((double)i * courses.Count / freeCount);
                var course = courses[idx];
                if (course.Price != 0 || course.Discount != null)
                {
                    course.Price = 0;
                    course.Discount = null;
                    changed++;
                }
            }

            if (changed > 0)
            {
                await db.SaveChangesAsync();
            }

            Console.WriteLine($"Pricing normalized. Free: {freeCount} (~5% of {courses.Count}), changes: {changed}");
        }

        /// <summary>
        /// Creates a completed Payment for each enrollment whose course is not free.
        /// The amount matches the app's FinalPrice (Price - Price*Discount/100).
        /// </summary>
        private static async Task SeedPaymentsAsync(ApplicationDbContext db)
        {
            var enrollments = await db.Enrollments
                .Include(e => e.Course)
                .ToListAsync();

            if (enrollments.Count == 0)
            {
                Console.WriteLine("No enrollments found. Skipping payments.");
                return;
            }

            var existingPaymentKeys = await db.Payments
                .Select(p => new { p.UserId, p.CourseId }).ToListAsync();
            var paymentSet = new HashSet<(string, int)>(existingPaymentKeys.Select(p => (p.UserId, p.CourseId)));

            var rng = new Random(13579);
            var created = 0;
            var skipped = 0;

            foreach (var enrollment in enrollments)
            {
                var course = enrollment.Course;
                // Free courses produce no payment (the app creates a "free" record itself).
                if (course == null || course.Price <= 0) continue;

                if (paymentSet.Contains((enrollment.UserId, enrollment.CourseId))) continue;

                var finalPrice = Math.Max(0, course.Price - (course.Price * (course.Discount ?? 0) / 100));

                db.Payments.Add(new Payment
                {
                    UserId = enrollment.UserId,
                    CourseId = enrollment.CourseId,
                    Amount = finalPrice,
                    PaymentMethod = "stripe",
                    Status = "completed",
                    PaidAt = enrollment.EnrolledAt.AddMinutes(-rng.Next(2, 40)),
                    CreatedAt = enrollment.EnrolledAt.AddMinutes(-rng.Next(40, 80)),
                    StripeSessionId = $"cs_seed_{enrollment.UserId.Substring(0, 8)}_{enrollment.CourseId}"
                });

                paymentSet.Add((enrollment.UserId, enrollment.CourseId));
                created++;

                if (created % 1000 == 0)
                {
                    await db.SaveChangesAsync();
                    db.ChangeTracker.Clear();
                }
            }

            if (created % 1000 != 0)
            {
                await db.SaveChangesAsync();
                db.ChangeTracker.Clear();
            }

            Console.WriteLine($"Payments done. Created: {created}, Skipped (free/no-enrollment/existing): {skipped}");
        }

        /// <summary>
        /// Seeds ratings: Enrolled students rate their courses with realistic 1-5 ratings.
        /// A subset of the comments is mirrored into the Reviews table for positive ratings.
        /// Deterministic per (course, student) hash, idempotent.
        /// </summary>
        private static async Task SeedRatingsAndReviewsAsync(ApplicationDbContext db)
        {
            var enrollments = await db.Enrollments
                .Select(e => new { e.UserId, e.CourseId, e.EnrolledAt })
                .ToListAsync();

            if (enrollments.Count == 0)
            {
                Console.WriteLine("No enrollments found for ratings. Skipping.");
                return;
            }

            var studentsLang = await db.Users
                .Select(u => new { u.Id, u.PreferredLanguage })
                .ToDictionaryAsync(u => u.Id, u => u.PreferredLanguage);

            var existingRatings = await db.Ratings.Select(r => new { r.UserId, r.CourseId }).ToListAsync();
            var existingReviews = await db.Reviews.Select(r => new { r.UserId, r.CourseId }).ToListAsync();
            var ratingSet = new HashSet<(string, int)>(existingRatings.Select(r => (r.UserId, r.CourseId)));
            var reviewSet = new HashSet<(string, int)>(existingReviews.Select(r => (r.UserId, r.CourseId)));

            var ratingsCreated = 0;
            var reviewsCreated = 0;

            foreach (var enrollment in enrollments)
            {
                var hash = StableHash($"{enrollment.CourseId}:{enrollment.UserId}");
                var r = (int)(hash % 100);

                // ~80% of enrolled students submit a rating
                if (r >= 80) continue;

                // Any normal rating 1-5 (slightly positive skew: ~40% 5, ~30% 4, ~15% 3, ~10% 2, ~5% 1).
                var value = r < 35 ? 5 : r < 60 ? 4 : r < 75 ? 3 : r < 85 ? 2 : 1;
                var hasComment = (hash >> 8) % 10 < 4; // ~40% carry a comment
                var lang = studentsLang.TryGetValue(enrollment.UserId, out var l) ? l : "ar";
                var isEnglish = lang == "en";

                if (!ratingSet.Contains((enrollment.UserId, enrollment.CourseId)))
                {
                    db.Ratings.Add(new Rating
                    {
                        CourseId = enrollment.CourseId,
                        UserId = enrollment.UserId,
                        Value = value,
                        Comment = hasComment ? PickComment(isEnglish, value, (int)(hash >> 16)) : null,
                        CreatedAt = enrollment.EnrolledAt.AddDays(Math.Max(1, (int)((hash >> 16) % 30)))
                    });
                    ratingSet.Add((enrollment.UserId, enrollment.CourseId));
                    ratingsCreated++;

                    // Mirror into the legacy Reviews table only for commented, positive ratings.
                    if (hasComment && value >= 4 && !reviewSet.Contains((enrollment.UserId, enrollment.CourseId)))
                    {
                        db.Reviews.Add(new Review
                        {
                            CourseId = enrollment.CourseId,
                            UserId = enrollment.UserId,
                            Rating = value,
                            Comment = PickComment(isEnglish, value, (int)(hash >> 16)),
                            CreatedAt = enrollment.EnrolledAt.AddDays(Math.Max(1, (int)((hash >> 16) % 30)))
                        });
                        reviewSet.Add((enrollment.UserId, enrollment.CourseId));
                        reviewsCreated++;
                    }

                    // Batch-save
                    if (ratingsCreated % 1000 == 0)
                    {
                        await db.SaveChangesAsync();
                        db.ChangeTracker.Clear();
                    }
                }
            }

            if (ratingsCreated % 1000 != 0)
            {
                await db.SaveChangesAsync();
                db.ChangeTracker.Clear();
            }

            Console.WriteLine($"Ratings done. Ratings: +{ratingsCreated}, Reviews: +{reviewsCreated}");
        }

        private static readonly string[] PositiveCommentsAr =
        {
            "شرح ممتاز ومنظم، استفدت كثيراً.", "دورة رائعة بمحتوى عملي قيّم.", "أسلوب جميل والمدرب محترف.",
            "محتوى غني ومناسب للمبتدئين.", "الدورة تستحق التجربة فعلاً.", "شرح واضح ومباشر.",
            "أفضل دورة في هذا المجال.", "جودة عالية وسعر مناسب."
        };

        private static readonly string[] PositiveCommentsEn =
        {
            "Excellent and well-structured content, learned a lot.", "Great course with practical value.",
            "Clear teaching style and professional instructor.", "Rich content suitable for beginners.",
            "Definitely worth taking.", "Clear and straightforward explanations.",
            "One of the best courses in this field.", "High quality at a fair price."
        };

        private static readonly string[] CriticalCommentsAr =
        {
            "جيدة لكن تحتاج المزيد من الأمثلة.", "شرح مقبول، أتمنى تحديث بعض الأجزاء.", "محتوى جيد لكن التقسيم يمكن تحسينه."
        };

        private static readonly string[] CriticalCommentsEn =
        {
            "Good but needs more examples.", "Decent, could use some updates.", "Nice content, structure could be improved."
        };

        private static string PickComment(bool isEnglish, int value, int seed)
        {
            var pool = isEnglish
                ? (value >= 4 ? PositiveCommentsEn : CriticalCommentsEn)
                : (value >= 4 ? PositiveCommentsAr : CriticalCommentsAr);
            return pool[Math.Abs(seed) % pool.Length];
        }

        /// <summary>
        /// Seeds lecture progress for every enrollment and issues a CourseCertificate for
        /// enrollments that completed the whole course (matches the app's certificate flow:
        /// certificate generated only when progress reaches 100% and HasCertificate is true).
        /// Deterministic per enrollment, idempotent.
        /// </summary>
        private static async Task SeedProgressAndCertificatesAsync(ApplicationDbContext db)
        {
            var enrollments = await db.Enrollments.ToListAsync();
            if (enrollments.Count == 0)
            {
                Console.WriteLine("No enrollments. Skipping progress/certificates.");
                return;
            }

            var courseIds = enrollments.Select(e => e.CourseId).Distinct().ToList();
            var lecturesByCourse = await db.Lectures
                .Where(l => courseIds.Contains(l.Section.CourseId))
                .OrderBy(l => l.SectionId)
                .ThenBy(l => l.Order)
                .GroupBy(l => l.Section.CourseId)
                .ToDictionaryAsync(g => g.Key, g => g.Select(l => l.Id).ToList());

            var existingProgress = await db.CourseProgresses
                .Select(p => new { p.EnrollmentId, p.LectureId }).ToListAsync();
            var progressSet = new HashSet<(int, int)>(existingProgress.Select(p => (p.EnrollmentId, p.LectureId)));

            var existingCerts = await db.CourseCertificates.Select(c => c.EnrollmentId).ToListAsync();
            var certSet = new HashSet<int>(existingCerts);

            var progressCreated = 0;
            var certsCreated = 0;
            var issueDate = DateTime.UtcNow.AddDays(-5);

            foreach (var enrollment in enrollments)
            {
                if (!lecturesByCourse.TryGetValue(enrollment.CourseId, out var lectureIds) || lectureIds.Count == 0)
                    continue;

                var hash = StableHash($"progress:{enrollment.Id}");
                var fullCompletion = hash % 100 < 40; // ~40% of students finish the course (get a certificate)
                var percent = fullCompletion
                    ? 100
                    : Math.Max(10, 10 + (int)((hash >> 8) % 85)); // 10..94% for the rest

                var completedCount = (int)Math.Ceiling(lectureIds.Count * percent / 100.0);
                completedCount = Math.Min(completedCount, lectureIds.Count);

                for (var i = 0; i < completedCount; i++)
                {
                    if (!progressSet.Contains((enrollment.Id, lectureIds[i])))
                    {
                        db.CourseProgresses.Add(new CourseProgress
                        {
                            EnrollmentId = enrollment.Id,
                            LectureId = lectureIds[i],
                            IsCompleted = true
                        });
                        progressSet.Add((enrollment.Id, lectureIds[i]));
                        progressCreated++;
                    }
                }

                // Certificate for fully completed courses (HasCertificate is true on all our courses).
                if (fullCompletion && !certSet.Contains(enrollment.Id))
                {
                    var code = $"EL-{issueDate:yyyyMMdd}-{unchecked((uint)enrollment.Id * 2654435761u):X16}";
                    db.CourseCertificates.Add(new CourseCertificate
                    {
                        EnrollmentId = enrollment.Id,
                        CertificateCode = code,
                        PdfPath = $"/uploads/certificates/Certificate_{code}.png",
                        IssuedDate = enrollment.EnrolledAt.AddDays(20 + ((int)(hash >> 16) % 30))
                    });
                    certSet.Add(enrollment.Id);
                    certsCreated++;
                }

                if ((progressCreated + certsCreated) > 0 && (progressCreated + certsCreated) % 2000 == 0)
                {
                    await db.SaveChangesAsync();
                    db.ChangeTracker.Clear();
                }
            }

            if ((progressCreated + certsCreated) % 2000 != 0)
            {
                await db.SaveChangesAsync();
                db.ChangeTracker.Clear();
            }

            Console.WriteLine($"Progress done. Progress rows: +{progressCreated}, Certificates: +{certsCreated}");
        }

        private static readonly string[] CommentAr =
        {
            "شرح ممتاز، جزاك الله خيراً", "أخيراً فهمتها، شكراً على التوضيح", "شرح واضح ومباشر",
            "محتاج أعيد المشاهدة بس الفكرة وصلت", "أفضل محاضرة حتى الآن", "ممكن توضيح أكثر في الجزء ده؟",
            "شكراً على مجهودك، محتوى رائع", "التطبيق العملي هنا أضاف لي كتير"
        };

        private static readonly string[] CommentEn =
        {
            "Great explanation, thanks!", "Finally understood it, well explained.", "Clear and straightforward.",
            "I'll rewatch it but I got the idea.", "Best lecture so far.", "Could you clarify this part more?",
            "Thanks for your effort, great content.", "The hands-on part added a lot for me."
        };

        private static readonly string[] ReplyAr = { "عندك حق", "شكراً على الملاحظة", "أنا معاك في ده", "تمام كده" };
        private static readonly string[] ReplyEn = { "Totally agree", "Thanks for the note", "Same here", "Exactly" };

        /// <summary>
        /// Adds comments (with some threaded replies) on ~20% of lectures.
        /// Deterministic per lecture, idempotent.
        /// </summary>
        private static async Task SeedLectureCommentsAsync(ApplicationDbContext db)
        {
            var lectureIds = await db.Lectures.OrderBy(l => l.Id).Select(l => l.Id).ToListAsync();
            var students = await db.Users
                .Where(u => db.UserRoles.Any(ur => ur.UserId == u.Id && ur.RoleId == db.Roles.First(r => r.Name == SD.Student).Id))
                .OrderBy(u => u.Id)
                .Select(u => new { u.Id, u.PreferredLanguage })
                .ToListAsync();

            if (lectureIds.Count == 0 || students.Count == 0)
            {
                Console.WriteLine("No lectures/students for comments. Skipping.");
                return;
            }

            // Load what already exists so re-runs add nothing.
            var existingComments = await db.LectureComments
                .Select(c => new { c.LectureId, c.UserId }).ToListAsync();
            var existingSet = new HashSet<(int, string)>(existingComments.Select(c => (c.LectureId, c.UserId)));
            var created = 0;

            foreach (var lectureId in lectureIds)
            {
                var h = StableHash($"lc:{lectureId}");
                if ((int)(h % 10) >= 2) continue; // ~20% of lectures

                var count = 1 + (int)((h >> 8) % 3); // 1..3 top-level comments
                for (var i = 0; i < count; i++)
                {
                    var student = students[((int)(h >> 16) + i) % students.Count];
                    if (!existingSet.Add((lectureId, student.Id))) continue;

                    var isEnglish = student.PreferredLanguage == "en";
                    var comment = new LectureComment
                    {
                        LectureId = lectureId,
                        UserId = student.Id,
                        Content = (isEnglish ? CommentEn : CommentAr)[Math.Abs((int)(h >> 20)) % (isEnglish ? CommentEn : CommentAr).Length],
                        CreatedAt = DateTime.UtcNow.AddDays(-((int)(h >> 24) % 45))
                    };
                    db.LectureComments.Add(comment);
                    created++;

                    // ~25% get a threaded reply from another student.
                    if ((h >> 28) % 4 == 0)
                    {
                        var replier = students[(Math.Abs((int)(h >> 5)) + i * 3) % students.Count];
                        if (replier.Id != student.Id && existingSet.Add((lectureId, replier.Id)))
                        {
                            var isEnReply = replier.PreferredLanguage == "en";
                            db.LectureComments.Add(new LectureComment
                            {
                                LectureId = lectureId,
                                UserId = replier.Id,
                                Content = (isEnReply ? ReplyEn : ReplyAr)[Math.Abs((int)(h >> 9)) % (isEnReply ? ReplyEn : ReplyAr).Length],
                                ParentComment = comment,
                                CreatedAt = comment.CreatedAt.AddMinutes(Math.Abs((int)(h >> 12)) % 240 + 5)
                            });
                            created++;
                        }
                    }
                }
            }

            if (created > 0)
            {
                await db.SaveChangesAsync();
            }

            Console.WriteLine($"Lecture comments done. Created: +{created}");
        }

        private static readonly string[] RefundReasonAr =
        {
            "غير راضٍ عن جودة المحتوى", "وجدت الكورس غير مناسب لي", "المحتوى مكرر من كورسات أخرى", "لم أستطع متابعة الشرح"
        };

        private static readonly string[] RefundReasonEn =
        {
            "Not satisfied with the content quality", "The course wasn't suitable for me", "Content overlaps with other courses", "Couldn't follow the explanations"
        };

        /// <summary>
        /// Seeds a small set of refund requests (~2% of payments) and content reports.
        /// Deterministic, idempotent.
        /// </summary>
        private static async Task SeedRefundsAndReportsAsync(ApplicationDbContext db)
        {
            var admin = await db.Users.FirstOrDefaultAsync(u => u.Email == "madagasser15@gmail.com");

            // ---- Refund requests: ~2% of payments ----
            var payments = await db.Payments.OrderBy(p => p.Id).ToListAsync();
            var existingRefunds = await db.RefundRequests.Select(r => r.PaymentId).ToHashSetAsync();
            var refundsCreated = 0;

            foreach (var payment in payments)
            {
                var h = StableHash($"refund:{payment.Id}");
                if ((int)(h % 50) != 0) continue;          // ~2%
                if (existingRefunds.Contains(payment.Id)) continue;

                var isEnglish = (h >> 8) % 2 == 0;
                var statusRoll = (int)((h >> 12) % 100);
                string status = statusRoll < 65 ? SD.RefundStatusPending
                    : statusRoll < 85 ? SD.RefundStatusAccepted
                    : SD.RefundStatusRejected;

                var request = new RefundRequest
                {
                    PaymentId = payment.Id,
                    UserId = payment.UserId,
                    Reason = (isEnglish ? RefundReasonEn : RefundReasonAr)[(int)((h >> 16) % (isEnglish ? RefundReasonEn : RefundReasonAr).Length)],
                    Status = status,
                    CreatedAt = DateTime.UtcNow.AddDays(-((int)((h >> 20) % 30)) - 1)
                };

                if (status == SD.RefundStatusAccepted)
                {
                    request.ProcessedAt = request.CreatedAt.AddDays(2);
                    request.ProcessedBy = admin?.Id;
                    request.StripeRefundId = $"re_{unchecked((uint)payment.Id * 7919):X12}";
                }
                else if (status == SD.RefundStatusRejected)
                {
                    request.ProcessedAt = request.CreatedAt.AddDays(3);
                    request.ProcessedBy = admin?.Id;
                    request.RejectionReason = isEnglish ? "Request exceeds the 7-day refund window." : "تجاوزت الطلب مدة الاسترداد المسموحة (7 أيام).";
                }

                db.RefundRequests.Add(request);
                existingRefunds.Add(payment.Id);
                refundsCreated++;
            }

            // ---- Reports ----
            var reporters = await db.Users
                .Where(u => db.UserRoles.Any(ur => ur.UserId == u.Id && ur.RoleId == db.Roles.First(r => r.Name == SD.Student).Id))
                .OrderBy(u => u.Id)
                .Select(u => u.Id).ToListAsync();
            var courseIds = await db.Courses.OrderBy(c => c.Id).Select(c => c.Id).ToListAsync();
            var commentIds = await db.LectureComments.OrderBy(c => c.Id).Select(c => c.Id).ToListAsync();
            var ratingIds = await db.Ratings.OrderBy(r => r.Id).Select(r => r.Id).ToListAsync();

            var existingReports = await db.Reports
                .Select(r => new { r.ReporterId, r.Type, r.TargetId }).ToListAsync();
            var reportSet = new HashSet<(string, string, int)>(existingReports.Select(r => (r.ReporterId, r.Type, r.TargetId)));

            var reportsCreated = 0;
            var reportTypes = new[] { SD.ReportTypeCourse, SD.ReportTypeComment, SD.ReportTypeReview };

            for (var i = 0; i < 24; i++)
            {
                var h = StableHash($"report:{i}");
                var type = reportTypes[(int)(h % 3)];
                var targetId = type switch
                {
                    var t when t == SD.ReportTypeCourse => courseIds[(int)((h >> 8) % courseIds.Count)],
                    var t when t == SD.ReportTypeComment && commentIds.Count > 0 => commentIds[(int)((h >> 12) % commentIds.Count)],
                    _ => ratingIds.Count > 0 ? ratingIds[(int)((h >> 16) % ratingIds.Count)] : courseIds[0]
                };
                var reporterId = reporters[(int)((h >> 20) % reporters.Count)];

                if (!reportSet.Add((reporterId, type, targetId))) continue;

                var allowedReasons = SD.GetReportReasons(type);
                var reason = allowedReasons[(int)((h >> 24) % allowedReasons.Length)];
                var isEnglish = (h >> 28) % 2 == 0;
                var statusRoll = (int)((h >> 3) % 100);
                var status = statusRoll < 60 ? SD.ReportStatusPending
                    : statusRoll < 85 ? SD.ReportStatusResolved
                    : SD.ReportStatusDismissed;

                var report = new Report
                {
                    Type = type,
                    TargetId = targetId,
                    Reason = reason,
                    Details = isEnglish ? "Additional details provided by the reporter." : "تفاصيل إضافية من المبلغ.",
                    ReporterId = reporterId,
                    Status = status,
                    CreatedAt = DateTime.UtcNow.AddDays(-((int)((h >> 6) % 40)) - 1)
                };

                if (status != SD.ReportStatusPending)
                {
                    report.HandledAt = report.CreatedAt.AddDays(2);
                    report.HandledById = admin?.Id;
                    report.AdminNote = isEnglish ? "Reviewed and action taken." : "تمت المراجعة واتخاذ الإجراء.";
                    report.ResolvedActions = status == SD.ReportStatusResolved
                        ? SD.ReportActionReviewedNoViolation
                        : SD.ReportActionReviewedNoViolation;
                }

                db.Reports.Add(report);
                reportsCreated++;
            }

            if (refundsCreated + reportsCreated > 0)
            {
                await db.SaveChangesAsync();
            }

            Console.WriteLine($"Refunds/Reports done. Refunds: +{refundsCreated}, Reports: +{reportsCreated}");
        }

        private static readonly (NotificationType Type, string TitleAr, string MsgAr, string TitleEn, string MsgEn)[] NotificationTemplates =
        {
            (NotificationType.System, "مرحباً بك في EduLab", "شكراً لانضمامك إلى منصتنا التعليمية", "Welcome to EduLab", "Thank you for joining our learning platform"),
            (NotificationType.Course, "كورس جديد في مجالك", "اكتشف كورسات جديدة تناسب اهتماماتك", "New course in your field", "Discover new courses matching your interests"),
            (NotificationType.Enrollment, "تم تسجيلك بنجاح", "اكتمل تسجيلك في الكورس بنجاح", "Enrollment successful", "Your course enrollment was completed"),
            (NotificationType.Promotional, "عرض لفترة محدودة", "استفد من الخصومات على الكورسات المختارة", "Limited-time offer", "Take advantage of discounts on selected courses"),
            (NotificationType.Reminder, "لا تنسَ استكمال تقدمك", "لديك كورسات غير مكتملة، واصل التعلم", "Don't forget your progress", "You have unfinished courses, keep learning")
        };

        /// <summary>
        /// Seeds 1-3 notifications per student (mix of read/unread, localized).
        /// Deterministic, idempotent.
        /// </summary>
        private static async Task SeedNotificationsAsync(ApplicationDbContext db)
        {
            var students = await db.Users
                .Where(u => db.UserRoles.Any(ur => ur.UserId == u.Id && ur.RoleId == db.Roles.First(r => r.Name == SD.Student).Id))
                .OrderBy(u => u.Id)
                .Select(u => new { u.Id, u.PreferredLanguage })
                .ToListAsync();

            if (students.Count == 0)
            {
                Console.WriteLine("No students for notifications. Skipping.");
                return;
            }

            var existingKeys = await db.Notifications
                .Select(n => new { n.UserId, n.Title, n.Message }).ToListAsync();
            var notifSet = new HashSet<(string, string, string)>(existingKeys.Select(n => (n.UserId, n.Title, n.Message)));

            var created = 0;

            foreach (var student in students)
            {
                var h = StableHash($"notif:{student.Id}");
                var count = 1 + (int)((h >> 8) % 3); // 1..3

                for (var i = 0; i < count; i++)
                {
                    var template = NotificationTemplates[(int)((h >> 16) + i * 7) % NotificationTemplates.Length];
                    var isEnglish = student.PreferredLanguage == "en";
                    var title = isEnglish ? template.TitleEn : template.TitleAr;
                    var message = isEnglish ? template.MsgEn : template.MsgAr;

                    if (!notifSet.Add((student.Id, title, message))) continue;

                    var isRead = ((h >> 20) + i * 13) % 100 < 40; // ~40% read
                    var createdDaysAgo = ((int)((h >> 24) + i * 5) % 30);

                    db.Notifications.Add(new Notification
                    {
                        UserId = student.Id,
                        Title = title,
                        Message = message,
                        Type = template.Type,
                        Status = isRead ? NotificationStatus.Read : NotificationStatus.Unread,
                        CreatedAt = DateTime.UtcNow.AddDays(-createdDaysAgo),
                        ReadAt = isRead ? DateTime.UtcNow.AddDays(-createdDaysAgo).AddHours(3) : null,
                        RelatedEntityType = template.Type.ToString(),
                        TitleKey = isEnglish ? $"Notif_{template.Type}_Title" : null,
                        MessageKey = isEnglish ? $"Notif_{template.Type}_Msg" : null
                    });
                    created++;
                }
            }

            if (created > 0)
            {
                await db.SaveChangesAsync();
            }

            Console.WriteLine($"Notifications done. Created: +{created}");
        }

        private static readonly (string Specialization, string Experience)[] InstructorAppTemplates =
        {
            ("تطوير الويب", "5 سنوات خبرة في تطوير مواقع الويب ومشاريع حقيقية"),
            ("برمجة تطبيقات الموبايل", "4 سنوات في تطوير تطبيقات اندرويد و iOS"),
            ("علوم البيانات", "6 سنوات في تحليل البيانات والتعلم الآلي"),
            ("تصميم واجهات المستخدم", "5 سنوات في تصميم تجربة المستخدم و Figma"),
            ("التسويق الرقمي", "4 سنوات في حملات إعلانية وتسويق محتوى"),
            ("أمن المعلومات", "6 سنوات في اختبار الاختراق وتأمين التطبيقات"),
            ("إدارة المشاريع", "5 سنوات في إدارة مشاريع تقنية وفرق عمل"),
            ("التصوير والفيديو", "7 سنوات في التصوير الاحترافي والمونتاج"),
            ("اللغة الإنجليزية", "8 سنوات في تدريس اللغة والمحادثة"),
            ("الموارد البشرية", "5 سنوات في التوظيف وبناء فرق العمل"),
            ("الحوسبة السحابية", "4 سنوات في AWS و Azure وبنية الأنظمة"),
            ("ريادة الأعمال", "6 سنوات في تأسيس شركات ناشئة ودعم رواد الأعمال")
        };

        private static readonly (string Specialization, string Experience)[] InstructorAppTemplatesEn =
        {
            ("Web Development", "5 years building real-world web applications"),
            ("Mobile Development", "4 years building Android and iOS apps"),
            ("Data Science", "6 years in data analysis and machine learning"),
            ("UI/UX Design", "5 years in user experience design and Figma"),
            ("Digital Marketing", "4 years running ad campaigns and content marketing"),
            ("Cyber Security", "6 years in penetration testing and application security"),
            ("Project Management", "5 years managing technical projects and teams"),
            ("Photography & Video", "7 years in professional photography and editing"),
            ("English Language", "8 years teaching English and conversation"),
            ("Human Resources", "5 years in recruitment and team building"),
            ("Cloud Computing", "4 years in AWS, Azure and system architecture"),
            ("Entrepreneurship", "6 years founding startups and coaching founders")
        };

        /// <summary>
        /// Seeds instructor applications from a subset of students so the admin has
        /// a queue to review (pending) plus a few already approved/rejected.
        /// Deterministic, idempotent (a user can only have one active application).
        /// </summary>
        private static async Task SeedInstructorApplicationsAsync(ApplicationDbContext db)
        {
            var admin = await db.Users.FirstOrDefaultAsync(u => u.Email == "madagasser15@gmail.com");

            var students = await db.Users
                .Where(u => db.UserRoles.Any(ur => ur.UserId == u.Id && ur.RoleId == db.Roles.First(r => r.Name == SD.Student).Id))
                .OrderBy(u => u.Id)
                .Select(u => new { u.Id, u.PreferredLanguage, u.Subjects })
                .ToListAsync();

            if (students.Count == 0)
            {
                Console.WriteLine("No students for instructor applications. Skipping.");
                return;
            }

            var existingUserIds = await db.InstructorApplications
                .Select(a => a.UserId).ToHashSetAsync();

            var created = 0;

            foreach (var student in students)
            {
                var h = StableHash($"ia:{student.Id}");
                if ((int)(h % 100) >= 14) continue; // ~14% of students apply
                if (existingUserIds.Contains(student.Id)) continue;

                var isEnglish = student.PreferredLanguage == "en";
                var templates = isEnglish ? InstructorAppTemplatesEn : InstructorAppTemplates;
                var template = templates[(int)((h >> 8) % templates.Length)];

                var statusRoll = (int)((h >> 12) % 100);
                var status = statusRoll < 60 ? SD.ApplicationStatusPending
                    : statusRoll < 85 ? SD.ApplicationStatusApproved
                    : SD.ApplicationStatusRejected;

                var skills = student.Subjects?.Count > 0
                    ? string.Join(", ", student.Subjects.Take(3))
                    : (isEnglish ? "C#, ASP.NET Core, SQL" : "C#, ASP.NET Core, SQL");

                var application = new InstructorApplication
                {
                    Id = Guid.NewGuid(),
                    UserId = student.Id,
                    Specialization = template.Specialization,
                    Experience = template.Experience,
                    Skills = skills,
                    CvUrl = $"/uploads/cv/cv-{Guid.NewGuid().ToString("N")[..8]}.pdf",
                    Status = status,
                    AppliedDate = DateTime.UtcNow.AddDays(-((int)((h >> 16) % 45)) - 1)
                };

                if (status != SD.ApplicationStatusPending)
                {
                    application.ReviewedDate = application.AppliedDate.AddDays(3);
                    application.ReviewedBy = admin?.Id;
                    if (status == SD.ApplicationStatusRejected)
                    {
                        application.RejectionReason = isEnglish
                            ? "Not enough teaching experience for this field at the moment."
                            : "لا تتوفر خبرة تدريس كافية في هذا المجال حالياً.";
                    }
                }

                db.InstructorApplications.Add(application);
                existingUserIds.Add(student.Id);
                created++;
            }

            if (created > 0)
            {
                await db.SaveChangesAsync();
            }

            Console.WriteLine($"Instructor applications done. Created: +{created}");
        }

        /// <summary>
        /// Scans all users in the database and repairs any Arabic fields (FullName, Title, Location, About)
        /// that suffered from character encoding / Mojibake corruption from legacy seed runs.
        /// </summary>
        public static async Task<int> FixCorruptedUserProfilesAsync(ApplicationDbContext db)
        {
            System.Text.Encoding.RegisterProvider(System.Text.CodePagesEncodingProvider.Instance);
            var win1256 = System.Text.Encoding.GetEncoding("windows-1256");

            var users = await db.Users.ToListAsync();
            var fixedCount = 0;

            foreach (var user in users)
            {
                var changed = false;

                var fixedName = FixMojibake(user.FullName, win1256);
                if (fixedName != user.FullName)
                {
                    user.FullName = fixedName;
                    changed = true;
                }

                var fixedTitle = FixMojibake(user.Title, win1256);
                if (fixedTitle != user.Title)
                {
                    user.Title = fixedTitle;
                    changed = true;
                }

                var fixedLoc = FixMojibake(user.Location, win1256);
                if (fixedLoc != user.Location)
                {
                    user.Location = fixedLoc;
                    changed = true;
                }

                var fixedAbout = FixMojibake(user.About, win1256);
                if (fixedAbout != user.About)
                {
                    user.About = fixedAbout;
                    changed = true;
                }

                if (changed)
                {
                    fixedCount++;
                }
            }

            if (fixedCount > 0)
            {
                await db.SaveChangesAsync();
                db.ChangeTracker.Clear();
                Console.WriteLine($"Repaired corrupted Arabic profile data for {fixedCount} users.");
            }
            else
            {
                Console.WriteLine("No corrupted user profiles found. All Arabic names are healthy.");
            }

            return fixedCount;
        }

        private static string FixMojibake(string? input, System.Text.Encoding win1256)
        {
            if (string.IsNullOrWhiteSpace(input)) return input ?? string.Empty;
            if (!input.Contains('ط') && !input.Contains('ظ')) return input;

            try
            {
                var bytes = win1256.GetBytes(input);
                var decoded = System.Text.Encoding.UTF8.GetString(bytes);
                if (!decoded.Contains('\uFFFD') && decoded.Any(c => c >= 0x0600 && c <= 0x06FF))
                {
                    return decoded;
                }
            }
            catch
            {
            }

            return input;
        }
    }

    internal enum SeedResult
    {
        Created,
        Updated,
        Skipped
    }
}