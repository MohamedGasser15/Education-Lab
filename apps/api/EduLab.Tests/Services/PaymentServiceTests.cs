using EduLab_Application.DTOs.Notification;
using EduLab_Application.DTOs.Payment;
using EduLab_Application.ServiceInterfaces;
using EduLab_Application.Services;
using EduLab_Domain.Entities;
using EduLab_Domain.IRepository;
using EduLab.Tests.Fakes;
using Microsoft.AspNetCore.Identity;
using Moq;
using Xunit;

namespace EduLab.Tests.Services;

public class PaymentServiceTests
{
    private readonly Mock<IPaymentRepository> _payments;
    private readonly Mock<ICartRepository> _carts;
    private readonly Mock<ICourseRepository> _courses;
    private readonly Mock<IEnrollmentRepository> _enrollments;
    private readonly Mock<IRefundRequestRepository> _refundRequests;
    private readonly Mock<INotificationService> _notifications;
    private readonly Mock<ICourseProgressService> _progress;
    private readonly Mock<IEmailTemplateService> _emailTemplates;
    private readonly Mock<IEmailSender> _emailSender;
    private readonly List<ApplicationUser> _users;
    private readonly PaymentService _service;

    public PaymentServiceTests()
    {
        _payments = new Mock<IPaymentRepository>();
        _carts = new Mock<ICartRepository>();
        _courses = new Mock<ICourseRepository>();
        _enrollments = new Mock<IEnrollmentRepository>();
        _refundRequests = new Mock<IRefundRequestRepository>();
        _notifications = new Mock<INotificationService>();
        _progress = new Mock<ICourseProgressService>();
        _emailTemplates = new Mock<IEmailTemplateService>();
        _emailSender = new Mock<IEmailSender>();

        _users = new List<ApplicationUser> { TestData.User("user-1", "Ahmed") };

        _notifications.Setup(x => x.CreateNotificationAsync(It.IsAny<CreateNotificationDto>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(new NotificationDto());
        _emailTemplates.Setup(x => x.GetLocalizedText(It.IsAny<string>(), It.IsAny<string>())).Returns("subject");
        _emailTemplates.Setup(x => x.GeneratePaymentSuccessEmail(
                It.IsAny<ApplicationUser>(), It.IsAny<List<Course>>(), It.IsAny<decimal>(),
                It.IsAny<string>(), It.IsAny<DateTime>(), It.IsAny<string>(), It.IsAny<string>()))
            .Returns("<html>paid</html>");
        _emailSender.Setup(x => x.SendEmailAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
            .Returns(Task.CompletedTask);

        _service = new PaymentService(
            _payments.Object,
            _carts.Object,
            TestInfrastructure.RealMapper(),
            TestInfrastructure.MockConfiguration(),
            TestData.NullLogger<PaymentService>(),
            TestData.MockUserManager(_users).Object,
            _emailTemplates.Object,
            _emailSender.Object,
            _courses.Object,
            _enrollments.Object,
            _notifications.Object,
            _progress.Object,
            _refundRequests.Object);
    }

    [Fact]
    public async Task CreatePaymentIntentAsync_ZeroAmount_SkipsStripeAndEnrollsDirectly()
    {
        _payments.Setup(x => x.CreateBulkPaymentsAsync(It.IsAny<IEnumerable<Payment>>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(2);
        _enrollments.Setup(x => x.CreateBulkEnrollmentsAsync(It.IsAny<IEnumerable<Enrollment>>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(2);
        _courses.Setup(x => x.GetCourseByIdAsync(It.IsAny<int>(), It.IsAny<bool>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((int id, bool tracking, CancellationToken ct) => TestData.Course(id, $"Course {id}"));

        var response = await _service.CreatePaymentIntentAsync("user-1", new PaymentRequest
        {
            Amount = 0,
            Currency = "usd",
            CourseIds = new List<int> { 1, 2 }
        });

        Assert.True(response.Success);
        Assert.Equal(0, response.Amount);
        Assert.StartsWith("free_", response.PaymentIntentId);
        Assert.Null(response.ClientSecret);

        _payments.Verify(x => x.CreateBulkPaymentsAsync(
            It.Is<IEnumerable<Payment>>(p => p.Count() == 2
                && p.All(pp => pp.UserId == "user-1"
                    && pp.Amount == 0
                    && pp.PaymentMethod == "free"
                    && pp.Status == "completed"
                    && pp.StripeSessionId!.StartsWith("free_")))
            , It.IsAny<CancellationToken>()), Times.Once);

        _enrollments.Verify(x => x.CreateBulkEnrollmentsAsync(
            It.Is<IEnumerable<Enrollment>>(e => e.Count() == 2 && e.All(en => en.UserId == "user-1")),
            It.IsAny<CancellationToken>()), Times.Once);

        _notifications.Verify(x => x.CreateNotificationAsync(
            It.Is<CreateNotificationDto>(n => n.UserId == "user-1" && n.Type == NotificationTypeDto.Enrollment),
            It.IsAny<CancellationToken>()), Times.Once);

        _emailSender.Verify(x => x.SendEmailAsync("Ahmed@test.com", "subject", "<html>paid</html>"), Times.Once);
    }

    [Fact]
    public async Task CreatePaymentIntentAsync_ZeroAmount_ClearsUserCart()
    {
        var cart = TestData.Cart(9, "user-1");
        _carts.Setup(x => x.GetCartByUserIdAsync("user-1", It.IsAny<CancellationToken>())).ReturnsAsync(cart);
        _carts.Setup(x => x.ClearCartAsync(9, It.IsAny<CancellationToken>())).ReturnsAsync(true);

        var response = await _service.CreatePaymentIntentAsync("user-1", new PaymentRequest
        {
            Amount = 0,
            CourseIds = new List<int> { 1 }
        });

        Assert.True(response.Success);
        _carts.Verify(x => x.ClearCartAsync(9, It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task CreatePaymentIntentAsync_ZeroAmount_NoCourses_Throws()
    {
        var ex = await Assert.ThrowsAsync<ApplicationException>(
            () => _service.CreatePaymentIntentAsync("user-1", new PaymentRequest { Amount = 0, CourseIds = new List<int>() }));

        Assert.Contains("No courses", ex.Message);
        _payments.Verify(x => x.CreateBulkPaymentsAsync(It.IsAny<IEnumerable<Payment>>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task CreatePaymentIntentAsync_UnknownUser_Throws()
    {
        var ex = await Assert.ThrowsAsync<ApplicationException>(
            () => _service.CreatePaymentIntentAsync("ghost", new PaymentRequest { Amount = 10, CourseIds = new List<int> { 1 } }));

        Assert.Contains("email is required", ex.Message);
    }

    [Fact]
    public async Task RefundAsync_CompletedPayment_CreatesPendingRequest()
    {
        var payment = TestData.Payment(1, 10, "user-1", 50m, paidAt: DateTime.UtcNow.AddDays(-1));
        payment.Course = TestData.Course(10, "SQL Basics");
        _payments.Setup(x => x.GetPaymentByIdAsync(1, It.IsAny<CancellationToken>())).ReturnsAsync(payment);
        _refundRequests.Setup(x => x.GetByPaymentIdAsync(1, It.IsAny<CancellationToken>())).ReturnsAsync((RefundRequest?)null);
        _enrollments.Setup(x => x.GetUserCourseEnrollmentAsync("user-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(TestData.Enrollment(3, 10, "user-1"));
        _progress.Setup(x => x.GetCourseProgressPercentageAsync(3, It.IsAny<CancellationToken>())).ReturnsAsync(10m);
        _refundRequests.Setup(x => x.CreateAsync(It.IsAny<RefundRequest>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((RefundRequest r, CancellationToken ct) =>
            {
                r.Id = 7;
                return r;
            });

        var response = await _service.RefundAsync("user-1", new RefundRequestDto { PaymentId = 1, Reason = "Changed my mind" });

        Assert.True(response.Success);
        Assert.Equal(50m, response.RefundedAmount);
        _refundRequests.Verify(x => x.CreateAsync(
            It.Is<RefundRequest>(r => r.PaymentId == 1
                && r.UserId == "user-1"
                && r.Status == "pending"
                && r.Reason == "Changed my mind"),
            It.IsAny<CancellationToken>()), Times.Once);
        _notifications.Verify(x => x.CreateNotificationAsync(
            It.Is<CreateNotificationDto>(n => n.UserId == "user-1"),
            It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task RefundAsync_NonCompletedPayment_ReturnsFailure()
    {
        _payments.Setup(x => x.GetPaymentByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(TestData.Payment(1, 10, "user-1", 50m, status: "pending"));

        var response = await _service.RefundAsync("user-1", new RefundRequestDto { PaymentId = 1 });

        Assert.False(response.Success);
        Assert.Contains("Only completed payments", response.Message);
        _refundRequests.Verify(x => x.CreateAsync(It.IsAny<RefundRequest>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task RefundAsync_ProgressAtLeast25Percent_ReturnsFailure()
    {
        _payments.Setup(x => x.GetPaymentByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(TestData.Payment(1, 10, "user-1", 50m));
        _refundRequests.Setup(x => x.GetByPaymentIdAsync(1, It.IsAny<CancellationToken>())).ReturnsAsync((RefundRequest?)null);
        _enrollments.Setup(x => x.GetUserCourseEnrollmentAsync("user-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(TestData.Enrollment(3, 10, "user-1"));
        _progress.Setup(x => x.GetCourseProgressPercentageAsync(3, It.IsAny<CancellationToken>())).ReturnsAsync(25m);

        var response = await _service.RefundAsync("user-1", new RefundRequestDto { PaymentId = 1 });

        Assert.False(response.Success);
        Assert.Contains("Refund not eligible", response.Message);
    }

    [Fact]
    public async Task RefundAsync_FreePayment_ReturnsFailure()
    {
        _payments.Setup(x => x.GetPaymentByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(TestData.Payment(1, 10, "user-1", 0m));

        var response = await _service.RefundAsync("user-1", new RefundRequestDto { PaymentId = 1 });

        Assert.False(response.Success);
        Assert.Contains("Free courses cannot be refunded", response.Message);
    }

    [Fact]
    public async Task RefundAsync_SevenDayWindowExpired_ReturnsFailure()
    {
        _payments.Setup(x => x.GetPaymentByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(TestData.Payment(1, 10, "user-1", 50m, paidAt: DateTime.UtcNow.AddDays(-10)));

        var response = await _service.RefundAsync("user-1", new RefundRequestDto { PaymentId = 1 });

        Assert.False(response.Success);
        Assert.Contains("Refund window has expired", response.Message);
    }

    [Fact]
    public async Task GetUserPaymentsAsync_ComputesRefundabilityAndOrdersByDate()
    {
        var recent = TestData.Payment(1, 10, "user-1", 50m, paidAt: DateTime.UtcNow.AddHours(-1));
        var free = TestData.Payment(2, 11, "user-1", 0m, paidAt: DateTime.UtcNow.AddHours(-2));
        var old = TestData.Payment(3, 12, "user-1", 30m, paidAt: DateTime.UtcNow.AddDays(-10));
        _payments.Setup(x => x.GetUserPaymentsAsync("user-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<Payment> { old, free, recent });
        _courses.Setup(x => x.GetCourseByIdAsync(It.IsAny<int>(), It.IsAny<bool>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((int id, bool tracking, CancellationToken ct) => id == 99 ? null : TestData.Course(id, $"Course {id}"));
        _enrollments.Setup(x => x.GetUserCourseEnrollmentAsync("user-1", It.IsAny<int>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync((string uid, int courseId, CancellationToken ct) => courseId == 10 ? TestData.Enrollment(1, 10, uid) : null);
        _progress.Setup(x => x.GetCourseProgressPercentageAsync(It.IsAny<int>(), It.IsAny<CancellationToken>())).ReturnsAsync(0m);
        _refundRequests.Setup(x => x.GetByPaymentIdAsync(It.IsAny<int>(), It.IsAny<CancellationToken>())).ReturnsAsync((RefundRequest?)null);

        var result = await _service.GetUserPaymentsAsync("user-1");

        Assert.Equal(3, result.Count);
        Assert.Equal(1, result[0].Id); // most recent first
        Assert.Equal("Course 10", result[0].CourseTitle);
        Assert.True(result[0].IsRefundable);
        Assert.Equal(2, result[1].Id); // free payment
        Assert.False(result[1].IsRefundable);
        Assert.Equal(3, result[2].Id); // older than 7 days
        Assert.False(result[2].IsRefundable);
    }

    [Fact]
    public async Task GetUserPaymentsAsync_UnknownCourse_UsesFallbackTitle()
    {
        var payment = TestData.Payment(1, 99, "user-1", 50m);
        _payments.Setup(x => x.GetUserPaymentsAsync("user-1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<Payment> { payment });
        _courses.Setup(x => x.GetCourseByIdAsync(99, false, It.IsAny<CancellationToken>())).ReturnsAsync((Course?)null);

        var result = await _service.GetUserPaymentsAsync("user-1");

        var dto = Assert.Single(result);
        Assert.Equal("Unknown Course", dto.CourseTitle);
    }

    [Fact]
    public async Task AdminGetRefundRequestsAsync_MapsUserAndCourseData()
    {
        var request = new RefundRequest
        {
            Id = 1,
            PaymentId = 5,
            UserId = "user-1",
            Reason = "duplicate",
            Status = "pending",
            CreatedAt = DateTime.UtcNow,
            User = _users[0],
            Payment = new Payment { Id = 5, Amount = 60m, Course = TestData.Course(10, "SQL Basics") }
        };
        _refundRequests.Setup(x => x.GetAllAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(new List<RefundRequest> { request });

        var list = await _service.AdminGetRefundRequestsAsync();

        var dto = Assert.Single(list);
        Assert.Equal("Ahmed", dto.UserName);
        Assert.Equal("Ahmed@test.com", dto.UserEmail);
        Assert.Equal("SQL Basics", dto.CourseTitle);
        Assert.Equal(60m, dto.Amount);
        Assert.Equal("pending", dto.Status);
    }

    [Fact]
    public async Task AdminProcessRefundAsync_Reject_MarksRequestRejectedWithoutRefund()
    {
        var payment = TestData.Payment(5, 10, "user-1", 50m);
        payment.Course = TestData.Course(10, "SQL Basics");
        var request = new RefundRequest { Id = 7, PaymentId = 5, UserId = "user-1", Status = "pending", Payment = payment };
        _refundRequests.Setup(x => x.GetByIdAsync(7, It.IsAny<CancellationToken>())).ReturnsAsync(request);
        _refundRequests.Setup(x => x.UpdateAsync(It.IsAny<RefundRequest>(), It.IsAny<CancellationToken>())).ReturnsAsync(true);
        _emailTemplates.Setup(x => x.GenerateRefundRejectionEmail(
                It.IsAny<ApplicationUser>(), It.IsAny<Course>(), It.IsAny<string>(), It.IsAny<string>()))
            .Returns("<html>rejected</html>");

        var response = await _service.AdminProcessRefundAsync(7, "admin-1", false, "Course is too hard");

        Assert.True(response.Success);
        Assert.Equal("rejected", request.Status);
        Assert.Equal("admin-1", request.ProcessedBy);
        Assert.Equal("Course is too hard", request.RejectionReason);
        Assert.NotNull(request.ProcessedAt);
        _payments.Verify(x => x.UpdatePaymentStatusAsync(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
        _emailSender.Verify(x => x.SendEmailAsync("Ahmed@test.com", It.IsAny<string>(), "<html>rejected</html>"), Times.Once);
    }

    [Fact]
    public async Task AdminProcessRefundAsync_Approve_WithoutStripeSession_RefundsAndRemovesEnrollment()
    {
        var payment = TestData.Payment(5, 10, "user-1", 50m);
        payment.StripeSessionId = null;
        payment.Course = TestData.Course(10, "SQL Basics");
        var request = new RefundRequest { Id = 7, PaymentId = 5, UserId = "user-1", Status = "pending", Payment = payment };
        _refundRequests.Setup(x => x.GetByIdAsync(7, It.IsAny<CancellationToken>())).ReturnsAsync(request);
        _refundRequests.Setup(x => x.UpdateAsync(It.IsAny<RefundRequest>(), It.IsAny<CancellationToken>())).ReturnsAsync(true);
        _payments.Setup(x => x.UpdatePaymentStatusAsync(5, "refunded", It.IsAny<CancellationToken>())).ReturnsAsync(true);
        _enrollments.Setup(x => x.GetUserCourseEnrollmentAsync("user-1", 10, It.IsAny<CancellationToken>()))
            .ReturnsAsync(TestData.Enrollment(3, 10, "user-1"));
        _enrollments.Setup(x => x.DeleteEnrollmentAsync(3, It.IsAny<CancellationToken>())).ReturnsAsync(true);
        _emailTemplates.Setup(x => x.GenerateRefundConfirmationEmail(
                It.IsAny<ApplicationUser>(), It.IsAny<Course>(), It.IsAny<decimal>(),
                It.IsAny<DateTime>(), It.IsAny<string>(), It.IsAny<string>()))
            .Returns("<html>refunded</html>");

        var response = await _service.AdminProcessRefundAsync(7, "admin-1", true);

        Assert.True(response.Success);
        Assert.Equal("accepted", request.Status);
        Assert.Equal("admin-1", request.ProcessedBy);
        Assert.Null(response.RefundId);
        _payments.Verify(x => x.UpdatePaymentStatusAsync(5, "refunded", It.IsAny<CancellationToken>()), Times.Once);
        _enrollments.Verify(x => x.DeleteEnrollmentAsync(3, It.IsAny<CancellationToken>()), Times.Once);
        _emailSender.Verify(x => x.SendEmailAsync("Ahmed@test.com", It.IsAny<string>(), "<html>refunded</html>"), Times.Once);
    }

    [Fact]
    public async Task AdminProcessRefundAsync_Approve_NonCompletedPayment_ReturnsFailure()
    {
        var payment = TestData.Payment(5, 10, "user-1", 50m, status: "pending");
        var request = new RefundRequest { Id = 7, PaymentId = 5, UserId = "user-1", Status = "pending", Payment = payment };
        _refundRequests.Setup(x => x.GetByIdAsync(7, It.IsAny<CancellationToken>())).ReturnsAsync(request);

        var response = await _service.AdminProcessRefundAsync(7, "admin-1", true);

        Assert.False(response.Success);
        Assert.Contains("Only completed payments", response.Message);
        _payments.Verify(x => x.UpdatePaymentStatusAsync(It.IsAny<int>(), It.IsAny<string>(), It.IsAny<CancellationToken>()), Times.Never);
    }

    [Fact]
    public async Task AdminProcessRefundAsync_AlreadyProcessed_ReturnsFailure()
    {
        var request = new RefundRequest { Id = 7, PaymentId = 5, UserId = "user-1", Status = "accepted" };
        _refundRequests.Setup(x => x.GetByIdAsync(7, It.IsAny<CancellationToken>())).ReturnsAsync(request);

        var response = await _service.AdminProcessRefundAsync(7, "admin-1", true);

        Assert.False(response.Success);
        Assert.Contains("already been processed", response.Message);
    }
}
