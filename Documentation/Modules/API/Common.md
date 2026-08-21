# Common Reference (EduLab_API + Application)

---

## Overview

### Purpose
The shared constants, response envelope, conventions, settings, and mapping profiles the API layer depends on: `SD`, `AdminClaims`, `HistoryMessages`, `NotificationMessages`, `ApiResponse<T>`, the Admin-area convention, `StripeSettings`, and `MappingConfig`.

### Main Functionality
- `SD` (Application) — roles/statuses incl. payment statuses
- `AdminClaims` — the 38-claim admin catalog
- `HistoryMessages` / `NotificationMessages` — localization keys for audit + notifications
- `ApiResponse<T>` — unified response envelope
- `AdminAreaAuthorizationConvention` (API) — namespace-based auto-protection
- `StripeSettings` + `MappingConfig` — config + AutoMapper

---

## 1. SD (Application) — `Common/Constants/SD.cs` (114 lines)

### Roles & identity

| Constant | Value | Notes |
|----------|-------|-------|
| Admin / Instructor / InstructorPending / Student / Support | literal | :11-15 |
| **Moderator** | `"Moderator "` | **trailing space** (:16) |
| EduLabInstructorId | `"edulab-instructor"` | (:17) |
| ProtectedRoles | Admin, Instructor, InstructorPending, Student, Support | Moderator NOT protected (:19-22) |

### Status vocabularies

| Domain | Values (verified) |
|--------|-------------------|
| Course | `Draft` / `Pending` / `Approved` / `Rejected` (:42-45) |
| Application | `Pending` / `Approved` / `Rejected` (:47-49) |
| Refund | `pending` / `accepted` / `rejected` — lowercase (:51-53) |
| **Payment** | `completed` / `refunded` / `Succeeded` / `Paid` — **mixed casing** (:55-58) |
| Report status | `pending` / `resolved` / `dismissed` (:60-62) |
| Report type | `Course` / `Comment` / `Review` (:64-66) |
| Report action | `WarnedUser` / `RemovedContent` / `ReviewedNoViolation` (:68-70) |

### Report reasons + `GetReportReasons(type)` (:72-112)
Same 10-code taxonomy as the MVC side; per-type arrays; unknown type → course reasons.

### ProtectedCategories (54, :24-40)
Identical to the MVC list — the shared taxonomy guard.

**Note:** the Application `SD` adds the **payment status constants** (:55-58) not present in the MVC `SD` — with a casing inconsistency (`completed`/`refunded` lowercase vs `Succeeded`/`Paid` PascalCase) that payment comparisons must respect.

---

## 2. AdminClaims (Application) — `Common/Constants/AdminClaims.cs` (35 lines)

**38 claims** (verified count, :5-33) — identical catalog to the MVC `AdminClaims`:

Dashboard (1) · Users (5) · Roles (5) · Courses (5) · Categories (4) · Applications (3) · Refunds (2) · Notifications (3) · System (2) · Reports (1) · Settings (2) · Students (3) · Support (2).

**Policy semantics**: the API `AdminArea` policy = any one of these claims (Program.cs:42-47).

---

## 3. Audit & Notification Keys

### HistoryMessages — `Common/HistoryMessages.cs` (65 lines)
Localization **keys** (`History_*`) for audit entries: Category, Course, Section, Lecture, Resource, Role, User, Instructor, View (:5-60). The Arabic text lives in resx; controllers pass the key + parameters + an Arabic inline description (verified in admin controllers).

### NotificationMessages — `Common/NotificationMessages.cs` (73 lines)
Localization **keys** (`Notif_*_Title` / `Notif_*_Msg`) for in-app notifications: Enrollment, Course, Rating, Payment/Refund, Lecture Comment (:5-50).

---

## 4. ApiResponse<T> — `Common/APIResponse.cs` (86 lines)

### Envelope

| Member | Notes |
|--------|-------|
| `Success` / `IsSuccess` | dual accessor (`IsSuccess` is `[JsonIgnore]` alias, :13-18) |
| `Message` | client message (:23) |
| `Error` / `Errors` / `ErrorMessages` | single + list + alias (:28-40) |
| `Data` / `Result` | type-safe data + alias (:45-52) |
| `StatusCode` | HTTP status (:57) |

### Factories
- `SuccessResponse(data, message)` (:61-70): OK + data.
- `FailResponse(message, errors)` (:72-80): BadRequest + message/errors.

Used by the API Instructor/Admin controllers that return the unified envelope (e.g. `StudentsController`, `UserController`).

---

## 5. AdminAreaAuthorizationConvention (API) — `Authorization/AdminAreaAuthorizationConvention.cs` (27 lines)

```mermaid
flowchart TD
    A[Controller registered] --> B{Namespace contains .Controllers.Admin? :12}
    B -->|no| C[No change]
    B -->|yes| D{Explicit [Authorize]? :18-19}
    D -->|yes| E[No change — explicit wins]
    D -->|no| F[Add AuthorizeFilter AdminArea :23]
```

- Detection: **namespace** check (`ControllerType.Namespace.Contains(".Controllers.Admin")`, :12) — unlike the MVC convention which checks the `[Area]` attribute.
- Same explicit-auth escape hatch (:18-19) — the reason mixed-auth admin controllers (e.g. UserController `me`) keep user-facing semantics, and the reason admin controllers without any `[Authorize]` GETs stay open (see `API/CourseController.md`).

---

## 6. StripeSettings — `Settings/StripeSettings.cs` (8 lines)

| Property | Purpose |
|----------|---------|
| `SecretKey` | API key (bound from `Stripe:SecretKey`, Program.cs:31, :171) |
| `PublishKey` | publishable key (used by the MVC checkout) |

---

## 7. MappingConfig — `MappingConfig.cs` (327 lines, AutoMapper Profile)

### Verified mappings & findings

| Mapping | Verified behavior |
|---------|-------------------|
| `ApplicationUser → UserDTO` | **`Role` ignored** (:36-37) — the root of the login `Role = null` bug |
| `ApplicationUser → ProfileDTO` | explicit field map; `SocialLinks` ignored (:41-53) |
| `ApplicationUser → UserInfoDTO` | `Role` ignored (:55-56) |
| `Course → CourseDTO` | `Status` via `ToString()`, `CategoryName`, `InstructorName`, `TotalLectures` = Σ section lectures (:73-77) |
| `Enrollment → EnrollmentDto` | `ProgressPercentage` default 0 (:179) |
| `CourseProgress → CourseProgressDto` | `SectionTitle` from `Lecture.Section.Title` (:242-247) — **always null** because the repo includes only `Lecture` (CourseProgressRepository.cs:187) |
| `ContentTypeResolver` | unknown content types default to `Video` (:316-325) |

---

## Cross-Cutting Findings

1. **`SD.PaymentStatus` mixed casing** (`completed` vs `Succeeded`, :55-58) — payment comparisons are case-sensitive string ops.
2. **`Role` ignored in both user mappings** (:36-37, :55-56) — no DTO carries the role from the entity; role is only in JWT claims.
3. **Convention detection differs between apps** — MVC uses `[Area]`, API uses namespace; the escape hatch is identical.
4. **ApiResponse aliases** (`IsSuccess`/`Result`) exist for backward compatibility — new code uses `Success`/`Data`.
5. **Key catalogs are localization keys, not text** — `History_*` / `Notif_*` resolve via resx; the controllers ALSO embed Arabic text inline (duplicated strings).

---

## Configuration

| Key | Purpose |
|-----|---------|
| `Stripe:SecretKey` / `Stripe:PublishKey` | StripeSettings (Program.cs:31, :171) |

---

## Change Log

**Current functionality (verified):** full constants/envelope/convention/mapping reference — SD (incl. payment statuses), 38-claim catalog, audit + notification keys, ApiResponse, namespace convention, StripeSettings, MappingConfig quirks.

**Maintenance notes:** fix payment-status casing; unify role mapping; move inline Arabic text to resources only.