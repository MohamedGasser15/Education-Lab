# LearnerCourseController Module Documentation (API)

---

## Overview

### Purpose
Public course browsing: approved courses by categories, by instructor, by category.

### Business Objective
Serve the course catalog to anonymous visitors (home page, category pages, instructor profiles).

### Main Functionality
- Courses by categories (per-category cap)
- Courses by instructor
- Courses by category

### Primary User Roles

| Role | Description |
|------|-------------|
| Anonymous | Browse catalog (intended public) |

---

## Module Architecture

```
Presentation           API controllers (JSON)
Application            ICourseRepository (approved filters)
Storage                Courses table (Status = Approved)
```

### Controllers

| Controller | Responsibility |
|-----------|----------------|
| `LearnerCourseController` | 6 actions (`api/LearnerCourse`) — mixed auth (`recommended` requires `[Authorize]`, others `[AllowAnonymous]`) |

### Services

| Service | Responsibility |
|---------|----------------|
| `ICourseService` | `GetFeaturedCoursesAsync`, `GetNewCoursesAsync`, `GetRecommendedCoursesAsync` |
| `CourseRepository` | `GetApprovedCoursesByCategoriesAsync`, `GetApprovedCoursesByInstructorAsync`, `GetApprovedCoursesByCategoryAsync` |

---

## Folder Structure

```
Controllers/Learner/
+-- LearnerCourseController.cs        # 6 actions (264 lines)
```

---

## Endpoints

**Route**: `api/LearnerCourse`  
**Authorization**: mixed (`[AllowAnonymous]` on catalog/home actions; `[Authorize]` on recommended)

| # | Action | HTTP | Route | Auth | Description |
|---|--------|------|-------|------|-------------|
| 1 | GetFeaturedCourses | GET | `api/LearnerCourse/featured?count=8` | 🔓 | Top-rated approved courses for home page (:46) |
| 2 | GetNewCourses | GET | `api/LearnerCourse/new?count=8` | 🔓 | Newest approved courses for home page (:71) |
| 3 | GetRecommendedCourses | GET | `api/LearnerCourse/recommended?count=12` | 🔐 | Personalized recommendations by enrolled categories (:95) |
| 4 | GetApprovedCoursesByCategories | GET | `api/LearnerCourse/approved/by-categories?categoryIds=&countPerCategory=` | 🔓 | Approved courses batched per category (:129) |
| 5 | GetApprovedCoursesByInstructor | GET | `api/LearnerCourse/approved/by-instructor/{instructorId}` | 🔓 | ⚠️ 404 by default if count omitted (:175) |
| 6 | GetApprovedCoursesByCategory | GET | `api/LearnerCourse/approved/by-category/{categoryId}` | 🔓 | Single category approved courses (:230) |

---

## Internal Workflows & Runtime Behavior

### Workflow 1: By Instructor (broken default)

```mermaid
flowchart TD
    A[GET approved/by-instructor/id] --> B{count provided? :99}
    B -->|no| C[count = 0 :99]
    C --> D[Take(0) UNCONDITIONAL :222 ⚠️]
    D --> E[Empty list → NotFound 404 :109-113]
    B -->|yes count>0| F[Works]
```

#### Runtime Behavior
- `CourseRepository.GetApprovedCoursesByInstructorAsync` applies `.Take(count)` **unconditionally** (:222) — unlike the base `Repository<T>` which guards `take > 0` (Repository.cs:92-96).
- With the controller default `count = 0`, the endpoint **always 404s unless `?count=` is explicitly supplied** — the most impactful public-facing bug in this batch.

### Workflow 2: By Categories

#### Behavior
- `categoryIds` from `[FromQuery] List<int>` (:48); empty/null → empty list 200 (not 404).
- Per-category `.Take(countPerCategory)` (:750); default 10 from controller (:52-53).

---

## Service Layer

| Service | Key logic (verified) |
|---------|----------------------|
| `CourseRepository` | `GetApprovedCoursesByInstructorAsync` bypasses the base repo's `take > 0` guard (CourseRepository.cs:222 vs Repository.cs:92-96) |

---

## Business Rules

| Rule | Verified in | Why it exists |
|------|-------------|---------------|
| Approved-only filters | repository predicates | Draft/Rejected hidden from public |
| count=0 means "all" (doc) | controller default :87 | ⚠️ contradicted by Take(0) behavior |
| Public access | `[AllowAnonymous]` | Catalog is marketing |

---

## Security Analysis

| Control | Status |
|---------|--------|
| Authentication | none — intended public |
| Data exposure | Only Approved courses surfaced (by predicate) |
| Availability | broken default returns 404 — degrades instructor-profile course sections |

---

## Hidden Behaviors & Technical Notes

1. **`by-instructor` always 404 by default** — CourseRepository.cs:222 × LearnerCourseController.cs:99/109-113.
2. **`by-category` with `count=0`** also yields an empty 200 (not 404) — same Take semantics, different fallback.
3. The MVC Instructor profile page hits this endpoint — the instructor-profile "courses" widget is broken out of the box unless the caller passes `count`.

---

## Configuration

| Key | Purpose |
|-----|---------|
| (none module-specific) | — |

---

## Change Log

**Current functionality (verified):** approved-catalog browsing — with a default-404 bug on the by-instructor endpoint.

**Maintenance notes:** guard `Take` like the base repository (`take > 0`); make `count=0` mean "no cap".