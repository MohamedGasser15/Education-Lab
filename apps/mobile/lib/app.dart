import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'core/services/locale_service.dart';
import 'core/services/theme_service.dart';
import 'l10n/app_localizations.dart'; 
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/main/presentation/screens/main_navigation_screen.dart';
import 'features/cart/presentation/screens/cart_screen.dart';
import 'features/cart/presentation/screens/checkout_screen.dart';
import 'features/inbox/presentation/screens/notifications_screen.dart';
import 'features/inbox/presentation/screens/messages_screen.dart';
import 'features/wishlist/presentation/screens/wishlist_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/profile/presentation/screens/settings_screen.dart';
import 'features/profile/presentation/screens/edit_profile_screen.dart';
import 'features/profile/presentation/screens/account_security_screen.dart';
import 'features/profile/presentation/screens/purchase_history_screen.dart';
import 'features/profile/presentation/screens/teach_application_screen.dart';
import 'features/catalog/presentation/screens/explore_screen.dart';
import 'features/learning/presentation/screens/learning_screen.dart';
import 'features/courses/presentation/screens/course_details_screen.dart';
import 'features/courses/presentation/screens/lesson_player_screen.dart';
import 'features/courses/presentation/screens/assignments_screen.dart';
import 'features/courses/presentation/screens/schedule_screen.dart';
import 'features/courses/presentation/screens/certificate_view_screen.dart';
import 'features/courses/presentation/screens/my_certificates_screen.dart';
import 'features/home/presentation/screens/instructors_screen.dart';
import 'features/home/presentation/screens/instructor_profile_screen.dart';
import 'features/legal/presentation/screens/legal_content_screen.dart';

import 'features/profile/presentation/providers/profile_provider.dart';
import 'features/profile/presentation/providers/teach_application_provider.dart';
import 'features/wishlist/presentation/providers/wishlist_provider.dart';
import 'features/learning/presentation/providers/enrollment_provider.dart';
import 'features/learning/presentation/providers/course_learning_provider.dart';
import 'features/cart/presentation/providers/cart_provider.dart';
import 'features/home/presentation/providers/home_provider.dart';
import 'features/inbox/presentation/providers/notification_provider.dart';
import 'features/inbox/presentation/providers/support_provider.dart';
import 'features/catalog/presentation/providers/explore_provider.dart';
import 'features/courses/presentation/providers/certificates_provider.dart';
import 'features/legal/presentation/providers/legal_provider.dart';
import 'features/profile/presentation/providers/security_provider.dart';
import 'features/profile/presentation/providers/payment_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const List<Locale> _supportedLocales = [Locale('ar', 'SA'), Locale('en', 'US')];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleService()..loadLocale()),
        ChangeNotifierProvider(create: (_) => ThemeService()..loadTheme()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()..fetchWishlist()),
        ChangeNotifierProvider(create: (_) => EnrollmentProvider()..fetchEnrollments()),
        ChangeNotifierProvider(create: (_) => CourseLearningProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()..fetchCart()),
        ChangeNotifierProvider(create: (_) => HomeProvider()..fetchHomeData()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()..fetchNotifications()),
        ChangeNotifierProvider(create: (_) => SupportProvider()),
        ChangeNotifierProvider(create: (_) => ExploreProvider()..loadRecentSearches()),
        ChangeNotifierProvider(create: (_) => TeachApplicationProvider()),
        ChangeNotifierProvider(create: (_) => CertificatesProvider()),
        ChangeNotifierProvider(create: (_) => LegalProvider()),
        ChangeNotifierProvider(create: (_) => SecurityProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ],
      child: Consumer2<LocaleService, ThemeService>(
        builder: (context, localeService, themeService, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'EduLab',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeService.themeMode,

            locale: DevicePreview.locale(context) ?? localeService.locale,
            supportedLocales:
                AppLocalizations.supportedLocales.isEmpty
                    ? _supportedLocales
                    : AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            initialRoute: '/splash',
            routes: {
              '/splash': (context) => const SplashScreen(),
              '/': (context) => const OnboardingScreen(),
              '/login': (context) => const LoginScreen(),
              '/main': (context) => const MainNavigationScreen(),
              '/cart': (context) => const CartScreen(),
              '/checkout': (context) => const CheckoutScreen(),
              '/notifications': (context) => const NotificationsScreen(),
              '/messages': (context) => const MessagesScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/edit-profile': (context) => const EditProfileScreen(),
              '/account-security': (context) => const AccountSecurityScreen(),
              '/purchase-history': (context) => const PurchaseHistoryScreen(),
              '/teach-apply': (context) => const TeachApplicationScreen(),
              '/explore': (context) => const ExploreScreen(),
              '/wishlist': (context) => const WishlistScreen(),
              '/my-courses': (context) => const LearningScreen(showTabs: false),
              '/my_courses': (context) => const LearningScreen(showTabs: false),
              '/learning': (context) => const LearningScreen(showTabs: true),
              '/course-details': (context) => const CourseDetailsScreen(),
              '/course_details': (context) => const CourseDetailsScreen(),
              '/lesson-player': (context) => const LessonPlayerScreen(),
              '/lesson_player': (context) => const LessonPlayerScreen(),
              '/assignments': (context) => const AssignmentsScreen(),
              '/schedule': (context) => const ScheduleScreen(),
              '/certificates': (context) => const MyCertificatesScreen(),
              '/my-certificates': (context) => const MyCertificatesScreen(),
              '/certificate_view': (context) => const MyCertificatesScreen(),
              '/certificate-view': (context) => const MyCertificatesScreen(),
              '/certificate-detail': (context) => const CertificateViewScreen(),
              '/instructors': (context) => const InstructorsScreen(),
              '/instructor-profile': (context) => const InstructorProfileScreen(),
              '/instructor_profile': (context) => const InstructorProfileScreen(),
              '/instructor-details': (context) => const InstructorProfileScreen(),
              '/legal': (context) => const LegalContentScreen(),
              '/about': (context) => const LegalContentScreen(initialTab: LegalTab.about),
              '/privacy': (context) => const LegalContentScreen(initialTab: LegalTab.privacy),
              '/terms': (context) => const LegalContentScreen(initialTab: LegalTab.terms),
            },
          );
        },
      ),
    );
  }
}