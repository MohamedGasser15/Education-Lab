# Mobile Feature Architecture: Authentication & Identity (`Auth`)

> **Feature Directory:** `apps/mobile/lib/features/auth/`  
> **Key Screens:** `LoginScreen`  
> **Repositories & Services:** `AuthRepository`, `AuthStorageService`, `GoogleAuthService`, `FacebookAuthService`, `AppSessionService`  
> **Backend Synchronization:** `/api/Auth` (Login, Register, External OAuth, Send Code, Verify Email, Refresh Token)

---

## 1. Feature Overview & Scope

The `Auth` feature encapsulates identity management, user onboarding, and session security across the EducationLab mobile app. It delivers:
1. **Email & Password Authentication:** Standard login flow exchanging credentials for JWT access and refresh tokens.
2. **3-Step Verified Registration with OTP:** Prevents fake email registration by dispatching an email OTP verification challenge before accepting account credentials.
3. **90-Second Flood Protection Timer:** Enforces client-side rate limiting on code resend requests.
4. **Native Google & Facebook Mobile OAuth:**
   - **Google**: Direct OAuth token acquisition without requiring Firebase SDKs, exchanging the Google ID token with `/api/Auth/google-mobile`.
   - **Facebook**: Native SDK login with iOS/Android app-switching and fallback in-app `FacebookOAuthDialog` (`webview_flutter`) to retrieve Graph API tokens for `/api/auth/FacebookMobile`.
5. **Two-Factor Authentication (2FA) & Session Security:**
   - TOTP authenticator setup (`Settings/two-factor/setup`), enabling/disabling 2FA with 6-digit codes.
   - Active device session tracking (`Settings/active-sessions`) and remote session revocation (`Settings/active-sessions/revoke`).
6. **Guest Mode Exploration:** Allows unauthenticated users to browse courses and previews, deferring authentication until checkout or lecture playback.
7. **Hardware-Encrypted Session Persistence:** Stores tokens in secure storage (Keychain/Keystore) with in-memory caching and updates `ProfileProvider` reactively.

---

## 2. Authentication Flow Architecture

```mermaid
sequenceDiagram
    autonumber
    actor User as Learner
    participant UI as LoginScreen
    participant Repo as AuthRepository
    participant Google as GoogleAuthService
    participant FB as FacebookAuthService
    participant Backend as EduLab Auth API
    participant Storage as AuthStorageService

    alt Email / Password Login
        User->>UI: Submits email & password
        UI->>Repo: login(email, password)
        Repo->>Backend: POST /api/Auth/login
        Backend-->>Repo: Returns { accessToken, refreshToken, user }
        Repo->>Storage: saveTokens(access, refresh) + saveUserData(user)
        Repo-->>UI: Success -> Route /main
    else Google Mobile OAuth
        User->>UI: Taps "المتابعة عبر Google"
        UI->>Google: signInWithGoogle()
        Google-->>UI: Returns Google ID Token
        UI->>Repo: externalLogin(idToken)
        Repo->>Backend: POST /api/Auth/google-mobile { idToken }
        Backend-->>Repo: Returns { accessToken, refreshToken, user }
        Repo->>Storage: saveTokens(access, refresh) + saveUserData(user)
        Repo-->>UI: Success -> Route /main
    else Facebook Mobile OAuth
        User->>UI: Taps "المتابعة عبر Facebook"
        UI->>FB: signInWithFacebook()
        FB-->>UI: Returns Graph API Access Token
        UI->>Repo: externalFacebookLogin(accessToken)
        Repo->>Backend: POST /api/auth/FacebookMobile { accessToken }
        Backend-->>Repo: Returns { accessToken, refreshToken, user }
        Repo->>Storage: saveTokens(access, refresh) + saveUserData(user)
        Repo-->>UI: Success -> Route /main
    else 3-Step Registration
        User->>UI: Step 0: Submits Email
        UI->>Backend: POST /api/Auth/send-registration-code
        Backend-->>UI: 200 OK (OTP Sent)
        User->>UI: Step 1: Enters 6-Digit OTP
        UI->>Backend: POST /api/Auth/verify-code
        Backend-->>UI: 200 OK (Email Verified)
        User->>UI: Step 2: Enters Name & Password
        UI->>Backend: POST /api/Auth/register
        Backend-->>UI: 201 Created -> Switch to Login Tab
    end
```

---

## 3. Storage & Interceptor Token Lifecycle

Tokens are managed through `AuthStorageService` using Flutter secure storage and shared preferences:
* **Access Token:** Short-lived JWT (15-60 minutes) injected into every outgoing request via Dio `AuthInterceptor` (`Authorization: Bearer <token>`).
* **Refresh Token:** Long-lived persistent token (30 days) used to silently acquire a new access token upon receiving `401 Unauthorized`.
* **Logout / Invalidation:** `AppSessionService.clearSession(context)` purges stored tokens, disconnects SignalR hubs, and redirects the navigation stack to `/login`.

---

## 4. Security & Edge Case Defense

1. **Brute-Force & Flooding Throttling:**
   * A non-bypassable 90-second countdown timer runs on the client upon OTP dispatch.
   * OTP input cells accept strictly numeric digits (`FilteringTextInputFormatter.digitsOnly`).
2. **Password Complexity Rules:**
   * Minimum 8 characters.
   * At least 1 uppercase letter (`[A-Z]`).
   * At least 1 numeric digit (`[0-9]`).
3. **Session Interception Hygiene:**
   * If token refresh fails on the backend, `AuthInterceptor` flushes cached tokens and triggers global redirection to `LoginScreen` to avoid infinite request retry loops.
