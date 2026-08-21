# Common Reference (EduLab_MVC)

---

## Overview

### Purpose
The shared constants and helpers every MVC controller references: roles/statuses (`SD`), admin claim catalog (`AdminClaims`), the Admin-area auto-protection convention, dropdown data, and localized time-ago text.

### Main Functionality
- `SD` — role names, status vocabularies, protected lists, report taxonomy
- `AdminClaims` — the 38-claim admin catalog
- `AdminAreaAuthorizationConvention` — implicit Admin-area protection
- `LanguageData` / `LevelData` — form dropdowns
- `TimeAgoHelper` — localized relative time

---

## 1. SD — `Common/SD.cs` (102 lines)

### Roles & identity

| Constant | Value | Notes |
|----------|-------|-------|
| Admin / Instructor / InstructorPending / Student / Support | literal names | :5-9 |
| **Moderator** | `"Moderator "` | **trailing space** (:10) — breaks role checks unless the DB role matches exactly |
| EduLabInstructorId | `"edulab-instructor"` | platform instructor account (:11) |
| ProtectedRoles | Admin, Instructor, InstructorPending, Student, Support | **Moderator NOT protected** (:13-16) |

### Status vocabularies

| Domain | Values (verified) |
|--------|-------------------|
| Course | `Draft` / `Pending` / `Approved` / `Rejected` (:36-39) |
| InstructorApplication | `Pending` / `Approved` / `Rejected` (:41-43) |
| Refund | `pending` / `accepted` / `rejected` — **lowercase** (:45-47) |
| Report status | `pending` / `resolved` / `dismissed` — **lowercase** (:49-51) |
| Report type | `Course` / `Comment` / `Review` (:53-55) |
| Report action | `WarnedUser` / `RemovedContent` / `ReviewedNoViolation` (:57-59) |

### Report reasons (code taxonomy)

- 10 reason codes (:61-70): Copyright, Pornographic, Inappropriate, Harassment, HateSpeech, Fraud, MisleadingInfo, Advertising, Spam, Other.
- Per-type arrays (:72-89): `ReportReasonsCourse` (8), `ReportReasonsComment` (6), `ReportReasonsReview` (7).
- `GetReportReasons(type)` switch (:91-100) — unknown type falls back to **course reasons**.

### ProtectedCategories (54 names, :18-34)
All major taxonomy categories — delete/rename blocked in Category admin flows (verified in `CategoryController.md`).

---

## 2. AdminClaims — `Common/AdminClaims.cs` (38 lines)

**38 claims** (verified count, :8-36):

| Group | Claims |
|-------|--------|
| Dashboard | ViewDashboard |
| Users | ViewUsers, EditUser, BlockUser, DeleteUser, CreateUser |
| Roles | ViewRoles, CreateRole, EditRole, DeleteRole, ManageRoleClaims |
| Courses | ViewCourses, CreateCourse, EditCourse, DeleteCourse, ApproveCourses |
| Categories | ViewCategories, CreateCategory, EditCategory, DeleteCategory |
| Applications | ViewInstructorApplications, HandleInstructorApplications, DownloadInstructorCV |
| Refunds | ViewRefunds, ManageRefunds |
| Notifications | ViewNotifications, SendNotifications, DeleteNotification |
| System | ViewSystemHistory, ViewReports |
| Reports | HandleReports |
| Settings | ViewSiteSettings, EditSiteSettings |
| Students | ViewStudents, EditStudent, DeleteStudent |
| Support | ViewSupport, HandleSupport |

**Policy semantics**: the `AdminArea` policy grants access to **any** one of these claims (Program.cs:39-44) — the broad-by-design model documented in the Admin docs.

---

## 3. AdminAreaAuthorizationConvention — `Common/AdminAreaAuthorizationConvention.cs` (28 lines)

```mermaid
flowchart TD
    A[Controller registered] --> B{[Area Admin] attribute? :13}
    B -->|no| C[No change]
    B -->|yes| D{Explicit [Authorize] on class/actions? :19-20}
    D -->|yes| E[No change — explicit wins]
    D -->|no| F[Add AuthorizeFilter AdminArea :24]
```

- Detection: **`[Area("Admin")]` attribute** (:13) — unlike the API convention which checks the namespace (see `API/Common.md`).
- **Explicit `[Authorize]` skips the convention** (:19-20) — this is why Admin-area controllers with per-action auth (e.g. UserController's `me`) keep their own semantics.
- The 12 MVC Admin controllers all declare `[Authorize(Policy="AdminArea")]` explicitly → **the convention is a no-op for them today** (documented in `MVC/Admin/*.md`).

---

## 4. Dropdown Data

### LanguageData — `Common/LanguageData.cs` (38 lines)
- `LanguageEntry { Code, ArabicName, EnglishName }` (:3-8).
- **20 languages** (:14-33): ar, en, fr, es, de, it, pt, ru, zh, ja, ko, tr, nl, pl, vi, id, ms, hi, ur, uk — mirrors the localization culture lists in both Program.cs files.
- `GetAll()` (:36) feeds the language-switcher modal.

### LevelData — `Common/LevelData.cs` (12 lines)
- `Levels` tuples: `beginner`/مبتدئ/Beginner, `intermediate`/متوسط/Intermediate, `advanced`/متقدم/Advanced (:5-10) — the `CourseDraftDTO.Level` default `"beginner"` contract.

---

## 5. TimeAgoHelper — `Common/TimeAgoHelper.cs` (55 lines)

- `GetTimeAgo(DateTime)` (:16-53): localized relative time from `SharedResources` (resx, :13-14), buckets: ≥30d → months, ≥1d → days, ≥1h → hours, ≥1m → minutes, else "Now".
- English fallbacks inline (e.g. `"{0} months ago"`, :26) when the resource key is missing.

---

## Cross-Cutting Findings

1. **`SD.Moderator = "Moderator "`** (trailing space, :10) — documented across the Admin docs; affects `[Authorize(Roles = $"{SD.Admin},{SD.Moderator}")]` checks (API UserController).
2. **Two casing conventions** for statuses: PascalCase (`Pending`) for course/application, **lowercase** (`pending`) for refund/report — string comparisons must match exactly.
3. **ProtectedRoles excludes Moderator** — the role can be deleted/renamed (verified in `RoleController.md`).
4. **The convention's explicit-auth escape hatch** is what keeps mixed-auth Admin controllers working — but also why some Admin GETs end up anonymous (see API `CourseController.md`).

---

## Configuration

| Key | Purpose |
|-----|---------|
| (none — compile-time constants) | — |

---

## Change Log

**Current functionality (verified):** full constants/helpers reference — roles, statuses, 38-claim catalog, report taxonomy, convention semantics, dropdown data, time-ago.

**Maintenance notes:** fix the Moderator trailing space; align status casing.