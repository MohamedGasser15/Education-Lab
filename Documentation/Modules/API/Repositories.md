# Repositories Reference (EduLab_Infrastructure)

---

## Overview

### Purpose
Complete reference of the persistence layer: the generic base repository, all 19 concrete repositories, the `ApplicationDbContext`, and startup seeding.

### Business Objective
Document every data-access entry point with its queries, transaction usage, and notable behaviors — the layer behind every service.

### Main Functionality
- Generic `Repository<T>` (filter/include/order/take, tracking control)
- 20 domain repositories (Cart, Category, Coupon, Course, CourseCertificate, CourseProgress, Enrollment, History, InstructorApplication, LectureComment, Notification, Payment, Profile, Rating, RefreshToken, RefundRequest, Report, Session, Student, Wishlist)
- `ApplicationDbContext` + `DbInitializer`

---

## Folder Structure

```
EduLab_Infrastructure/
├── Config/
│   └── InfrastructureContainer.cs    # AddDbContextPool<ApplicationDbContext> (:29-30) + DI registrations
├── Data/
│   ├── ApplicationDbContext.cs       # DbSets + EF configuration + 6 composite indexes (:203-220)
│   └── DbInitializer.cs              # Startup seeding
└── Persistence/Repository/
    ├── Repository.cs                 # Generic base (436 lines)
    └── 20 concrete repositories
```

---

## 1. Generic Base — `Repository<T>` (Repository.cs:19-436)

### API surface

| Method | Behavior (verified) |
|--------|---------------------|
| `GetAllAsync(filter, includeProperties, isTracking=false, orderBy, take?, ct)` | `AsNoTracking()` by default (:68); string-split `Include` chain with automatic **`AsSplitQuery()` when `properties.Length > 1 \|\| includeProperties.Contains('.')`** (:78-83); **`Take` only applied when `take > 0`** (:97-101) |
| `GetAsync(filter, includeProperties, isTracking, ct)` | throws on null filter (:139-140); `AsNoTracking()` when `!isTracking` (:149) |
| `AnyAsync(predicate, ct)` | `AsNoTracking()` (:212) |
| `CountAsync(filter, ct)` | SQL-level `dbSet.AsNoTracking().Where(filter).CountAsync(cancellationToken)` (:236-262) |
| `CreateAsync(entity, ct)` | Add + Save (:284-285) |
| `DeleteAsync(entity, ct)` / `DeleteRangeAsync(entities, ct)` | Remove + Save (:325-326, :371-372) |
| `SaveAsync(ct)` | SaveChanges with typed catches (Concurrency/Update, :416-425) |

### Key findings
- **Automatic Split Queries (`AsSplitQuery`)**: `GetAllAsync` (:78-83) detects multi-navigation or nested dot-path includes (`properties.Length > 1 || includeProperties.Contains('.')`) and enables `.AsSplitQuery()`, preventing Cartesian explosion across `Sections.Lectures` and `Instructor`/`Category` joins.
- **SQL-level `CountAsync`** (:236-262): executes `COUNT(*)` directly in SQL Server with `AsNoTracking()` rather than materializing entities in memory.

---

## 2. Per-Repository Reference

### CartRepository — `CartRepository.cs` (338 lines)
- `GetCartByUserIdAsync`/`GetCartByGuestIdAsync`: carts + items + course + instructor + **AppliedCoupon**, AsNoTracking (:47-52, :73-78).
- `CreateUserCartAsync`/`CreateGuestCartAsync`: bare `new Cart { UserId/GuestId }` (:103, :129).
- `MigrateGuestCartToUserAsync`: empty/absent guest cart → false (:161-164); merges items skipping already-enrolled courses (**enrollment check inside the repo**, :180-191); then **removes the guest cart** (:195).
- `AddItemToCartAsync`: sets `AddedAt = UtcNow` (:232).
- `RemoveItemFromCartAsync`/`ClearCartAsync`: find/remove + RemoveRange (:261-266, :293-295).
- `ApplyCouponToCartAsync`/`RemoveCouponFromCartAsync`: associates or clears `AppliedCouponId` and updates cart timestamp.

### CategoryRepository — `CategoryRepository.cs` (57 lines)
- Only one custom method: `UpdateAsync` (`_db.Categories.Update` + Save, :43-44). Everything else inherits from base.

### CouponRepository — `CouponRepository.cs` (106 lines)
- `GetByCodeAsync`: case-insensitive coupon lookup with `.Include(c => c.Usages)` (:30-38).
- `UpdateAsync`: updates `UpdatedAt = UtcNow`, calls `_db.Coupons.Update` + Save (:43-57).
- `GetUserUsageCountAsync`: counts records in `_db.CouponUsages` for specific `couponId` and `userId` (:62-68).
- `AddUsageAsync`: persists `CouponUsage` records upon successful checkout (:73-85).
- `CodeExistsAsync`: verifies uniqueness of coupon codes with optional `excludeId` for updates (:90-103).

### CourseRepository — `CourseRepository.cs` (1,059 lines)
- `AddAsync`: **explicit transaction** (:44); wires Section→Course, Lecture→Section (:52-65).
- `UpdateAsync`: transaction; loads existing with Sections→Lectures (:123-126); `CurrentValues.SetValues` (:135); diff-sync via private `UpdateSectionsAsync`/`UpdateLecturesAsync`/`UpdateResourcesAsync` (:942-1054) — removes missing, updates existing, adds new, with per-level ordering.
- `DeleteAsync` / `BulkDeleteAsync` / `BulkUpdateStatusAsync` / `UpdateStatusAsync`: all **transaction-wrapped** (:159, :722, :760, :802).
- **Read query optimizations (`.AsNoTracking()` + `.AsSplitQuery()`)**:
  - `GetLectureResourcesAsync`: `.AsNoTracking()` (:89-92).
  - `GetCoursesByInstructorAsync`: `.AsNoTracking().AsSplitQuery()` (:211-218).
  - `GetApprovedCoursesByInstructorAsync`: `.AsNoTracking().AsSplitQuery()` (:236-244), with **`if (count > 0) return await query.Take(count).ToListAsync(...)` guard** (:246-251) — returns all approved courses when `count <= 0`.
  - `GetCoursesWithCategoryAsync`: `.AsNoTracking().AsSplitQuery()` (:269-277).
  - `GetCourseByIdAsync`: `.AsNoTracking()` when `!isTracking` + `.AsSplitQuery()` (:295-303).
  - `GetApprovedCoursesByCategoriesAsync` (:856-863), `GetApprovedCoursesByCategoryAsync` (:886-893), and `GetRecommendedCoursesAsync` (:917-931): `.AsNoTracking()`.
- `AddSectionAsync`/`AddLectureAsync`: **auto-order = max+1** (:328-332, :489-493).
- `UpdateSectionAsync`: only Title + IsFreePreview (:360-361).
- `UnsetFreePreviewForOtherSectionsAsync`: single-free-preview invariant (:374-392).
- `ReorderSectionsAsync`/`ReorderLecturesAsync`: in-memory order rewrite (:428-456, :573-601).
- `GetCourseIdByLectureAsync`/`GetCourseIdByResourceAsync`: resolve course ownership for guards (:678-711) — **exceptions swallowed → null** (:690, :708).
- `GetSectionByIdAsync`: lectures ordered by `Order` (:467).

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

## 3. Data, Connection Pooling & Seeding

### InfrastructureContainer — `Config/InfrastructureContainer.cs`
- Registers `ApplicationDbContext` using **`services.AddDbContextPool<ApplicationDbContext>`** (`InfrastructureContainer.cs:29-30`), pooling context instances to eliminate per-request allocation overhead.

### ApplicationDbContext — `Data/ApplicationDbContext.cs`
- DbSets for all 29 entities + Identity (Users, Roles, RoleClaims, UserRoles); referenced by every repository.
- **6 Composite Performance Indexes** (`OnModelCreating`, `ApplicationDbContext.cs:203-220`):
  1. `Enrollment`: `(UserId, CourseId)` (:204-205)
  2. `Wishlist`: `(UserId, CourseId)` (:207-208)
  3. `Course`: `(Status, CategoryId)` (:210-211)
  4. `Course`: `(Status, CreatedAt)` (:213-214)
  5. `Rating`: `(CourseId, UserId)` (:216-217)
  6. `CourseProgress`: `(EnrollmentId, LectureId)` (:219-220)

### DbInitializer — `Data/DbInitializer.cs`
- Runs at startup (Program.cs:215-231); seeds roles, hardcoded accounts (`Admin@123` — DbInitializer.cs:102/173/195), courses, enrollments, certificates, progress, payments, reviews, an instructor application.

---

## Business Rules (enforced at the data layer)

| Rule | Where (verified) | Why it exists |
|------|------------------|---------------|
| Multi-include queries use `AsSplitQuery()` | Repository.cs:78-83, CourseRepository.cs:214/239/272/298 | Prevent Cartesian product bloat on deep curriculum graphs |
| Cart migration skips enrolled courses | CartRepository.cs:180-191 | No re-buy |
| Section/lecture auto-order = max+1 | CourseRepository.cs:328-332, :489-493 | Ordering integrity |
| One free-preview section per course | CourseRepository.cs:374-392 | UX invariant |
| Refresh tokens not rotated-revoked | RefreshTokenRepository.cs:164-179 | Parallel-tab resilience |
| Report creation is deferred-save | ReportRepository.cs:23-27 + :112-114 | Service controls commit |
| History update failures → ApplicationException | HistoryRepository.cs:54-58 | Audit must be loud |

---

## Hidden Behaviors & Technical Notes

1. **`Take` guard unified**: both `Repository<T>.GetAllAsync` (`Repository.cs:97-101`) and `CourseRepository.GetApprovedCoursesByInstructorAsync` (`CourseRepository.cs:246-251`) guard `count > 0` before applying `.Take(count)`.
2. **Exception swallowing** in `CourseRepository.GetCourseIdByLectureAsync`/`GetCourseIdByResourceAsync` (:690, :708) and `CourseProgressRepository` (:316-319, :261-265) — ownership checks silently fail open/closed depending on callers.
3. **`Review` vs `Rating`**: both entities exist; only `Rating` has controller surface.
4. **Two update patterns** in ProfileRepository: SetValues (user profile) vs field-by-field (instructor profile) — inconsistent maintenance.
5. **Transactions** are used only in CourseRepository paths — other multi-write flows (cart migration, refresh rotation) rely on a single SaveChanges.
6. **`CreateAsync` (ReportRepository) doesn't save** — unlike every other repository; services must remember `SaveAsync`.

---

## Configuration

| Key | Purpose |
|-----|---------|
| (EF Core, code-first with `AddDbContextPool`) | — |

---

## Change Log

**Current functionality (verified):** full persistence-layer reference — `AddDbContextPool<ApplicationDbContext>`, 6 composite indexes, generic base (`AsSplitQuery`, `AsNoTracking`, `CountAsync`) + 19 repositories with query shapes, transactions, and exceptions.

**Maintenance notes:** make ReportRepository's CreateAsync save consistently; unify profile-update patterns.