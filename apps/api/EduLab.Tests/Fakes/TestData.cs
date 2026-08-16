using EduLab_Domain.Entities;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Moq;
using EduLab_Infrastructure.DB;

namespace EduLab.Tests.Fakes;

public static class TestData
{
    public static ApplicationUser User(string id, string name, DateTime? createdAt = null, string role = "Student")
    {
        return new ApplicationUser
        {
            Id = id,
            UserName = name,
            Email = $"{name}@test.com",
            FullName = name,
            CreatedAt = createdAt ?? DateTime.UtcNow.AddDays(-10),
            Role = role
        };
    }

    public static Course Course(int id, string title, decimal price = 100m, decimal? discount = null, string instructorId = "ins-1", int categoryId = 1, DateTime? createdAt = null)
    {
        return new Course
        {
            Id = id,
            Title = title,
            Price = price,
            Discount = discount,
            InstructorId = instructorId,
            CategoryId = categoryId,
            Status = Coursestatus.Approved,
            CreatedAt = createdAt ?? DateTime.UtcNow.AddDays(-5),
            Category = new Category { Category_Id = categoryId, Category_Name = $"Category {categoryId}" },
            Sections = new List<Section>()
        };
    }

    public static Enrollment Enrollment(int id, int courseId, string userId, DateTime? enrolledAt = null)
    {
        return new Enrollment
        {
            Id = id,
            CourseId = courseId,
            UserId = userId,
            EnrolledAt = enrolledAt ?? DateTime.UtcNow.AddDays(-2)
        };
    }

    public static Payment Payment(int id, int courseId, string userId, decimal amount, string status = "completed", DateTime? paidAt = null)
    {
        return new Payment
        {
            Id = id,
            CourseId = courseId,
            UserId = userId,
            Amount = amount,
            Status = status,
            PaidAt = paidAt ?? DateTime.UtcNow.AddDays(-1),
            CreatedAt = paidAt ?? DateTime.UtcNow.AddDays(-1)
        };
    }

    public static Rating Rating(int id, int courseId, string userId, int value, DateTime? createdAt = null)
    {
        return new Rating
        {
            Id = id,
            CourseId = courseId,
            UserId = userId,
            Value = value,
            CreatedAt = createdAt ?? DateTime.UtcNow.AddDays(-1)
        };
    }

    public static SupportConversation Conversation(int id, string userId, string subject = "Help", SupportConversationStatus status = SupportConversationStatus.Open)
    {
        return new SupportConversation
        {
            Id = id,
            UserId = userId,
            Subject = subject,
            Status = status,
            CreatedAt = DateTime.UtcNow.AddDays(-1),
            UpdatedAt = DateTime.UtcNow.AddDays(-1),
            Messages = new List<SupportMessage>()
        };
    }

    public static SupportMessage Message(int id, int conversationId, string senderId, SupportMessageSenderRole role, string content, bool isRead = false, DateTime? createdAt = null)
    {
        return new SupportMessage
        {
            Id = id,
            ConversationId = conversationId,
            SenderId = senderId,
            SenderRole = role,
            Content = content,
            IsRead = isRead,
            CreatedAt = createdAt ?? DateTime.UtcNow
        };
    }

    public static CourseProgress Progress(int id, int enrollmentId, int lectureId, int courseId, bool isCompleted)
    {
        return new CourseProgress
        {
            Id = id,
            EnrollmentId = enrollmentId,
            LectureId = lectureId,
            IsCompleted = isCompleted,
            Lecture = new Lecture
            {
                Id = lectureId,
                Title = $"Lecture {lectureId}",
                Duration = 600,
                Section = new Section { Id = lectureId, CourseId = courseId }
            }
        };
    }

    public static Cart Cart(int id, string? userId, string? guestId = null)
    {
        return new Cart
        {
            Id = id,
            UserId = userId,
            GuestId = guestId,
            CartItems = new List<CartItem>(),
            CreatedAt = DateTime.UtcNow.AddDays(-1),
            UpdatedAt = DateTime.UtcNow.AddDays(-1)
        };
    }

    public static CartItem CartItem(int id, int cartId, int courseId, decimal price, decimal? discount = null)
    {
        return new CartItem
        {
            Id = id,
            CartId = cartId,
            CourseId = courseId,
            AddedAt = DateTime.UtcNow,
            Course = new Course
            {
                Id = courseId,
                Title = $"Course {courseId}",
                Price = price,
                Discount = discount
            }
        };
    }

    public static Wishlist WishlistItem(int id, string userId, int courseId)
    {
        return new Wishlist
        {
            Id = id,
            UserId = userId,
            CourseId = courseId,
            AddedAt = DateTime.UtcNow.AddDays(-1)
        };
    }

    public static Notification Notification(int id, string userId, string title, string message, NotificationType type = NotificationType.System, NotificationStatus status = NotificationStatus.Unread)
    {
        return new Notification
        {
            Id = id,
            UserId = userId,
            Title = title,
            Message = message,
            Type = type,
            Status = status,
            CreatedAt = DateTime.UtcNow.AddHours(-1)
        };
    }

    public static History History(int id, string userId, string operation, string? messageKey = null, string? parameters = null)
    {
        return new History
        {
            Id = id,
            UserId = userId,
            Operation = operation,
            MessageKey = messageKey,
            Parameters = parameters,
            Date = DateOnly.FromDateTime(DateTime.Now),
            Time = TimeOnly.FromDateTime(DateTime.Now)
        };
    }

    public static InstructorApplication InstructorApplication(Guid id, string userId, string status = "Pending", DateTime? appliedDate = null)
    {
        return new InstructorApplication
        {
            Id = id,
            UserId = userId,
            Status = status,
            AppliedDate = appliedDate ?? DateTime.UtcNow.AddDays(-1)
        };
    }

    public static LectureComment LectureComment(int id, int lectureId, string userId, string content)
    {
        return new LectureComment
        {
            Id = id,
            LectureId = lectureId,
            UserId = userId,
            Content = content,
            CreatedAt = DateTime.UtcNow.AddHours(-1)
        };
    }

    public static SiteSettings Settings(int id = 1)
    {
        return new SiteSettings
        {
            Id = id,
            SiteName = "EduLab",
            SiteDescription = "Education platform",
            DefaultLanguage = "ar",
            DefaultTheme = "system",
            PrimaryColor = "#2563eb"
        };
    }

    /// <summary>
    /// Creates a UserManager mock with an InMemory-backed Users query (supports ToListAsync).
    /// </summary>
    public static Mock<UserManager<ApplicationUser>> MockUserManager(List<ApplicationUser>? users = null)
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;

        var db = new ApplicationDbContext(options);
        if (users != null)
        {
            db.Users.AddRange(users);
            db.SaveChanges();
        }

        var store = new Mock<IUserStore<ApplicationUser>>();
        var userManager = new Mock<UserManager<ApplicationUser>>(
            store.Object,
            null!, null!, null!, null!, null!, null!, null!, null!);

        userManager.Setup(x => x.Users).Returns(db.Users);
        userManager.Setup(x => x.GetRolesAsync(It.IsAny<ApplicationUser>()))
            .ReturnsAsync((ApplicationUser u) => new List<string> { u?.Role ?? "Student" });
        userManager.Setup(x => x.GetUsersInRoleAsync(It.IsAny<string>()))
            .ReturnsAsync(new List<ApplicationUser>());
        userManager.Setup(x => x.FindByIdAsync(It.IsAny<string>()))
            .ReturnsAsync((string id) => users?.FirstOrDefault(u => u.Id == id));

        return userManager;
    }

    public static ILogger<T> NullLogger<T>() => Mock.Of<ILogger<T>>();
}
