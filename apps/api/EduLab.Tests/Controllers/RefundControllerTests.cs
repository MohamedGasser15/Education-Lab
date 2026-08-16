using EduLab_API.Controllers.Admin;
using EduLab_Application.DTOs.Payment;
using EduLab_Application.ServiceInterfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace EduLab.Tests.Controllers;

public class RefundControllerTests
{
    private readonly Mock<IPaymentService> _paymentService;
    private readonly RefundController _controller;

    public RefundControllerTests()
    {
        _paymentService = new Mock<IPaymentService>();
        _controller = new RefundController(
            _paymentService.Object,
            Mock.Of<ILogger<RefundController>>());
    }

    private void SetUser(string userId, params (string Type, string Value)[] claims)
    {
        _controller.ControllerContext = new ControllerContext
        {
            HttpContext = new DefaultHttpContext
            {
                User = new System.Security.Claims.ClaimsPrincipal(new System.Security.Claims.ClaimsIdentity(
                    new[] { new System.Security.Claims.Claim(System.Security.Claims.ClaimTypes.NameIdentifier, userId) }
                        .Concat(claims.Select(c => new System.Security.Claims.Claim(c.Type, c.Value)))))
            }
        };
    }

    [Fact]
    public async Task GetAll_ReturnsOkWithRequests()
    {
        var requests = new List<AdminRefundRequestDto> { new() };
        _paymentService.Setup(x => x.AdminGetRefundRequestsAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(requests);

        var result = await _controller.GetAll();

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(requests, ok.Value);
    }

    [Fact]
    public async Task Accept_WithoutAdminId_ReturnsUnauthorized()
    {
        SetUser("");

        var result = await _controller.Accept(1);

        Assert.IsType<UnauthorizedObjectResult>(result.Result);
        _paymentService.Verify(x => x.AdminProcessRefundAsync(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<bool>(), It.IsAny<string?>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task Accept_WhenProcessingFails_ReturnsBadRequest()
    {
        SetUser("admin-1");
        _paymentService.Setup(x => x.AdminProcessRefundAsync(1, "admin-1", true, null, It.IsAny<CancellationToken>()))
            .ReturnsAsync(new RefundResponseDto { Success = false, Message = "Refund not eligible" });

        var result = await _controller.Accept(1);

        Assert.IsType<BadRequestObjectResult>(result.Result);
    }

    [Fact]
    public async Task Accept_Success_ReturnsOkWithResult()
    {
        SetUser("admin-1");
        var response = new RefundResponseDto { Success = true, Message = "Refund issued", RefundId = "re_1", RefundedAmount = 100m };
        _paymentService.Setup(x => x.AdminProcessRefundAsync(1, "admin-1", true, null, It.IsAny<CancellationToken>()))
            .ReturnsAsync(response);

        var result = await _controller.Accept(1);

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(response, ok.Value);
    }

    [Fact]
    public async Task Reject_WithoutAdminId_ReturnsUnauthorized()
    {
        SetUser("");

        var result = await _controller.Reject(1, new RefundController.RejectRefundBody { Reason = "duplicate" });

        Assert.IsType<UnauthorizedObjectResult>(result.Result);
    }

    [Fact]
    public async Task Reject_Success_ReturnsOkWithResult()
    {
        SetUser("admin-1");
        var response = new RefundResponseDto { Success = true, Message = "Refund rejected" };
        _paymentService.Setup(x => x.AdminProcessRefundAsync(1, "admin-1", false, "duplicate", It.IsAny<CancellationToken>()))
            .ReturnsAsync(response);

        var result = await _controller.Reject(1, new RefundController.RejectRefundBody { Reason = "duplicate" });

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        Assert.Equal(response, ok.Value);
        _paymentService.Verify(x => x.AdminProcessRefundAsync(1, "admin-1", false, "duplicate", It.IsAny<CancellationToken>()), Times.Once);
    }
}
