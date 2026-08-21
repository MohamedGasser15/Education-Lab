# InstructorApplicationsController Module Documentation (API — Admin)

---

## Overview

### Purpose
Admin review of instructor applications: list, details, approve, reject.

### Business Objective
Complete the onboarding loop: evaluate applicants and promote to Instructor / demote to Student.

### Main Functionality
- All applications + details
- Approve (role → Instructor)
- Reject (role → Student, with reason)

### Primary User Roles

| Role | Description |
|------|-------------|
| AdminArea (any claim) | Review + decide |

---

## Module Architecture

```
Presentation           API controllers (JSON)
Application            IInstructorApplicationService
Storage                InstructorApplications + Identity roles
```

### Controllers

| Controller | Responsibility |
|-----------|----------------|
| `InstructorApplicationsController` | 4 actions (`api/InstructorApplications`) — class `[Authorize(Policy="AdminArea")]` |

---

## Endpoints

**Route**: `api/InstructorApplications`  
**Authorization**: `[Authorize(Policy="AdminArea")]` class (:23)

| # | Action | HTTP | Route | Description |
|---|--------|------|-------|-------------|
| 1 | GetAllApplications | GET | `api/InstructorApplications` | All + CV urls (:66-92) |
| 2 | GetApplicationDetails | GET | `api/InstructorApplications/{id}` | Detail (⚠️ in-memory filter, :103-134) |
| 3 | ApproveApplication | PUT | `api/InstructorApplications/{id}/approve` | Role → Instructor (:149-188) |
| 4 | RejectApplication | PUT | `api/InstructorApplications/{id}/reject` | Role → Student + reason (:199-238) |

---

## Internal Workflows & Runtime Behavior

### Workflow 1: Approve / Reject

```mermaid
flowchart TD
    A[PUT id/approve or id/reject] --> B[Parse Guid :357]
    B --> C[⚠️ REMOVE ALL current roles :378-387 / 474-483]
    C --> D[Add Instructor (approve) :390-400<br/>or Student (reject) :486-496]
    D --> E[Email + notification]
    E --> F[Status Approved / Rejected + RejectionReason :419/499/520]
```

#### Runtime Behavior
- **No status guard**: re-approving an already-approved application re-runs the role changes (no Pending check — service reads the app at :363/459 but never verifies status).
- **Role-stripping hazard**: applicants holding roles like `Admin` are silently demoted on approve/reject (all roles removed).
- `adminId` from `NameIdentifier` claim, else `"System"` (:159, :209).
- **`GetApplicationDetails` loads all applications then filters in memory** (`FirstOrDefault(a => a.Id == id)`, :114) — inefficient.

---

## Business Rules

| Rule | Verified in | Why it exists |
|------|-------------|---------------|
| Approve → Instructor role | InstructorApplicationService.cs:378-400 | Onboarding |
| Reject → Student role | :474-496 | Rollback |
| Rejection reason persisted | :499 | Feedback |
| Duplicate active application blocked (user-side) | :99-109 | Spam control |

---

## Security Analysis

| Control | Status |
|---------|--------|
| Authentication | ✅ AdminArea |
| **Claim granularity** | ❌ any admin claim can view + decide (no ViewInstructorApplications/HandleInstructorApplications checks) |
| **Status replay** | ❌ no Pending guard on approve/reject (race/replay) |
| **CV exposure** | CV urls (sensitive personal documents) visible to any claim-holder |
| **Role stripping** | ❌ multi-role applicants lose unrelated roles |
| Dead DI | `IHttpContextAccessor` + `UserManager` injected, never used (:28-29, :43-44) |
| API shape | Approve/Reject return plain strings, GETs return DTOs — inconsistent |

---

## Hidden Behaviors & Technical Notes

1. **Rejection reason is optional** — no validation that a reason exists (`RejectApplicationRequest.RejectionReason`).
2. **No `DownloadInstructorCV` claim** exists despite CV exposure.
3. 499 on cancellations (:85, :127, …).

---

## Configuration

| Key | Purpose |
|-----|---------|
| (none module-specific) | — |

---

## Change Log

**Current functionality (verified):** role-transition approval/rejection with email notifications — coarse any-claim auth, replayable decisions, and all-roles-stripping.

**Maintenance notes:** guard Pending status; preserve unrelated roles; add claim checks; query by id instead of in-memory filter.