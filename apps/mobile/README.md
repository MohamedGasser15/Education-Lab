# 🎓 EduLab Mobile Application

<div align="center">

  [![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture%20%2B%20Feature--First-blueviolet?style=for-the-badge)](#architecture)
  [![Tests](https://img.shields.io/badge/Tests-60%2B%20Suites%20Passing-brightgreen?style=for-the-badge)](#testing)
  [![Platform](https://img.shields.io/badge/Platforms-iOS%20%7C%20Android-black?style=for-the-badge)](#requirements)

  <p align="center">
    <b>A modern, enterprise-grade mobile learning management platform (LMS) built with Flutter, featuring Clean Architecture, Real-Time SignalR Chat, Stripe Payments, and Native Social Auth.</b>
  </p>

</div>

---

## 🌟 Key Features

- **🔐 Robust Authentication & Security**:
  - Email/Password with 2FA, OTP verification, and JWT session handling.
  - Native Social Sign-in via **Google** & **Facebook** (Graph API OAuth 2.0).
  - Hardware-encrypted token storage (iOS Keychain / Android EncryptedSharedPreferences).
- **📚 Rich Course Player & Learning Experience**:
  - Multi-resolution video streaming, lecture progress auto-save, and curriculum tracking.
  - Interactive Q&A discussions, ratings, and course reviews.
- **💳 Complete E-Commerce & Checkout**:
  - Cart, Wishlist, and real-time coupon/discount calculations.
  - Seamless Stripe payment integration (Cards & 3D Secure verification).
- **📜 Verified Digital Certificates**:
  - View, share, and verify completion certificates with QR verification.
- **💬 Real-Time Live Support**:
  - Integrated bidirectional WebSocket support chat via **SignalR**.
- **🔔 Cloud & Local Push Notifications**:
  - Integrated with **Firebase Cloud Messaging (FCM)** and local scheduled notifications.
- **🌍 Internationalization & Theming**:
  - Full **Arabic (RTL)** and **English (LTR)** localization with dynamic switching.
  - System-adaptive **Dark Mode** & **Light Mode** styling.

---

## 🏛️ Architecture & Project Structure

EduLab follows a **Feature-First Clean Architecture** with strict separation of concerns:

```
lib/
├── core/                       # Shared foundational layer
│   ├── constants/              # API endpoints, assets, admin claims
│   ├── di/                     # Dependency injection (GetIt Service Locator)
│   ├── extensions/             # String, Date, and Localization extensions
│   ├── repositories/           # Base & core repositories
│   ├── services/               # ApiClient (Dio), Storage, Auth, Sounds, Push
│   ├── theme/                  # Theme configurations (Dark/Light) & AppColors
│   ├── utils/                  # AppLogger (with PII sanitization), Responsive helpers
│   └── widgets/                # Reusable UI widgets (AppNetworkImage, AppButton, AppShimmer)
├── features/                   # Self-contained business modules
│   ├── auth/                   # Authentication (Login, Register, 2FA, OAuth)
│   ├── cart/                   # Cart, Checkout & Stripe Payment integration
│   ├── catalog/                # Explore, Filters, Search & Categories
│   ├── courses/                # Course details, Video player, Lessons, Reviews
│   ├── home/                   # Home feed, Top instructors, Promo banners
│   ├── inbox/                  # Push Notifications, Support Chat (SignalR)
│   ├── learning/               # My Courses, Enrollment, Progress tracking
│   ├── legal/                  # Privacy policy, Terms of service
│   ├── onboarding/             # App walkthrough & welcome flow
│   ├── profile/                # User profile, Instructor application, Security
│   └── wishlist/               # Wishlist management
├── l10n/                       # AR / EN localization files
├── app.dart                    # App root, Theme & Route configuration
└── main.dart                   # Application bootstrap & background services init
```

---

## ⚡ Performance & Optimization Highlights

- **In-Memory JWT & Config Caching**: Eliminates async disk reads during network requests (`ApiClient` interceptors respond in ~0ms).
- **Memory-Bounded Image Rendering**: `AppNetworkImage` utilizes `CachedNetworkImage` with custom `memCacheWidth/Height` boundaries, preventing Out-Of-Memory (OOM) crashes on high-res assets.
- **Startup Lazy-Loading**: Screen-bound data fetching avoids startup request storms and battery consumption.
- **Data Sanitization**: Production-ready `AppLogger` that strips sensitive PII (Passwords, Card numbers, CVVs, Bearer tokens) from console logs.

---

## 🛠️ Tech Stack & Dependencies

| Category | Technologies |
|---|---|
| **Framework** | Flutter 3.x / Dart 3.x |
| **State Management** | Provider (ChangeNotifier) + GetIt (Service Locator) |
| **Networking** | Dio + Custom Interceptors + In-Memory Caching |
| **Real-Time** | SignalR NetCore Client (WebSockets) |
| **Push Notifications** | Firebase Cloud Messaging (FCM) + Flutter Local Notifications |
| **Storage** | Flutter Secure Storage (Keychain/Keystore) + SharedPreferences |
| **Payment Gateway** | Stripe API Integration |
| **Media & Video** | Video Player + AudioPlayers |
| **Testing** | Flutter Test + Mockito (60+ Unit & Widget test suites) |

---

## 🚀 Getting Started

### 1. Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.11.0`)
- Android Studio / Xcode (for iOS builds)

### 2. Installation
```bash
# Clone the repository
git clone https://github.com/MohamedGasser15/Education-Lab.git

# Navigate to mobile project
cd "Education Lab/apps/mobile"

# Install dependencies
flutter pub get

# Run tests
flutter test

# Run the app
flutter run
```

### 3. Production Build
```bash
# Build Android App Bundle (Optimized)
flutter build appbundle --release

# Build split Android APKs (Per ABI)
flutter build apk --split-per-abi --release

# Build iOS IPA
flutter build ipa --release
```

---

## 🧪 Testing

The codebase includes over **60 test suites** covering:
- Unit tests for Repositories, Providers, and API Clients.
- Card validation and billing formatters.
- Memory and token cache state transitions.
- Widget and Golden responsiveness tests.

```bash
flutter test --coverage
```

---

## 👨‍💻 Author

Developed with ❤️ by **Mohamed Gasser**  
- LinkedIn: [Mohamed Gasser](https://www.linkedin.com/in/mohamedgasser15)
- GitHub: [@MohamedGasser15](https://github.com/MohamedGasser15)
