# Application Services Reference (EduLab_Application)

---

## Overview

### Purpose
Complete reference of the API business-logic layer: all 35 services in `EduLab_Application/Services/`, with public method surfaces and verified behaviors.

### Business Objective
This layer implements the rules the controllers and repositories execute: auth flows, payment policy, certificate issuance, role transitions, emails, file storage.

### Main Functionality
- Domain services (Auth, Course, Payment, Enrollment, Rating, ...)
- Infrastructure helpers (EmailSender, EmailTemplateService, FileStorageService, IpService, VideoDurationService, LinkBuilderService, TokenService, CurrentUserService)
- Certificate rendering (CertificateService + CertificateTypefaceProvider)

---

## Folder Structure

```
EduLab_Application/
├── Services/                 # 35 implementations
├── ServiceInterfaces/        # I<Domain>Service contracts
├── DTOs/                     # Request/response models
├── Common/                   # Constants (SD, AdminClaims), utilities
└── Resources/                # resx localization (email templates)
```

---

## 1. Identity & Auth

### TokenService — `TokenService.cs`
| Method | Line | Notes |
|--------|------|-------|
| `GenerateAccessToken(user)` | :53 | claims `sub`=id, `email`, `jti` + roles as `ClaimTypes.Role` (:79-101); expiry 7 days (:105-107); **HMAC-SHA256** (:120-122) |
| `GenerateRefreshToken()` | :153 | 32 random bytes, Base64 (:153-173) |
| `GetPrincipalFromExpiredToken(token)` | :186 | **audience/issuer validation disabled** (:199-206); HS256 verified (:220-228) |

### AuthService — `AuthService.cs`
| Method | Line | Verified behavior |
|--------|------|-------------------|
| `Login(request)` | :74 | banned check (:91-95); **lockout checked before password** (:98-107); wrong password → `AccessFailedAsync` (:110-114); lockout notification (:119-138); `user.Role = roles.First()` (:147-148) — but MappingConfig ignores it (Role always null) |
| `RefreshToken(request)` | :194 | validates stored token; issues new pair |
| `RevokeRefreshToken(userId, token)` | :265 | revokes the row |

### UserService — `UserService.cs` (large; key flows)
- **Register** requires the `emailConfirmed:{email}` cache flag (gated by email verification — :222-228), creates with `EmailConfirmed = true` (:246-253).
- OTP flow: `SendVerificationCodeAsync` rejects registered emails (:324-330), stores `verify:{email}` 10 min (:333); `VerifyEmailCodeAsync` sets `emailConfirmed:{email}` 30 min (:302).
- Reset flow: uniform forgot-password message (:88-97), `passwordReset:{email}` (:100), `passwordResetVerified:{email}` (:146), reset requires the flag (:170-176).
- **`GenerateRandomCode` uses `new Random()`** (:983) — predictable 6-digit OTPs (documented in `AuthController.md`).
- `CreateUserAsync` auto-creates roles incl. `"Moderator "` trailing-space role (:918-925).

### ExternalLoginService — `ExternalLoginService.cs`
- `HandleExternalLoginCallbackAsync` (:66): **auto-creates the user** for new external emails (:145-170); `IsNewUser` is false on every return path (:104/:136/:164/:258) → the confirmation flow is dead (see `AuthController.md`).
- `ConfigureExternalAuthProperties(provider, redirectUrl)` (:285): no provider validation.

### CurrentUserService — `CurrentUserService.cs`
- `GetUserIdAsync` (:24): `(await _userManager.GetUserAsync(HttpContext?.User))?.Id`.
- `GetUserFullNameAsync` (:30).

---

## 2. Catalog (Course / Category / Progress)

### CourseService — `CourseService.cs` (~1400 lines, the core)
| Group | Methods (verified lines) |
|-------|--------------------------|
| Reads | `GetCourseByIdAsync` (:130) |
| Create | `AddCourseAsync` (:369) · `AddCourseAsInstructorAsync` (:390) · `CreateCourseDraftAsync` (:628) |
| Update | `UpdateCourseAsync` (:423) · `UpdateCourseAsInstructorAsync` (:472) · `UpdateCourseDetailsAsync` (:676) |
| Delete | `DeleteCourseAsync` (:531) · `DeleteCourseAsInstructorAsync` (:582) |
| Sections | `AddSectionAsync` (:727) · `UpdateSectionAsync` (:754) · `DeleteSectionAsync` (:784) · `ReorderSectionsAsync` (:798) · `GetSectionByIdAsync` (:812) |
| Lectures | `AddLectureAsync` (:834) · `UpdateLectureAsync` (:879) · `DeleteLectureAsync` (:923) · `ReorderLecturesAsync` (:942) · `GetLectureByIdAsync` (:956) |
| Ownership helpers | `GetCourseIdByLectureAsync` (:974) · `GetCourseIdByResourceAsync` (:987) |
| Publish | `PublishCourseAsync` (:1109) · `AdminPublishCourseAsync` (:1152) · `BulkPublishCoursesAsync` (:1269) · `BulkUnpublishCoursesAsync` (:1290) |
| Bulk | `BulkDeleteCoursesAsync` (:1197) · `BulkDeleteCoursesAsInstructorAsync` (:1231) |
| Review | `AcceptCourseAsync` (:1315) · `RejectCourseAsync(id, reason)` (:1353) |
| Resources | `AddResourceToLectureAsync` (:304) · `DeleteResourceAsync` (:349) |

### CategoryService — `CategoryService.cs`
`GetCategoryByIdAsync` (:91) · `CreateCategoryAsync` (:189) · `UpdateCategoryAsync` (:236) · `DeleteCategoryAsync` (:293).

### CourseProgressService — `CourseProgressService.cs`
- `MarkLectureAsCompletedAsync` (:137): **recomputes percentage and calls `TryIssueCertificateIfCompletedAsync`** — auto-issue at ≥100% + `HasCertificate` (:158/:180/:315-336); **no lecture-to-course membership validation** → certificate fraud path (see `CourseProgressController.md`).
- `MarkLectureAsIncompleteAsync` (:203): **creates a `IsCompleted=false` record when none exists** (:227-242) — never null.
- `GetCourseProgressPercentageAsync` (:522): **exceptions swallowed → 0** (:533-537).
- `GetCourseProgressSummaryAsync` (:449): total = sum of section lectures (:462).

---

## 3. Commerce (Payment / Cart / Enrollment)

### PaymentService — `PaymentService.cs`
| Method | Line | Verified behavior |
|--------|------|-------------------|
| `CreatePaymentIntentAsync(userId, request)` | :110 | Stripe intent; **free checkout (`Price == 0`) skips Stripe, `PaymentIntentId = "free"`** (:128-146); missing key → ArgumentException (:82-87); `StripeException → ApplicationException` (:184-187) |
| `ConfirmPaymentAsync(id)` | :206 | confirms intent |
| `ProcessPaymentSuccessAsync(id)` | :272 | post-payment side effects (enrollments) |
| `CreateCheckoutSessionAsync(userId, request)` | :335 | cart checkout session |
| `RefundAsync(userId, request)` | :633 | policy: within 7 days + progress < 25% (controller doc :305-308) |
| `AdminProcessRefundAsync(requestId, adminId, approve, reason)` | :756 | admin decision + Stripe refund |

### CartService — `CartService.cs`
`GetUserCartAsync` (:152) · `GetGuestCartAsync` (:179) · `AddItemToCartAsync` (:209) — **registered users blocked if already enrolled; guests not** (:217-235) · `MigrateGuestCartToUserAsync` (:277) — **dead null-guard on empty guestId** (:284-288), deletes guest cart after merge (:195) · `RemoveItemFromCartAsync` (:306) — **registered path has no ownership check (IDOR)** (:331) · `ClearCartAsync` (:353).
Guest cookie `Secure=true` + `HttpOnly` (:67-74) — broken over plain HTTP dev.

### EnrollmentService — `EnrollmentService.cs`
- `GetEnrollmentByIdAsync` (:46): **NRE on missing enrollment** (:52-57) → 500 instead of 404.
- `CreateEnrollmentAsync` (:186): checks already-enrolled (:193-198) + course exists (:201-206) — **NO payment or Approved-status check** → payment bypass (see `EnrollmentController.md`).
- `CreateBulkEnrollmentsAsync` (:244): the payment-flow path.
- `DeleteEnrollmentAsync` (:229): raw delete, no ownership check.

---

## 4. Learning (Certificates / Comments / Ratings)

### CertificateService — `CertificateService.cs`
- `GetCertificateFilePath` (:89): `Path.Combine(WebRootPath ?? CWD, "uploads", "certificates", ...)` — null-safe.
- `GenerateCertificateAsync` (:99): creates the row + renders PNG + notifies.
- **Disposes a SkiaSharp font** (:419) — ties into the Arabic-glyph fix (`CertificateTypefaceProvider`).

### CertificateTypefaceProvider — `CertificateTypefaceProvider.cs`
- `FromFamilyName(...)` (:24): SkiaSharp font resolution — the **Cairo font for Arabic certificate text** (see prior certificate fix).

### LectureCommentService — `LectureCommentService.cs`
- `AddCommentAsync` (:70): **`ParentCommentId` accepted from the client without verifying it belongs to the lecture** (:77); notifies the instructor (:90-110).
- `ReplyToCommentAsync` (:115).
- `DeleteCommentAsync` (:175): author-only (`comment.UserId == userId`, :183); deletes replies then comment (:186-190).
- List path N+1 `IsUserInstructor` per comment (:53-64).

### RatingService — `RatingService.cs`
`AddRatingAsync` (:65) · `UpdateRatingAsync` (:162) · `DeleteRatingAsync` (:218) · `GetUserRatingForCourseAsync` (:259) · `GetCourseRatingSummaryAsync` (:337) · `CanUserRateCourseAsync` (:374) · `GetInstructorRatingsAsync` (:429).

---

## 5. Instructor & Students

### InstructorApplicationService — `InstructorApplicationService.cs`
- `SubmitApplication` (:82): re-apply blocked only while Pending/Approved (:99-109); updates profile (:112-114); **removes ALL current roles then adds `InstructorPending`** (:129-146); saves CV (:154-158); `Status = "Pending"` (:161-171).
- `GetApplicationDetails` (:251) — **ownership-enforced** (:260-264).
- `ApproveApplication` (:348) / `RejectApplication` (:443): reject resets roles to Student (:485-496).
- `SaveFile` helper: **no size/type whitelist; filename = `Guid_originalFileName`** — traversal risk (:548-579); no WebRootPath null guard.

### InstructorService — `InstructorService.cs`
- `GetAllInstructorsAsync` (:80): full-table load + N+1 role checks; filters Instructor role.
- `GetInstructorByIdAsync` (:148).
- **`TotalStudents` hardcoded 1200** and top-rated ordering issues live in the API controller path (see `InstructorController.md`).

### StudentService — `StudentService.cs`
`GetStudentDetailsAsync` (:142) · `GetStudentsSummaryByInstructorAsync` (:276) · `SendBulkMessageAsync` (:421) · `GetNotificationSummaryAsync` (:495).

---

## 6. Admin (Roles / Reports / Support / Settings / History / Dashboard / Notifications)

### RoleService — `RoleService.cs`
`GetRoleByIdAsync` (:88) · `CreateRoleAsync` (:128) · `UpdateRoleAsync` (:173) · `DeleteRoleAsync` (:230) · `BulkDeleteRolesAsync` (:287) · `GetRoleClaimsAsync` (:361) · `UpdateRoleClaimsAsync(roleId, claims)` (:413) · `CountUsersInRoleAsync` (:519) · `GetRolesStatisticsAsync` (:551).

### RoleClaimsService — `RoleClaimsService.cs`
`GetClaimsForRoleAsync` (:23) · `UpdateRoleClaimsAsync` (:95) — the categorized permissions editor backend.

### ReportService — `ReportService.cs`
`CreateReportAsync(userId, dto)` (:53) — dedupe + validation (KeyNotFound/InvalidOperation/Argument) · `GetAdminReportsAsync(status, type, search, page, pageSize)` (:129) · `GetPendingCountAsync` (:158) · `HasReportedAsync` (:163) · `UpdateStatusAsync(adminId, id, dto)` (:178) · `DeleteReportedContentAsync(adminId, id)` (:212).

### SupportService — `SupportService.cs`
`CreateConversationAsync` (:41) · `SendUserMessageAsync` (:137) · `CloseConversationAsync` (:168) · `ReopenConversationAsync` (:185) · `GetUserUnreadCountAsync` (:202) · `GetConversationDetailAsync` (:253) · `SendAgentMessageAsync` (:295) · `SetConversationStatusAsync` (:326) · `GetAgentUnreadCountAsync` (:343) · `MarkAllUserMessagesReadAsync` (:354).

### SiteSettingsService — `SiteSettingsService.cs`
`GetSettingsAsync` (:29) — 5-min cache · `UpdateSettingsAsync(dto, updatedBy)` (:60).

### HistoryService — `HistoryService.cs`
`LogOperationAsync(userId, operation, operationType, messageKey, parameters)` (:50) — the single audit writer used by every admin controller.

### DashboardService — `DashboardService.cs`
`GetAdminDashboardAsync` (:56) · `GetInstructorDashboardAsync` (:175) · `GetInstructorRevenueAsync(instructorId, period)` (:327) · `GetPublicStatsAsync` (:423).

### NotificationService — `NotificationService.cs`
`GetUserNotificationSummaryAsync` (:129) · `CreateNotificationAsync` (:164) · `MarkNotificationAsReadAsync` (:224) · `MarkAllNotificationsAsReadAsync` (:259) · `DeleteNotificationAsync` (:291) · `DeleteAllNotificationsAsync` (:337) · `GetUnreadCountAsync` (:369) · `SendBulkNotificationAsync` (:405) · `SendInstructorNotificationAsync` (:532) · `GetInstructorNotificationSummaryAsync` (:670).

### UserSettingsService — `UserSettingsService.cs`
`GetGeneralSettingsAsync` (:77) · `UpdateGeneralSettingsAsync` (:115) · `ChangePasswordAsync` (:174) · `EnableTwoFactorAsync` (:240) · `DisableTwoFactorAsync` (:298) · `VerifyTwoFactorCodeAsync` (:343) · `GetTwoFactorSetupAsync` (:384) · `IsTwoFactorEnabledAsync` (:442) · `RevokeSessionAsync` (:521) · `RevokeAllSessionsAsync` (:560) — **revoke-all behavior at service level** (see `SettingsController.md` self-lockout finding).

### WishlistService — `WishlistService.cs`
`AddToWishlistAsync` (:119) · `RemoveFromWishlistAsync` (:201) · `IsCourseInWishlistAsync` (:260) · `GetWishlistCountAsync` (:294) — all user-scoped.

---

## 7. Infrastructure Helpers

| Service | Purpose (verified) |
|---------|--------------------|
| **EmailSender** (:25, :57) | SMTP send + attachment variant (certificates) |
| **EmailTemplateService** (20+ generators, :37-2870) | Localized HTML emails: login, verification, reset, approval/rejection, payment, refund, certificate, lockout, report warning... (link fixes applied previously) |
| **FileStorageService** (:19-132) | `UploadFileAsync`, `DeleteFile`/`DeleteFileIfExists`, `DeleteVideoFile`/`DeleteVideoFileIfExists` |
| **IpService** (:22-98) | `GetClientIpAddress`, `GetLocationFromIP`, `GetDeviceInfo`, `CreateUserSessionAsync(userId, jwtToken)` — session tracking on login |
| **VideoDurationService** (:21-57) | `GetVideoDurationAsync` (IFormFile), from path/URL — lecture duration extraction |
| **LinkBuilderService** (:19-24) | `GenerateResetPasswordLink(userId)`, `GenerateCertificateVerifyLink(code)` |

---

## Cross-Cutting Findings

1. **Certificate fraud** originates here: `CourseProgressService` auto-issues at ≥100% without lecture-membership validation (`CourseProgressService.cs:315-336`).
2. **Payment bypass** is service-level: `EnrollmentService.CreateEnrollmentAsync` never checks payment/status (:186-226).
3. **OTP PRNG weakness**: `UserService.GenerateRandomCode` uses `new Random()` (:983).
4. **Two revoke-all paths**: `UserSettingsService.RevokeAllSessionsAsync` (:560) vs the repository's `excludeSessionId` capability (`SessionRepository.cs:217`) — the exclusion is never used by the service.
5. **Email layer is the largest single file family** — `EmailTemplateService` spans ~2900 lines across 20+ templates.
6. **Naming split**: `SupportService.MarkAllUserMessagesReadAsync` (:354) is the **agent** mark-all-read (the "UserMessages" = user-sent messages) — naming trap.

---

## Business Rules (implemented here, verified)

| Rule | Where |
|------|-------|
| Auto-certificate at 100% + HasCertificate | CourseProgressService.cs:315-336 |
| Refund policy: 7 days + <25% progress | PaymentController.cs:305-308 (service-enforced in RefundAsync) |
| One pending/approved instructor application | InstructorApplicationService.cs:99-109 |
| Comment delete = author-only | LectureCommentService.cs:183 |
| Bulk notifications report Total/Notifications/Emails | NotificationService.cs:405+ |
| Login lockout before password check | AuthService.cs:98-107 |

---

## Configuration

| Key | Purpose |
|-----|---------|
| `Stripe:SecretKey` | PaymentService (Program.cs:171) |
| SMTP settings | EmailSender (appsettings.json:23-29) |
| `JWT:*` | TokenService signing |

---

## Change Log

**Current functionality (verified):** complete application-layer reference — 35 services, method surfaces with line citations, and the security-critical behaviors (certificate fraud, payment bypass, OTP weakness, IDOR patterns).

**Maintenance notes:** validate lecture membership before certificate issuance; enforce payment in CreateEnrollmentAsync; replace OTP PRNG; use the repository's exclude-session capability.