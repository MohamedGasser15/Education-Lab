using EduLab_Domain.Entities;
using System;
using Xunit;

namespace EduLab.Tests.Services;

public class CouponServiceTests
{
    [Fact]
    public void CalculateDiscount_Percentage_CalculatesCorrectly()
    {
        // Arrange
        var coupon = new Coupon
        {
            Code = "SAVE20",
            DiscountType = DiscountType.Percentage,
            DiscountValue = 20, // 20%
            IsActive = true
        };

        // Act
        var discount = coupon.CalculateDiscount(500m);

        // Assert
        Assert.Equal(100m, discount);
    }

    [Fact]
    public void CalculateDiscount_PercentageWithMaxCap_RespectsCap()
    {
        // Arrange
        var coupon = new Coupon
        {
            Code = "SAVE50",
            DiscountType = DiscountType.Percentage,
            DiscountValue = 50, // 50%
            MaxDiscountAmount = 100m,
            IsActive = true
        };

        // Act
        var discount = coupon.CalculateDiscount(1000m); // 50% of 1000 is 500, but capped at 100

        // Assert
        Assert.Equal(100m, discount);
    }

    [Fact]
    public void CalculateDiscount_FixedAmount_CalculatesCorrectly()
    {
        // Arrange
        var coupon = new Coupon
        {
            Code = "FIXED50",
            DiscountType = DiscountType.FixedAmount,
            DiscountValue = 50m,
            IsActive = true
        };

        // Act
        var discount = coupon.CalculateDiscount(300m);

        // Assert
        Assert.Equal(50m, discount);
    }

    [Fact]
    public void CalculateDiscount_FixedAmountExceedsSubtotal_CapsAtSubtotal()
    {
        // Arrange
        var coupon = new Coupon
        {
            Code = "FIXED100",
            DiscountType = DiscountType.FixedAmount,
            DiscountValue = 100m,
            IsActive = true
        };

        // Act
        var discount = coupon.CalculateDiscount(60m);

        // Assert
        Assert.Equal(60m, discount);
    }

    [Fact]
    public void CalculateDiscount_BelowMinimumSpend_ReturnsZero()
    {
        // Arrange
        var coupon = new Coupon
        {
            Code = "MIN200",
            DiscountType = DiscountType.FixedAmount,
            DiscountValue = 50m,
            MinimumSpend = 200m,
            IsActive = true
        };

        // Act
        var discount = coupon.CalculateDiscount(150m);

        // Assert
        Assert.Equal(0m, discount);
    }

    [Fact]
    public void IsValidNow_ExpiredCoupon_ReturnsFalse()
    {
        // Arrange
        var coupon = new Coupon
        {
            Code = "EXPIRED",
            DiscountType = DiscountType.Percentage,
            DiscountValue = 10,
            IsActive = true,
            ExpiryDate = DateTime.UtcNow.AddDays(-2)
        };

        // Act & Assert
        Assert.False(coupon.IsValidNow());
    }

    [Fact]
    public void IsValidNow_InactiveCoupon_ReturnsFalse()
    {
        // Arrange
        var coupon = new Coupon
        {
            Code = "DISABLED",
            DiscountType = DiscountType.Percentage,
            DiscountValue = 10,
            IsActive = false
        };

        // Act & Assert
        Assert.False(coupon.IsValidNow());
    }

    [Fact]
    public void IsValidNow_MaxUsageReached_ReturnsFalse()
    {
        // Arrange
        var coupon = new Coupon
        {
            Code = "MAX10",
            DiscountType = DiscountType.Percentage,
            DiscountValue = 10,
            UsageLimit = 10,
            TimesUsed = 10,
            IsActive = true
        };

        // Act & Assert
        Assert.False(coupon.IsValidNow());
    }

    [Fact]
    public void IsValidNow_ValidCoupon_ReturnsTrue()
    {
        // Arrange
        var coupon = new Coupon
        {
            Code = "ACTIVE10",
            DiscountType = DiscountType.Percentage,
            DiscountValue = 10,
            UsageLimit = 100,
            TimesUsed = 5,
            ExpiryDate = DateTime.UtcNow.AddDays(10),
            IsActive = true
        };

        // Act & Assert
        Assert.True(coupon.IsValidNow());
    }
}
