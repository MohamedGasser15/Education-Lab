# InstructorController Module Documentation (API)

---

## Overview

### Purpose
Public instructor directory: list all instructors, by id, and "top-rated".

### Business Objective
Marketing surface: showcase instructors with real ratings and student counts.

### Main Functionality
- All instructors
- Instructor by id
- Top instructors (default 4)

### Primary User Roles

| Role | Description |
|------|-------------|
| Anonymous | Browse (intended public) |

---

## Module Architecture

```
Presentation           API controllers (JSON)
Application            IInstructorService
Storage                Users (Instructor role) + Ratings table
```

### Controllers

| Controller | Responsibility |
|-----------|----------------|
| `InstructorController` | 3 actions (`api/Instructor`) — `[AllowAnonymous]` class (:18) |

### Services

| Service | Responsibility |
|---------|----------------|
| `InstructorService` | Instructor queries, ratings aggregation, top-rated |

---

## Folder Structure

```
Controllers/Learner/
+-- InstructorController.cs           # 3 actions (167 lines)

Services/
+-- InstructorService.cs
```

---

## Database Design

None direct — reads `Users` (role-scoped) + `Ratings` (aggregated by `Course.InstructorId`).

---

## Endpoints

**Route**: `api/Instructor`  
**Authorization**: `[AllowAnonymous]` (:18)

| # | Action | HTTP | Route | Description |
|---|--------|------|-------|-------------|
| 1 | GetAllInstructors | GET | `api/Instructor` | All instructors (:55) |
| 2 | GetInstructorById | GET | `api/Instructor/{id}` | One instructor (:89) |
| 3 | GetTopRatedInstructors | GET | `api/Instructor/top/{count}` | "Top" list (:133, count default 4) |

---

## Internal Workflows & Runtime Behavior

### Workflow 1: Top Rated (broken)

```mermaid
flowchart TD
    A[GET top/count] --> B[Load ALL users :226-228]
    B --> C[N+1 GetRolesAsync per user]
    C --> D[Filter Instructor role]
    D --> E[Take(count) :242-263]
    E --> F[⚠️ NOT SORTED BY RATING —<br/>"top" = first N arbitrary users]
```

### Workflow 2: Ratings

#### Behavior
- `GetInstructorRatingAsync` computes real averages from `Ratings` filtered by `Course.InstructorId` (:63-68).
- **`TotalStudents` hardcoded `1200`** in three places with TODO comments (:115, :186, :253).

---

## Service Layer

| Service | Key logic (verified) |
|---------|----------------------|
| `InstructorService` | Full-table loads + N+1 role checks (:87-90, :96); role filter (:97); rating math (:63-68); **un-sorted Take** (:242-263) |

---

## Business Rules

| Rule | Verified in | Why it exists |
|------|-------------|---------------|
| Public listing | `[AllowAnonymous]` | Marketing |
| Instructor-role filter | :97, :173 | Directory = instructors only |
| Count default 4 | :137 | Sensible default |

---

## Security Analysis

| Control | Status |
|---------|--------|
| Authentication | none — intended public |
| Data exposure | Public instructor profiles by design |
| Performance | full-table loads + N+1 — DoS-prone under load |

---

## Hidden Behaviors & Technical Notes

1. **"Top-rated" is not sorted** (InstructorService.cs:242-263) — data-integrity bug affecting the home page "top instructors" widget.
2. **TotalStudents = 1200 hardcoded** (:115/186/253) — misleading public data with TODO markers.
3. **Route ambiguity**: `GET /api/Instructor/top` (no count) matches `{id}` = "top" → 404 (harmless; ids are GUIDs).
4. **N+1 + full-table enumeration** — the most expensive public endpoint family.

---

## Configuration

| Key | Purpose |
|-----|---------|
| (none module-specific) | — |

---

## Change Log

**Current functionality (verified):** public directory with real rating aggregates — but "top-rated" ordering is broken and TotalStudents is fake.

**Maintenance notes:**
- Sort by rating (desc) before Take; compute real student counts; optimize the N+1 queries.