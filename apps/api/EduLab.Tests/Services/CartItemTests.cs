using EduLab_Domain.Entities;
using EduLab.Tests.Fakes;
using Xunit;

namespace EduLab.Tests.Services;

/// <summary>
/// Tests for cart pricing math and enrollment helpers (pure domain logic).
/// </summary>
public class CartItemTests
{
    [Theory]
    [InlineData(100, 20, 80)]
    [InlineData(100, 0, 100)]
    [InlineData(100, 100, 0)]   // 100% discount = free
    [InlineData(100, 150, 0)]   // over 100% never goes negative
    [InlineData(50, -1, 50)]    // -1 = no discount
    [InlineData(0, 10, 0)]
    public void TotalPrice_AppliesDiscountPercent_AndNeverNegative(decimal price, decimal discount, decimal expected)
    {
        var item = new CartItem
        {
            Course = new Course
            {
                Id = 1,
                Title = "Test",
                Price = price,
                Discount = discount < 0 ? null : discount
            }
        };

        Assert.Equal(expected, item.TotalPrice);
    }

    [Fact]
    public void TotalPrice_FreeCourse_IsZero()
    {
        var item = new CartItem
        {
            Course = new Course { Id = 1, Title = "Free", Price = 0, Discount = null }
        };

        Assert.Equal(0, item.TotalPrice);
    }

    [Fact]
    public void Course_FreeWhenFinalPriceZero()
    {
        var course = TestData.Course(1, "Free Course", price: 120m, discount: 100m);

        var finalPrice = course.Price - (course.Price * (course.Discount ?? 0) / 100);

        Assert.Equal(0m, finalPrice);
        Assert.True(finalPrice <= 0, "final price must be <= 0 for the Free badge to show");
    }
}
