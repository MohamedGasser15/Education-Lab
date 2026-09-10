import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/home/data/models/home_models.dart';
import 'package:mobile/features/home/presentation/providers/home_provider.dart';
import 'package:mobile/features/home/presentation/widgets/home_promo_slider.dart';
import 'package:mobile/features/profile/data/models/user_profile_model.dart';
import 'package:mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class MockProfileProvider extends ChangeNotifier implements ProfileProvider {
  final UserProfileModel? _mockProfile;

  MockProfileProvider({UserProfileModel? profile}) : _mockProfile = profile;

  @override
  UserProfileModel? get profile => _mockProfile;

  @override
  bool get isInstructor => _mockProfile?.isInstructor ?? false;

  @override
  bool get isLoggedIn => _mockProfile != null;

  @override
  bool get hasProfile => _mockProfile != null;

  @override
  bool get isLoading => false;

  @override
  String? get errorMessage => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockHomeProvider extends ChangeNotifier implements HomeProvider {
  @override
  HomeStatsDTO get stats => const HomeStatsDTO();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget createTestWidget({required ProfileProvider profileProvider}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<ProfileProvider>.value(value: profileProvider),
      ChangeNotifierProvider<HomeProvider>(create: (_) => MockHomeProvider()),
    ],
    child: const MaterialApp(
      locale: Locale('ar', 'SA'),
      supportedLocales: [Locale('ar', 'SA'), Locale('en', 'US')],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: SingleChildScrollView(
          child: HomePromoSlider(),
        ),
      ),
    ),
  );
}

void main() {
  group('UserProfileModel.isInstructor', () {
    test('returns true when roles list contains instructor (case insensitive)', () {
      final user = UserProfileModel.fromJson({'roles': ['Instructor']});
      expect(user.isInstructor, isTrue);

      final userLower = UserProfileModel.fromJson({'roles': ['instructor']});
      expect(userLower.isInstructor, isTrue);
    });

    test('returns true when role string is instructor', () {
      final user = UserProfileModel.fromJson({'role': 'Instructor'});
      expect(user.isInstructor, isTrue);

      final userRole = UserProfileModel.fromJson({'Role': 'instructor'});
      expect(userRole.isInstructor, isTrue);
    });

    test('returns false when user is only a student or has empty roles', () {
      final student = UserProfileModel.fromJson({'roles': ['Student']});
      expect(student.isInstructor, isFalse);

      final empty = UserProfileModel.fromJson({});
      expect(empty.isInstructor, isFalse);
    });
  });

  group('HomePromoSlider Instructor Banner Visibility', () {
    testWidgets('shows 4 slides with Become an Instructor banner when user is NOT an instructor', (tester) async {
      final mockProvider = MockProfileProvider(
        profile: const UserProfileModel(
          id: 'user1',
          fullName: 'طالب مجتهد',
          email: 'student@edulab.edu',
          roles: ['Student'],
        ),
      );

      await tester.pumpWidget(createTestWidget(profileProvider: mockProvider));
      await tester.pump();

      // Check 4 dots indicator (one for each slide including Instructor slide)
      final dotsFinder = find.byType(AnimatedContainer);
      expect(dotsFinder, findsNWidgets(4));

      // Tap on the 4th dot indicator to navigate directly to the 4th slide
      await tester.tap(dotsFinder.at(3));
      for (int i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Look for the Become an Instructor banner title, badge, and button
      expect(find.text('انضم معنا كمدرب وشارك شغفك'), findsOneWidget);
      expect(find.text('فرصة تدريبية • شارك خبرتك'), findsOneWidget);
      expect(find.text('قدّم طلبك الآن'), findsOneWidget);
    });

    testWidgets('shows 4 slides when user is a guest (null profile)', (tester) async {
      final mockProvider = MockProfileProvider(profile: null);

      await tester.pumpWidget(createTestWidget(profileProvider: mockProvider));
      await tester.pump();

      // 4 dots for guests as well
      final dotsFinder = find.byType(AnimatedContainer);
      expect(dotsFinder, findsNWidgets(4));

      // Tap on the 4th dot indicator
      await tester.tap(dotsFinder.at(3));
      for (int i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.text('انضم معنا كمدرب وشارك شغفك'), findsOneWidget);
    });

    testWidgets('HIDES Become an Instructor banner (only 3 slides) when user IS an instructor', (tester) async {
      final mockProvider = MockProfileProvider(
        profile: const UserProfileModel(
          id: 'inst1',
          fullName: 'د. أحمد',
          email: 'instructor@edulab.edu',
          roles: ['Instructor'],
        ),
      );

      await tester.pumpWidget(createTestWidget(profileProvider: mockProvider));
      await tester.pump();

      // Only 3 dots indicator
      expect(find.byType(AnimatedContainer), findsNWidgets(3));

      // Instructor banner should NOT be found
      expect(find.text('انضم معنا كمدرب وشارك شغفك'), findsNothing);
      expect(find.text('فرصة تدريبية • شارك خبرتك'), findsNothing);
      expect(find.text('قدّم طلبك الآن'), findsNothing);
    });
  });
}
