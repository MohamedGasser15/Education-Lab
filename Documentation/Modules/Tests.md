# Tests Reference (EduLab.Tests)

---

## Overview

### Purpose
Reference of the automated test project: coverage map, framework, fakes, and how to run.

### Business Objective
634 test cases (verified count) guarding controllers, services, the hub, and mapping — the quality gate for the API backend.

### Main Functionality
- 34 controller test files (every API controller family)
- 33 service test files (every Application service)
- Hub + mapping tests
- Shared fakes (in-memory EF, test data)

---

## Project Setup (EduLab.Tests.csproj)

| Aspect | Value |
|--------|-------|
| Target framework | net9.0 |
| Test framework | **xUnit 2.9.2** (`[Fact]` × 623, `[Theory]` × 11) |
| Mocking | **Moq 4.20.72** |
| Data | **EntityFrameworkCore.InMemory 9.0.5** |
| References | Application, Domain, Infrastructure, API |

**Run:** `dotnet test` (from `apps/api/EduLab.Tests` or repo root).

---

## Coverage Map

### Controllers/ — 34 files

| Area | Files |
|------|-------|
| Learner (18) | LearnerAuth, LearnerCart, LearnerCertificates, LearnerCourse, LearnerCourseProgress, LearnerEnrollment, LearnerInstructorApplication, LearnerInstructor, LearnerLectureComments, LearnerNotifications, LearnerPayment, LearnerProfile, LearnerRatings, LearnerReports, LearnerSettings, LearnerSupport, LearnerWishlist, Public |
| Instructor (5) | InstructorComments, InstructorCourse, InstructorDashboard, InstructorRatings, InstructorStudents |
| Admin (11) | AdminReports, AdminSupport, Category, Course, Dashboard, History, InstructorApplications, Refund, Role, SiteSettings, User |

### Services/ — 33 files

AuthService, CartItem, CartService, CategoryService, CertificateService, CertificateTypefaceProvider, CourseProgressService, CourseService (709 lines — largest), CurrentUserService, DashboardService, EmailTemplateService, EnrollmentService, ExternalLoginService, FileStorageService, HistoryService, InstructorApplicationService, InstructorService, IpService, LectureCommentService, LinkBuilderService, NotificationService (347 lines), PaymentService (376 lines), ProfileService, RatingService (319 lines), ReportService (333 lines), RoleClaimsService, SiteSettingsService, StudentService, SupportService, TokenService, UserService (388 lines), UserSettingsService, VideoDurationService, WishlistService

### Hubs/ + Mapping/

| File | Scope |
|------|-------|
| `SupportHubTests.cs` | Hub grouping/join behavior (141 lines) |
| `MappingConfigTests.cs` | AutoMapper profile validation (102 lines) |

### Fakes/

| File | Purpose |
|------|---------|
| `FakeRepository.cs` (75) | Generic in-memory repository double |
| `TestData.cs` (264) | Seed fixtures (users, courses, enrollments...) |
| `TestInfrastructure.cs` (193) | DbContext + service wiring helpers |

---

## Verified Test Facts

- **634 test cases total** — 623 `[Fact]` + 11 `[Theory]` (attribute count over all source files).
- Every API controller family has a paired test file — including the **public** `PublicControllerTests` and the claim-gated admin surfaces (`AdminReportsControllerTests`, `AdminSupportControllerTests`).
- The heaviest suites: `CourseServiceTests` (709 lines), `PaymentServiceTests` (376), `UserServiceTests` (388), `NotificationServiceTests` (347), `ReportServiceTests` (333), `RatingServiceTests` (319).
- Tests use Moq for services/repositories and EF InMemory for repository-ish flows — no external dependencies (no live API/Stripe/DB).

---

## Business Rules (as tested)

| Rule | Suite |
|------|-------|
| Certificate issuance at 100% | CourseProgressServiceTests |
| Refund policy (7 days / <25%) | PaymentServiceTests |
| Auth flows (login/refresh/OTP/reset) | AuthServiceTests, UserServiceTests, LearnerAuthControllerTests |
| Cart migration + guest IDOR | CartServiceTests, LearnerCartControllerTests |
| Enrollment payment-bypass guard | EnrollmentServiceTests, LearnerEnrollmentControllerTests |
| Report dedupe (409) | ReportServiceTests, LearnerReportsControllerTests |
| Course ownership guards | CourseServiceTests, InstructorCourseControllerTests |

---

## Hidden Behaviors & Technical Notes

1. **Tests mirror the controller surface 1:1** — a controller without a test file would be visible as a gap in `Controllers/`.
2. **No integration tests** — Stripe/SMTP/DB are all mocked; the `PaymentServiceTests` cover the free-checkout branch and Stripe-exception mapping with fakes.
3. **InMemory EF** differs from SQL Server semantics (e.g., no FK enforcement) — tests can't catch the FK-violation paths documented in `CartController.md`.
4. **`FakeRepository`** is the base used by most service tests — changes to `Repository<T>` contracts require syncing the fake.

---

## Configuration

| Key | Purpose |
|-----|---------|
| (none) | Tests are self-contained; no appsettings dependency |

---

## Change Log

**Current functionality (verified):** 634 test cases across 73 source files covering every controller family and Application service, xUnit + Moq + EF InMemory, runnable via `dotnet test`.

**Maintenance notes:** keep `FakeRepository` in sync with `Repository<T>`; consider SQL Server integration tests for FK paths.