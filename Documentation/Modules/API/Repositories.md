# Repositories Reference (EduLab_Infrastructure)

---

## Overview

### Purpose
Complete reference of the persistence layer: the generic base repository, all 19 concrete repositories, the `ApplicationDbContext`, and startup seeding.

### Business Objective
Document every data-access entry point with its queries, transaction usage, and notable behaviors — the layer behind every service.

### Main Functionality
- Generic `Repository<T>` (filter/include/order/take, tracking control)
- 19 domain repositories (Cart, Category, Course, CourseCertificate, CourseProgress, Enrollment, History, InstructorApplication, LectureComment, Notification, Payment, Profile, Rating, RefreshToken, RefundRequest, Report, Session, Student, Wishlist)
- `ApplicationDbContext` + `DbInitializer`

---

## Folder Structure

```
EduLab_Infrastructure/
├── Data/
│   ├── ApplicationDbContext.cs       # DbSets + EF configuration
│   └── DbInitializer.cs              # Startup seeding
└── Persistence/Repository/
    ├── Repository.cs                 # Generic base (400 lines)
    └── 19 concrete repositories
```

---

## 1. Generic Base — `Repository<T>` (Repository.cs:19-399)

### API surface

| Method | Behavior (verified) |
|--------|---------------------|
| `GetAllAsync(filter, includeProperties, isTracking=false, orderBy, take?, ct)` | AsNoTracking by default (:68); string-split `Include` chain (:76-84); **`Take` only applied when `take > 0`** (:92-96) |
| `GetAsync(filter, includeProperties, isTracking, ct)` | throws on null filter (:136-137) |
| `AnyAsync(predicate, ct)` | AsNoTracking (:207) |
| `CreateAsync(entity, ct)` | Add + Save (:249-250) |
| `DeleteAsync(entity, ct)` / `DeleteRangeAsync(entities, ct)` | Remove + Save (:290-291, :336-337) |
| `SaveAsync(ct)` | SaveChanges with typed catches (Concurrency/Update, :381-390) |

### Key finding
- **The `take > 0` guard** (:92-96) exists here — but `CourseRepository.GetApprovedCoursesByInstructorAsync` bypasses it with an unconditional `.Take(count)` (:222), causing the `by-instructor` 404-by-default bug (see `LearnerCourseController.md`).

---

## 2. Per-Repository Reference

### CartRepository — `CartRepository.cs` (309 lines)
- `GetCartByUserIdAsync`/`GetCartByGuestIdAsync`: carts + items + course + instructor, AsNoTracking (:47-52, :73-78).
- `CreateUserCartAsync`/`CreateGuestCartAsync`: bare `new Cart { UserId/GuestId }` (:103, :129).
- `MigrateGuestCartToUserAsync`: empty/absent guest cart → false (:161-164); merges items skipping already-enrolled courses (**enrollment check inside the repo**, :180-191); then **removes the guest cart** (:195).
- `AddItemToCartAsync`: sets `AddedAt = UtcNow` (:232).
- `RemoveItemFromCartAsync`/`ClearCartAsync`: find/remove + RemoveRange (:261-266, :293-295).

### CategoryRepository — `CategoryRepository.cs` (57 lines)
- Only one custom method: `UpdateAsync` (`_db.Categories.Update` + Save, :43-44). Everything else inherits from base.

### CourseRepository — `CourseRepository.cs` (910 lines)
- `AddAsync`: **explicit transaction** (:44); wires Section→Course, Lecture→Section (:52-65).
- `UpdateAsync`: transaction; loads existing with Sections→Lectures (:115-118); `CurrentValues.SetValues` (:127); diff-sync via private `UpdateSectionsAsync`/`UpdateLecturesAsync`/`UpdateResourcesAsync` (:798-905) — removes missing, updates existing, adds new, with per-level ordering.
- `DeleteAsync` / `BulkDeleteAsync` / `BulkUpdateStatusAsync` / `UpdateStatusAsync`: all **transaction-wrapped** (:151, :621, :657, :697).
- `AddSectionAsync`/`AddLectureAsync`: **auto-order = max+1** (:291-295, :446-450).
- `UpdateSectionAsync`: only Title + IsFreePreview (:323-324).
- `UnsetFreePreviewForOtherSectionsAsync`: single-free-preview invariant (:337-355).
- `ReorderSectionsAsync`/`ReorderLecturesAsync`: in-memory order rewrite (:389-417, :528-556).
- `GetApprovedCoursesByInstructorAsync`: **unconditional `.Take(count)`** (:222) — the documented bug.
- `GetApprovedCoursesByCategoriesAsync`/`ByCategoryAsync`: `.Take(countPerCategory/count)` (:750, :781).
- `GetCourseIdByLectureAsync`/`GetCourseIdByResourceAsync`: resolve course ownership for guards (:579-610) — **exceptions swallowed → null** (:591, :608).
- `GetSectionByIdAsync`: lectures ordered by `Order` (:426).

### CourseCertificateRepository — `CourseCertificateRepository.cs` (66 lines)
- `GetByCodeAsync`: exact string match, includes Enrollment→Course/User (:42-51).
- `GetByUserIdAsync`: ordered by IssuedDate desc (:62).
- `CreateAsync`: Add + Save (:24-25).

### CourseProgressRepository — `CourseProgressRepository.cs` (325 lines)
- `GetProgressByEnrollmentAsync`: includes **only Lecture, not Lecture.Section** (:187) — the `SectionTitle`-always-null finding (MappingConfig.cs:242-247).
- `GetCourseProgressPercentageAsync`: completed/total×100 (:308-309); **exceptions swallowed → 0** (:316-319).
- `GetAllLectureStatusesAsync`: **exceptions swallowed → empty dict** (:261-265).
- `IsLectureCompletedAsync`/`GetCompletedLecturesCountAsync`: standard counts (:233-248, :206-221).

### EnrollmentRepository — `EnrollmentRepository.cs` (296 lines)
- `CreateEnrollmentAsync`/`DeleteEnrollmentAsync`/`GetEnrollmentByIdAsync` (includes Course→Instructor + User, :129-134)/`GetUserEnrollmentsAsync` (ordered by EnrolledAt desc, :158-166)/`GetUserCourseEnrollmentAsync`/`IsUserEnrolledInCourseAsync`/`CreateBulkEnrollmentsAsync`/`GetUserEnrollmentsCountAsync`.

### HistoryRepository — `HistoryRepository.cs` (134 lines)
- `AddAsync` wraps base Create; **DbUpdateException → ApplicationException** (:54-58).
- `GetAllAsync`/`GetByUserIdAsync`: include User + OperationKey, ordered Date/Time desc (:77-83, :113-120); empty userId throws ArgumentException (:105-109).

### InstructorApplicationRepository — `InstructorApplicationRepository.cs` (72 lines)
- `UpdateStatusAsync`: sets Status + ReviewedDate = UtcNow + ReviewedBy (:51-53); missing → **KeyNotFoundException with Arabic message** (:48).

### LectureCommentRepository — `LectureCommentRepository.cs` (35 lines)
- `GetLectureCommentsAsync`: roots only (`ParentCommentId == null`), includes User + Replies→User, CreatedAt desc (:19-27).
- `HasUserCommentedOnLectureAsync` (:29-33).

### NotificationRepository — `NotificationRepository.cs` (339 lines)
- `GetUserNotificationsAsync`: filters + **pagination with validation (pageSize 1-100)** (:60-64); Activity spans (:49).
- `GetUserNotificationSummaryAsync`: 4 counts in parallel queries (:161-164).
- `MarkAllAsReadAsync`/`MarkAsReadAsync`: user-scoped updates (:194-238, :285-335).
- `DeleteAllUserNotificationsAsync`: via base DeleteRange (:265).

### PaymentRepository — `PaymentRepository.cs` (215 lines)
- `CreatePaymentAsync`: DbUpdateException → ApplicationException (:52-55).
- `GetPaymentByUserAndCourseAsync`: filters `Status == SD.PaymentStatusCompleted`, latest PaidAt (:193-211).
- `UpdatePaymentStatusAsync`: sets Status + **PaidAt = UtcNow** (:111-112).
- `CreateBulkPaymentsAsync` (:172-191).

### ProfileRepository — `ProfileRepository.cs` (356 lines)
- `GetUserProfileAsync`/`GetInstructorProfileAsync` (includes Certificates, :185).
- `UpdateUserProfileAsync`: `CurrentValues.SetValues` on tracked entity (:100).
- `UpdateInstructorProfileAsync`: **explicit field-by-field** (FullName/Title/Location/Phone/About/socials/Subjects, :236-245) — different pattern from the generic SetValues.
- `AddCertificateAsync`/`DeleteCertificateAsync` (user-scoped delete :326).

### RatingRepository — `RatingRepository.cs` (249 lines)
- `GetCourseRatingsAsync`: **expression-tree filter combination** (:111-127) then base GetAll.
- `GetCourseRatingSummaryRawAsync`: average (rounded 1dp) + distribution stars 1-5 (:156-207).
- `HasUserRatedCourseAsync` (:216-245).

### RefreshTokenRepository — `RefreshTokenRepository.cs` (306 lines)
- `SaveRefreshTokenAsync`: validates inputs + expiry future (:44-51).
- `ValidateRefreshTokenAsync`: user + token + expiry + not revoked (:106-111).
- `UpdateRefreshTokenAsync`: **deliberately does NOT revoke the old token** — documented Arabic comment: parallel tab refreshes would 401 others; the old token stays valid until expiry, real revocation happens at logout (:164-179).
- `RevokeRefreshTokenAsync` / `RevokeAllRefreshTokensAsync`: set IsRevoked (:220-229, :268-281).

### RefundRequestRepository — `RefundRequestRepository.cs` (183 lines)
- `GetByIdAsync`/`GetAllAsync`: includes Payment→Course + User (:73-78, :98-104).
- `GetByPaymentIdAsync`: latest by CreatedAt (:125-129).
- `UpdateAsync`: field-by-field status/ProcessedAt/ProcessedBy/RejectionReason/StripeRefundId (:157-161).

### ReportRepository — `ReportRepository.cs` (117 lines)
- `CreateAsync`: **Add only — does NOT SaveChanges** (deferred; `SaveAsync` at :112-114 must be called by the service).
- `GetFilteredAsync`/`CountFilteredAsync`: status/type/search (search = `Details.Contains`, :57-61) + skip/take (:41-68, :70-87).
- `GetReportedTargetIdsAsync`: dedupe by reporter+type+targets (:99-110).

### SessionRepository — `SessionRepository.cs` (272 lines)
- `GetActiveSessionsForUser`: IsActive && LogoutTime == null, ordered LastActivity (:59-62).
- `RevokeSession`: IsActive=false + LogoutTime (:186-187).
- `RevokeAllSessionsForUser`: **supports `excludeSessionId`** (:217-235) — the revoke-all-except-current capability exists at the repo level.

### StudentRepository — `StudentRepository.cs` (579 lines)
- `GetStudentsAsync`: **ALL users with any role** — not student-filtered (:211-214).
- `GetStudentsByInstructorAsync`/`GetStudentsForNotificationAsync`: enrollments → distinct users (:256-262, :63-69).
- `ValidateStudentsBelongToInstructorAsync`: count equality check (:121-127) — the instructor-scoping gate for notifications.
- `GetStudentEnrollmentsWithDetailsAsync`/`GetRecentStudentEnrollmentsAsync` (:344-387, :396-438).
- `GetStudentsSummaryStatsByInstructorAsync`: Total/Active/Completed/Average via group-by on CourseProgresses (:448-514).
- `GetStudentsProgressEnrollmentsAsync`: enrollments by arbitrary ids (:536-575).

### WishlistRepository — `WishlistRepository.cs` (221 lines)
- `GetUserWishlistAsync`: includes Course→Instructor/Category, AddedAt desc (:58-65).
- `GetWishlistItemAsync`/`IsCourseInWishlistAsync`/`GetWishlistCountAsync`: user-scoped (:94-134, :144-176, :185-217).

---

## 3. Data & Seeding

### ApplicationDbContext — `Data/ApplicationDbContext.cs`
- DbSets for all 28 entities + Identity (Users, Roles, RoleClaims, UserRoles); referenced by every repository.

### DbInitializer — `Data/DbInitializer.cs`
- Runs at startup (Program.cs:208-224); seeds roles, hardcoded accounts (`Admin@123` — DbInitializer.cs:102/173/195), courses, enrollments, certificates, progress, payments, reviews, an instructor application.

---

## Business Rules (enforced at the data layer)

| Rule | Where (verified) | Why it exists |
|------|------------------|---------------|
| Cart migration skips enrolled courses | CartRepository.cs:180-191 | No re-buy |
| Section/lecture auto-order = max+1 | CourseRepository.cs:291-295, :446-450 | Ordering integrity |
| One free-preview section per course | CourseRepository.cs:337-355 | UX invariant |
| Refresh tokens not rotated-revoked | RefreshTokenRepository.cs:164-179 | Parallel-tab resilience |
| Report creation is deferred-save | ReportRepository.cs:23-27 + :112-114 | Service controls commit |
| History update failures → ApplicationException | HistoryRepository.cs:54-58 | Audit must be loud |

---

## Hidden Behaviors & Technical Notes

1. **`Take` inconsistency**: base guards `take > 0` (Repository.cs:92-96); `CourseRepository` doesn't (:222) — the source of the public `by-instructor` 404 bug.
2. **Exception swallowing** in `CourseRepository.GetCourseIdByLectureAsync`/`GetCourseIdByResourceAsync` (:591, :608) and `CourseProgressRepository` (:316-319, :261-265) — ownership checks silently fail open/closed depending on callers.
3. **`Review` vs `Rating`**: both entities exist; only `Rating` has controller surface.
4. **Two update patterns** in ProfileRepository: SetValues (user profile) vs field-by-field (instructor profile) — inconsistent maintenance.
5. **Transactions** are used only in CourseRepository paths — other multi-write flows (cart migration, refresh rotation) rely on a single SaveChanges.
6. **`CreateAsync` (ReportRepository) doesn't save** — unlike every other repository; services must remember `SaveAsync`.

---

## Configuration

| Key | Purpose |
|-----|---------|
| (EF Core, code-first) | — |

---

## Change Log

**Current functionality (verified):** full persistence-layer reference — generic base + 19 repositories with query shapes, transactions, exceptions, and the documented quirks.

**Maintenance notes:** guard `Take` in CourseRepository; make ReportRepository's CreateAsync save consistently; unify profile-update patterns.