using EduLab_Domain.Entities;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.DB
{
    public static class DbInitializer
    {
        public static async Task InitializeAsync(ApplicationDbContext db,
                                              UserManager<ApplicationUser> userManager,
                                              RoleManager<IdentityRole> roleManager,
                                              ILogger logger = null)
        {
            try
            {
                logger?.LogInformation("Starting database initialization...");

                // Apply pending migrations
                if (db.Database.GetPendingMigrations().Any())
                {
                    logger?.LogInformation("Applying pending migrations...");
                    await db.Database.MigrateAsync();
                }

                // Seed data
                await SeedRolesAsync(roleManager, logger);
                var users = await SeedUsersAsync(userManager, logger);
                var categories = await SeedCategoriesAsync(db, logger);
                var courses = await SeedCoursesAsync(db, categories, users.instructorUser, logger);
                await SeedSectionsAndLecturesAsync(db, courses, logger);
                await SeedEnrollmentsAndCertificatesAsync(db, courses, users.studentUser, logger);
                await SeedPaymentsAsync(db, courses, users.studentUser, logger);
                await SeedReviewsAndRatingsAsync(db, courses, users.studentUser, logger);
                await SeedInstructorApplicationsAsync(db, users.studentUser, logger);
                await SeedWishlistAsync(db, courses, users.studentUser, logger);
                await SeedNotificationsAsync(db, users, logger);

                logger?.LogInformation("Database initialization completed successfully.");
            }
            catch (Exception ex)
            {
                logger?.LogError(ex, "An error occurred during database initialization.");
                throw;
            }
        }

        private static async Task SeedRolesAsync(RoleManager<IdentityRole> roleManager, ILogger logger)
        {
            string[] roles = { SD.Admin, SD.Instructor, SD.Student, SD.InstructorPending };

            foreach (var role in roles)
            {
                if (!await roleManager.RoleExistsAsync(role))
                {
                    logger?.LogInformation("Creating role: {Role}", role);
                    await roleManager.CreateAsync(new IdentityRole(role));
                }
            }
        }

        private static async Task<(ApplicationUser adminUser, ApplicationUser instructorUser, ApplicationUser studentUser)>
            SeedUsersAsync(UserManager<ApplicationUser> userManager, ILogger logger)
        {
            var adminUser = new ApplicationUser
            {
                UserName = "admin@edulab.com",
                Email = "admin@edulab.com",
                FullName = "أحمد محمد",
                Title = "مدير المنصة",
                Location = "القاهرة، مصر",
                About = "مسؤول عن إدارة المنصة ومراقبة المحتوى",
                ProfileImageUrl = "/images/users/admin.jpg",
                GitHubUrl = "https://github.com/edulab-admin",
                LinkedInUrl = "https://linkedin.com/in/edulab-admin",
                TwitterUrl = "https://twitter.com/edulab-admin",
                FacebookUrl = "https://facebook.com/edulab-admin",
                Subjects = new List<string> { "إدارة", "تكنولوجيا", "تعليم" },
                CreatedAt = DateTime.UtcNow,
                EmailConfirmed = true
            };

            var instructorUser = new ApplicationUser
            {
                UserName = "instructor@edulab.com",
                Email = "instructor@edulab.com",
                FullName = "محمد علي",
                Title = "مدرب برمجة متخصص",
                Location = "الإسكندرية، مصر",
                About = "أعمل في تطوير البرمجيات ولدي خبرة 5 سنوات في تطوير تطبيقات الويب",
                ProfileImageUrl = "/images/users/instructor.jpg",
                GitHubUrl = "https://github.com/edulab-instructor",
                LinkedInUrl = "https://linkedin.com/in/edulab-instructor",
                TwitterUrl = "https://twitter.com/edulab-instructor",
                FacebookUrl = "https://facebook.com/edulab-instructor",
                Subjects = new List<string> { "برمجة", "C#", "ASP.NET Core", "قواعد البيانات" },
                CreatedAt = DateTime.UtcNow,
                EmailConfirmed = true
            };

            var studentUser = new ApplicationUser
            {
                UserName = "student@edulab.com",
                Email = "student@edulab.com",
                FullName = "علي حسن",
                Title = "طالب هندسة برمجيات",
                Location = "الجيزة، مصر",
                About = "أحب تعلم البرمجة وتطوير الويب وأطمح لأن أصبح مبرمج محترف",
                ProfileImageUrl = "/images/users/student.jpg",
                GitHubUrl = "https://github.com/edulab-student",
                LinkedInUrl = "https://linkedin.com/in/edulab-student",
                TwitterUrl = "https://twitter.com/edulab-student",
                FacebookUrl = "https://facebook.com/edulab-student",
                Subjects = new List<string> { "برمجة", "ويب", "قواعد بيانات", "خوارزميات" },
                CreatedAt = DateTime.UtcNow,
                EmailConfirmed = true
            };

            // Create admin user
            if (await userManager.FindByEmailAsync(adminUser.Email) == null)
            {
                var result = await userManager.CreateAsync(adminUser, "Admin@123");
                if (result.Succeeded)
                {
                    await userManager.AddToRoleAsync(adminUser, SD.Admin);
                    logger?.LogInformation("Admin user created successfully.");
                }
                else
                {
                    logger?.LogError("Failed to create admin user: {Errors}",
                        string.Join(", ", result.Errors.Select(e => e.Description)));
                }
            }

            // Create instructor user
            if (await userManager.FindByEmailAsync(instructorUser.Email) == null)
            {
                var result = await userManager.CreateAsync(instructorUser, "Instructor@123");
                if (result.Succeeded)
                {
                    await userManager.AddToRoleAsync(instructorUser, SD.Instructor);
                    logger?.LogInformation("Instructor user created successfully.");
                }
            }

            // Create student user
            if (await userManager.FindByEmailAsync(studentUser.Email) == null)
            {
                var result = await userManager.CreateAsync(studentUser, "Student@123");
                if (result.Succeeded)
                {
                    await userManager.AddToRoleAsync(studentUser, SD.Student);
                    logger?.LogInformation("Student user created successfully.");
                }
            }

            return (adminUser, instructorUser, studentUser);
        }

        private static async Task<List<Category>> SeedCategoriesAsync(ApplicationDbContext db, ILogger logger)
        {
            if (await db.Categories.AnyAsync())
                return await db.Categories.ToListAsync();

            var categories = new List<Category>
            {
                new Category { Category_Name = "برمجة وتطوير", CreatedAt = DateTime.UtcNow },
                new Category { Category_Name = "تصميم جرافيك", CreatedAt = DateTime.UtcNow },
                new Category { Category_Name = "إدارة أعمال", CreatedAt = DateTime.UtcNow },
                new Category { Category_Name = "لغات أجنبية", CreatedAt = DateTime.UtcNow },
                new Category { Category_Name = "علوم البيانات والذكاء الاصطناعي", CreatedAt = DateTime.UtcNow },
                new Category { Category_Name = "تسويق رقمي", CreatedAt = DateTime.UtcNow },
                new Category { Category_Name = "مهارات شخصية", CreatedAt = DateTime.UtcNow },
                new Category { Category_Name = "الصحة واللياقة", CreatedAt = DateTime.UtcNow }
            };

            await db.Categories.AddRangeAsync(categories);
            await db.SaveChangesAsync();
            logger?.LogInformation("Categories seeded successfully.");

            return categories;
        }

        private static async Task<List<Course>> SeedCoursesAsync(ApplicationDbContext db, List<Category> categories, ApplicationUser instructor, ILogger logger)
        {
            if (await db.Courses.AnyAsync())
                return await db.Courses.ToListAsync();

            var programmingCategory = categories.First(c => c.Category_Name == "برمجة وتطوير");
            var dataScienceCategory = categories.First(c => c.Category_Name == "علوم البيانات والذكاء الاصطناعي");

            var courses = new List<Course>
            {
                new Course
                {
                    Title = "تعلم C# من الصفر للإحتراف",
                    Description = "دورة شاملة لتعلم لغة C# من الأساسيات وحتى المستوى المتقدم مع مشاريع عملية",
                    ShortDescription = "تعلم C# بسهولة وإنشاء تطبيقات حقيقية",
                    Price = 199.99m,
                    Discount = 149.99m,
                    ThumbnailUrl = "/images/courses/csharp.jpg",
                    CreatedAt = DateTime.UtcNow,
                    InstructorId = instructor.Id,
                    CategoryId = programmingCategory.Category_Id,
                    Level = "مبتدئ",
                    Language = "العربية",
                    Duration = 30,
                    HasCertificate = true,
                    Requirements = new List<string> { "جهاز كمبيوتر", "برنامج Visual Studio", "معرفة أساسية بالكمبيوتر" },
                    Learnings = new List<string> { "أساسيات البرمجة", "كتابة كود نظيف", "بناء تطبيقات حقيقية", "Object Oriented Programming" },
                    TargetAudience = "المبتدئين في البرمجة، طلاب الكمبيوتر، الراغبين في تغيير مسارهم المهني",
                    Status = Coursestatus.Approved
                },
                new Course
                {
                    Title = "تطوير الويب باستخدام ASP.NET Core",
                    Description = "دورة متكاملة لتعلم بناء تطبيقات الويب الحديثة باستخدام ASP.NET Core و Entity Framework",
                    ShortDescription = "تطوير تطبيقات ويب احترافية باستخدام ASP.NET Core",
                    Price = 299.99m,
                    Discount = 249.99m,
                    ThumbnailUrl = "/images/courses/aspnet.jpg",
                    CreatedAt = DateTime.UtcNow,
                    InstructorId = instructor.Id,
                    CategoryId = programmingCategory.Category_Id,
                    Level = "متوسط",
                    Language = "العربية",
                    Duration = 45,
                    HasCertificate = true,
                    Requirements = new List<string> { "معرفة أساسية بـ C#", "Visual Studio", "HTML & CSS أساسيات" },
                    Learnings = new List<string> { "بناء APIs", "MVC Architecture", "Entity Framework Core", "Authentication & Authorization" },
                    TargetAudience = "المبرمجين الراغبين في تعلم تطوير الويب، مطوري Backend",
                    Status = Coursestatus.Approved
                },
                new Course
                {
                    Title = "تعلم بايثون وعلوم البيانات",
                    Description = "دورة متكاملة لتعلم لغة بايثون وتطبيقاتها في علوم البيانات والذكاء الاصطناعي",
                    ShortDescription = "بايثون للبيانات science والذكاء الاصطناعي",
                    Price = 349.99m,
                    ThumbnailUrl = "/images/courses/python.jpg",
                    CreatedAt = DateTime.UtcNow,
                    InstructorId = instructor.Id,
                    CategoryId = dataScienceCategory.Category_Id,
                    Level = "مبتدئ",
                    Language = "العربية",
                    Duration = 40,
                    HasCertificate = true,
                    Requirements = new List<string> { "جهاز كمبيوتر", "Python 3.x", "لا تحتاج خبرة سابقة" },
                    Learnings = new List<string> { "أساسيات بايثون", "تحليل البيانات", "Machine Learning", "Data Visualization" },
                    TargetAudience = "المهتمين بعلوم البيانات، الباحثين، محللي البيانات",
                    Status = Coursestatus.Approved
                }
            };

            await db.Courses.AddRangeAsync(courses);
            await db.SaveChangesAsync();
            logger?.LogInformation("Courses seeded successfully.");

            return courses;
        }

        private static async Task SeedSectionsAndLecturesAsync(ApplicationDbContext db, List<Course> courses, ILogger logger)
        {
            if (await db.Sections.AnyAsync()) return;

            var sections = new List<Section>();
            var lectures = new List<Lecture>();

            foreach (var course in courses)
            {
                if (course.Title.Contains("C#"))
                {
                    var cSharpSections = new[]
                    {
                        new Section { Title = "مقدمة إلى C#", Order = 1, CourseId = course.Id },
                        new Section { Title = "أساسيات البرمجة", Order = 2, CourseId = course.Id },
                        new Section { Title = "البرمجة الكائنية", Order = 3, CourseId = course.Id },
                        new Section { Title = "مشروع نهائي", Order = 4, CourseId = course.Id }
                    };
                    sections.AddRange(cSharpSections);

                    // Lectures for C# course
                    lectures.AddRange(new[]
                    {
                        new Lecture
                        {
                            Title = "ما هي لغة C# ولماذا نتعلمها؟",
                            ArticleContent = "C# هي لغة برمجة كائنية التوجه طورتها مايكروسوفت...",
                            ContentType = ContentType.Article,
                            Duration = 15,
                            Order = 1,
                            IsFreePreview = true,
                            SectionId = cSharpSections[0].Id,
                            Description = "مقدمة شاملة عن لغة C# ومجالات استخدامها"
                        },
                        new Lecture
                        {
                            Title = "تثبيت وتجهيز بيئة العمل",
                            VideoUrl = "/videos/csharp/setup.mp4",
                            ContentType = ContentType.Video,
                            Duration = 20,
                            Order = 2,
                            IsFreePreview = true,
                            SectionId = cSharpSections[0].Id,
                            Description = "كيفية تثبيت Visual Studio وإعداد المشروع الأول"
                        }
                    });
                }
                else if (course.Title.Contains("ASP.NET Core"))
                {
                    var aspNetSections = new[]
                    {
                        new Section { Title = "مقدمة إلى ASP.NET Core", Order = 1, CourseId = course.Id },
                        new Section { Title = "بناء أول تطبيق ويب", Order = 2, CourseId = course.Id },
                        new Section { Title = "قواعد البيانات و Entity Framework", Order = 3, CourseId = course.Id }
                    };
                    sections.AddRange(aspNetSections);

                    lectures.Add(new Lecture
                    {
                        Title = "ما هو ASP.NET Core؟",
                        ArticleContent = "ASP.NET Core هو إطار عمل مفتوح المصدر...",
                        ContentType = ContentType.Article,
                        Duration = 15,
                        Order = 1,
                        IsFreePreview = true,
                        SectionId = aspNetSections[0].Id,
                        Description = "مقدمة عن ASP.NET Core ومميزاته"
                    });
                }
            }

            await db.Sections.AddRangeAsync(sections);
            await db.Lectures.AddRangeAsync(lectures);
            await db.SaveChangesAsync();
            logger?.LogInformation("Sections and lectures seeded successfully.");
        }

        private static async Task SeedEnrollmentsAndCertificatesAsync(ApplicationDbContext db, List<Course> courses, ApplicationUser student, ILogger logger)
        {
            if (await db.Enrollments.AnyAsync()) return;

            var enrollments = new List<Enrollment>
            {
                new Enrollment
                {
                    CourseId = courses[0].Id,
                    UserId = student.Id,
                    EnrolledAt = DateTime.UtcNow.AddDays(-10)
                },
                new Enrollment
                {
                    CourseId = courses[1].Id,
                    UserId = student.Id,
                    EnrolledAt = DateTime.UtcNow.AddDays(-5)
                }
            };

            await db.Enrollments.AddRangeAsync(enrollments);
            await db.SaveChangesAsync();

            // Add certificates
            var certificates = new List<Certificate>
            {
                new Certificate
                {
                    Name = "شهادة إتمام دورة C# المتقدمة",
                    Issuer = "EduLab",
                    Year = DateTime.UtcNow.Year,
                    UserId = student.Id
                },
                new Certificate
                {
                    Name = "شهادة إتمام دورة ASP.NET Core",
                    Issuer = "EduLab",
                    Year = DateTime.UtcNow.Year,
                    UserId = student.Id
                }
            };

            await db.Certificates.AddRangeAsync(certificates);
            await db.SaveChangesAsync();
            logger?.LogInformation("Enrollments and certificates seeded successfully.");
        }

        private static async Task SeedPaymentsAsync(ApplicationDbContext db, List<Course> courses, ApplicationUser student, ILogger logger)
        {
            if (await db.Payments.AnyAsync()) return;

            var payments = new List<Payment>
            {
                new Payment
                {
                    UserId = student.Id,
                    CourseId = courses[0].Id,
                    Amount = courses[0].Discount ?? courses[0].Price,
                    PaymentMethod = "بطاقة ائتمانية",
                    Status = "مكتمل",
                    PaidAt = DateTime.UtcNow.AddDays(-11),
                    StripeSessionId = "cs_test_" + Guid.NewGuid().ToString("N")
                },
                new Payment
                {
                    UserId = student.Id,
                    CourseId = courses[1].Id,
                    Amount = courses[1].Discount ?? courses[1].Price,
                    PaymentMethod = "PayPal",
                    Status = "مكتمل",
                    PaidAt = DateTime.UtcNow.AddDays(-6),
                    StripeSessionId = "cs_test_" + Guid.NewGuid().ToString("N")
                }
            };

            await db.Payments.AddRangeAsync(payments);
            await db.SaveChangesAsync();
            logger?.LogInformation("Payments seeded successfully.");
        }

        private static async Task SeedReviewsAndRatingsAsync(ApplicationDbContext db, List<Course> courses, ApplicationUser student, ILogger logger)
        {
            if (await db.Reviews.AnyAsync()) return;

            var reviews = new List<Review>
            {
                new Review
                {
                    CourseId = courses[0].Id,
                    UserId = student.Id,
                    Rating = 5,
                    Comment = "دورة رائعة، شرح واضح ومفيد جداً للمبتدئين",
                    CreatedAt = DateTime.UtcNow.AddDays(-3)
                },
                new Review
                {
                    CourseId = courses[1].Id,
                    UserId = student.Id,
                    Rating = 4,
                    Comment = "محتوى جيد ولكن يحتاج المزيد من الأمثلة العملية",
                    CreatedAt = DateTime.UtcNow.AddDays(-1)
                }
            };

            var ratings = new List<Rating>
            {
                new Rating
                {
                    CourseId = courses[0].Id,
                    UserId = student.Id,
                    Value = 5,
                    Comment = "دورة ممتازة للمبتدئين",
                    CreatedAt = DateTime.UtcNow.AddDays(-3)
                },
                new Rating
                {
                    CourseId = courses[1].Id,
                    UserId = student.Id,
                    Value = 4,
                    Comment = "جيدة ولكن تحتاج تحديث",
                    CreatedAt = DateTime.UtcNow.AddDays(-1)
                }
            };

            await db.Reviews.AddRangeAsync(reviews);
            await db.Ratings.AddRangeAsync(ratings);
            await db.SaveChangesAsync();
            logger?.LogInformation("Reviews and ratings seeded successfully.");
        }

        private static async Task SeedInstructorApplicationsAsync(ApplicationDbContext db, ApplicationUser student, ILogger logger)
        {
            if (await db.InstructorApplications.AnyAsync()) return;

            var application = new InstructorApplication
            {
                UserId = student.Id,
                Specialization = "برمجة وتطوير الويب",
                Experience = "3 سنوات خبرة كمطور ويب في شركات مختلفة، مشاريع شخصية متعددة",
                Skills = "C#, ASP.NET Core, SQL, JavaScript, React, Python",
                CvUrl = "/uploads/cv/student-cv.pdf",
                Status = "Pending",
                AppliedDate = DateTime.UtcNow.AddDays(-15),
            };

            await db.InstructorApplications.AddAsync(application);
            await db.SaveChangesAsync();
            logger?.LogInformation("Instructor applications seeded successfully.");
        }

        private static async Task SeedWishlistAsync(ApplicationDbContext db, List<Course> courses, ApplicationUser student, ILogger logger)
        {
            if (await db.WishlistItems.AnyAsync()) return;

            var wishlistItems = new List<Wishlist>
            {
                new Wishlist
                {
                    UserId = student.Id,
                    CourseId = courses[2].Id, // Python course
                    AddedAt = DateTime.UtcNow.AddDays(-2)
                }
            };

            await db.WishlistItems.AddRangeAsync(wishlistItems);
            await db.SaveChangesAsync();
            logger?.LogInformation("Wishlist seeded successfully.");
        }

        private static async Task SeedNotificationsAsync(ApplicationDbContext db,
            (ApplicationUser admin, ApplicationUser instructor, ApplicationUser student) users, ILogger logger)
        {
            if (await db.Notifications.AnyAsync()) return;

            var notifications = new List<Notification>
            {
                new Notification
                {
                    Title = "مرحبا بك في EduLab!",
                    Message = "نرحب بك في منصة EduLab للتعلم الإلكتروني. نتمنى لك رحلة تعلم ممتعة.",
                    Type = NotificationType.System,
                    Status = NotificationStatus.Read,
                    UserId = users.student.Id,
                    CreatedAt = DateTime.UtcNow.AddDays(-15),
                    RelatedEntityType = "Welcome"
                },
                new Notification
                {
                    Title = "دورة جديدة متاحة",
                    Message = "تمت إضافة دورة جديدة في تخصص البرمجة قد تهمك.",
                    Type = NotificationType.Promotional,
                    Status = NotificationStatus.Unread,
                    UserId = users.student.Id,
                    CreatedAt = DateTime.UtcNow.AddDays(-3),
                    RelatedEntityType = "Course"
                },
                new Notification
                {
                    Title = "تمت الموافقة على دورتك",
                    Message = "تمت الموافقة على دورة 'تعلم C# من الصفر للإحتراف' وتم نشرها.",
                    Type = NotificationType.Course,
                    Status = NotificationStatus.Read,
                    UserId = users.instructor.Id,
                    CreatedAt = DateTime.UtcNow.AddDays(-5),
                    RelatedEntityType = "Course",
                    RelatedEntityId = "1"
                }
            };

            await db.Notifications.AddRangeAsync(notifications);
            await db.SaveChangesAsync();
            logger?.LogInformation("Notifications seeded successfully.");
        }
    }
}