using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab.Tests.Fakes;
using Moq;
using Xunit;

namespace EduLab.Tests.Services;

public class WishlistServiceTests
{
    private class FakeWishlistRepository : FakeRepository<Wishlist>, IWishlistRepository
    {
        public Task<List<Wishlist>> GetUserWishlistAsync(string userId, CancellationToken cancellationToken = default)
            => GetAllAsync(w => w.UserId == userId, cancellationToken: cancellationToken);

        public Task<Wishlist> GetWishlistItemAsync(string userId, int courseId, CancellationToken cancellationToken = default)
            => GetAsync(w => w.UserId == userId && w.CourseId == courseId, cancellationToken: cancellationToken);

        public Task<bool> IsCourseInWishlistAsync(string userId, int courseId, CancellationToken cancellationToken = default)
            => AnyAsync(w => w.UserId == userId && w.CourseId == courseId, cancellationToken);

        public Task<int> GetWishlistCountAsync(string userId, CancellationToken cancellationToken = default)
            => Task.FromResult(Items.Count(w => w.UserId == userId));
    }

    private readonly FakeWishlistRepository _wishlistRepo;
    private readonly FakeRepository<Course> _courseRepo;
    private readonly Mock<IRatingRepository> _ratingRepo;
    private readonly WishlistService _service;

    public WishlistServiceTests()
    {
        _wishlistRepo = new FakeWishlistRepository();
        _courseRepo = new FakeRepository<Course>();
        _ratingRepo = new Mock<IRatingRepository>();
        _ratingRepo.Setup(r => r.GetCourseRatingSummaryRawAsync(It.IsAny<int>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((4.5, 2, new Dictionary<int, int> { [5] = 1, [4] = 1 }));

        _service = new WishlistService(
            _wishlistRepo,
            _courseRepo,
            TestData.NullLogger<WishlistService>(),
            _ratingRepo.Object);
    }

    private static Wishlist WishlistWithCourse(int id, string userId, int courseId, string title, string instructorName)
    {
        return new Wishlist
        {
            Id = id,
            UserId = userId,
            CourseId = courseId,
            AddedAt = DateTime.UtcNow.AddDays(-1),
            Course = new Course
            {
                Id = courseId,
                Title = title,
                ShortDescription = $"{title} description",
                Price = 100m,
                Discount = 20m,
                ThumbnailUrl = $"https://img/{courseId}.png",
                Instructor = TestData.User("ins-1", instructorName)
            }
        };
    }

    [Fact]
    public async Task AddToWishlistAsync_AddsCourseAndReturnsCount()
    {
        _courseRepo.Items.Add(TestData.Course(1, "C# Basics"));

        var result = await _service.AddToWishlistAsync("u1", 1);

        Assert.True(result.Success);
        Assert.Equal(1, result.WishlistCount);
        var stored = Assert.Single(_wishlistRepo.Items);
        Assert.Equal("u1", stored.UserId);
        Assert.Equal(1, stored.CourseId);
    }

    [Fact]
    public async Task AddToWishlistAsync_CourseNotFound_ReturnsFailure()
    {
        var result = await _service.AddToWishlistAsync("u1", 999);

        Assert.False(result.Success);
        Assert.Equal("Course not found", result.Message);
        Assert.Empty(_wishlistRepo.Items);
    }

    [Fact]
    public async Task AddToWishlistAsync_Duplicate_ReturnsFailure()
    {
        _courseRepo.Items.Add(TestData.Course(1, "C# Basics"));
        _wishlistRepo.Items.Add(TestData.WishlistItem(1, "u1", 1));

        var result = await _service.AddToWishlistAsync("u1", 1);

        Assert.False(result.Success);
        Assert.Equal("Course is already in wishlist", result.Message);
        Assert.Single(_wishlistRepo.Items);
    }

    [Fact]
    public async Task AddToWishlistAsync_EmptyUserId_ThrowsArgumentException()
    {
        await Assert.ThrowsAsync<ArgumentException>(() => _service.AddToWishlistAsync("", 1));
    }

    [Fact]
    public async Task RemoveFromWishlistAsync_RemovesCourseAndReturnsNewCount()
    {
        _wishlistRepo.Items.Add(TestData.WishlistItem(1, "u1", 1));
        _wishlistRepo.Items.Add(TestData.WishlistItem(2, "u1", 2));

        var result = await _service.RemoveFromWishlistAsync("u1", 1);

        Assert.True(result.Success);
        Assert.Equal(1, result.WishlistCount);
        Assert.DoesNotContain(_wishlistRepo.Items, w => w.CourseId == 1);
    }

    [Fact]
    public async Task RemoveFromWishlistAsync_NotInWishlist_ReturnsFailure()
    {
        var result = await _service.RemoveFromWishlistAsync("u1", 42);

        Assert.False(result.Success);
        Assert.Equal("Course not found in wishlist", result.Message);
    }

    [Fact]
    public async Task IsCourseInWishlistAsync_ReturnsTrueOnlyWhenPresent()
    {
        _wishlistRepo.Items.Add(TestData.WishlistItem(1, "u1", 1));

        Assert.True(await _service.IsCourseInWishlistAsync("u1", 1));
        Assert.False(await _service.IsCourseInWishlistAsync("u1", 2));
    }

    [Fact]
    public async Task GetUserWishlistAsync_ReturnsItemsWithCourseAndRatingInfo()
    {
        _wishlistRepo.Items.Add(WishlistWithCourse(1, "u1", 10, "React", "Sara Ahmed"));
        _wishlistRepo.Items.Add(WishlistWithCourse(2, "u1", 20, "Node.js", "Omar Ali"));
        _wishlistRepo.Items.Add(TestData.WishlistItem(3, "u2", 30)); // other user

        var result = await _service.GetUserWishlistAsync("u1");

        Assert.Equal(2, result.Count);
        var first = result.First(w => w.CourseId == 10);
        Assert.Equal("React", first.CourseTitle);
        Assert.Equal("Sara Ahmed", first.InstructorName);
        Assert.Equal(100m, first.CoursePrice);
        Assert.Equal(80m, first.FinalPrice);
        Assert.Equal(4.5, first.AverageRating);
        Assert.Equal(2, first.TotalRatings);
        Assert.Equal(2, first.RatingDistribution.Count);
    }

    [Fact]
    public async Task GetUserWishlistAsync_EmptyUserId_ThrowsArgumentException()
    {
        await Assert.ThrowsAsync<ArgumentException>(() => _service.GetUserWishlistAsync("  "));
    }

    [Fact]
    public async Task GetWishlistCountAsync_CountsUserItems()
    {
        _wishlistRepo.Items.Add(TestData.WishlistItem(1, "u1", 1));
        _wishlistRepo.Items.Add(TestData.WishlistItem(2, "u1", 2));
        _wishlistRepo.Items.Add(TestData.WishlistItem(3, "u2", 3));

        Assert.Equal(2, await _service.GetWishlistCountAsync("u1"));
        Assert.Equal(1, await _service.GetWishlistCountAsync("u2"));
    }
}
