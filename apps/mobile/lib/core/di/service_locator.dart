import 'package:get_it/get_it.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/services/auth_service.dart';
import 'package:mobile/core/services/notification_service.dart';
import 'package:mobile/core/services/sound_service.dart';
import 'package:mobile/core/repositories/auth_repository.dart';

// Feature Services & Repositories
import 'package:mobile/features/cart/data/repositories/cart_repository.dart';
import 'package:mobile/features/catalog/data/repositories/explore_repository.dart';
import 'package:mobile/features/courses/data/repositories/certificates_repository.dart';
import 'package:mobile/features/courses/data/repositories/courses_repository.dart';
import 'package:mobile/features/home/data/repositories/home_repository.dart';
import 'package:mobile/features/home/data/services/home_api_service.dart';
import 'package:mobile/features/inbox/data/repositories/notification_repository.dart';
import 'package:mobile/features/inbox/data/repositories/support_repository.dart';
import 'package:mobile/features/inbox/data/services/support_hub_service.dart';
import 'package:mobile/features/learning/data/repositories/course_learning_repository.dart';
import 'package:mobile/features/learning/data/repositories/enrollment_repository.dart';
import 'package:mobile/features/legal/data/services/legal_api_service.dart';
import 'package:mobile/features/profile/data/repositories/payment_repository.dart';
import 'package:mobile/features/profile/data/repositories/profile_repository.dart';
import 'package:mobile/features/profile/data/repositories/security_repository.dart';
import 'package:mobile/features/profile/data/services/instructor_application_api_service.dart';
import 'package:mobile/features/wishlist/data/repositories/wishlist_repository.dart';

final locator = GetIt.instance;

void setupServiceLocator() {
  if (locator.isRegistered<ApiClient>()) return;

  // Core Services
  locator
    ..registerLazySingleton<ApiClient>(() => ApiClient())
    ..registerLazySingleton<AuthService>(() => AuthService())
    ..registerLazySingleton<NotificationService>(() => NotificationService())
    ..registerLazySingleton<SoundService>(() => SoundService())
    // Core Repositories
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepository(service: locator<AuthService>()),
    )
    // Feature Services & Hubs
    ..registerLazySingleton<HomeApiService>(() => HomeApiService())
    ..registerLazySingleton<LegalApiService>(() => LegalApiService())
    ..registerLazySingleton<InstructorApplicationApiService>(
      () => InstructorApplicationApiService(),
    )
    ..registerLazySingleton<SupportHubService>(() => SupportHubService())
    // Feature Repositories
    ..registerLazySingleton<CartRepository>(() => CartRepository())
    ..registerLazySingleton<ExploreRepository>(() => ExploreRepository())
    ..registerLazySingleton<CertificatesRepository>(
      () => CertificatesRepository(),
    )
    ..registerLazySingleton<CoursesRepository>(() => CoursesRepository())
    ..registerLazySingleton<HomeRepository>(() => HomeRepository())
    ..registerLazySingleton<NotificationRepository>(
      () => NotificationRepository(),
    )
    ..registerLazySingleton<SupportRepository>(() => SupportRepository())
    ..registerLazySingleton<CourseLearningRepository>(
      () => CourseLearningRepository(),
    )
    ..registerLazySingleton<EnrollmentRepository>(() => EnrollmentRepository())
    ..registerLazySingleton<PaymentRepository>(() => PaymentRepository())
    ..registerLazySingleton<ProfileRepository>(() => ProfileRepository())
    ..registerLazySingleton<SecurityRepository>(() => SecurityRepository())
    ..registerLazySingleton<WishlistRepository>(() => WishlistRepository());
}

/// Helper to safely resolve a dependency or instantiate fallback
T resolveOr<T extends Object>(T Function() fallback) {
  if (locator.isRegistered<T>()) {
    return locator<T>();
  }
  return fallback();
}
