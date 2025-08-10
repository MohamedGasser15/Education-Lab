using EduLab_Domain.Entities;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
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
                                              RoleManager<IdentityRole> roleManager)
        {
            if (db.Database.GetPendingMigrations().Any())
            {
                await db.Database.MigrateAsync();
            }

            await SeedRolesAsync(roleManager);

            var (adminUser, instructorUser, studentUser) = await SeedUsersAsync(userManager);

            var categories = SeedCategories(db);

            var courses = SeedCourses(db, categories, instructorUser);

            SeedSectionsAndLectures(db, courses);

            SeedEnrollmentsAndCertificates(db, courses, studentUser);

            SeedPayments(db, courses, studentUser);

            SeedReviews(db, courses, studentUser);

            SeedInstructorApplications(db, studentUser);
        }

        private static async Task SeedRolesAsync(RoleManager<IdentityRole> roleManager)
        {
            string[] roles = { "Admin", "Instructor", "Student" };

            foreach (var role in roles)
            {
                if (!await roleManager.RoleExistsAsync(role))
                {
                    await roleManager.CreateAsync(new IdentityRole(role));
                }
            }
        }

        private static async Task<(ApplicationUser, ApplicationUser, ApplicationUser)> SeedUsersAsync(UserManager<ApplicationUser> userManager)
        {
            var adminUser = new ApplicationUser
            {
                UserName = "madagasser15@gmail.com",
                Email = "madagasser15@gmail.com",
                FullName = "أحمد محمد",
                CreatedAt = DateTime.Now
            };

            if (await userManager.FindByEmailAsync(adminUser.Email) == null)
            {
                await userManager.CreateAsync(adminUser, "Admin@123");
                await userManager.AddToRoleAsync(adminUser, "Admin");
            }

            var instructorUser = new ApplicationUser
            {
                UserName = "instructor@edulab.com",
                Email = "instructor@edulab.com",
                FullName = "محمد علي",
                CreatedAt = DateTime.Now
            };

            if (await userManager.FindByEmailAsync(instructorUser.Email) == null)
            {
                await userManager.CreateAsync(instructorUser, "Instructor123*");
                await userManager.AddToRoleAsync(instructorUser, "Instructor");
            }

            // إنشاء طالب
            var studentUser = new ApplicationUser
            {
                UserName = "student@edulab.com",
                Email = "student@edulab.com",
                FullName = "علي حسن",
                CreatedAt = DateTime.Now
            };

            if (await userManager.FindByEmailAsync(studentUser.Email) == null)
            {
                await userManager.CreateAsync(studentUser, "Student123*");
                await userManager.AddToRoleAsync(studentUser, "Student");
            }

            return (adminUser, instructorUser, studentUser);
        }

        private static List<Category> SeedCategories(ApplicationDbContext db)
        {
            if (db.Categories.Any()) return db.Categories.ToList();

            var categories = new List<Category>
            {
                new Category { Category_Name = "برمجة", CreatedAt = DateTime.Now },
                new Category { Category_Name = "تصميم", CreatedAt = DateTime.Now },
                new Category { Category_Name = "أعمال", CreatedAt = DateTime.Now },
                new Category { Category_Name = "لغات", CreatedAt = DateTime.Now },
                new Category { Category_Name = "علوم البيانات", CreatedAt = DateTime.Now }
            };

            db.Categories.AddRange(categories);
            db.SaveChanges();

            return categories;
        }

        private static List<Course> SeedCourses(ApplicationDbContext db, List<Category> categories, ApplicationUser instructor)
        {
            if (db.Courses.Any()) return db.Courses.ToList();

            var courses = new List<Course>
            {
                new Course
                {
                    Title = "تعلم C# من الصفر للإحتراف",
                    Description = "دورة شاملة لتعلم لغة C# من الأساسيات وحتى المستوى المتقدم",
                    ShortDescription = "تعلم C# بسهولة",
                    Price = 199.99m,
                    Discount = 149.99m,
                    ThumbnailUrl = "/images/courses/csharp.jpg",
                    CreatedAt = DateTime.Now,
                    InstructorId = instructor.Id,
                    CategoryId = categories.First(c => c.Category_Name == "برمجة").Category_Id,
                    Level = "مبتدئ",
                    Language = "العربية",
                    Duration = 30,
                    HasCertificate = true,
                    Requirements = new List<string> { "جهاز كمبيوتر", "برنامج Visual Studio" },
                    Learnings = new List<string> { "أساسيات البرمجة", "كتابة كود نظيف", "بناء تطبيقات حقيقية" },
                    TargetAudience = "المبتدئين في البرمجة"
                },
                new Course
                {
                    Title = "تعلم تطوير الويب باستخدام ASP.NET Core",
                    Description = "دورة متكاملة لتعلم بناء تطبيقات الويب باستخدام ASP.NET Core",
                    ShortDescription = "تطوير الويب باستخدام ASP.NET Core",
                    Price = 299.99m,
                    ThumbnailUrl = "/images/courses/aspnet.jpg",
                    CreatedAt = DateTime.Now,
                    InstructorId = instructor.Id,
                    CategoryId = categories.First(c => c.Category_Name == "برمجة").Category_Id,
                    Level = "متوسط",
                    Language = "العربية",
                    Duration = 45,
                    HasCertificate = true,
                    Requirements = new List<string> { "معرفة أساسية بـ C#", "Visual Studio" },
                    Learnings = new List<string> { "بناء APIs", "MVC Architecture", "Entity Framework Core" },
                    TargetAudience = "المبرمجين الراغبين في تعلم تطوير الويب"
                }
            };

            db.Courses.AddRange(courses);
            db.SaveChanges();

            return courses;
        }

        private static void SeedSectionsAndLectures(ApplicationDbContext db, List<Course> courses)
        {
            if (db.Sections.Any()) return;

            var sections = new List<Section>();
            var lectures = new List<Lecture>();

            foreach (var course in courses)
            {
                if (course.Title.Contains("C#"))
                {
                    var section1 = new Section
                    {
                        Title = "مقدمة إلى C#",
                        Order = 1,
                        CourseId = course.Id
                    };
                    sections.Add(section1);

                    lectures.AddRange(new List<Lecture>
                    {
                        new Lecture
                        {
                            Title = "ما هي لغة C#؟",
                            ArticleContent = "C# هي لغة برمجة كائنية التوجه...",
                            ContentType = ContentType.Article,
                            Duration = 15,
                            Order = 1,
                            IsFreePreview = true,
                            SectionId = section1.Id
                        },
                        new Lecture
                        {
                            Title = "تثبيت الأدوات المطلوبة",
                            VideoUrl = "https://example.com/video1",
                            ContentType = ContentType.Video,
                            Duration = 20,
                            Order = 2,
                            IsFreePreview = true,
                            SectionId = section1.Id
                        }
                    });

                    var section2 = new Section
                    {
                        Title = "أساسيات البرمجة",
                        Order = 2,
                        CourseId = course.Id
                    };
                    sections.Add(section2);

                    lectures.AddRange(new List<Lecture>
                    {
                        new Lecture
                        {
                            Title = "المتغيرات وأنواع البيانات",
                            VideoUrl = "https://example.com/video2",
                            ContentType = ContentType.Video,
                            Duration = 25,
                            Order = 1,
                            IsFreePreview = false,
                            SectionId = section2.Id
                        }
                    });
                }
                else if (course.Title.Contains("ASP.NET Core"))
                {
                    var section1 = new Section
                    {
                        Title = "مقدمة إلى ASP.NET Core",
                        Order = 1,
                        CourseId = course.Id
                    };
                    sections.Add(section1);

                    lectures.Add(new Lecture
                    {
                        Title = "ما هو ASP.NET Core؟",
                        ArticleContent = "ASP.NET Core هو إطار عمل مفتوح المصدر...",
                        ContentType = ContentType.Article,
                        Duration = 15,
                        Order = 1,
                        IsFreePreview = true,
                        SectionId = section1.Id
                    });
                }
            }

            db.Sections.AddRange(sections);
            db.Lectures.AddRange(lectures);
            db.SaveChanges();
        }

        private static void SeedEnrollmentsAndCertificates(ApplicationDbContext db, List<Course> courses, ApplicationUser student)
        {
            if (db.Enrollments.Any()) return;

            var enrollments = new List<Enrollment>
            {
                new Enrollment
                {
                    CourseId = courses[0].Id,
                    UserId = student.Id,
                    EnrolledAt = DateTime.Now.AddDays(-10)
                },
                new Enrollment
                {
                    CourseId = courses[1].Id,
                    UserId = student.Id,
                    EnrolledAt = DateTime.Now.AddDays(-5)
                }
            };

            db.Enrollments.AddRange(enrollments);
            db.SaveChanges();

            // إضافة شهادات للدورات المكتملة
            if (!db.Certificates.Any())
            {
                var certificates = new List<Certificate>
                {
                    new Certificate
                    {
                        EnrollmentId = enrollments[0].Id,
                        CertificateUrl = "/certificates/cert001.pdf",
                        IssuedAt = DateTime.Now.AddDays(-2)
                    }
                };

                db.Certificates.AddRange(certificates);
                db.SaveChanges();
            }

            // إضافة تقدم الدورة
            if (!db.CourseProgresses.Any())
            {
                var lectures = db.Lectures.ToList();
                var progresses = new List<CourseProgress>
                {
                    new CourseProgress
                    {
                        EnrollmentId = enrollments[0].Id,
                        LectureId = lectures[0].Id,
                        IsCompleted = true
                    },
                    new CourseProgress
                    {
                        EnrollmentId = enrollments[0].Id,
                        LectureId = lectures[1].Id,
                        IsCompleted = true
                    }
                };

                db.CourseProgresses.AddRange(progresses);
                db.SaveChanges();
            }
        }

        private static void SeedPayments(ApplicationDbContext db, List<Course> courses, ApplicationUser student)
        {
            if (db.Payments.Any()) return;

            var payments = new List<Payment>
            {
                new Payment
                {
                    UserId = student.Id,
                    CourseId = courses[0].Id,
                    Amount = courses[0].Discount ?? courses[0].Price,
                    PaymentMethod = "بطاقة ائتمانية",
                    Status = "مكتمل",
                    PaidAt = DateTime.Now.AddDays(-11)
                },
                new Payment
                {
                    UserId = student.Id,
                    CourseId = courses[1].Id,
                    Amount = courses[1].Price,
                    PaymentMethod = "PayPal",
                    Status = "مكتمل",
                    PaidAt = DateTime.Now.AddDays(-6)
                }
            };

            db.Payments.AddRange(payments);
            db.SaveChanges();
        }

        private static void SeedReviews(ApplicationDbContext db, List<Course> courses, ApplicationUser student)
        {
            if (db.Reviews.Any()) return;

            var reviews = new List<Review>
            {
                new Review
                {
                    CourseId = courses[0].Id,
                    UserId = student.Id,
                    Rating = 5,
                    Comment = "دورة رائعة، شرح واضح ومفيد",
                    CreatedAt = DateTime.Now.AddDays(-3)
                },
                new Review
                {
                    CourseId = courses[1].Id,
                    UserId = student.Id,
                    Rating = 4,
                    Comment = "محتوى جيد ولكن يحتاج المزيد من الأمثلة",
                    CreatedAt = DateTime.Now.AddDays(-1)
                }
            };

            db.Reviews.AddRange(reviews);
            db.SaveChanges();
        }

        private static void SeedInstructorApplications(ApplicationDbContext db, ApplicationUser student)
        {
            if (db.InstructorApplications.Any()) return;

            var application = new InstructorApplication
            {
                UserId = student.Id,
                Bio = "أنا مهتم بتدريس البرمجة ولدي خبرة 3 سنوات",
                Experience = "عملت كمطور ويب في عدة شركات",
                Status = "قيد المراجعة",
                AppliedAt = DateTime.Now.AddDays(-15)
            };

            db.InstructorApplications.Add(application);
            db.SaveChanges();
        }
    }
}