using EduLab_Application.DTOs.Cart;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab.Tests.Fakes;
using Moq;
using Xunit;

namespace EduLab.Tests.Services;

public class CartServiceTests
{
    private class FakeCartRepository : ICartRepository
    {
        public List<Cart> Carts { get; } = new();
        private readonly Dictionary<int, Course> _catalog;
        private int _nextCartId = 1;
        private int _nextItemId = 1;

        public FakeCartRepository(IEnumerable<Course> courses)
        {
            _catalog = courses.ToDictionary(c => c.Id);
        }

        public Task<Cart> GetCartByUserIdAsync(string userId, CancellationToken cancellationToken = default)
            => Task.FromResult(Carts.FirstOrDefault(c => c.UserId == userId)!);

        public Task<Cart> GetCartByGuestIdAsync(string guestId, CancellationToken cancellationToken = default)
            => Task.FromResult(Carts.FirstOrDefault(c => c.GuestId == guestId)!);

        public Task<Cart> CreateUserCartAsync(string userId, CancellationToken cancellationToken = default)
            => Task.FromResult(AddCart(new Cart { Id = _nextCartId++, UserId = userId }));

        public Task<Cart> CreateGuestCartAsync(string guestId, CancellationToken cancellationToken = default)
            => Task.FromResult(AddCart(new Cart { Id = _nextCartId++, GuestId = guestId }));

        public Task<bool> MigrateGuestCartToUserAsync(string guestId, string userId, CancellationToken cancellationToken = default)
        {
            var guestCart = Carts.FirstOrDefault(c => c.GuestId == guestId);
            if (guestCart == null) return Task.FromResult(false);

            var userCart = Carts.FirstOrDefault(c => c.UserId == userId)
                ?? AddCart(new Cart { Id = _nextCartId++, UserId = userId });

            foreach (var item in guestCart.CartItems.ToList())
            {
                item.CartId = userCart.Id;
                userCart.CartItems.Add(item);
            }
            guestCart.CartItems.Clear();
            return Task.FromResult(true);
        }

        public Task<CartItem> AddItemToCartAsync(int cartId, int courseId, int quantity, CancellationToken cancellationToken = default)
        {
            var cart = Carts.First(c => c.Id == cartId);
            var item = new CartItem
            {
                Id = _nextItemId++,
                CartId = cartId,
                CourseId = courseId,
                AddedAt = DateTime.UtcNow,
                Course = _catalog[courseId]
            };
            cart.CartItems.Add(item);
            return Task.FromResult(item);
        }

        public Task<bool> RemoveItemFromCartAsync(int cartItemId, CancellationToken cancellationToken = default)
        {
            var item = Carts.SelectMany(c => c.CartItems).FirstOrDefault(ci => ci.Id == cartItemId);
            if (item == null) return Task.FromResult(false);

            var cart = Carts.First(c => c.Id == item.CartId);
            cart.CartItems.Remove(item);
            return Task.FromResult(true);
        }

        public Task<bool> ClearCartAsync(int cartId, CancellationToken cancellationToken = default)
        {
            var cart = Carts.FirstOrDefault(c => c.Id == cartId);
            if (cart == null) return Task.FromResult(false);

            cart.CartItems.Clear();
            return Task.FromResult(true);
        }

        private Cart AddCart(Cart cart)
        {
            Carts.Add(cart);
            return cart;
        }
    }

    private readonly FakeCartRepository _cartRepository;
    private readonly CartService _guestService;
    private readonly Mock<IEnrollmentService> _enrollmentService;

    public CartServiceTests()
    {
        _cartRepository = new FakeCartRepository(new[]
        {
            TestData.Course(1, "C# Basics", price: 100m, discount: 20m),
            TestData.Course(2, "React", price: 200m, discount: null),
            TestData.Course(3, "Design", price: 50m, discount: null)
        });
        _enrollmentService = new Mock<IEnrollmentService>();
        _enrollmentService.Setup(e => e.IsUserEnrolledInCourseAsync(It.IsAny<string>(), It.IsAny<int>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(false);

        _guestService = CreateGuestService();
    }

    private CartService CreateGuestService() => new(
        _cartRepository,
        TestInfrastructure.RealMapper(),
        TestInfrastructure.MockHttpContextAccessor(new Dictionary<string, string> { ["GuestId"] = "g-123" }),
        TestData.NullLogger<CartService>(),
        _enrollmentService.Object);

    [Fact]
    public async Task AddItemToCartAsync_Guest_CreatesCartAndAddsItem()
    {
        var result = await _guestService.AddItemToCartAsync(null, new AddToCartRequest { CourseId = 1 });

        Assert.NotNull(result);
        var item = Assert.Single(result.Items);
        Assert.Equal(1, item.CourseId);
        Assert.Equal("C# Basics", item.CourseTitle);

        var cart = Assert.Single(_cartRepository.Carts);
        Assert.Equal("g-123", cart.GuestId);
        Assert.Null(cart.UserId);
    }

    [Fact]
    public async Task AddItemToCartAsync_Guest_DuplicateItem_ThrowsInvalidOperation()
    {
        await _guestService.AddItemToCartAsync(null, new AddToCartRequest { CourseId = 1 });

        await Assert.ThrowsAsync<InvalidOperationException>(
            () => _guestService.AddItemToCartAsync(null, new AddToCartRequest { CourseId = 1 }));
    }

    [Fact]
    public async Task AddItemToCartAsync_User_CreatesUserCart()
    {
        var result = await _guestService.AddItemToCartAsync("user-1", new AddToCartRequest { CourseId = 2 });

        var item = Assert.Single(result.Items);
        Assert.Equal(2, item.CourseId);
        var cart = Assert.Single(_cartRepository.Carts);
        Assert.Equal("user-1", cart.UserId);
        Assert.Null(cart.GuestId);
    }

    [Fact]
    public async Task AddItemToCartAsync_User_AlreadyEnrolled_ThrowsInvalidOperation()
    {
        _enrollmentService.Setup(e => e.IsUserEnrolledInCourseAsync("user-1", 1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);

        await Assert.ThrowsAsync<InvalidOperationException>(
            () => _guestService.AddItemToCartAsync("user-1", new AddToCartRequest { CourseId = 1 }));
    }

    [Fact]
    public async Task RemoveItemFromCartAsync_Guest_RemovesItem()
    {
        var cart = await _guestService.AddItemToCartAsync(null, new AddToCartRequest { CourseId = 1 });
        var itemId = cart.Items[0].Id;

        var updated = await _guestService.RemoveItemFromCartAsync(null, itemId);

        Assert.Empty(updated.Items);
        Assert.Equal(0m, updated.TotalPrice);
    }

    [Fact]
    public async Task RemoveItemFromCartAsync_Guest_UnknownItem_ThrowsKeyNotFound()
    {
        await Assert.ThrowsAsync<KeyNotFoundException>(
            () => _guestService.RemoveItemFromCartAsync(null, 999));
    }

    [Fact]
    public async Task ClearCartAsync_Guest_RemovesAllItems()
    {
        await _guestService.AddItemToCartAsync(null, new AddToCartRequest { CourseId = 1 });
        await _guestService.AddItemToCartAsync(null, new AddToCartRequest { CourseId = 2 });

        var result = await _guestService.ClearCartAsync(null);

        Assert.True(result);
        var cart = Assert.Single(_cartRepository.Carts);
        Assert.Empty(cart.CartItems);
    }

    [Fact]
    public async Task GetGuestCartAsync_TotalsApplyDiscounts()
    {
        await _guestService.AddItemToCartAsync(null, new AddToCartRequest { CourseId = 1 }); // 100 - 20% = 80
        await _guestService.AddItemToCartAsync(null, new AddToCartRequest { CourseId = 2 }); // 200 no discount

        var cart = await _guestService.GetGuestCartAsync();

        Assert.Equal(2, cart.Items.Count);
        Assert.Equal(80m, cart.Items.First(i => i.CourseId == 1).TotalPrice);
        Assert.Equal(200m, cart.Items.First(i => i.CourseId == 2).TotalPrice);
        Assert.Equal(280m, cart.TotalPrice);
    }

    [Fact]
    public async Task MigrateGuestCartToUserAsync_MovesGuestItemsToUserCart()
    {
        await _guestService.AddItemToCartAsync(null, new AddToCartRequest { CourseId = 1 });
        await _guestService.AddItemToCartAsync(null, new AddToCartRequest { CourseId = 3 });

        var migrated = await _guestService.MigrateGuestCartToUserAsync("user-1");

        Assert.True(migrated);
        var userCart = await _cartRepository.GetCartByUserIdAsync("user-1");
        Assert.NotNull(userCart);
        Assert.Equal(2, userCart.CartItems.Count);

        var guestCart = await _cartRepository.GetCartByGuestIdAsync("g-123");
        Assert.Empty(guestCart!.CartItems);
    }

    [Fact]
    public async Task MigrateGuestCartToUserAsync_NoGuestCart_ReturnsFalse()
    {
        var service = new CartService(
            _cartRepository,
            TestInfrastructure.RealMapper(),
            TestInfrastructure.MockHttpContextAccessor(), // no GuestId cookie
            TestData.NullLogger<CartService>(),
            _enrollmentService.Object);

        var migrated = await service.MigrateGuestCartToUserAsync("user-1");

        Assert.False(migrated);
    }

    [Fact]
    public async Task GetUserCartAsync_CreatesCartWhenMissing()
    {
        var cart = await _guestService.GetUserCartAsync("user-9");

        Assert.NotNull(cart);
        Assert.Empty(cart.Items);
        var stored = Assert.Single(_cartRepository.Carts);
        Assert.Equal("user-9", stored.UserId);
    }

    [Fact]
    public async Task RemoveItemFromCartAsync_User_RemovesItem()
    {
        var cart = await _guestService.AddItemToCartAsync("user-1", new AddToCartRequest { CourseId = 2 });
        var itemId = cart.Items[0].Id;

        var updated = await _guestService.RemoveItemFromCartAsync("user-1", itemId);

        Assert.Empty(updated.Items);
    }
}
