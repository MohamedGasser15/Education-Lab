# Middlewares Module Documentation (MVC)

---

## Overview

### Purpose
The MVC request pipeline's four custom middlewares: cookie→principal conversion, guest identity, silent token refresh, and maintenance-mode gating.

### Business Objective
Bridge the cookie-based MVC session to the JWT-based API: authenticate from cookies, keep anonymous carts working, keep sessions alive, and gate the site during maintenance.

### Main Functionality
- `JwtCookieMiddleware` — read `AuthToken` cookie → build the `User` principal
- `GuestIdMiddleware` — ensure a 30-day guest id cookie for anonymous carts
- `TokenRefreshMiddleware` — auto-refresh expired access tokens (+ forced logout on invalid refresh)
- `MaintenanceModeMiddleware` — block non-admins when `MaintenanceMode` is on

---

## Pipeline Position

```
Program.cs:168-171 (registration order)
JwtCookie → GuestId → TokenRefresh → MaintenanceMode → UseAuthentication → UseAuthorization (172-173)
```

All four are **middlewares, not filters** — they run before authentication/authorization and operate on the raw `HttpContext`.

---

## 1. JwtCookieMiddleware (113 lines)

### Behavior

```mermaid
flowchart TD
    A[Request] --> B{AuthToken cookie? :38}
    B -->|no| C[Log debug — continue]
    B -->|yes| D{CanReadToken? :49}
    D -->|no| E[Delete AuthToken cookie :85]
    D -->|yes| F{ValidTo >= UtcNow? :54}
    F -->|no| G[Delete AuthToken cookie :79]
    F -->|yes| H[Map JWT sub → NameIdentifier claim :58-62]
    H --> I[ClaimsIdentity jwt-cookie / Name / role :64-69]
    I --> J[context.User = principal :72]
    E --> K[_next]
    G --> K
    C --> K
    J --> K
```

#### Key facts
- Reads the cookie named `AuthToken` (JwtCookieMiddleware.cs:38).
- Uses `JwtSecurityTokenHandler` — **no signature/issuer validation at this layer**; only `ValidTo` expiry is checked (:54). Signature validation happens at the API.
- Maps the JWT registered `sub` claim to `ClaimTypes.NameIdentifier` so MVC code can use `FindFirst(ClaimTypes.NameIdentifier)` (:58-62).
- Claim types: name → `ClaimTypes.Name`, role → literal `"role"` type (:66-68).
- Any parse failure (malformed, invalid format, exceptions) **deletes the `AuthToken` cookie** (:79, :85, :91, :96) and continues the pipeline.
- Never short-circuits — always calls `_next` (:110).

---

## 2. GuestIdMiddleware (28 lines)

### Behavior

```mermaid
flowchart TD
    A[Request] --> B{GuestId cookie? :14}
    B -->|yes| C[_next]
    B -->|no| D[Append GuestId = new Guid<br/>30 days · HttpOnly · IsEssential :16-22]
    D --> C
```

#### Key facts
- Only writes the cookie; never reads its value (cart services read it later) (GuestIdMiddleware.cs:14-23).
- **`IsEssential = true`** (:21) — survives cookie-consent gating.
- **No `Secure` flag** — differs from the API's guest-cart cookie which is `Secure=true` (CartService.cs:67-74); over plain HTTP the MVC cookie works but the API's doesn't (dev inconsistency).

---

## 3. TokenRefreshMiddleware (199 lines)

### Behavior

```mermaid
flowchart TD
    A[Request] --> B{AuthToken AND RefreshToken cookies? :42}
    B -->|no| C[continue]
    B -->|yes| D{IsTokenExpired accessToken? :46}
    D -->|no| E[continue]
    D -->|yes| F[RefreshToken access+refresh :58]
    F -->|ok| G[SaveTokensToCookies :62-66]
    G --> H[context.Items[AuthToken] = new token :70]
    H --> I[continue — same-request services use Items]
    F -->|UnauthorizedAccessException| J[LogoutUser :83]
    F -->|other error| K[Log + continue :88-89]
    J --> L[InvalidateCurrentUserCache :125 → Revoke refresh :138<br/>→ clear cookies :184-189 → clear session :151 → redirect /Learner/Auth/Login :159]
```

#### Key facts
- **`IsTokenExpired`** decides when to refresh (TokenRefreshMiddleware.cs:46); the middleware does not verify expiry itself.
- **Same-request propagation**: the new access token is stored in `context.Items["AuthToken"]` (:70) because the cookie isn't re-read mid-request — services must read `HttpContext.Items` to use the refreshed token (documented in the Arabic comment :68-69).
- **Soft failure**: transient refresh failure (API down) continues without logging out (:76-78).
- **Hard failure**: `UnauthorizedAccessException` (invalid/revoked refresh token) → `LogoutUser` (:80-85, :117-166):
  - **evicts the current user's 10-minute `IMemoryCache` entry** via `context.RequestServices.GetService<IUserService>()?.InvalidateCurrentUserCache()` (:125),
  - revokes the refresh token (:138),
  - clears 6 auth cookies (`AuthToken`, `RefreshToken`, `RefreshTokenExpiry`, `UserFullName`, `UserRole`, `ProfileImageUrl`) with `Secure` + `SameSite=Strict` + `UnixEpoch` expiry (:172-197),
  - clears the session (:151),
  - redirects to `/Learner/Auth/Login` unless already there (:155-160).
- Never throws outward — outer try/catch continues the pipeline (:102-108).

---

## 4. MaintenanceModeMiddleware (81 lines)

### Behavior

```mermaid
flowchart TD
    A[Request] --> B[GetSettingsAsync 60-min IMemoryCache :35]
    B -->|null or MaintenanceMode false| C[continue]
    B -->|MaintenanceMode true| D{Admin role claim? :43-45}
    D -->|yes| E[continue — admin bypass]
    D -->|no| F{Path in allowlist? :54-62}
    F -->|yes| G[continue]
    F -->|no| H[Redirect /Error/Maintenance :69]
```

#### Key facts
- Reads settings via `ISiteSettingsService.GetSettingsAsync()` (MaintenanceModeMiddleware.cs:35), which is backed by a **60-minute `IMemoryCache`** (`SiteSettingsService.cs:56`) so the middleware incurs zero HTTP overhead on ordinary requests.
- Admin bypass: role claim equals `SD.Admin` **case-insensitively** (:43-45).
- Allowlist (lowercased path prefixes, :54-62): `/learner/auth/`, `/admin`, `/css`, `/js`, `/lib`, `/img`, `/fonts`, `/error/maintenance` — login, the admin area, static assets, and the maintenance page itself stay reachable.
- Everything else → 302 redirect to `/Error/Maintenance` (:69).
- **Settings-loading exceptions are swallowed** (:72-75) — if the API is down, maintenance mode silently deactivates (fail-open).

---

## Cross-Cutting Analysis

| Aspect | Finding (verified) |
|--------|--------------------|
| Ordering | JwtCookie before TokenRefresh — principal is built from the OLD cookie, then the refresh updates the cookie; the current request still uses the old principal (fresh principal only next request) |
| JWT validation depth | MVC checks only expiry; signature/issuer validation is API-side |
| Fail-open design | both TokenRefresh (soft-fail) and MaintenanceMode (exception → continue) degrade open |
| Cookie flags | logout clears with `Secure`+`Strict`; GuestId is `IsEssential` without `Secure`; API guest cookie is `Secure` (dev-HTTP mismatch) |
| Items propagation | refreshed token is only usable via `HttpContext.Items["AuthToken"]` — a documented convention services must follow |
| Cache hygiene | `TokenRefreshMiddleware.LogoutUser` explicitly calls `InvalidateCurrentUserCache()` (:125) and `MaintenanceModeMiddleware` reads 60-min cached `SiteSettings` (:35) |

---

## Business Rules

| Rule | Verified in | Why it exists |
|------|-------------|---------------|
| Admin bypasses maintenance | role claim check :43-45 | Platform ops during downtime |
| Login/static/admin always reachable | allowlist :54-62 | Users can still authenticate + assets load |
| Soft-fail refresh | :76-78 | Don't log out on API hiccups |
| Hard-fail logout + user cache eviction | :80-85, :125 | Invalid refresh token = real problem; prevent stale `CurrentUser_{id}` cache |

---

## Security Analysis

| Control | Status |
|---------|--------|
| Token handling | cookie-only; MVC never exposes the JWT in memory beyond Items |
| Maintenance fail-open | ⚠️ API outage disables maintenance (exception → continue, :72-77) |
| JWT expiry-only check | ⚠️ a tampered-but-unexpired token passes MVC and is rejected only at the API |
| Logout hygiene | ✅ evicts `CurrentUser_{id}` cache + revokes refresh + clears 6 cookies + session |
| GuestId | HttpOnly + IsEssential; no Secure (HTTP dev works, but no TLS protection) |

---

## Configuration

| Key | Purpose |
|-----|---------|
| (cookie names) | `AuthToken`, `RefreshToken`, `RefreshTokenExpiry`, `GuestId` (hardcoded in middleware) |

---

## Change Log

**Current functionality (verified):** cookie→principal bridge, guest identity cookie, silent token refresh with hard-fail logout and `InvalidateCurrentUserCache()`, maintenance-mode gating (backed by 60-min cached settings) with admin bypass + allowlist.

**Maintenance notes:**
- Align GuestId `Secure` flag with the API guest cookie.
- Consider full JWT validation in JwtCookieMiddleware (or document that API is the enforcement point).