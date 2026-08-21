# InstructorApplicationsController Module Documentation (MVC — Admin Area)

---

## Overview

### Purpose
Admin review of instructor applications: list, view details, approve, reject (with reason).

### Business Objective
Close the "become an instructor" loop: admins evaluate applicants (CV + profile) and promote/deny with feedback.

### Main Functionality
- Applications list + categories for specialization mapping
- Application details JSON (full profile + CV)
- Approve application
- Reject with reason

### Primary User Roles

| Role | Description |
|------|-------------|
| Admin (AdminArea policy) | Review + decide |

---

## Module Architecture

```
Presentation           Areas/Admin/Views/InstructorApplications/Index.cshtml (only view)
Application            IInstructorApplicationService + ICategoryService
External               EduLab API: GET InstructorApplications,
                       GET InstructorApplications/{id},
                       PUT InstructorApplications/{id}/{action}
```

### Controllers

| Controller | Responsibility |
|-----------|----------------|
| `InstructorApplicationsController` | Index, GetApplicationDetails, Approve, Reject (4 actions) |

### Services

| Service | Responsibility |
|---------|----------------|
| `InstructorApplicationService` | admin: `GetAllApplicationsAsync` -> GET `InstructorApplications` (:210), `GetApplicationDetailsAdminAsync` -> GET `InstructorApplications/{id}` (:268), `ApproveApplicationAsync`/`RejectApplicationAsync` -> PUT `InstructorApplications/{id}/{action}` (:347); learner paths (`InstructorApplication/apply`, `my-applications`, `application-details`) also live here |
| `CategoryService` | `GetAllCategoriesAsync` -> GET `Category` (CategoryService.cs:42) for the specialization map |

### Dependencies on Other Modules
- **Admin layout** (sidebar link).
- **EduLab API** (hard dependency).

---

## Folder Structure

```
Areas/Admin/Controllers/
+-- InstructorApplicationsController.cs   # 4 actions (190 lines)

Areas/Admin/Views/InstructorApplications/
+-- Index.cshtml                       # Application queue
```

---

## Database Design

None (MVC). Applications live in the API's `InstructorApplications` table; CVs under `Images/cv-files`.

---

## Internal Workflows & Runtime Behavior

### Workflow 1: Application Queue

#### Flow

```mermaid
flowchart TD
    A[Index :47-70] --> B[GetAllApplicationsAsync + GetAllCategoriesAsync]
    B --> C[ViewBag.AllCategories + View(applications)]
    B -->|OperationCanceledException| D[Redirect Dashboard]
    B -->|other exception| E[View Error]
```

#### Runtime Behavior
- Cancellation redirects to Dashboard; other exceptions render the shared Error view (InstructorApplicationsController.cs:60-69).

### Workflow 2: Details

#### Behavior
- `GetApplicationDetails` (`[HttpGet]`, :78-79): null result -> `NotFound()`; success -> Json with full applicant payload (id, fullName, email, specialization, experience, skills, skillsList, bio, profileImageUrl, status, appliedDate, reviewedBy, reviewedDate, cvUrl) (:92-108).

### Workflow 3: Approve / Reject

#### Flow

```mermaid
flowchart TD
    A[Approve :128-130 POST ✅] --> B[ApproveApplicationAsync]
    B --> C[PUT InstructorApplications/id/approve]
    C --> D[TempData Success<br/>⚠️ ApplicationRejected key (:138) — BUG]
    E[Reject :161-163 POST ✅] --> F[RejectApplicationAsync id, reason]
    F --> G[PUT InstructorApplications/id/reject]
    G --> H[TempData Success ApplicationRejected ✅ correct]
```

#### Runtime Behavior
- Both POSTs antiforgery-protected (:129, :162).
- **Copy-paste bug**: `Approve` sets `TempData["Success"] = _localizer["ApplicationRejected"]` (InstructorApplicationsController.cs:138) — approving shows the "application rejected" success message.

---

## Data Flow Analysis

```mermaid
flowchart LR
    A[Queue UI] --> B[InstructorApplicationsController]
    B --> C[InstructorApplicationService + CategoryService]
    C -->|GET InstructorApplications · {id} ·<br/>PUT {id}/{action} · GET Category| API[EduLab API]
    B --> D[Views / Json / TempData]
```

---

## Controllers & Endpoints

### InstructorApplicationsController

**Route**: `/Admin/InstructorApplications`  
**Authorization**: `[Area("Admin")]` (:13) + `[Authorize(Policy="AdminArea")]` (:14)  
**Dependencies**: `IInstructorApplicationService`, `ICategoryService`, `ILogger`, `IStringLocalizer` (:28-38)

| Action | HTTP | Route | Description | Anti-forgery |
|--------|------|-------|-------------|--------------|
| Index | GET | `/Admin/InstructorApplications/Index` | Application queue | — |
| GetApplicationDetails | GET | `/Admin/InstructorApplications/GetApplicationDetails?id` | Details JSON | — |
| Approve | POST | `/Admin/InstructorApplications/Approve?id` | Approve application | ✅ |
| Reject | POST | `/Admin/InstructorApplications/Reject?id&rejectionReason` | Reject with reason | ✅ |

**Model**: `List<InstructorApplicationResponseDto>` (Index); details via JSON.

---

## Frontend Integration

### Index.cshtml
- Queue cards with status filters; details modal (fetch `GetApplicationDetails`); approve/reject with reason prompt; TempData toasts.

---

## Business Rules

| Rule | Verified in | Why it exists |
|------|-------------|---------------|
| Reject carries a reason | `RejectApplicationAsync(id, rejectionReason)` | Applicant feedback + audit |
| Approval only via POST + token | :128-130 | Anti-CSRF on privilege changes |
| Cancellation handled distinctly | :60-64, :110-114 | Long-running API calls |

---

## Security Analysis

| Control | Status |
|---------|--------|
| Authentication | ✅ AdminArea policy |
| Anti-forgery | ✅ both decision POSTs |
| Privilege change | Approve promotes Student -> InstructorPending/Instructor — API must validate allowed transitions |
| Data exposure | Full applicant PII (email, CV URL) in details JSON — admin-scoped by policy |

---

## Module Dependencies

```mermaid
flowchart LR
    A[InstructorApplicationsController] --> S[IInstructorApplicationService]
    A --> C[ICategoryService]
    S -->|InstructorApplications · {id} · PUT {id}/{action}| API[EduLab API]
    C -->|GET Category| API
    L[Admin _Layout] -->|sidebar link| A
```

**Internal**: Admin layout, learner-side application service (shared).
**External**: EduLab API only.

---

## Hidden Behaviors & Technical Notes

1. **Approve shows "Application rejected" success** (InstructorApplicationsController.cs:138) — copy-paste bug from Reject; users see wrong success text.
2. **Success message shown regardless of result**: both Approve/Reject ignore the service result on the success path (TempData set unconditionally after the call, :138, :171).
3. **Details JSON is hand-mapped** (not a DTO passthrough) — new fields require editing the action.
4. **Shared service**: the learner's apply flow and the admin queue live in the same `InstructorApplicationService`.

---

## Configuration

| Key | Purpose |
|-----|---------|
| `EduLab:ApiBaseUrl` | API base |

---

## Change Log

**Current functionality (verified):** claim-free (AdminArea) application queue with details JSON, antiforgery-protected approve/reject — plus a wrong-success-message bug on Approve.

**Maintenance notes:** fix `TempData["Success"]` key on Approve; optionally honor service results.