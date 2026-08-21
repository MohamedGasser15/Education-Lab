# EduLab Documentation — Modules

Per-controller, source-verified documentation for both applications. Every claim in these files was verified against the actual source code with `file.cs:line` citations — no assumptions, no pattern-guessing.

---

## Structure

```
Modules/
├── MVC/                     EduLab_MVC (ASP.NET Core MVC frontend)
│   ├── Learner/             18 controllers — Areas/Learner/Controllers/
│   ├── Instructor/          8 controllers  — Areas/Instructor/Controllers/
│   ├── Admin/               12 controllers  — Areas/Admin/Controllers/
│   ├── Middlewares.md       the 4 custom middlewares (JWT cookie, guest id, token refresh, maintenance)
│   ├── Services.md          26 services — full MVC→API endpoint map with file:line
│   ├── Common.md            SD constants, 38-claim catalog, admin convention, dropdowns, time-ago
│   └── Program.md           startup & configuration (pipeline, auth, localization, routes)
├── API/                     EduLab_API (REST backend)
│   ├── Learner/             18 controllers — Controllers/Learner/ (public + customer)
│   ├── Instructor/          5 controllers  — Controllers/Instructor/
│   ├── Admin/               11 controllers  — Controllers/Admin/
│   ├── SupportHub.md        SignalR support hub (groups + broadcast helpers + JoinConversation IDOR)
│   ├── DomainEntities.md    full entity reference — 28 entities, 6 enums, claim/support classes
│   ├── Repositories.md      persistence layer — generic base + 19 repositories + DbInitializer
│   ├── ApplicationServices.md  35 business-logic services — auth, payment, certificates, emails
│   ├── Common.md            SD (incl. payment statuses), ApiResponse, namespace convention, MappingConfig
│   └── Program.md           startup & configuration (JWT, OAuth, Stripe, CORS, seeding, Scalar)
└── Tests.md                 EduLab.Tests — 634 test cases, coverage map, fakes
```

**Total: 83 module files.**

---

## MVC — Learner (18)

| Controller | File | Highlights |
|---|---|---|
| AuthController | `MVC/Learner/AuthController.md` | Login/register, external logins |
| HomeController | `MVC/Learner/HomeController.md` | Landing, contact, about (orphan view) |
| CourseController | `MVC/Learner/CourseController.md` | Catalog, details, player |
| CartController | `MVC/Learner/CartController.md` | Guest + user cart |
| WishlistController | `MVC/Learner/WishlistController.md` | Wishlist CRUD |
| MyLearningController | `MVC/Learner/MyLearningController.md` | Enrolled courses |
| NotificationsController | `MVC/Learner/NotificationsController.md` | Inbox, toast stub |
| ProfileController | `MVC/Learner/ProfileController.md` | Profile, instructor profile |
| SettingsController | `MVC/Learner/SettingsController.md` | Tabs, sessions, 2FA |
| PaymentController | `MVC/Learner/PaymentController.md` | Stripe checkout (**missing views**) |
| RatingController | `MVC/Learner/RatingController.md` | Ratings AJAX |
| CommentsController | `MVC/Learner/CommentsController.md` | Lecture comments |
| ReportsController | `MVC/Learner/ReportsController.md` | Report modal |
| SupportController | `MVC/Learner/SupportController.md` | Chat widget |
| CertificatesController | `MVC/Learner/CertificatesController.md` | Public verification |
| InstructorApplicationController | `MVC/Learner/InstructorApplicationController.md` | Apply flow |
| InstructorsController | `MVC/Learner/InstructorsController.md` | Directory (dead actions) |
| ErrorController | `MVC/Learner/ErrorController.md` | Status pages, maintenance |

## MVC — Instructor (8)

| Controller | File |
|---|---|
| DashboardController | `MVC/Instructor/DashboardController.md` |
| CourseController | `MVC/Instructor/CourseController.md` |
| StudentsController | `MVC/Instructor/StudentsController.md` |
| QuestionsController | `MVC/Instructor/QuestionsController.md` |
| ReviewsController | `MVC/Instructor/ReviewsController.md` |
| RevenueController | `MVC/Instructor/RevenueController.md` |
| HistoryController | `MVC/Instructor/HistoryController.md` |
| ReportsController | `MVC/Instructor/ReportsController.md` |

## MVC — Admin (12)

| Controller | File |
|---|---|
| DashboardController | `MVC/Admin/DashboardController.md` |
| UserController | `MVC/Admin/UserController.md` |
| RoleController | `MVC/Admin/RoleController.md` (missing views) |
| CategoryController | `MVC/Admin/CategoryController.md` |
| CourseController | `MVC/Admin/CourseController.md` |
| InstructorApplicationsController | `MVC/Admin/InstructorApplicationsController.md` |
| NotificationController | `MVC/Admin/NotificationController.md` |
| RefundsController | `MVC/Admin/RefundsController.md` |
| ReportsController | `MVC/Admin/ReportsController.md` |
| SettingsController | `MVC/Admin/SettingsController.md` |
| SupportController | `MVC/Admin/SupportController.md` |
| HistoryController | `MVC/Admin/HistoryController.md` |

---

## API — Learner (18)

| Controller | File | Highlights |
|---|---|---|
| AuthController | `API/Learner/AuthController.md` | JWT + OTP + OAuth |
| CartController | `API/Learner/CartController.md` | IDOR delete |
| CertificatesController | `API/Learner/CertificatesController.md` | PNG vs PDF doc |
| CourseProgressController | `API/Learner/CourseProgressController.md` | **certificate fraud path** |
| EnrollmentController | `API/Learner/EnrollmentController.md` | **payment bypass** |
| InstructorApplicationController | `API/Learner/InstructorApplicationController.md` | upload traversal risk |
| InstructorController | `API/Learner/InstructorController.md` | top-rated unsorted |
| LearnerCourseController | `API/Learner/LearnerCourseController.md` | 404-by-default bug |
| LectureCommentsController | `API/Learner/LectureCommentsController.md` | ungated replies |
| NotificationsController | `API/Learner/NotificationsController.md` | never-404 |
| PaymentController | `API/Learner/PaymentController.md` | **broken checkout flow, client price** |
| ProfileController | `API/Learner/ProfileController.md` | **public PII leak** |
| PublicController | `API/Learner/PublicController.md` | inflated stats |
| RatingsController | `API/Learner/RatingsController.md` | in-memory pagination |
| ReportsController | `API/Learner/ReportsController.md` | dedupe guards |
| SettingsController | `API/Learner/SettingsController.md` | **revoke-all self-lockout** |
| SupportController | `API/Learner/SupportController.md` | hub IDOR |
| WishlistController | `API/Learner/WishlistController.md` | N+1 |

## API — Instructor (5)

| Controller | File |
|---|---|
| DashboardController | `API/Instructor/DashboardController.md` |
| InstructorCourseController | `API/Instructor/InstructorCourseController.md` (**create IDOR**) |
| InstructorCommentsController | `API/Instructor/InstructorCommentsController.md` |
| InstructorRatingsController | `API/Instructor/InstructorRatingsController.md` |
| StudentsController | `API/Instructor/StudentsController.md` (**IDOR cluster**) |

## API — Admin (11)

| Controller | File |
|---|---|
| DashboardController | `API/Admin/DashboardController.md` |
| CategoryController | `API/Admin/CategoryController.md` (anonymous GETs) |
| CourseController | `API/Admin/CourseController.md` (**anonymous writes**) |
| HistoryController | `API/Admin/HistoryController.md` (**anonymous audit leak**) |
| InstructorApplicationsController | `API/Admin/InstructorApplicationsController.md` |
| RefundController | `API/Admin/RefundController.md` |
| ReportsController | `API/Admin/ReportsController.md` (reference claim-gating) |
| RoleController | `API/Admin/RoleController.md` (**self-escalation**) |
| SiteSettingsController | `API/Admin/SiteSettingsController.md` |
| SupportController | `API/Admin/SupportController.md` |
| UserController | `API/Admin/UserController.md` (cross-user read) |

## Infrastructure (8)

| File | Scope |
|---|---|
| `MVC/Middlewares.md` | JwtCookie, GuestId, TokenRefresh, MaintenanceMode — order, fail-open behavior, logout hygiene |
| `MVC/Services.md` | 26 MVC services — verified MVC→API endpoint map per service, URL-stripping + token-log findings |
| `MVC/Common.md` | SD constants (Moderator trailing space, status casing), 38-claim catalog, convention, dropdowns, time-ago |
| `MVC/Program.md` | MVC startup: 26 scoped services, cookie auth + 401/403, 20 cultures (default ar), routes |
| `API/Program.md` | API startup: JWT validation, OAuth, Stripe, CORS, DbInitializer seeding, Scalar docs |
| `API/SupportHub.md` | SignalR groups (`user-{id}` / `agents` / `conv-{id}`) + static broadcast helpers + **JoinConversation IDOR** |
| `API/DomainEntities.md` | 28 entities + 6 enums + claims catalog — fields, defaults, computed props, ER map |
| `API/Repositories.md` | Generic `Repository<T>` + 19 repositories — queries, transactions, **Take(0) bug**, deferred report save |
| `API/ApplicationServices.md` | 35 business-logic services — certificate fraud, payment bypass, OTP weakness, email layer |
| `API/Common.md` | SD (payment statuses), ApiResponse envelope, namespace convention, StripeSettings, MappingConfig quirks |
| `Tests.md` | 634 test cases (623 Fact + 11 Theory) — coverage map, xUnit+Moq+EF InMemory, fakes |

---

## Cross-Cutting Findings (verified)

**Critical security**
1. `API/Admin/CourseController.md` — two anonymous WRITE endpoints (add/delete lecture resources).
2. `API/Learner/CourseProgressController.md` — certificate fraud: arbitrary lecture marking → ≥100% → auto-issue.
3. `API/Learner/EnrollmentController.md` + `API/Learner/PaymentController.md` — enrollment without payment; client-controlled price.
4. `API/Admin/RoleController.md` — any-claim holders can edit role claims (self-escalation); AdminArea policy is any-single-claim (Program.cs:42-47).
5. `API/Instructor/StudentsController.md` — all-users list + any-user details + unvalidated bulk messages.
6. `API/Learner/ProfileController.md` — public instructor endpoint leaks email/phone.
7. `API/Admin/HistoryController.md` — anonymous per-user audit history.
8. `API/Learner/SupportController.md` + `API/Admin/SupportController.md` — SignalR `JoinConversation` has no ownership check.
9. `API/Learner/SettingsController.md` — revoke-all revokes the caller's own session.
10. `API/Instructor/InstructorCourseController.md` — create-draft trusts body `InstructorId`.

**Recurring defects**
- Anti-forgery gaps: most MVC POSTs lack `[ValidateAntiForgeryToken]` (Learner areas especially).
- `SD.Moderator = "Moderator "` trailing space (SD.cs:16) breaks role checks.
- `AdminArea` policy is any-claim; granular claims only enforced in API Admin Reports/Support.
- `AdminAreaAuthorizationConvention` no-ops on controllers mixing authorized/unauthorized actions → anonymous endpoints.
- 499 status codes for client cancellations; `ex.Message` leaked in 500s.
- Hardcoded seeded passwords (`Admin@123`) + committed secrets in `appsettings.json`.

**Dead code**
- MVC: `CourseRatings` (no view), Instructors `Details`/`Top` (no views), Role `Details`/`Claims`/`UsersInRole` (no views), Payment `Success`/`Cancel`/`PaymentResult` (no views), Curriculum reorder actions missing, `SaveCurrentLecture`, `UnreadCount` endpoint unused, dead export buttons.
- API: `IsNewUser` external-login flag always false (dead confirmation flow), `PaymentMethodId`/`SavePaymentMethod` dead fields, `SendBulkMessage` email stubbed, `PaymentClaimList` ignored, `WatchedDuration`/`TotalDuration` unused.

---

## Naming Conventions

- One Markdown file per controller, named `<ControllerName>.md`.
- Files live in area subfolders (`Learner/`, `Instructor/`, `Admin/`) because the same controller names exist in multiple areas (e.g. `CourseController` exists 3× in MVC, 2× in API).
- Each file follows the same template: Overview → Architecture → Folder Structure → Database Design → Workflows (mermaid) → Data Flow → Endpoints → Frontend Integration → Business Rules → Security Analysis → Hidden Behaviors → Configuration → Change Log.