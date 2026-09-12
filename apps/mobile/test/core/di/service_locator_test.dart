import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/services/api_client.dart';
import 'package:mobile/core/services/auth_service.dart';
import 'package:mobile/core/services/notification_service.dart';
import 'package:mobile/core/services/sound_service.dart';
import 'package:mobile/core/repositories/auth_repository.dart';
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Service Locator DI Tests', () {
    setUpAll(() {
      setupServiceLocator();
    });

    test('Core services are registered in GetIt locator', () {
      expect(locator.isRegistered<ApiClient>(), true);
      expect(locator.isRegistered<AuthService>(), true);
      expect(locator.isRegistered<NotificationService>(), true);
      expect(locator.isRegistered<SoundService>(), true);
      expect(locator.isRegistered<AuthRepository>(), true);
    });

    test(
      'All feature services and repositories are registered in GetIt locator',
      () {
        expect(locator.isRegistered<HomeApiService>(), true);
        expect(locator.isRegistered<LegalApiService>(), true);
        expect(locator.isRegistered<InstructorApplicationApiService>(), true);
        expect(locator.isRegistered<SupportHubService>(), true);
        expect(locator.isRegistered<CartRepository>(), true);
        expect(locator.isRegistered<ExploreRepository>(), true);
        expect(locator.isRegistered<CertificatesRepository>(), true);
        expect(locator.isRegistered<CoursesRepository>(), true);
        expect(locator.isRegistered<HomeRepository>(), true);
        expect(locator.isRegistered<NotificationRepository>(), true);
        expect(locator.isRegistered<SupportRepository>(), true);
        expect(locator.isRegistered<CourseLearningRepository>(), true);
        expect(locator.isRegistered<EnrollmentRepository>(), true);
        expect(locator.isRegistered<PaymentRepository>(), true);
        expect(locator.isRegistered<ProfileRepository>(), true);
        expect(locator.isRegistered<SecurityRepository>(), true);
        expect(locator.isRegistered<WishlistRepository>(), true);
      },
    );

    test('resolveOr returns registered singleton when available', () {
      final repo = resolveOr<CartRepository>(() => CartRepository());
      expect(repo, isNotNull);
      expect(identical(repo, locator<CartRepository>()), true);
    });

    test('resolveOr returns fallback when type is not registered', () {
      const fallbackObj = 'Fallback String';
      final resolved = resolveOr<String>(() => fallbackObj);
      expect(resolved, 'Fallback String');
    });
  });
}
