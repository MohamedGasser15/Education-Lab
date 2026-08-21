# Services Reference (EduLab_MVC)

---

## Overview

### Purpose
Complete reference of the MVC service layer: all 26 `AddScoped` services that wrap the EduLab API, with their exact HTTP endpoints (verified `file.cs:line` per call).

### Business Objective
Every MVC service is a thin HTTP client over the API — this map shows which endpoint each service hits, so the MVC↔API contract is traceable.

### Main Functionality
- One service per domain (Cart, Course, Profile, ...) injected into controllers
- All share `AuthorizedHttpClientService` for the JWT + guest-id plumbing

---

## Folder Structure

```
Services/
├── ServiceInterfaces/          # I<Domain>Service interfaces
└── <Domain>Service.cs          # 26 implementations (registered in Program.cs:52-77)
```

---

## Infrastructure Base

### AuthorizedHttpClientService
- **Logs the first 10 characters of the AuthToken** (:36) — partial token in logs (intentional for correlation, but see Security).
- **Forwards the GuestId cookie** to the API (:50-54) — how guest carts work across the boundary.
- Base address from `ApiBaseUrl` (Program.cs:46-49).

---

## Per-Service API Map

| Service | API endpoints (verified) |
|---------|--------------------------|
| **AuthService** | Token helpers used by AuthController + TokenRefreshMiddleware: `IsTokenExpired` (TokenRefreshMiddleware.cs:46), `RefreshToken` (:58), `RevokeToken` (:129), `SaveTokensToCookies` (:62) |
| **CartService** | GET `Cart` (:79) · POST `Cart/migrate` (:120) · POST `Cart/items` (:175) · DELETE `Cart/items/{cartItemId}` (:220) · DELETE `Cart/clear` (:253) |
| **CategoryService** | GET `Category` (:42) · POST `Category` (:115) · PUT `Category` (:154) · DELETE `Category/{id}` (:190) · DELETE `Category/bulk?ids=` (:236) |
| **CertificateService** | GET `certificates/my` (:35) |
| **CommentsService** | POST `comments` (:56) · GET `instructor/comments` (:121) · DELETE `comments/{commentId}` (:106) |
| **CourseProgressService** | POST `courseprogress/mark-completed` (:60) · POST `courseprogress/mark-incomplete` (:108) |
| **CourseService** | GET `course` (:53) · POST `course` (:474) · POST `course/create-draft` (:1067) · DELETE `course/{id}` (:584) · DELETE `course/sections/{sectionId}` (:1145) · DELETE `course/lectures/{lectureId}` (:1264) · POST `course/lecture/{lectureId}/resources` (:371) · GET `course/lecture/{lectureId}/resources` (:425) · DELETE `course/resources/{resourceId}` (:400) · **Instructor surface:** POST `InstructorCourse` (:1333) · PUT `InstructorCourse/{id}` (:1363) · GET `InstructorCourse/instructor-courses` (:1395) · DELETE `InstructorCourse/instructor/{id}` (:1469) · POST `InstructorCourse/instructor/BulkDelete` (:1513) · POST `InstructorCourse/{courseId}/sections` (:741) · PUT/DELETE `InstructorCourse/sections/{sectionId}` (:766/:791) · PUT `InstructorCourse/sections/reorder` (:809) · GET `InstructorCourse/sections/{sectionId}` (:827) · POST `InstructorCourse/sections/{sectionId}/lectures` (:870) · PUT/DELETE `InstructorCourse/lectures/{lectureId}` (:921/:954) · PUT `InstructorCourse/lectures/reorder` (:972) · GET `InstructorCourse/lectures/{lectureId}` (:990) · POST `InstructorCourse/{courseId}/publish` (:1016) · `GetCurrentInstructorId` parses JWT `sub` (:1552-1569) · `ExtractApiError` parses `message` (:1883-1893) · legacy `AddCourseAsInstructorAsync` copies only Title+ShortDescription (:1427-1446) |
| **DashboardService** | GET `admin/dashboard` (:45) · GET `instructor/dashboard` (:83) · GET `instructor/dashboard/revenue?period=` (:128) · GET `public/stats` (:166) |
| **EnrollmentService** | GET `enrollment` (:37) · GET `enrollment/count` (:203) · DELETE `enrollment/{enrollmentId}` (:185) |
| **HistoryService** | GET `History/all` (:115) · GET `History/MyHistory` (:162) · GET `History/user/{userId}` (:215) · POST `History/log?userId=&operation=` (:72) · URL fix `Replace("/api","")` (:39) |
| **InstructorApplicationService** | POST `InstructorApplication/apply` (:75) · GET `InstructorApplication/my-applications` (:113) · GET `InstructorApplication/application-details/{id}` (:163) · GET `InstructorApplications` (:210) · GET `InstructorApplications/{id}` (:268) · PUT `InstructorApplications/{id}/{action}` (:347) |
| **InstructorService** | GET `Instructor` (:57) · GET `instructor/ratings` (:197) · image URL prefixing (:36-37) |
| **NotificationService** | GET `Notifications/summary` (:77) · GET `Notifications/unread-count` (:105) · POST `Notifications/mark-all-read` (:133) · DELETE `Notifications/{id}` (:182) · DELETE `Notifications/delete-all` (:207) · POST `Notifications/send-bulk` (:242) |
| **PaymentService** | GET `payment/user-data` (:70) · POST `payment/create-payment-intent` (:118) · POST `payment/confirm-payment` (:178) · POST `payment/create-checkout-session` (:234) · GET `payment/user-payments` (:352) · POST `payment/refund` (:385) |
| **ProfileService** | GET `profile` (:57) · PUT `profile` (:112) · POST `profile/upload-image` (:228) · GET `profile/instructor` (:270) · PUT `profile/instructor` (:341) · POST `profile/instructor/upload-image` (:390) · POST `profile/certificates` (:445) · DELETE `profile/certificates/{certId}` (:496) |
| **RatingService** | GET `ratings/course/{id}?page=&pageSize=` · GET `ratings/course/{id}/summary` · GET `ratings/course/{id}/my-rating` · GET `ratings/can-rate/{id}` · POST `ratings` (:210) · PUT/DELETE `ratings/{ratingId}` · avatar fallback `"/img/User Logo.png"` (:386) |
| **RefundRequestService** | GET `admin/refunds` (:46) |
| **ReportService** | GET `admin/reports?page=&pageSize=&status=&type=&search=` (:38) · GET `admin/reports/pending-count` (:66) · POST `admin/reports/{id}/status` (:88) · POST `admin/reports/{id}/delete-content` (:115) · POST `reports` (:144) |
| **RoleService** | GET `role` (:39) · GET `role/{id}` (:83) · POST `role` (:128) · PUT `role/{id}` (:173) · DELETE `role/{id}` (:217) · POST `role/bulk-delete` (:261) · POST `role/{roleId}/claims` (:310) · GET `role/{roleId}/claims` (:355) · GET `role/getRoleClaims/{roleId}` (:389) · PUT `role/updateRoleClaims/{roleId}` (:420) · GET `role/statistics` (:456) · GET `role/{roleName}/users` (:504) |
| **SiteSettingsService** | GET `admin/settings` (:35) with **5-min IMemoryCache** (:43) · PUT `admin/settings` (:67) |
| **StudentService** | GET `students/my-students` (:117) · GET `students/summary` (:278) · POST `students/send-notification` (:327) · GET `students/by-instructor/{instructorId}` (:75) · GET `students{query}` (:175) · GET `students/{studentId}` (:224) · GET `students/notification-students` (:377) · GET `students/notification-summary` (:427) |
| **SupportService** | GET `support/conversations` (:35) · POST `support/conversations` (:56) · GET `support/unread-count` (:143) · GET `admin/support/conversations` (:165) · GET `admin/support/conversations/{id}` (:183) · POST `admin/support/conversations/{id}/messages` (:204) · POST `admin/support/conversations/{id}/status` (:225) · GET `admin/support/unread-count` (:240) · POST `admin/support/mark-all-read` (:258) |
| **UserService** | GET `user` (:58) · GET `user/instructors` (:87) · GET `user/admins` (:114) · GET `user/{id}` (:145) · GET `user/me` (:172) · GET `user/by-edulab-id/{id}` (:225) · DELETE `user/{userId}` (:260) · POST `user/DeleteUsers` (:302) · PUT `user` (:354) · POST `user/LockUsers` (:403) · POST `user/UnlockUsers` (:435) |
| **UserSettingsService** | GET `settings/general` (:47) · PUT `settings/general` (:94) · POST `settings/change-password` (:141) · GET `settings/active-sessions` (:181) · GET `settings/two-factor/setup` (:310) · POST `settings/two-factor/enable` (:356) · GET `settings/two-factor/status` (:435) · POST `settings/two-factor/verify` (:483) |
| **WishlistService** | GET `wishlist` (:75) · GET `wishlist/count` (:271) |

---

## Cross-Cutting Findings

1. **URL-base stripping inconsistency** (3 patterns): `HistoryService` uses `Replace("/api","").TrimEnd('/')` (:39); `InstructorService`/`StudentService`/`RatingService` use `Replace("/api/","/")` (:40); `_Layout.cshtml:41` strips nothing. All "work" only because the API base ends in `/api/`.
2. **`AuthToken` prefix logged** by AuthorizedHttpClientService (:36) — first 10 chars of the JWT appear in logs.
3. **GuestId forwarding** (:50-54) is what makes guest carts survive — but the API's guest cookie is `Secure` (broken over plain-HTTP dev; see `CartController.md`).
4. **CourseService is the widest client** (28 API paths, ~1900 lines) — both admin `course/*` and instructor `InstructorCourse/*` surfaces, plus the legacy `AddCourseAsInstructorAsync` wrapper.
5. **SiteSettingsService caches 5 minutes** — maintenance-mode toggles lag up to 5 min in the MVC app (interacts with `MaintenanceModeMiddleware`).

---

## Business Rules

| Rule | Where (verified) |
|------|------------------|
| Every service is scoped + HTTP-only (no DB access) | Program.cs:52-77 |
| Instructor identity from JWT `sub` | CourseService.cs:1552-1569 |
| API errors parsed from `message` field | CourseService.cs:1883-1893 |

---

## Configuration

| Key | Purpose |
|-----|---------|
| `ApiBaseUrl` | Base for every service call (Program.cs:46-49) |

---

## Change Log

**Current functionality (verified):** complete MVC→API endpoint map for all 26 services, with the cross-cutting URL-stripping and token-logging findings.

**Maintenance notes:** unify the `/api` stripping; consider trimming the token prefix log.