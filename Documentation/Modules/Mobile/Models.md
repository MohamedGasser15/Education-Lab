# Mobile Data Models Catalog & Serialization Reference

> **Directory:** `apps/mobile/lib/features/*/models/` & `apps/mobile/lib/core/models/`  
> **Target Framework:** Dart 3.11 / Flutter 3.x  
> **Serialization Strategy:** Robust handwritten `fromJson`/`toJson` factory constructors with defensive type casting, dual casing resolution (camelCase / PascalCase), and context-aware localization getters.

This document serves as the single source of truth for all 21 data models across the EducationLab mobile client.

---

## 1. Domain Modeling Architecture

Mobile models in EducationLab follow a **defensive deserialization** architecture:
- **Null Safety Resilience:** Numeric properties safely parse strings (`int.tryParse`), doubles handle integer literals (`num.toDouble()`), and booleans handle numeric `0`/`1` or string `"true"` equivalents.
- **Backend Compatibility:** Deserializers support both ASP.NET Core camelCase default output and legacy PascalCase DTO output via fallback key checks (e.g. `json['id'] ?? json['Id']`).
- **Rich Computeds:** Models encapsulate formatted presentation helpers (e.g. `formattedDuration`, `progressRatio`, `cleanUrl`, `getLocalizedTitle`) to keep Flutter widget trees purely declarative.

---

## 2. Comprehensive Model Catalog

### 2.1 Course Details & Curriculum Models
**File:** [`apps/mobile/lib/features/courses/data/models/course_details_model.dart`](file:///d:/Programming/MonoRepo%20Porjects/EducationLab/apps/mobile/lib/features/courses/data/models/course_details_model.dart)

#### `CourseDetailsModel`
Root aggregate model representing complete course syllabus, instructor bio, and curriculum tree.
| Property | Type | JSON Key(s) | Description |
| :--- | :--- | :--- | :--- |
| `id` | `int` | `id`, `Id` | Course identifier. |
| `title` | `String` | `title`, `Title` | Primary course headline. |
| `shortDescription` | `String` | `shortDescription` | High-level summary shown in cards. |
| `description` | `String` | `description` | Full Markdown/HTML course description. |
| `status` | `String` | `status` | Course publication lifecycle (`Published`, `Draft`). |
| `price` | `double` | `price`, `Price` | Current purchase price. |
| `discount` | `double?` | `discount`, `originalPrice` | Original price before reduction (if any). |
| `rawThumbnailUrl`| `String?` | `thumbnailUrl`, `thumbnail` | Raw media URI formatted via `ApiConstants.formatImageUrl`. |
| `createdAt` | `DateTime?` | `createdAt`, `CreatedDate` | Timestamp of course publication. |
| `instructorId` | `String` | `instructorId` | AspNetUsers GUID of course instructor. |
| `instructorName`| `String` | `instructorName` | Display name of instructor. |
| `instructorTitle`| `String?` | `instructorTitle` | Professional designation (e.g. "Senior Cloud Architect"). |
| `instructorAbout`| `String?` | `instructorAbout` | Detailed instructor biography. |
| `instructorSubjects`| `List<String>`| `instructorSubjects` | Primary topic tags taught by instructor. |
| `rawProfileImageUrl`| `String?`| `instructorImageUrl` | Instructor profile picture URL. |
| `categoryId` | `int` | `categoryId` | Primary discipline identifier. |
| `categoryName` | `String` | `categoryName` | Arabic category name. |
| `categoryEnglishName`| `String?`| `categoryEnglishName` | English category name. |
| `level` | `String` | `level` | Difficulty rating (`Beginner`, `Intermediate`, `Advanced`). |
| `language` | `String` | `language` | Instruction medium (`Arabic`, `English`). |
| `duration` | `int` | `duration` | Total video runtime in minutes. |
| `totalLectures` | `int` | `totalLectures` | Cumulative count of lessons. |
| `hasCertificate`| `bool` | `hasCertificate` | Flag indicating completion certificate availability. |
| `requirements` | `List<String>` | `requirements` | Prerequisites list parsed from string/array. |
| `learnings` | `List<String>` | `learnings`, `whatYouWillLearn` | Course takeaways list. |
| `targetAudience`| `String` | `targetAudience` | Intended learners profile. |
| `sections` | `List<CourseSectionModel>` | `sections` | Structured syllabus sections. |
| `averageRating` | `double` | `averageRating` | Cumulative 5-star score average. |
| `totalRatings` | `int` | `totalRatings`, `reviewsCount` | Number of student ratings. |
| `enrollmentCount`| `int` | `enrollmentCount` | Number of enrolled learners. |

#### `CourseSectionModel`
Represents an instructional module or chapter containing sequential lectures.
| Property | Type | Description |
| :--- | :--- | :--- |
| `id` | `int` | Section identifier. |
| `title` | `String` | Module title (e.g. "Section 1: Getting Started"). |
| `order` | `int` | Display sequence within curriculum. |
| `courseId` | `int` | Parent course foreign key. |
| `isFreePreview` | `bool` | Flag unlocking all child lectures for preview. |
| `lectures` | `List<CourseLectureModel>` | Child lectures array. |
| `isExpanded` | `bool` | In-memory accordion toggle state. |
| `totalDurationMinutes`| `int` *(computed)* | Sum of durations across all child lectures. |

#### `CourseLectureModel`
Represents an individual playable or readable learning unit.
| Property | Type | Description |
| :--- | :--- | :--- |
| `id` | `int` | Lecture primary key. |
| `title` | `String` | Lesson title. |
| `videoUrl` | `String?` | HLS or MP4 stream URI. |
| `articleContent`| `String?` | Markdown text for reading lessons. |
| `quizId` | `int?` | Foreign key linking interactive quiz. |
| `sectionId` | `int` | Parent section ID. |
| `contentType` | `String` | Lesson type: `Video`, `Article`, `Quiz`. |
| `duration` | `int` | Runtime in seconds or minutes. |
| `order` | `int` | Playback order. |
| `isFreePreview` | `bool` | Allows guest viewing without purchase. |
| `resources` | `List<LectureResourceModel>` | Downloadable supplementary files. |
| `isVideo` / `isArticle` / `isQuiz` | `bool` *(computed)* | Boolean type detectors. |
| `formattedDuration` | `String` *(computed)* | Formats duration into `mm:ss`. |

---

### 2.2 Learning Progress & Enrollment Models
**Files:** [`apps/mobile/lib/features/learning/data/models/course_progress_models.dart`](file:///d:/Programming/MonoRepo%20Porjects/EducationLab/apps/mobile/lib/features/learning/data/models/course_progress_models.dart) & [`enrollment_model.dart`](file:///d:/Programming/MonoRepo%20Porjects/EducationLab/apps/mobile/lib/features/learning/data/models/enrollment_model.dart)

#### `CourseProgressSummaryModel`
Tracks user completion across lectures and video watch times.
| Property | Type | Description |
| :--- | :--- | :--- |
| `enrollmentId` | `int` | Enrollment binding identifier. |
| `courseId` | `int` | Course foreign key. |
| `courseTitle` | `String` | Bound course headline. |
| `totalLectures` | `int` | Total required lectures in syllabus. |
| `completedLectures` | `int` | Number of completed lectures. |
| `progressPercentage` | `double` | Scalar percentage (0.0 to 100.0). |
| `lastActivity` | `DateTime?` | Timestamp of last viewed lesson. |
| `totalDuration` | `int` | Cumulative course duration in seconds. |
| `watchedDuration`| `int` | Total watch time elapsed in seconds. |
| `isCompleted` | `bool` *(computed)* | `progressPercentage >= 100` or `completedLectures >= totalLectures`. |
| `progressRatio` | `double` *(computed)* | Progress scalar clamped between 0.0 and 1.0 for ProgressIndicators. |

#### `LectureResourceModel`
Downloadable assets attached to a lesson.
- `id` (`int`), `lectureId` (`int`), `title` (`String`), `fileUrl` (`String?`), `fileType` (`String`), `fileSize` (`String?`).
- `formattedUrl` (`String` *computed*): Converts relative path to absolute CDN endpoint.

#### `EnrollmentModel`
Active student subscription binding user to course.
- `id` (`int`), `courseId` (`int`), `userId` (`String`), `enrolledAt` (`DateTime`), `progressPercentage` (`double`), `isCompleted` (`bool`), `course` (`CourseModel?`).

#### `LectureCommentModel`
**File:** [`apps/mobile/lib/features/learning/data/models/lecture_comment_model.dart`](file:///d:/Programming/MonoRepo%20Porjects/EducationLab/apps/mobile/lib/features/learning/data/models/lecture_comment_model.dart)
Q&A discussions attached to individual lectures.
- `id` (`int`), `lectureId` (`int`), `userId` (`String`), `userName` (`String`), `userAvatarUrl` (`String?`), `content` (`String`), `createdAt` (`DateTime`), `replies` (`List<LectureCommentModel>`).

---

### 2.3 Certificates Model
**File:** [`apps/mobile/lib/features/courses/data/models/certificate_model.dart`](file:///d:/Programming/MonoRepo%20Porjects/EducationLab/apps/mobile/lib/features/courses/data/models/certificate_model.dart)

#### `CertificateModel`
Official completion accreditation issued upon course completion.
| Property | Type | Description |
| :--- | :--- | :--- |
| `id` | `int` | Certificate record primary key. |
| `courseId` | `int` | Completed course identifier. |
| `certificateCode` | `String` | Unique cryptographic verification code (e.g. `EL-CERT-872631`). |
| `issuedDate` | `DateTime` | Graduation timestamp. |
| `studentName` | `String` | Student's verified legal name. |
| `courseTitle` | `String` | Accredited course headline. |
| `verifyUrl` | `String` | External public verification link. |
| `formattedDate` | `String` *(computed)* | Formats timestamp as `DD/MM/YYYY`. |
| `fullVerifyUrl` | `String` *(computed)* | Generates web URL via `ApiConstants.verifyCertificatePath`. |
| `downloadUrl` | `String` *(computed)* | PDF download endpoint via `ApiConstants.downloadCertificatePath`. |

---

### 2.4 Cart & Wishlist Models
**Files:** [`apps/mobile/lib/features/cart/data/models/cart_model.dart`](file:///d:/Programming/MonoRepo%20Porjects/EducationLab/apps/mobile/lib/features/cart/data/models/cart_model.dart) & [`wishlist_item_model.dart`](file:///d:/Programming/MonoRepo%20Porjects/EducationLab/apps/mobile/lib/features/wishlist/data/models/wishlist_item_model.dart)

#### `CartModel` & `CartItemModel`
Shopping cart state tracking course additions and subtotal calculations.
- `CartModel`: `id` (`int`), `userId` (`String`), `items` (`List<CartItemModel>`), `totalPrice` (`double`).
- `CartItemModel`: `id` (`int`), `courseId` (`int`), `courseTitle` (`String`), `coursePrice` (`double`), `thumbnailUrl` (`String?`), `instructorName` (`String`), `totalPrice` (`double`).

#### `WishlistItemModel`
Saved bookmark entries for future enrollment.
- `id` (`int`), `courseId` (`int`), `userId` (`String`), `title` (`String`), `instructorName` (`String`), `price` (`double`), `rating` (`double`), `reviewsCount` (`int`), `thumbnailUrl` (`String?`), `addedAt` (`DateTime`).

---

### 2.5 Catalog & Explore Models
**File:** [`apps/mobile/lib/features/catalog/presentation/models/explore_models.dart`](file:///d:/Programming/MonoRepo%20Porjects/EducationLab/apps/mobile/lib/features/catalog/presentation/models/explore_models.dart)

#### `CategoryItem`
Visual category cards rendered in explore screen.
- `id` (`String`), `title` (`String`), `subtitle` (`String`), `arabicTitle` (`String?`), `englishTitle` (`String?`), `icon` (`IconData`), `color` (`Color`), `coursesCount` (`String`), `englishTag` (`String?`), `rawCount` (`int?`).
- `getLocalizedTitle(BuildContext)`: Returns localized title matching current app locale.
- `getLocalizedTag(BuildContext)`: Translates tags ("Highest Demand" -> "الأعلى طلباً").

#### `CourseItem`
Course summary card model adapted from `HomeCourseDTO` for search and exploration listings.
- `id` (`String`), `rawId` (`int`), `title` (`String`), `arabicTitle` (`String`), `instructor` (`String`), `rating` (`double`), `reviews` (`String`), `price` (`String`), `originalPrice` (`String`), `category` (`String`), `categoryId` (`int?`), `isBestseller` (`bool`), `badgeText` (`String`), `badgeColor` (`Color`), `duration` (`String`), `icon` (`IconData`), `gradient` (`List<Color>`), `thumbnailUrl` (`String?`).

#### `FilterChipItem` & `CourseFilterState`
Parameters managing catalog filtering: selected categories, price range, ratings, sorting order, and level.

---

### 2.6 Home & Instructor Profile Models
**Files:** [`apps/mobile/lib/features/home/data/models/home_models.dart`](file:///d:/Programming/MonoRepo%20Porjects/EducationLab/apps/mobile/lib/features/home/data/models/home_models.dart) & [`instructor_profile_model.dart`](file:///d:/Programming/MonoRepo%20Porjects/EducationLab/apps/mobile/lib/features/home/data/models/instructor_profile_model.dart)

#### `HomeDataBundle`
Aggregated payload returned by `HomeRepository.fetchHomeData()` combining 6 parallel backend requests:
- `banners` (`List<BannerModel>`)
- `featuredCourses` (`List<HomeCourseDTO>`)
- `newCourses` (`List<HomeCourseDTO>`)
- `recommendedCourses` (`List<HomeCourseDTO>`)
- `instructors` (`List<InstructorSummaryModel>`)
- `categories` (`List<CategoryItem>`)

#### `InstructorProfileModel`
Detailed public curriculum profile of an instructor.
- `id` (`String`), `fullName` (`String`), `title` (`String?`), `about` (`String?`), `profileImageUrl` (`String?`), `rating` (`double`), `totalStudents` (`int`), `totalCourses` (`int`), `totalReviews` (`int`), `courses` (`List<InstructorCourseModel>`), `socialLinks` (`SocialLinksModel`).

---

### 2.7 Support & Inbox Models
**Files:** [`apps/mobile/lib/features/inbox/data/models/support_model.dart`](file:///d:/Programming/MonoRepo%20Porjects/EducationLab/apps/mobile/lib/features/inbox/data/models/support_model.dart), [`notification_model.dart`](file:///d:/Programming/MonoRepo%20Porjects/EducationLab/apps/mobile/lib/features/inbox/data/models/notification_model.dart), & [`notification_summary_model.dart`](file:///d:/Programming/MonoRepo%20Porjects/EducationLab/apps/mobile/lib/features/inbox/data/models/notification_summary_model.dart)

#### `SupportConversationModel`
Real-time customer service thread.
- `id` (`int`), `subject` (`String`), `status` (`String` - `Open`/`Closed`), `createdAt` (`DateTime`), `updatedAt` (`DateTime`), `unreadCount` (`int`), `lastMessage` (`String?`), `lastMessageAt` (`DateTime?`).
- `isOpen` (`bool` *computed*): `status.toLowerCase() == 'open'`.

#### `SupportMessageModel`
Individual message bubble within a ticket.
- `id` (`int`), `conversationId` (`int`), `senderId` (`String`), `senderRole` (`String` - `User`/`Admin`/`Support`), `content` (`String`), `createdAt` (`DateTime`), `isRead` (`bool`).
- `isUser` (`bool` *computed*): `senderRole.toLowerCase() == 'user'`.

#### `NotificationModel` & `NotificationSummaryModel`
Push and inbox notifications.
- `NotificationModel`: `id` (`int`), `title` (`String`), `message` (`String`), `type` (`String`), `isRead` (`bool`), `createdAt` (`DateTime`), `actionUrl` (`String?`).
- `NotificationSummaryModel`: `unreadCount` (`int`), `totalCount` (`int`), `latestNotification` (`NotificationModel?`).

---

### 2.8 User Profile & Security Models
**Files:** [`apps/mobile/lib/features/profile/data/models/user_profile_model.dart`](file:///d:/Programming/MonoRepo%20Porjects/EducationLab/apps/mobile/lib/features/profile/data/models/user_profile_model.dart), [`security_models.dart`](file:///d:/Programming/MonoRepo%20Porjects/EducationLab/apps/mobile/lib/features/profile/data/models/security_models.dart), & [`instructor_application_models.dart`](file:///d:/Programming/MonoRepo%20Porjects/EducationLab/apps/mobile/lib/features/profile/data/models/instructor_application_models.dart)

#### `UserProfileModel` & `SocialLinksModel`
Learner and instructor account profile.
- `UserProfileModel`: `id` (`String`), `fullName` (`String`), `email` (`String`), `title` (`String?`), `location` (`String?`), `postalCode` (`String?`), `phoneNumber` (`String?`), `about` (`String?`), `profileImageUrl` (`String?`), `createdAt` (`DateTime?`), `socialLinks` (`SocialLinksModel`), `roles` (`List<String>`).
- `SocialLinksModel`: `gitHub`, `linkedIn`, `twitter`, `facebook`. Contains `cleanUrl(...)` utility validating and formatting handles to pass ASP.NET Core URI validation.

#### `ActiveSessionModel` & `TwoFactorSetupModel`
Security management payloads.
- `ActiveSessionModel`: `id` (`String`), `deviceName` (`String`), `deviceType` (`String` - `phone`/`tablet`/`desktop`), `location` (`String`), `ipAddress` (`String`), `lastActive` (`DateTime?`), `isCurrent` (`bool`).
- `TwoFactorSetupModel`: `qrCodeUrl` (`String`), `secret` (`String`), `recoveryCodes` (`List<String>`).

#### `InstructorApplicationModel`
Application dossier submitted by users aspiring to become instructors.
- `id` (`int`), `userId` (`String`), `bio` (`String`), `expertise` (`String`), `cvUrl` (`String`), `status` (`String` - `Pending`/`Approved`/`Rejected`), `submittedAt` (`DateTime`), `reviewNotes` (`String?`).

---

### 2.9 Payments & Legal Models
**Files:** [`apps/mobile/lib/features/profile/data/models/payment_intent_models.dart`](file:///d:/Programming/MonoRepo%20Porjects/EducationLab/apps/mobile/lib/features/profile/data/models/payment_intent_models.dart), [`payment_model.dart`](file:///d:/Programming/MonoRepo%20Porjects/EducationLab/apps/mobile/lib/features/profile/data/models/payment_model.dart), & [`legal_content_model.dart`](file:///d:/Programming/MonoRepo%20Porjects/EducationLab/apps/mobile/lib/features/legal/data/models/legal_content_model.dart)

#### `PaymentIntentResponseModel`
Server-issued Stripe PaymentIntent secrets.
- `clientSecret` (`String`), `paymentIntentId` (`String`), `amount` (`double`), `currency` (`String`).

#### `PaymentHistoryItemModel`
Past transaction record shown in user purchase history.
- `id` (`String`), `courseTitle` (`String`), `amount` (`double`), `paymentDate` (`DateTime`), `paymentMethod` (`String`), `status` (`String`), `receiptUrl` (`String?`).

#### `LegalContentModel`
HTML/Markdown compliance documents fetched from `/api/Legal`.
- `type` (`String` - `About`/`Privacy`/`Terms`), `title` (`String`), `content` (`String`), `lastUpdated` (`DateTime`).
