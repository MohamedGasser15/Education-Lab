using EduLab_API.Controllers.Learner;
using EduLab_Application.DTOs.Payment;
using EduLab_Application.ServiceInterfaces;
using EduLab.Tests.Fakes;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using System.Security.Claims;
using Xunit;

namespace EduLab.Tests.Controllers;

public class LearnerPaymentControllerTests
{
    private readonly Mock<IPaymentService> _paymentService;
    private readonly Mock<ICartService> _cartService;
    private readonly PaymentController _controller;

    public LearnerPaymentControllerTests()
    {
        _paymentService = new Mock<IPaymentService>();
        _cartService = new Mock<ICartService>();
        _controller = new PaymentController(
            _paymentService.Object,
            _cartService.Object,
            Mock.Of<ILogger<PaymentController>>(),
            TestData.MockUserManager().Object);
    }

    private void SetUser(string? userId)
    {
        var identity = userId == null
            ? new ClaimsIdentity()
            : new ClaimsIdentity(new[] { new Claim(ClaimTypes.NameIdentifier, userId) });
        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext { User = new ClaimsPrincipal(identity) }
        };
    }

    [Fact]
    public async Task CreateCheckoutSession_WithoutUserId_ReturnsUnauthorized()
    {
        SetUser(null);

        var result = await _controller.CreateCheckoutSession(new CheckoutRequest());

        Assert.IsType<UnauthorizedObjectResult>(result.Result);
        _paymentService.Verify(x => x.CreateCheckoutSessionAsync(It.IsAny<string>(), It.IsAny<CheckoutRequest>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task CreateCheckoutSession_Success_ReturnsOk()
    {
        SetUser("user-1");
        var response = new PaymentResponse { Success = true, ClientSecret = "cs_secret" };
        _paymentService.Setup(x => x.CreateCheckoutSessionAsync("user-1", It.IsAny<CheckoutRequest>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(response);

        var result = await _controller.CreateCheckoutSession(new CheckoutRequest { ReturnUrl = "https://site/callback" });

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(response, ok.Value);
    }

    [Fact]
    public async Task CreateCheckoutSession_OnApplicationError_ReturnsBadRequest()
    {
        SetUser("user-1");
        _paymentService.Setup(x => x.CreateCheckoutSessionAsync("user-1", It.IsAny<CheckoutRequest>(), It.IsAny<CancellationToken>()))
            .ThrowsAsync(new ApplicationException("Cart is empty"));

        var result = await _controller.CreateCheckoutSession(new CheckoutRequest());

        Assert.IsType<BadRequestObjectResult>(result.Result);
    }

    [Fact]
    public async Task PaymentSuccess_WithSessionId_ProcessesAndReturnsOk()
    {
        _paymentService.Setup(x => x.ProcessPaymentSuccessAsync("cs_123", It.IsAny<CancellationToken>())).ReturnsAsync(true);

        var result = await _controller.PaymentSuccess("cs_123");

        Assert.IsType<OkObjectResult>(result);
        _paymentService.Verify(x => x.ProcessPaymentSuccessAsync("cs_123", It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task PaymentSuccess_WithoutSessionId_ReturnsOkWithoutProcessing()
    {
        var result = await _controller.PaymentSuccess(null!);

        Assert.IsType<OkObjectResult>(result);
        _paymentService.Verify(x => x.ProcessPaymentSuccessAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task PaymentSuccess_OnServiceError_Returns500()
    {
        _paymentService.Setup(x => x.ProcessPaymentSuccessAsync("cs_123", It.IsAny<CancellationToken>()))
            .ThrowsAsync(new InvalidOperationException("boom"));

        var result = await _controller.PaymentSuccess("cs_123");

        var status = Assert.IsType<ObjectResult>(result);
        Assert.Equal(500, status.StatusCode);
    }

    [Fact]
    public async Task GetUserPayments_WithoutUserId_ReturnsUnauthorized()
    {
        SetUser(null);

        var result = await _controller.GetUserPayments();

        Assert.IsType<UnauthorizedObjectResult>(result.Result);
        _paymentService.Verify(x => x.GetUserPaymentsAsync(It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task GetUserPayments_Success_ReturnsPayments()
    {
        SetUser("user-1");
        var payments = new List<PaymentDto> { new() { Id = 1, Amount = 100, Status = "completed", CourseId = 5 } };
        _paymentService.Setup(x => x.GetUserPaymentsAsync("user-1", It.IsAny<CancellationToken>())).ReturnsAsync(payments);

        var result = await _controller.GetUserPayments();

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(payments, ok.Value);
    }

    [Fact]
    public async Task RequestRefund_WithoutUserId_ReturnsUnauthorized()
    {
        SetUser(null);

        var result = await _controller.RequestRefund(new RefundRequestDto { PaymentId = 1 });

        Assert.IsType<UnauthorizedObjectResult>(result.Result);
    }

    [Fact]
    public async Task RequestRefund_WithNullRequest_ReturnsBadRequest()
    {
        SetUser("user-1");

        var result = await _controller.RequestRefund(null!);

        Assert.IsType<BadRequestObjectResult>(result.Result);
        _paymentService.Verify(x => x.RefundAsync(It.IsAny<string>(), It.IsAny<RefundRequestDto>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task RequestRefund_WhenRefundRejected_ReturnsBadRequest()
    {
        SetUser("user-1");
        var response = new RefundResponseDto { Success = false, Message = "Outside refund window" };
        _paymentService.Setup(x => x.RefundAsync("user-1", It.IsAny<RefundRequestDto>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(response);

        var result = await _controller.RequestRefund(new RefundRequestDto { PaymentId = 1 });

        var bad = Assert.IsType<BadRequestObjectResult>(result.Result);
        Assert.Equal(response, bad.Value);
    }

    [Fact]
    public async Task RequestRefund_Success_ReturnsOk()
    {
        SetUser("user-1");
        var response = new RefundResponseDto { Success = true, RefundId = "re_1", RefundedAmount = 100 };
        _paymentService.Setup(x => x.RefundAsync("user-1", It.IsAny<RefundRequestDto>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(response);

        var result = await _controller.RequestRefund(new RefundRequestDto { PaymentId = 1, Reason = "duplicate purchase" });

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(response, ok.Value);
    }
}
