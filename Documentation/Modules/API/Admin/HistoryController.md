# HistoryController Module Documentation (API — Admin)

---

## Overview

### Purpose
Audit log surface: all history, my history, per-user history, and a log-write endpoint.

### Business Objective
Trace platform activity for auditability.

### Main Functionality
- All logs (AdminArea)
- My logs (⚠️ anonymous)
- Any user's logs (⚠️ anonymous — IDOR)
- Write arbitrary log rows (AdminArea)

### Primary User Roles

| Role | Description |
|------|-------------|
| Anonymous | ⚠️ my-history + any-user history |
| AdminArea | all logs + write |

---

## Module Architecture

```
Presentation           API controllers (JSON)
Application            IHistoryService
Storage                HistoryLogs table
```

### Controllers

| Controller | Responsibility |
|-----------|----------------|
| `HistoryController` | 4 actions (`api/History`) — **no class-level `[Authorize]`** |

---

## Endpoints

**Route**: `api/History`  
**Authorization**: mixed — critical gap

| # | Action | HTTP | Route | Auth | Description |
|---|--------|------|-------|------|-------------|
| 1 | GetAllHistory | GET | `api/History/all` | 🛡️ AdminArea (:61) | All logs |
| 2 | GetMyHistory | GET | `api/History/MyHistory` | 🔓 **anonymous** (:91-96) | Own logs; 404 when empty (:112-116) |
| 3 | GetHistoryByUser | GET | `api/History/user/{userId}` | 🔓 **anonymous** (:141-146) | ⚠️ ANY user's logs |
| 4 | LogOperation | POST | `api/History/log?userId&operation` | 🛡️ AdminArea (:186) | Write arbitrary row |

---

## Internal Workflows & Runtime Behavior

### Workflow 1: Anonymous Leak

```mermaid
flowchart TD
    A[GET api/History/user/userId] --> B[NO auth — convention adds nothing<br/>because action 1 has [Authorize] :141-146]
    B --> C[GetHistoryByUserAsync :177]
    C --> D[⚠️ Any user's complete audit trail<br/>operations + message keys + JSON params]
```

#### Runtime Behavior
- The controller mixes one `[Authorize]` action with unannotated ones → `AdminAreaAuthorizationConvention` (adds a filter only when NO explicit `[Authorize]` exists anywhere) adds nothing → **`GetMyHistory` and `GetHistoryByUser` are fully anonymous**.
- `GetMyHistory` returns `NotFound` for a user with no logs (:112-116) — semantically wrong (200 + empty list).
- `LogOperation` accepts arbitrary `userId` + `operation` strings — **audit forgery** by any claim-holder; no sanitization.
- Generic catches leak `ex.Message` (:74-78, :124-128, :164-168).

---

## Business Rules

| Rule | Verified in | Why it exists |
|------|-------------|---------------|
| Logs carry Operation/KeyId/MessageKey/Parameters | HistoryService.cs:68-79 | Structured audit |

---

## Security Analysis

| Control | Status |
|---------|--------|
| **Anonymous audit leak (critical)** | ❌ `GET api/History/user/{id}` unauthenticated — full audit trail of any user |
| **Audit forgery** | ❌ `LogOperation` writes arbitrary rows (userId + operation strings from the caller) |
| **MyHistory 404 semantics** | no-logs → 404 instead of 200 empty |
| Route naming | `all` / `MyHistory` / `user/{userId}` — inconsistent casing |

---

## Hidden Behaviors & Technical Notes

1. **The convention's no-op behavior** (controller has both authorized and unauthorized actions) is the root cause of the leak — pattern repeats in CategoryController and CourseController.
2. **Audit integrity**: a claim-holder can forge history entries for any user.

---

## Configuration

| Key | Purpose |
|-----|---------|
| (none module-specific) | — |

---

## Change Log

**Current functionality (verified):** admin audit read/write — with anonymous access to any user's history and forgeable log writes.

**Maintenance notes:** `[Authorize]` the two GETs; make LogOperation accept a DTO with server-side user resolution; return 200-empty for no logs.