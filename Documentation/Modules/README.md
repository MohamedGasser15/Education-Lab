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
│   ├── Learner/             19 controllers — Controllers/Learner/ (public + customer)
│   ├── Instructor/          5 controllers  — Controllers/Instructor/
│   ├── Admin/               11 controllers  — Controllers/Admin/
│   ├── SupportHub.md        SignalR support hub (groups + broadcast helpers + JoinConversation IDOR)
│   ├── DomainEntities.md    full entity reference — 29 entities, 6 enums, claim/support classes
│   ├── Repositories.md      persistence layer — generic base + 19 repositories + DbInitializer
│   ├── ApplicationServices.md  37 business-logic services — auth, payment, certificates, emails, push, legal
├── Mobile/                  apps/mobile (Flutter cross-platform client) — 45 files
│   ├── Architecture.md      State management (Provider), GetIt, Tajawal/Inter fonts, LTR/RTL
│   ├── CoreServices.md      Dio ApiClient, AuthStorage, FCM push, SignalR SupportHub, Stripe
│   ├── Models.md            21 data models catalog — JSON serialization, defensive types, computeds
│   ├── Providers.md         12 state management providers — properties, methods, streams, optimistic rollbacks
│   ├── Repositories.md      15 repositories — endpoint maps, parameters, caching, conversions
│   ├── Widgets.md           Design system — buttons, skeletons, shimmers, cards, chat bubbles
│   ├── Localization.md      20 languages — ARB files, Tajawal/Inter typography, LTR/RTL mirroring
│   ├── Navigation.md        28 named routes, argument contracts, floating bottom navigation bar
│   ├── Features/            9 feature engineering specs (Auth, Home, Catalog, Courses, Learning, Cart, Inbox, Profile, Legal)
│   └── Screens/             28 screens documented across 22 dedicated screen deep-dive specs
└── Tests.md                 EduLab.Tests — 634 test cases, coverage map, fakes
```

**Total: 126 module files.**

---

## MVC — Learner (18)

| Controller | File | Highlights |
|---|---|---|
| AuthController | `MVC/Learner/AuthController.md` | Login/register, external logins |
| HomeController | `MVC/Learner/HomeController.md` | Landing, about, contact, blog, roadmap |
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

## API — Learner (19)

| Controller | File | Highlights |
|---|---|---|
| AuthController | `API/Learner/AuthController.md` | JWT + OTP + OAuth + Google Mobile |
| CartController | `API/Learner/CartController.md` | IDOR delete |
| CertificatesController | `API/Learner/CertificatesController.md` | PNG vs PDF doc |
| CourseProgressController | `API/Learner/CourseProgressController.md` | **certificate fraud path** |
| EnrollmentController | `API/Learner/EnrollmentController.md` | **payment bypass** |
| InstructorApplicationController | `API/Learner/InstructorApplicationController.md` | upload traversal risk |
| InstructorController | `API/Learner/InstructorController.md` | top-rated unsorted |
| LearnerCourseController | `API/Learner/LearnerCourseController.md` | 404-by-default bug, featured/new/recommended |
| LectureCommentsController | `API/Learner/LectureCommentsController.md` | ungated replies |
| LegalController | `API/Learner/LegalController.md` | About Us, Terms, Privacy Policy (20 languages) |
| NotificationsController | `API/Learner/NotificationsController.md` | FCM push + study reminders |
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

## Mobile — Flutter Application (45)

### Core Architecture & System Guides (8)

| Module | File | Highlights |
|---|---|---|
| Architecture | `Mobile/Architecture.md` | Feature-first clean architecture, Provider, GetIt, AppTheme, Tajawal/Inter fonts, declarative routes |
| Core Services | `Mobile/CoreServices.md` | Dio ApiClient, Bearer interceptor, FCM push, SignalR support hub, Stripe service, Google OAuth |
| Data Models | `Mobile/Models.md` | 21 domain models, defensive type casting, dual casing resolution, computed properties |
| State Providers | `Mobile/Providers.md` | 12 ChangeNotifiers — variables, actions, optimistic mutations, error rollback, notifyListeners |
| Repositories | `Mobile/Repositories.md` | 15 data access repositories — endpoint mappings, parameter serializing, memory/prefs cache |
| Design System | `Mobile/Widgets.md` | AppButton, AppShimmer, AppSkeleton, AppNetworkImage, AppEmptyState, HomeCourseCard |
| Localization | `Mobile/Localization.md` | 20 global languages (ARB catalog), dynamic font switching (Tajawal/Inter), RTL/LTR layout mirroring |
| Navigation | `Mobile/Navigation.md` | 28 named routes, parameter contracts, Cupertino transitions, floating bottom navigation bar |

### Feature Engineering Specs (9)

| Feature | File | Highlights |
|---|---|---|
| Auth Feature | `Mobile/Features/Auth.md` | Login, 2-step OTP register, Google Mobile OAuth (IdToken), token persistence |
| Home Feature | `Mobile/Features/Home.md` | Feed dashboard, promo slider, category chips, 7 parallel Future.wait requests, top instructors |
| Catalog Feature | `Mobile/Features/Catalog.md` | Explore courses, debounced search, category filters, recent queries, 2-tier caching |
| Courses Feature | `Mobile/Features/Courses.md` | Course details, video player (video_player), certificates, syllabus, assignments, schedule |
| Learning Feature | `Mobile/Features/Learning.md` | Enrolled courses (ongoing/completed), lecture completion sync, Q&A comments, auto-certificates |
| Cart & Wishlist | `Mobile/Features/CartAndWishlist.md` | Cart items, coupon discounts, wishlist sync, Luhn check, Stripe checkout, SoundService |
| Inbox & Support | `Mobile/Features/InboxAndSupport.md` | Notifications inbox, real-time SignalR support chat client with room subscriptions |
| Profile & Settings | `Mobile/Features/ProfileAndSettings.md` | User profile, avatar upload, password change, 2FA setup, active sessions, teach application |
| Legal & Onboarding | `Mobile/Features/LegalAndOnboarding.md` | Splash startup check, onboarding carousel, localized legal tabs (About/Terms/Privacy) |

### Screen Deep-Dive Directory (28 Screens across 22 Specs)

| Screen | File | Lines / Highlights |
|---|---|---|
| `CourseDetailsScreen` | `Mobile/Screens/CourseDetailsScreen.md` | 3,008 lines — Hero preview, 4 tabs, syllabus accordion, video trailer modal |
| `LessonPlayerScreen` | `Mobile/Screens/LessonPlayerScreen.md` | 3,659 lines — video_player, double tap 10s skip, speed controls, playlist drawer, Q&A thread |
| `CheckoutScreen` | `Mobile/Screens/CheckoutScreen.md` | 3,283 lines — Luhn check, Arabic digits conversion, Stripe PaymentIntent, SoundService |
| `LearningScreen` | `Mobile/Screens/LearningScreen.md` | 2,481 lines — My Courses, Wishlist, Certificates portals, filtering & sorting |
| `AccountSecurityScreen` | `Mobile/Screens/AccountSecurityScreen.md` | 1,200 lines — Password update, 2FA TOTP QR setup & recovery codes, remote session revocation |
| `LoginScreen` | `Mobile/Screens/LoginScreen.md` | 1,391 lines — Animated gradient background, 2-step OTP flow, Google Mobile OAuth, guest mode |
| `HomeScreen` | `Mobile/Screens/HomeScreen.md` | CustomScrollView with slivers, multi-provider pull-to-refresh |
| `ExploreScreen` | `Mobile/Screens/ExploreScreen.md` | Dual-mode UI (idle category grid vs active search with filter chips) |
| `CartScreen` | `Mobile/Screens/CartScreen.md` | 1,393 lines — Cart item list, coupon discount formulas, clear cart modal |
| `WishlistScreen` | `Mobile/Screens/WishlistScreen.md` | Optimistic un-bookmarking, one-tap move to cart |
| `SupportChatScreen` | `Mobile/Screens/SupportChatScreen.md` | SignalR live chat, room join/leave, optimistic message bubbles |
| `NotificationsScreen` | `Mobile/Screens/NotificationsScreen.md` | FCM inbox alerts, swipe-to-delete, mark-all-as-read |
| `MessagesScreen` | `Mobile/Screens/MessagesScreen.md` | Support ticket threads directory, new conversation modal |
| `ProfileScreen` | `Mobile/Screens/ProfileScreen.md` | Account settings hub, UserProfileHeader, session logout confirmation |
| `EditProfileScreen` | `Mobile/Screens/EditProfileScreen.md` | ImagePicker avatar multipart upload, sanitized social links |
| `TeachApplicationScreen`| `Mobile/Screens/TeachApplicationScreen.md` | Instructor onboarding application, PDF CV upload |
| `CertificateViewScreen`| `Mobile/Screens/CertificateViewScreen.md` | Digital diploma canvas, PDF download, public verification |
| `MyCertificatesScreen` | `Mobile/Screens/MyCertificatesScreen.md` | Student credentials and trophy gallery |
| `AssignmentsScreen` | `Mobile/Screens/AssignmentsScreen.md` | Practical assignments, submission file uploads, instructor grading |
| `ScheduleScreen` | `Mobile/Screens/ScheduleScreen.md` | Calendar study agenda, lesson timeline, local reminders |
| `InstructorsScreen` | `Mobile/Screens/InstructorsScreen.md` | Faculty directory with keyword search filter |
| `InstructorProfileScreen`| `Mobile/Screens/InstructorProfileScreen.md`| Public faculty credentials, biography, and published course list |
| `PurchaseHistoryScreen`| `Mobile/Screens/PurchaseHistoryScreen.md`| Transaction records, payment dates, invoice PDF receipts |
| `SettingsScreen` | `Mobile/Screens/SettingsScreen.md` | Theme selection (light/dark/system), language selection (ar/en) |
| `SplashScreen` | `Mobile/Screens/SplashScreen.md` | 2,000ms staggered animation, session check routing decision matrix |
| `OnboardingScreen` | `Mobile/Screens/OnboardingScreen.md` | 3-slide value proposition carousel, auto-advancing timer |
| `LegalContentScreen` | `Mobile/Screens/LegalContentScreen.md` | Localized About Us, Privacy Policy, Terms of Service tabs, offline fallbacks |
| `MainNavigationScreen` | `Mobile/Screens/MainNavigationScreen.md` | Floating bottom navigation bar, deep programmatic tab switching |

## Infrastructure (8)

| File | Scope |
|---|---|
| `MVC/Middlewares.md` | JwtCookie, GuestId, TokenRefresh, MaintenanceMode — order, fail-open behavior, logout hygiene |
| `MVC/Services.md` | 26 MVC services — verified MVC→API endpoint map per service, URL-stripping + token-log findings |
| `MVC/Common.md` | SD constants (Moderator trailing space, status casing), 38-claim catalog, convention, dropdowns, time-ago |
| `MVC/Program.md` | MVC startup: 26 scoped services, cookie auth + 401/403, 20 cultures (default ar), routes |
| `API/Program.md` | API startup: JWT validation, OAuth, Stripe, CORS, DbInitializer seeding, Scalar docs |
| `API/SupportHub.md` | SignalR groups (`user-{id}` / `agents` / `conv-{id}`) + static broadcast helpers + **JoinConversation IDOR** |
| `API/DomainEntities.md` | 29 entities + 6 enums + claims catalog — fields, defaults, computed props, ER map |
| `API/Repositories.md` | Generic `Repository<T>` + 19 repositories — queries, transactions, **Take(0) bug**, deferred report save |
| `API/ApplicationServices.md` | 37 business-logic services — certificate fraud, payment bypass, OTP weakness, email layer, push, legal |
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