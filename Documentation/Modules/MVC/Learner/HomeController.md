# HomeController Module Documentation (MVC)

---

## Overview

### Purpose
Serve the public landing experience: the personalized home page, static informational pages (About, FAQ, Help, Contact, Privacy, Terms), the blog feed, the learning roadmap, and the language switcher.

### Business Objective
Convert visitors into learners: show featured/new courses and top instructors immediately, surface the visitor's own in-progress enrollments when logged in, and keep the site localized and easily navigable.

### Main Functionality
- Personalized landing (enrollments + progress for logged-in users, site stats)
- Blog list + details (static in-code data)
- Static pages: About, FAQ, Help, Contact, Privacy, Terms
- Roadmap page (learning path)
- Language switching with API-side preference sync

### Primary User Roles

| Role | Description |
|------|-------------|
| Anonymous | Public sections only |
| Student / Instructor / Admin | Landing additionally shows "continue learning" enrollments (cookie check) |

---

## Module Architecture

```
Presentation           Views/Home/*.cshtml (Index ~1126 lines, blog, blogDetails,
                       faq, contact, Privacy, terms, help, Roadmap, about)
Application            IEnrollmentService, ICourseProgressService, ICourseService,
                       IAuthorizedHttpClientService, IDashboardService
External               EduLab API: GET Enrollment (`ApiEndpoints.Enrollment.Base`),
                       GET LearnerCourse/recommended (`ApiEndpoints.LearnerCourse.Recommended`),
                       GET public/stats (`ApiEndpoints.Public.Stats`),
                       PUT User/preferred-language (`ApiEndpoints.User.PreferredLanguage`)
State                  Read-only: AuthToken cookie (identity check)
```

### Controllers

| Controller | Responsibility |
|-----------|----------------|
| `HomeController` (759 lines) | Landing + static pages + `SetLanguage` |

### Services

| Service | Responsibility |
|---------|----------------|
| `IEnrollmentService` | `GetUserEnrollmentsAsync` -> GET `Enrollment` (`ApiEndpoints.Enrollment.Base`) with preloaded `ProgressPercentage` |
| `ICourseService` | `GetRecommendedCoursesAsync(12)` -> GET `LearnerCourse/recommended?count=12` (10-min `IMemoryCache`) |
| `IDashboardService` | `GetPublicStatsAsync` -> GET `public/stats` (`Services/DashboardService.cs:166`) |
| `IAuthorizedHttpClientService` | PUT `User/preferred-language` for culture sync |
| `ICourseProgressService` | Injected constructor dependency (`HomeController.cs:35`); no longer called in `Index` because `EnrollmentDto.ProgressPercentage` is preloaded |

### Dependencies on Other Modules
- **View Components**: `CategoriesDropdown`, `FeaturedCourses` (8), `TopInstructors` (4), `NewCourses` (8) drive the landing content.
- **MyLearning**: enrollment cards link to the learner dashboard.
- **EduLab API** (hard dependency).

---

## Folder Structure

```
Areas/Learner/Controllers/
+-- HomeController.cs                  # 759 lines

Areas/Learner/Views/Home/
+-- Index.cshtml                       # Landing (hero, categories, courses, stats)
+-- blog.cshtml / blogDetails.cshtml   # Static blog feed + article
+-- faq.cshtml / contact.cshtml / help.cshtml
+-- Privacy.cshtml / terms.cshtml
+-- Roadmap.cshtml                     # Learning path
+-- about.cshtml                       # About page (served by about action :133)

Models/ViewModels/
+-- BlogListViewModel.cs / Blog.cs
+-- RoadmapViewModel.cs (+ RoadmapStep)
```

---

## Database Design

None. `AllBlogs` is a static in-code list; no persistence touched. Culture preference is persisted to the API (`PUT User/preferred-language`) when an authenticated user switches language.

---

## Internal Workflows & Runtime Behavior

### Workflow 1: Landing Page (Index)

#### Purpose
Render a personalized, conversion-oriented landing page with parallel data fetching and zero N+1 progress round-trips.

#### Flow Diagram

```mermaid
flowchart TD
    A[GET Learner/Home/Index :41] --> B{AuthToken cookie? :45}
    B -->|yes| C[Task.WhenAll :47-55<br/>1. GetUserEnrollmentsAsync<br/>2. GetRecommendedCoursesAsync 12<br/>3. GetPublicStatsAsync]
    C --> D[Take 6 enrollments + default images :60-68]
    D --> E[Read preloaded e.ProgressPercentage<br/>into ViewBag.CourseProgress dict :70-73]
    E --> F[Set ViewBag.TotalEnrollmentsCount,<br/>RecommendedCourses, SiteStats :56-77]
    B -->|no| G[GetPublicStatsAsync :85<br/>into ViewBag.SiteStats]
    F --> I[Render Index.cshtml]
    G --> I
    I --> J[Components: CategoriesDropdown,<br/>FeaturedCourses 8, TopInstructors 4, NewCourses 8]
```

#### Runtime Behavior
- Authenticated check is a raw cookie read (`Request.Cookies["AuthToken"]`), not the claims principal (`HomeController.cs:45`).
- **Parallel API Execution**: When authenticated, `GetUserEnrollmentsAsync()`, `GetRecommendedCoursesAsync(12)`, and `GetPublicStatsAsync()` are dispatched concurrently via `Task.WhenAll(enrollmentsTask, recommendedTask, statsTask)` (`HomeController.cs:47-55`).
- **N+1 Progress Elimination**: Instead of issuing per-enrollment `GetCourseProgressAsync` HTTP calls, `Index` reads the preloaded `e.ProgressPercentage` property directly from each `EnrollmentDto` (`HomeController.cs:70-73`).
- Thumbnail/avatar fallbacks: `/images/default-course.jpg`, `/images/default-instructor.jpg` (`HomeController.cs:62-67`).
- Anonymous visitors execute only `_dashboardService.GetPublicStatsAsync()` (`HomeController.cs:82-86`).
- Any exception -> `View()` without TempData (silent degradation, `HomeController.cs:95-99`).

#### Side Effects
None (read-only).

#### Edge Cases
- `Index.cshtml` declares `@model List<CourseDTO>` but the action returns no model — the view only uses it defensively; all content comes from components/ViewBag.
- API failure anywhere -> empty fallback rendering, no user-visible error.

### Workflow 2: Language Switching (SetLanguage)

#### Purpose
Persist UI culture and keep the API user profile in sync.

#### Flow
1. Write `.AspNetCore.Culture` cookie (1 year, essential) via `CookieRequestCultureProvider`.
2. If `AuthToken` cookie exists -> PUT `User/preferred-language` with `{preferredLanguage = culture}` through `AuthorizedHttpClientService`.
3. Failures are caught + warning-logged (API sync must never break the redirect).
4. `LocalRedirect(returnUrl)` (open-redirect safe).

#### Runtime Behavior
Culture applies immediately to the next request; API preference survives new browsers.

### Workflow 3: Blog & Static Pages

- `blog(page=1, category=null)`: pageSize 6 over the static `AllBlogs` list -> `BlogListViewModel`.
- `blogDetails(id)`: single article.
- `about` (`HomeController.cs:133`): loads `ViewBag.SiteStats = await _dashboardService.GetPublicStatsAsync()` and renders `about.cshtml`.
- Static views (FAQ/Help/Contact/Privacy/Terms) render without data loading.

---

## Data Flow Analysis

```mermaid
flowchart LR
    A[Request] --> B[HomeController.Index]
    B --> C[Task.WhenAll<br/>Enrollment / Recommended / PublicStats]
    C --> D[Preloaded e.ProgressPercentage + ViewBag collections]
    D --> F[View renders + View Components<br/>read 10-15m IMemoryCache]
```

#### Mapping & Transformations
- Preloaded `e.ProgressPercentage` rounded (`Math.Round(e.ProgressPercentage, 0)`) into a `Dictionary<int, decimal>` keyed by `CourseId` (`ViewBag.CourseProgress`, `HomeController.cs:70-73`).
- Enrollment DTOs normalized with default images before display (`HomeController.cs:62-67`).

---

## Controllers & Endpoints

### HomeController

**Route**: `/Learner/Home` (area convention; also the app default route)  
**Authorization**: `[AllowAnonymous]`  
**Dependencies**: `ILogger`, `IEnrollmentService`, `ICourseProgressService`, `IAuthorizedHttpClientService`, `IDashboardService`, `ICourseService`

| Action | HTTP | Route | Description |
|--------|------|-------|-------------|
| Index | GET | `/Learner/Home/Index` | Personalized landing (parallel `Task.WhenAll` :47-55) |
| about | GET | `/Learner/Home/about` | About EduLab page (loads public site stats) (:133) |
| blog | GET | `/Learner/Home/blog?page&category` | Paginated static blog (6/page) |
| blogDetails | GET | `/Learner/Home/blogDetails/{id}` | Article page |
| faq | GET | `/Learner/Home/faq` | FAQ page |
| contact | GET | `/Learner/Home/contact` | Contact page |
| Privacy | GET | `/Learner/Home/Privacy` | Privacy policy |
| terms | GET | `/Learner/Home/terms` | Terms page |
| help | GET | `/Learner/Home/help` | Help center |
| Roadmap | GET | `/Learner/Home/Roadmap/{id?}` | Learning roadmap |
| SetLanguage | POST | `/Learner/Home/SetLanguage?culture&returnUrl` | Culture switch + API sync |

---

## Frontend Integration

### Landing page (Index.cshtml, ~1126 lines)
- Hero with Swiper, topic pills, category blocks (top 10 per category), grid-mode course swipers.
- View components invoked inline: `CategoriesDropdown` (type=Home), `FeaturedCourses` (count=8), `TopInstructors` (count=4), `NewCourses` (count=8).
- Search box navigates to `Course/Search?search=`.
- `window.formatDuration` helper defined for duration display (Index.cshtml:578-587).

### Site-wide JS (`wwwroot/js/site.js`, loaded by Learner layout)
- Dark mode from `localStorage.theme` (system-pref default).
- Hero swiper (fade, 5s autoplay), FAQ accordions, course swipers.
- Global alert system `showAlert(type, message, duration)` renders TempData-driven alerts.

---

## Business Rules

| Rule | Verified in | Why it exists |
|------|-------------|---------------|
| Enrollment & recommended fetch only for cookie-authenticated users | HomeController.cs:45-81 | Personalized content without hitting authenticated endpoints anonymously |
| Parallel landing page fan-out + preloaded progress | HomeController.cs:47-55, 70-73 | Eliminates sequential latency and N+1 progress calls |
| Default images when media missing | HomeController.cs:62-67 | Consistent cards for courses without thumbnails |
| Landing degrades silently on API failure | HomeController.cs:95-99 | The public page must never 500 because stats are down |
| Language sync must never break redirect | SetLanguage try/catch | Switching language is UX-critical; API sync is best-effort |
| Local redirects only | `LocalRedirect(returnUrl)` | Open-redirect protection |

---

## Security Analysis

| Control | Status |
|---------|--------|
| Authentication | `[AllowAnonymous]` — public by design |
| Identity check | Raw `AuthToken` cookie presence (not a validated principal) — display-only decision |
| Open redirect | `LocalRedirect` prevents external redirect targets |
| API calls | Anonymous endpoints (`public/stats`, `LearnerCourse/recommended`); protected calls (`Enrollment`) rely on `AuthorizedHttpClientService` attaching the Bearer token from the cookie |
| Culture sync | PUT `User/preferred-language` requires the valid token; failure logged, never surfaces |

---

## Module Dependencies

```mermaid
flowchart LR
    A[HomeController] --> E[IEnrollmentService]
    A --> C[ICourseService]
    A --> D[IDashboardService]
    A --> H[IAuthorizedHttpClientService]
    E -->|GET Enrollment| API[EduLab API]
    C -->|GET LearnerCourse/recommended| API
    D -->|GET public/stats| API
    H -->|PUT User/preferred-language| API
    A --> VC[View Components<br/>CategoriesDropdown / FeaturedCourses /<br/>TopInstructors / NewCourses]
    VC --> API
```

**Internal**: View components (backed by 10–15 min `IMemoryCache` in MVC services), `_CourseCard` shared partial, `_ToastMessages`, `_Layout` nav.
**External**: EduLab API only.

---

## Hidden Behaviors & Technical Notes

1. **Model mismatch**: `Index.cshtml` declares `List<CourseDTO>` but `Index` returns no model; the landing depends entirely on ViewBag + components.
2. **Cookie-not-claims identity check**: Home decides personalization by raw cookie presence; a stale cookie (expired token) still triggers the personalized block, which then fails silently and renders the public layout anyway.
3. **Blog is hardcoded**: `AllBlogs` is static in-code content — editing blog posts requires a code change.
4. **ViewBag-driven components**: New/Featured/TopInstructors counts are fixed (8/8/4) at the view call site and served from MVC `IMemoryCache`.

---

## Configuration

| Key | Purpose |
|-----|---------|
| `EduLab:ApiBaseUrl` | API base for all service calls |
| Culture cookie | `.AspNetCore.Culture` (1-year, essential) |

No feature flags or environment variables specific to this module.

---

## Change Log

**Current functionality (verified):** personalized landing with parallel `Task.WhenAll` (`GetUserEnrollmentsAsync`, `GetRecommendedCoursesAsync(12)`, `GetPublicStatsAsync`) and zero N+1 progress calls via preloaded `e.ProgressPercentage`, static pages (`about` action at `:133` with `GetPublicStatsAsync`), static blog, roadmap, language switching with API-side preference persistence.

**Maintenance notes:**
- Blog content is code-static; consider a CMS/data source if posts change often.