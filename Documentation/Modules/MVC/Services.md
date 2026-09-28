# Services Reference (EduLab_MVC)

---

## Overview

### Purpose
Complete reference of the MVC service layer: all 28 `AddScoped` services that wrap the EduLab API and external services, with their exact HTTP endpoints (verified `file.cs:line` per call).

### Business Objective
Every MVC service is a thin HTTP client over the API or external providers — this map shows which endpoint each service hits, so the MVC↔API contract is traceable.

### Main Functionality
- One service per domain (Cart, Course, Profile, Currency...) injected into controllers
- All share `AuthorizedHttpClientService` for the JWT + guest-id plumbing and `ApiEndpoints` (`Common/ApiEndpoints.cs:7-266`) for centralized route constants
- Multi-layer caching: `IMemoryCache` across `SiteSettingsService` (60m), `CategoryService` (15m), `CourseService` (10m), `InstructorService` (10m), `UserService` (10m), and `CurrencyService` (6h for live exchange rates), plus request-scoped `_cachedCart` and `_cachedWishlist` to eliminate duplicate per-request API calls

---

## Folder Structure

```
Services/
├── ServiceInterfaces/          # I<Domain>Service interfaces
└── <Domain>Service.cs          # 28 implementations (registered in Program.cs:65-92)
```

---

## Infrastructure Base

### AuthorizedHttpClientService
- **Logs the first 10 characters of the AuthToken** (:36) — partial token in logs (intentional for correlation, but see Security).
- **Forwards the GuestId cookie** to the API (:50-54) — how guest carts work across the boundary.
- Base address from `ApiBaseUrl` with 15s timeout and `AutomaticDecompression = DecompressionMethods.All` (Program.cs:53-62).

---

## Caching Architecture (MVC Service Layer)

| Service | Cache Strategy | Keys & TTL | Invalidation / Eviction (verified) |
|---------|----------------|------------|------------------------------------|
| **CurrencyService** | `IMemoryCache` | `"LiveExchangeRates_USD"` — **6 hours** (`CurrencyService.cs:22, :98`) | Time-based expiration (6h); automatic fallback to built-in static dictionary on API failure |
| **SiteSettingsService** | `IMemoryCache` | `"SiteSettings"` — **60 min** (:18, :41-42, :56) | Refreshed in-place on `UpdateSettingsAsync` (:87) |
| **CategoryService** | `IMemoryCache` | `"Mvc_All_Categories"`, `$"Mvc_Top_Categories_{count}"` — **15 min** (:19-20, :59-62, :77, :99-103, :118) | `InvalidateCategoryCache()` (:38-48) removes `"Mvc_All_Categories"`, `"Mvc_Top_Categories_4/6/8/10"`, `"Learner_Categories_With_Courses"`, `"Learner_Categories_Suggest"` on create (:158), update (:198), delete (:233), bulk-delete (:279) |
| **CourseService** | `IMemoryCache` | `$"FeaturedCourses_{count}"` (:92-96, :116), `$"NewCourses_{count}"` (:138-142, :162) — **10 min** | Time-based expiration (10m) |
| **InstructorService** | `IMemoryCache` | `"All_Instructors_List"` (:60-64, :86), `$"Mvc_Top_Instructors_{count}"` (:21, :171-175, :192) — **10 min** | Time-based expiration (10m) |
| **UserService** | `IMemoryCache` + cookie fast-path | `$"CurrentUser_{userId}"` — **10 min** (:178-184, :208); returns `null` in 0ms when no `AuthToken` cookie exists (:172-176) | `InvalidateCurrentUserCache()` (:252-260) called on `AuthController.Logout` (:604), `TokenRefreshMiddleware.LogoutUser` (:125), and `ProfileController` updates/uploads (:250, :304, :406, :460); `InvalidateUserCache(userId)` (:262-269) called on `UpdateUserAsync` (:437) |
| **CartService** | Request-scoped field | `_cachedCart` (`CartDto?`, :25, :76-79, :102) | Cleared (`_cachedCart = null`) on `AddItemToCartAsync` (:187), `RemoveItemFromCartAsync` (:233), `ClearCartAsync` (:269) |
| **WishlistService** | Request-scoped fields | `_cachedWishlist` (`List<WishlistItemDto>?`, :25) + `_cachedWishlistCourseIds` (`HashSet<int>?`, :26) | Populated once per HTTP request (:71-74, :99-100, :238-252); cleared on `AddToWishlistAsync` (:139-140) and `RemoveFromWishlistAsync` (:194-195) |

---

## Per-Service API Map (`ApiEndpoints.*`)

| Service | API endpoints (verified) |
|---------|--------------------------|
| **AuthService** | Token helpers used by AuthController + TokenRefreshMiddleware: `IsTokenExpired` (TokenRefreshMiddleware.cs:46), `RefreshToken` (:58), `RevokeToken` (:138), `SaveTokensToCookies` (:62) |
| **CartService** | `ApiEndpoints.Cart.*` + request-scoped `_cachedCart` (:25, :76-79) · GET `Cart` (:84) · POST `Cart/migrate` (:125) · POST `Cart/items` (:180) · DELETE `Cart/items/{cartItemId}` (:226) · DELETE `Cart/clear` (:260) · POST `Cart/apply-coupon` · DELETE `Cart/remove-coupon` |
| **CategoryService** | `ApiEndpoints.Categories.*` + 15-min `IMemoryCache` (:19-20) · GET `Category` (:68) · GET `Category/top?count=` (:109) · POST `Category` (:148) · PUT `Category` (:188) · DELETE `Category/{id}` (:225) · DELETE `Category/bulk?ids=` (:271) |
| **CouponService** | `ApiEndpoints.Coupons.*` · GET `Coupon` · GET `Coupon/{id}` · POST `Coupon` · PUT `Coupon/{id}` · DELETE `Coupon/{id}` · PATCH `Coupon/{id}/toggle` · POST `Coupon/apply` · POST `Coupon/remove` |
| **CurrencyService** | External live exchange API: `open.er-api.com/v6/latest/USD` + 6-hour `IMemoryCache` (`"LiveExchangeRates_USD"`) · Cookie storage `UserCurrency` (30 days) · `GetSupportedCurrencies()`, `GetUserCurrencyAsync()`, `SetUserCurrency()`, `ConvertFromUsdAsync()`, `FormatPriceAsync()`, `FormatUsdEquivalentAsync()` |
| **CertificateService** | `ApiEndpoints.Certificates.*` · GET `certificates/my` (:35) |
| **CommentsService** | `ApiEndpoints.Comments.*` · POST `comments` (:56) · GET `instructor/comments` (:121) · DELETE `comments/{commentId}` (:106) |
| **CourseProgressService** | `ApiEndpoints.CourseProgress.*` · POST `courseprogress/mark-completed` (:60) · POST `courseprogress/mark-incomplete` (:108) |
| **CourseService** | `ApiEndpoints.Courses.*` / `LearnerCourses.*` / `InstructorCourses.*` + 10-min `IMemoryCache` on `GetFeaturedCoursesAsync` (:92-116) & `GetNewCoursesAsync` (:138-162) · GET `course` (:54) · POST `course` (:480) · POST `course/create-draft` (:1073) · DELETE `course/{id}` (:590) · DELETE `course/sections/{sectionId}` (:1151) · DELETE `course/lectures/{lectureId}` (:1270) · POST `course/lecture/{lectureId}/resources` (:377) · GET `course/lecture/{lectureId}/resources` (:431) · DELETE `course/resources/{resourceId}` (:406) · **Instructor surface:** POST `InstructorCourse` (:1339) · PUT `InstructorCourse/{id}` (:1369) · GET `InstructorCourse/instructor-courses` (:1401) · DELETE `InstructorCourse/instructor/{id}` (:1475) · POST `InstructorCourse/instructor/BulkDelete` (:1519) · POST `InstructorCourse/{courseId}/sections` (:747) · PUT/DELETE `InstructorCourse/sections/{sectionId}` (:772/:797) · PUT `InstructorCourse/sections/reorder` (:815) · GET `InstructorCourse/sections/{sectionId}` (:833) · POST `InstructorCourse/sections/{sectionId}/lectures` (:876) · PUT/DELETE `InstructorCourse/lectures/{lectureId}` (:927/:960) · PUT `InstructorCourse/lectures/reorder` (:978) · GET `InstructorCourse/lectures/{lectureId}` (:996) · POST `InstructorCourse/{courseId}/publish` (:1022) · `GetCurrentInstructorId` parses JWT `sub` (:1558-1575) · `ExtractApiError` parses `message` (:1889-1899) |
| **DashboardService** | `ApiEndpoints.Dashboard.*` · GET `admin/dashboard` (:45) · GET `instructor/dashboard` (:83) · GET `instructor/dashboard/revenue?period=` (:128) · GET `public/stats` (:166) |
| **EnrollmentService** | `ApiEndpoints.Enrollment.*` · GET `enrollment` (:37) · GET `enrollment/count` (:203) · DELETE `enrollment/{enrollmentId}` (:185) |
| **HistoryService** | `ApiEndpoints.History.*` · GET `History/all` (:115) · GET `History/MyHistory` (:162) · GET `History/user/{userId}` (:215) · POST `History/log?userId=&operation=` (:72) · URL fix `Replace("/api","")` (:39) |
| **InstructorApplicationService** | `ApiEndpoints.InstructorApplications.*` · POST `InstructorApplication/apply` (:75) · GET `InstructorApplication/my-applications` (:113) · GET `InstructorApplication/application-details/{id}` (:163) · GET `InstructorApplications` (:210) · GET `InstructorApplications/{id}` (:268) · PUT `InstructorApplications/{id}/{action}` (:347) |
| **InstructorService** | `ApiEndpoints.Instructors.*` + 10-min `IMemoryCache` (:21, :60-64, :171-175) · GET `Instructor` (:70) · GET `Instructor/top?count=` (:181) · GET `instructor/ratings/{id}` (:225) · image URL prefixing (:39-40) |
| **NotificationService** | `ApiEndpoints.Notifications.*` · GET `Notifications/summary` (:77) · GET `Notifications/unread-count` (:105) · POST `Notifications/mark-all-read` (:133) · DELETE `Notifications/{id}` (:182) · DELETE `Notifications/delete-all` (:207) · POST `Notifications/send-bulk` (:242) |
| **PaymentService** | `ApiEndpoints.Payment.*` · GET `payment/user-data` (:70) · POST `payment/create-payment-intent` (:118) · POST `payment/confirm-payment` (:178) · POST `payment/create-checkout-session` (:234) · GET `payment/user-payments` (:352) · POST `payment/refund` (:385) |
| **ProfileService** | `ApiEndpoints.Profile.*` · GET `profile` (:57) · PUT `profile` (:112) · POST `profile/upload-image` (:228) · GET `profile/instructor` (:270) · PUT `profile/instructor` (:341) · POST `profile/instructor/upload-image` (:390) · POST `profile/certificates` (:445) · DELETE `profile/certificates/{certId}` (:496) |
| **RatingService** | `ApiEndpoints.Ratings.*` · GET `ratings/course/{id}?page=&pageSize=` · GET `ratings/course/{id}/summary` · GET `ratings/course/{id}/my-rating` · GET `ratings/can-rate/{id}` · POST `ratings` (:210) · PUT/DELETE `ratings/{ratingId}` · avatar fallback `"/img/User Logo.png"` (:386) |
| **RefundRequestService** | `ApiEndpoints.RefundRequests.*` · GET `admin/refunds` (:46) |
| **ReportService** | `ApiEndpoints.Reports.*` · GET `admin/reports?page=&pageSize=&status=&type=&search=` (:38) · GET `admin/reports/pending-count` (:66) · POST `admin/reports/{id}/status` (:88) · POST `admin/reports/{id}/delete-content` (:115) · POST `reports` (:144) |
| **RoleService** | `ApiEndpoints.Roles.*` · GET `role` (:39) · GET `role/{id}` (:83) · POST `role` (:128) · PUT `role/{id}` (:173) · DELETE `role/{id}` (:217) · POST `role/bulk-delete` (:261) · POST `role/{roleId}/claims` (:310) · GET `role/{roleId}/claims` (:355) · GET `role/getRoleClaims/{roleId}` (:389) · PUT `role/updateRoleClaims/{roleId}` (:420) · GET `role/statistics` (:456) · GET `role/{roleName}/users` (:504) |
| **SiteSettingsService** | `ApiEndpoints.SiteSettings.Base` · GET `admin/settings` (:48) with **60-min `IMemoryCache`** (`"SiteSettings"`, :18, :41-42, :56) · PUT `admin/settings` (:83, refreshes cache at :87) |
| **StudentService** | `ApiEndpoints.Students.*` · GET `students/my-students` (:117) · GET `students/summary` (:278) · POST `students/send-notification` (:327) · GET `students/by-instructor/{instructorId}` (:75) · GET `students{query}` (:175) · GET `students/{studentId}` (:224) · GET `students/notification-students` (:377) · GET `students/notification-summary` (:427) |
| **SupportService** | `ApiEndpoints.Support.*` · GET `support/conversations` (:35) · POST `support/conversations` (:56) · GET `support/unread-count` (:143) · GET `admin/support/conversations` (:165) · GET `admin/support/conversations/{id}` (:183) · POST `admin/support/conversations/{id}/messages` (:204) · POST `admin/support/conversations/{id}/status` (:225) · GET `admin/support/unread-count` (:240) · POST `admin/support/mark-all-read` (:258) |
| **UserService** | `ApiEndpoints.Users.*` + 10-min `IMemoryCache` on `GetCurrentUserAsync` (`$"CurrentUser_{userId}"`, :170-219) · GET `user` (:62) · GET `user/instructors` (:91) · GET `user/admins` (:118) · GET `user/{id}` (:149) · GET `user/me` (:190) · GET `user/by-edulab-id/{id}` (:243) · DELETE `user/{userId}` (:295) · POST `user/DeleteUsers` (:337) · PUT `user` (:389, invalidates user cache :437) · POST `user/LockUsers` (:458) · POST `user/UnlockUsers` (:490) |
| **UserSettingsService** | `ApiEndpoints.Settings.*` · GET `settings/general` (:47) · PUT `settings/general` (:94) · POST `settings/change-password` (:141) · GET `settings/active-sessions` (:181) · GET `settings/two-factor/setup` (:310) · POST `settings/two-factor/enable` (:356) · GET `settings/two-factor/status` (:435) · POST `settings/two-factor/verify` (:483) |
| **WishlistService** | `ApiEndpoints.Wishlist.*` + request-scoped `_cachedWishlist` / `_cachedWishlistCourseIds` (:25-26, :71-74, :238-252) · GET `wishlist` (:78) · POST `wishlist` (:126) · DELETE `wishlist/{courseId}` (:181) · GET `wishlist/count` (:283) |

---

## Cross-Cutting Findings

1. **Centralized `ApiEndpoints.cs` constants**: all 26 services use `ApiEndpoints.<Domain>.*` (`Common/ApiEndpoints.cs:7-266`) rather than hardcoded string paths.
2. **Per-request deduplication (`_cachedCart` & `_cachedWishlist`)**: `CartService` (`:25, :76-79`) and `WishlistService` (`:25-26, :71-74, :238-252`) cache the current request's cart and wishlist items/IDs in scoped fields, preventing N+1 API calls when rendering course grids or header view components.
3. **URL-base stripping inconsistency** (3 patterns): `HistoryService` uses `Replace("/api","").TrimEnd('/')` (:39); `InstructorService`/`StudentService`/`RatingService` use `Replace("/api/","/")` (:40); `_Layout.cshtml:41` strips nothing. All "work" only because the API base ends in `/api/`.
4. **`AuthToken` prefix logged** by AuthorizedHttpClientService (:36) — first 10 chars of the JWT appear in logs.
5. **GuestId forwarding** (:50-54) is what makes guest carts survive — but the API's guest cookie is `Secure` (broken over plain-HTTP dev; see `CartController.md`).
6. **SiteSettingsService caches 60 minutes** (`SiteSettingsService.cs:56`) and updates the cache immediately when `UpdateSettingsAsync` is called from the MVC Admin panel (:87).

---

## Business Rules

| Rule | Where (verified) |
|------|------------------|
| Every service is scoped + HTTP-only (no DB access) | Program.cs:65-90 |
| All API paths come from `ApiEndpoints` | Common/ApiEndpoints.cs:7-266 |
| Anonymous requests skip `/api/user/me` | UserService.cs:172-176 |
| Instructor identity from JWT `sub` | CourseService.cs:1558-1575 |
| API errors parsed from `message` field | CourseService.cs:1889-1899 |

---

## Configuration

| Key | Purpose |
|-----|---------|
| `ApiBaseUrl` | Base for every service call (Program.cs:53-62) |

---

## Change Log

**Current functionality (verified):** complete MVC→API endpoint map for all 26 services using `ApiEndpoints.cs`, `IMemoryCache` caching across 5 services, request-scoped `_cachedCart` and `_cachedWishlist`, and cross-cutting URL-stripping and token-logging findings.

**Maintenance notes:** unify the `/api` stripping; consider trimming the token prefix log.