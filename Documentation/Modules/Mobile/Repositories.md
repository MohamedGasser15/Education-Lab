# Mobile Repositories & Data Access Layer Reference

> **Framework:** Flutter 3.x / Dart 3.11  
> **Pattern:** Repository Pattern with functional `Result<T>` envelopes  
> **Source Directory:** `apps/mobile/lib/core/repositories/` & `apps/mobile/lib/features/*/data/repositories/`  
> **Total Repositories:** 15 Active Repositories

This document provides a technical specification of the mobile data access layer, mapping each repository to its corresponding backend REST endpoints, parameter serialization rules, caching strategies, and exception translations.

---

## 1. Architectural Role of Repositories

Repositories in EducationLab encapsulate data access mechanisms and decouple ViewModels (`Provider`) from transport specifics (`ApiClient` Dio wrapper vs local storage):
- **Functional Returns:** Methods return `Result<T>` (`Success<T>` or `Failure<T>`), preventing unhandled exception bubbling in Flutter UI threads.
- **Cache Mediation:** Repositories mediate between network requests, memory caches, and `SharedPreferences`.
- **Payload Sanitization:** Normalizes DTO keys, parses localized string dates, and adapts relative server image paths to full CDN URLs.

```mermaid
flowchart LR
    Provider[Provider / ViewModel] -->|Requests Domain Object| Repo[Repository]
    Repo -->|1. Cache Check| LocalStore[(SharedPreferences / In-Memory)]
    Repo -->|2. Network Request| ApiClient[ApiClient / Dio]
    ApiClient -->|3. HTTP Wire| BackendAPI[ASP.NET Core REST API]
    BackendAPI -->|JSON Response| ApiClient
    ApiClient -->|Decoded Map| Repo
    Repo -->|Result.Success / Failure| Provider
```

---

## 2. Complete Catalog of All 15 Repositories

### 2.1 `AuthRepository`
**File:** ``apps/mobile/lib/core/repositories/auth_repository.dart``

| Method | HTTP Call | Backend Endpoint | Description |
| :--- | :--- | :--- | :--- |
| `login(email, password)` | POST | `/api/Auth/login` | Authenticates email/password; saves tokens via `AuthStorageService`. |
| `sendRegistrationCode(email, name, password)` | POST | `/api/Auth/send-registration-code` | Initiates 2-step registration and triggers backend email OTP. |
| `register(email, name, password, code)` | POST | `/api/Auth/register` | Commits registration with verified 6-digit OTP code. |
| `googleMobileLogin(idToken)` | POST | `/api/Auth/google-mobile` | Exchanges Google OAuth ID token for EducationLab JWT and refresh tokens. |
| `refreshToken()` | POST | `/api/Auth/refresh-token` | Silent token renewal. |
| `logout()` | POST / Local | `/api/Auth/logout` | Calls server logout and flushes local credentials. |

---

### 2.2 `HomeRepository` & `HomeApiService`
**Files:** `apps/mobile/lib/features/home/data/repositories/home_repository.dart` (`:32-231`) & `apps/mobile/lib/features/home/data/services/home_api_service.dart` (`:7-516`)

| Method | HTTP Call | Backend Endpoint | Description |
| :--- | :--- | :--- | :--- |
| `getHomeBundleData()` | Parallel `Future.wait` | 6 initial + multi-category batch | Orchestrates the home feed (`home_repository.dart:40-180`): dispatches `getCategories`, `getInstructors`, `getPublicStats`, `getFeaturedCourses`, `getNewCourses`, and `getRecommendedCourses` concurrently via `Future.wait` (`:43-50`), then fetches `getAllCourses(categoryIds)` (`:79-81`). |
| `getCategories()` | GET (15m cache) | `/api/Category` | Returns categories with icon data and count (`home_api_service.dart:13-25`). |
| `getFeaturedCourses()` | GET (5m cache) | `/api/LearnerCourse/featured?count=10` | Retrieves high-priority promoted courses (`home_api_service.dart:100-112`). |
| `getRecommendedCourses()` | GET (5m cache) | `/api/LearnerCourse/recommended?count=10`| Retrieves tailored course recommendations (`home_api_service.dart:130-142`). |
| `getNewCourses()` | GET (5m cache) | `/api/LearnerCourse/new?count=10` | Retrieves latest courses sorted by release date (`home_api_service.dart:115-127`). |
| `getInstructors()` | GET (10m cache)| `/api/Instructor` | Retrieves top faculty members (`home_api_service.dart:28-40`). |
| `getAllCourses(categoryIds)`| GET (5m cache) | `/api/LearnerCourse/approved/by-categories` | Fetches approved courses across up to 8 categories in a single batch call (`home_api_service.dart:62-76`), with a parallel `Future.wait` fallback across per-category `/api/LearnerCourse/category/{id}` endpoints (`:80-86`). |
| `getPublicStats()` | GET (10m cache)| `/api/public/stats` | Returns system-wide statistics (`home_api_service.dart:43-53`). |

---

### 2.3 `ExploreRepository` & `ExploreApiService`
**Files:** `apps/mobile/lib/features/catalog/data/repositories/explore_repository.dart` (`:9-313`) & `apps/mobile/lib/features/catalog/data/services/explore_api_service.dart` (`:8-202`)

| Method | Storage / HTTP | Target | Description |
| :--- | :--- | :--- | :--- |
| `getCoursesByCategory(id, {count})`| GET (5m cache) | `/api/LearnerCourse/category/{id}?count=50` | Fetches courses belonging to a specific discipline (`explore_api_service.dart:76-95`). |
| `getCatalogCourses()` | Parallel `Future.wait` | `ExploreApiService.getAllLearnerCourses()` | Aggregates unique approved courses in parallel via `Future.wait` across `getApprovedCoursesByCategories(defaultCategoryIds, countPerCategory: 20)` (`/api/LearnerCourse/approved/by-categories`), `getFeaturedCourses(count: 30)`, and `getNewCourses(count: 30)` (`explore_api_service.dart:122-180`). |
| `getRecentSearches()` | Local Read | `SharedPreferences` | Reads stored search history. |
| `addRecentSearch(query)` | Local Write| `SharedPreferences` | Adds query, deduplicates, and caps at 10 items. |
| `removeRecentSearch(query)` | Local Delete| `SharedPreferences` | Removes a single query. |
| `clearRecentSearches()` | Local Delete| `SharedPreferences` | Flushes all search history. |

---

### 2.4 `CoursesRepository` & `CourseDetailsRepository`
**Files:** ``courses_repository.dart`` & ``course_details_repository.dart``

| Method | HTTP Call | Backend Endpoint | Description |
| :--- | :--- | :--- | :--- |
| `getCourseDetails(courseId)` | GET | `/api/Course/{id}` | Deserializes syllabus, sections, lectures, and instructor details. |
| `getCourseReviews(courseId)` | GET | `/api/CourseRating/{id}/ratings` | Retrieves student ratings and feedback. |
| `getCourseRatingSummary(courseId)`| GET | `/api/CourseRating/{id}/summary` | Returns star distribution and average score. |

---

### 2.5 `CourseLearningRepository`
**File:** ``apps/mobile/lib/features/learning/data/repositories/course_learning_repository.dart``

| Method | HTTP Call | Backend Endpoint | Description |
| :--- | :--- | :--- | :--- |
| `getCourseProgress(courseId)` | GET | `/api/CourseProgress/{courseId}` | Real-time completion percentages and watched duration. |
| `getLectureStatuses(courseId)` | GET | `/api/CourseProgress/{courseId}/lectures` | Map of completed lecture IDs. |
| `markLectureCompleted(courseId, lectureId)` | POST | `/api/CourseProgress/mark-completed` | Marks lesson completed; triggers certificate check if 100%. |
| `markLectureIncomplete(courseId, lectureId)` | POST | `/api/CourseProgress/mark-incomplete`| Reverts lesson completion state. |
| `getLectureComments(lectureId)` | GET | `/api/LectureComments/lecture/{id}` | Loads Q&A questions and replies. |
| `addLectureComment(lectureId, content)` | POST | `/api/LectureComments` | Posts a student question. |
| `addCommentReply(commentId, content)` | POST | `/api/LectureComments/{id}/reply` | Posts reply to thread. |
| `submitRating(courseId, rating, review)` | POST | `/api/CourseRating` | Submits 1-5 star course review. |

---

### 2.6 `EnrollmentRepository`
**File:** ``apps/mobile/lib/features/learning/data/repositories/enrollment_repository.dart``

| Method | HTTP Call | Backend Endpoint | Description |
| :--- | :--- | :--- | :--- |
| `getMyEnrollments()` | GET | `/api/Enrollment/my-courses` | Fetches all courses student is currently enrolled in. |
| `enrollFreeCourse(courseId)` | POST | `/api/Enrollment/enroll` | Direct zero-cost enrollment for free courses. |

---

### 2.7 `CertificatesRepository`
**File:** ``apps/mobile/lib/features/courses/data/repositories/certificates_repository.dart``

| Method | HTTP Call | Backend Endpoint | Description |
| :--- | :--- | :--- | :--- |
| `getMyCertificates()` | GET | `/api/Certificates/my-certificates` | Retrieves all completion certificates earned by learner. |
| `getCertificateByCourse(courseId)`| GET | `/api/Certificates/course/{id}` | Retrieves certificate for a specific completed course. |
| `verifyCertificate(code)` | GET | `/api/Certificates/verify/{code}` | Validates cryptographic authenticity of a credential. |

---

### 2.8 `CartRepository` & `WishlistRepository`
**Files:** ``cart_repository.dart`` & ``wishlist_repository.dart``

| Method | HTTP Call | Backend Endpoint | Description |
| :--- | :--- | :--- | :--- |
| `getCart()` | GET | `/api/Cart` | Loads active cart and item list. |
| `addToCart(courseId)` | POST | `/api/Cart/add` | Adds course to shopping cart. |
| `removeFromCart(cartItemId)` | DELETE | `/api/Cart/items/{id}` | Deletes course from cart. |
| `clearCart()` | DELETE | `/api/Cart` | Empties entire cart. |
| `getWishlist()` | GET | `/api/Wishlist` | Fetches bookmarked courses. |
| `toggleWishlist(courseId)` | POST | `/api/Wishlist/toggle/{courseId}` | Toggles bookmark state. |

---

### 2.9 `NotificationRepository` & `SupportRepository`
**Files:** ``notification_repository.dart`` & ``support_repository.dart``

| Method | HTTP Call | Backend Endpoint | Description |
| :--- | :--- | :--- | :--- |
| `getNotifications()` | GET | `/api/Notifications` | Fetches paginated user notifications. |
| `getSummary()` | GET | `/api/Notifications/summary` | Returns unread badge counter. |
| `markAsRead(id)` | PUT | `/api/Notifications/{id}/read` | Updates single notification state. |
| `markAllAsRead()` | PUT | `/api/Notifications/read-all` | Clears all unread badges. |
| `getConversations()` | GET | `/api/Support/conversations` | Retrieves user support tickets. |
| `getMessages(conversationId)` | GET | `/api/Support/conversations/{id}/messages` | Retrieves ticket message history. |
| `sendMessage(conversationId, text)` | POST | `/api/Support/conversations/{id}/messages` | Posts customer support message. |
| `createConversation(subject, msg)`| POST | `/api/Support/conversations` | Creates new support ticket. |

---

### 2.10 `ProfileRepository`, `SecurityRepository`, `PaymentRepository`
**Files:** ``profile_repository.dart``, ``security_repository.dart``, ``payment_repository.dart``

| Method | HTTP Call | Backend Endpoint | Description |
| :--- | :--- | :--- | :--- |
| `getProfile()` | GET | `/api/Profile` | Retrieves user profile, avatar, social handles. |
| `updateProfile(model)` | PUT | `/api/Profile` | Updates user details. |
| `uploadAvatar(imageFile)` | POST (Multipart)| `/api/Profile/upload-avatar` | Uploads profile picture. |
| `changePassword(...)` | POST | `/api/Security/change-password` | Updates account credentials. |
| `getTwoFactorStatus()` | GET | `/api/Security/2fa-status` | Checks if 2FA is active. |
| `getTwoFactorSetup()` | GET | `/api/Security/2fa-setup` | Fetches QR code URL and secret. |
| `getActiveSessions()` | GET | `/api/Security/active-sessions` | Lists devices logged into account. |
| `revokeSession(sessionId)` | POST | `/api/Security/revoke-session/{id}` | Terminates remote login session. |
| `createPaymentIntent(amount, curr)`| POST | `/api/Payment/create-payment-intent` | Initiates Stripe PaymentIntent. |
| `confirmOrder(paymentIntentId)` | POST | `/api/Payment/confirm-order` | Confirms transaction and enrolls student. |
| `getPaymentHistory()` | GET | `/api/Payment/history` | Fetches past billing invoices. |
