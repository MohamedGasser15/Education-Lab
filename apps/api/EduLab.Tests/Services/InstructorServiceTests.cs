using System.Linq.Expressions;
using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab.Tests.Fakes;
using Microsoft.AspNetCore.Identity;
using Moq;
using Xunit;

namespace EduLab.Tests.Services;

public class InstructorServiceTests
{
    private readonly List<ApplicationUser> _users;
    private readonly List<Rating> _allRatings;
    private readonly Mock<IRatingRepository> _ratingRepo;
    private readonly InstructorService _service;

    public InstructorServiceTests()
    {
        var ins1 = TestData.User("ins-1", "Sara", role: "Instructor");
        ins1.Title = "Senior Developer";
        ins1.CoursesCreated = new List<Course> { InstructorCourse(1, "C# Basics"), InstructorCourse(2, "React") };

        var ins2 = TestData.User("ins-2", "Omar", role: "Instructor");
        ins2.Title = "UI Designer";
        ins2.CoursesCreated = new List<Course> { InstructorCourse(3, "Design") };

        var student = TestData.User("st-1", "Ahmed", role: "Student");

        _users = new List<ApplicationUser> { ins1, ins2, student };

        _allRatings = new List<Rating>
        {
            RatingFor(1, 1, "ins-1", "st-1", 4),
            RatingFor(2, 1, "ins-1", "st-2", 5)
        };

        _ratingRepo = new Mock<IRatingRepository>();
        _ratingRepo.Setup(x => x.GetAllAsync(
                It.IsAny<Expression<Func<Rating, bool>>>(),
                It.IsAny<string>(),
                It.IsAny<bool>(),
                It.IsAny<Func<IQueryable<Rating>, IOrderedQueryable<Rating>>>(),
                It.IsAny<int?>(),
                It.IsAny<CancellationToken>()))
            .ReturnsAsync((Expression<Func<Rating, bool>> filter, string _, bool __,
                Func<IQueryable<Rating>, IOrderedQueryable<Rating>>? ___, int? ____, CancellationToken _______) =>
                _allRatings.AsQueryable().Where(filter).ToList());

        var userManager = TestData.MockUserManager(_users);
        userManager.Setup(x => x.GetRolesAsync(It.IsAny<ApplicationUser>()))
            .ReturnsAsync((ApplicationUser u) =>
            {
                var original = _users.FirstOrDefault(x => x.Id == u?.Id);
                return new List<string> { original?.Role ?? "Student" };
            });

        _service = new InstructorService(
            userManager.Object,
            TestInfrastructure.RealMapper(),
            TestData.NullLogger<InstructorService>(),
            _ratingRepo.Object);
    }

    private static Rating RatingFor(int id, int courseId, string instructorId, string userId, int value)
    {
        var rating = TestData.Rating(id, courseId, userId, value);
        rating.Course = new Course { Id = courseId, InstructorId = instructorId };
        return rating;
    }

    private static Course InstructorCourse(int id, string title)
    {
        var course = TestData.Course(id, title);
        course.Category = null;
        course.Requirements = new List<string>();
        course.Learnings = new List<string>();
        course.Description = "desc";
        course.ShortDescription = "short";
        course.Level = "Beginner";
        course.Language = "ar";
        course.TargetAudience = "Everyone";
        return course;
    }

    [Fact]
    public async Task GetAllInstructorsAsync_ReturnsOnlyInstructors()
    {
        var result = await _service.GetAllInstructorsAsync();

        Assert.Equal(2, result.TotalCount);
        Assert.Equal(2, result.Instructors.Count);
        Assert.All(result.Instructors, i => Assert.DoesNotContain(i.Id, new[] { "st-1" }));
    }

    [Fact]
    public async Task GetAllInstructorsAsync_ComputesAverageRatingAndCourseCount()
    {
        var result = await _service.GetAllInstructorsAsync();

        var sara = result.Instructors.Single(i => i.Id == "ins-1");
        Assert.Equal("Sara", sara.FullName);
        Assert.Equal("Senior Developer", sara.Title);
        Assert.Equal(2, sara.TotalCourses);
        Assert.Equal(4.5, sara.Rating);

        var omar = result.Instructors.Single(i => i.Id == "ins-2");
        Assert.Equal(0, omar.Rating);
        Assert.Equal(1, omar.TotalCourses);
    }

    [Fact]
    public async Task GetInstructorByIdAsync_ReturnsInstructorWithRating()
    {
        var result = await _service.GetInstructorByIdAsync("ins-1");

        Assert.NotNull(result);
        Assert.Equal("Sara", result.FullName);
        Assert.Equal(4.5, result.Rating);
        Assert.Equal(2, result.TotalCourses);
    }

    [Fact]
    public async Task GetInstructorByIdAsync_ReturnsNullForUnknownId()
    {
        Assert.Null(await _service.GetInstructorByIdAsync("missing"));
    }

    [Fact]
    public async Task GetInstructorByIdAsync_ReturnsNullForEmptyId()
    {
        Assert.Null(await _service.GetInstructorByIdAsync(""));
    }

    [Fact]
    public async Task GetInstructorByIdAsync_ReturnsNullForNonInstructorUser()
    {
        Assert.Null(await _service.GetInstructorByIdAsync("st-1"));
    }

    [Fact]
    public async Task GetTopRatedInstructorsAsync_ReturnsRequestedCount()
    {
        var result = await _service.GetTopRatedInstructorsAsync(1);

        var instructor = Assert.Single(result);
        Assert.Equal("ins-1", instructor.Id);
        Assert.Equal(4.5, instructor.Rating);
    }

    [Fact]
    public async Task GetTopRatedInstructorsAsync_ReturnsEmptyForNonPositiveCount()
    {
        var result = await _service.GetTopRatedInstructorsAsync(0);

        Assert.Empty(result);
    }

    [Fact]
    public async Task GetTopRatedInstructorsAsync_TakesUpToAvailableInstructors()
    {
        var result = await _service.GetTopRatedInstructorsAsync(5);

        Assert.Equal(2, result.Count);
    }
}
